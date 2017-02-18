#Note: This is my mini project to identify the flat to choose
#The efforts may be more than required? Short of constructing a regression model (unless you carry out revealed preference survey. I'm too lazy for that)
#Alternatively you can carry out panel regressions on existing estates to obtain weightsfor the different characteristics. Although returns is not a main considerataion, since as a couple we have our own considerations
#Given that a flat is a hefty investment, I've decided to spend some time analysing the options before making a decision
#Ideally, you could weight it with thee geographical distance. I'm not really too sure how to do it.You've to be well verse with geospatial analysis
#Probably write an article on this for all young couples
#Come up with a score for each unit. If blk is near main road, assign a score of 0 under main road. Even if the floor plan is really good, we'll still assign a score of 0
#Take into account of the following attributes - with a weight of 0 to 5 for important options and 0 to 3 for not so important options
#Afternoon sun
#Near main road
#Near rubbish bin
#Near pavallion
#Near hard court
#Anything in void deck
#Is it a low floor -> weight of 0 to 5 from lowest to second highest floor
#Is it the highest floor
#Is it near playground
#Is it near bus stop
#Is it near mrt
#Floor plan
#90 or 93 square feet == 
#Is it airy enough? Near parks? Or is it surrounded by flats (not too good). People may see what you're doing 
#

#Things to note:
#Subset by Chinese Ethnicity and 4 room flats
#First save all the raw web pages: from 'any' under flat availability
#Second save all the raw web pages: from 'Not booked' under flat availability 

#Load all the packages
library(stringr)
library(XML)  #for parsing
library(RCurl) 


#set the working directory
setwd("C:/Users/Huang Jirong/Desktop/hdb analysis")

#Create a dataframe from whatever is inside the folder of raw html pages
blks = list.files("raw html pages")


##################################functions used in the bigger function to produce scraped data for 1 blk##################
locate_start = function(x,pat){
  end = str_locate_all(pattern = pat,x)[[1]][1,1]
  if(is.numeric(end)){
    end = end
  }else{
    end = 0
  }
  
  return (end)
}

locate_end = function(x,pat){
  end = str_locate_all(pattern = pat,x)[[1]][1,2]
  if(is.numeric(end)){
    end = end
  }else{
    end = 0
  }
  return (end)
}
##############################function to produce scraped data for 1 blk#################
#Create a function to create a tabular data set for 1 block

blk_scrape = function(blk){    #blk key in 618A.html
  
#loading in the raw html data
# blk = blks[1]
blk = paste("raw html pages/",blk,sep = "")
hdb = readLines(blk)
hdb = htmlParse(hdb,useInternalNodes = T)
hdb = getNodeSet(hdb,"//div[@class = 'row form-row']")  #<script type="text/javascript">

#Pick up this unique string to extract the node (or select the node) var Applet = new function() {
hdb1 = sapply(hdb, function(x)paste(capture.output(print(x)), collapse = ""))
# ind = grep('flatDetails',hdb1) 
# ind = grep('All additional amounts and premiums will be adjusted according to the lease chosen',hdb1)
ind = grep('All additional amounts and premiums will be adjusted according to the lease chosen',hdb1)

#KIV on the grep function to pick up the specific node
node = hdb1[[5]]

#Organise data in data-frames
dat = as.data.frame(strsplit(node,"bookMarkCheck"))
dat[,1] = as.character(dat[,1])
dat[,1] = gsub(" ","",dat[,1])

dat = as.data.frame(dat[2:nrow(dat),])
names(dat) = "dat"
dat$dat = as.character(dat$dat)
# write.csv(dat,"test.csv")

#Blk number
blk_num = gsub("raw html pages/","",blk); blk_num = gsub(".html","",blk_num)
dat$blk = blk_num


#Extract unit
dat$unitstart = mapply(locate_end,x = dat$dat, pat = ",'#")
dat$unitend = mapply(locate_start,x = dat$dat, pat = "'\\)")-1
dat$unit = substring(dat$dat, first = dat$unitstart, last = dat$unitend)

#Extract the floor number (so that you would know if it's the highest floor for that block)
dat$morethan10floor = as.numeric(substring(dat$unit, first = 2, last = 2))
dat$floor = ifelse(dat$morethan10floor == 0,
                   substring(dat$unit, first = 3, last = 3), 
                   substring(dat$unit, first = 2, last = 3))
dat$floor = as.numeric(dat$floor)  

#Extract the unit number
dat$unitnumstart = mapply(locate_end,x = dat$unit, pat = "-") + 1
dat$unitnumend = nchar(dat$unit)
dat$unitnum = substring(dat$unit, first = dat$unitnumstart, last = dat$unitnumend)
dat$unitnum = as.numeric(dat$unitnum)

# freelance$loc = gsub("[[:punct:]]","",freelance$loc)
# freelance$loc = gsub("country","",freelance$loc)

#Extract price
# dat$pricestart = ifelse(grepl("\\$",dat$dat),mapply(locate_end,x = dat$dat, pat = "\\$"),0)
# dat$priceend = ifelse(grepl("\\$",dat$dat),mapply(locate_start,x = dat$dat, pat = "0&lt"),0)

dat$with_price = grepl("title",dat$dat)
dat_sub = dat[which(dat$with_price == TRUE),]

dat_sub$pricestart = ifelse(grepl("\\$",dat_sub$dat),mapply(locate_end,x = dat_sub$dat, pat = "\\$"),0)
dat_sub$priceend = ifelse(grepl("\\$",dat_sub$dat),mapply(locate_start,x = dat_sub$dat, pat = "0&lt"),0)
dat_sub$price = substring(dat_sub$dat, first = dat_sub$pricestart, last = dat_sub$priceend)
dat_sub$price = gsub("[[:punct:]]","",dat_sub$price) ; dat_sub$price = as.numeric(dat_sub$price)

#Extract square feet
dat_sub$sqstart = mapply(locate_start,x = dat_sub$dat, pat = "Sqm")-3
dat_sub$sqend = mapply(locate_start,x = dat_sub$dat, pat = "Sqm")-1
dat_sub$sq = substring(dat_sub$dat, first = dat_sub$sqstart, last = dat_sub$sqend)

#Extract availability
dat_sub$availabiity = 1
dat_sub = subset(dat_sub, select = c(unit,pricestart,priceend,price,sqstart,sqend,sq))

#Merge into the dat
dat = merge(dat, dat_sub, by = "unit", all = TRUE)

#return dataframe
return(dat)


}#end of function

##################################Using the above function for all blocks####################

for(i in 1:length(blks)){
  #initialise
  if (i == 1){
    blk_agg = blk_scrape(blks[i])
  }else{
    blk_ind = blk_scrape(blks[i])
    blk_agg = rbind(blk_agg,blk_ind)
  }
}

# blk_formatted = subset(blk_agg,select = c("unit","blk","with_price","price","sq"))


blk_agg$no_afternn_sun = 0
blk_agg$awayfr_mainrd = 0
blk_agg$awayfr_rubbishbin = 0
blk_agg$awayfr_pavallion = 0
blk_agg$awayfr_hardcrt = 0
blk_agg$awayfr_busstop = 0
blk_agg$near_mrt = 0
blk_agg$nothing_voiddeck = 0
blk_agg$highfloor = 0
blk_agg$highestfloor = 0  #not good
blk_agg$awayfr_playgrd = 0  
blk_agg$floor_plan = 0  
blk_agg$ninety_ninetythree_sq = 0 
blk_agg$airy = 0 

sel_variables = c(
  "unit"                  ,"blk"                   ,"morethan10floor"   ,   
  "floor"                 ,"unitnum"               ,"with_price"        ,           
  "price"                 ,"sq"                    ,"no_afternn_sun"    ,   
  "awayfr_mainrd"         ,"awayfr_rubbishbin"     ,"awayfr_pavallion"  ,    
  "awayfr_hardcrt"        ,"nothing_voiddeck"      ,"highfloor"         ,            
  "highestfloor"          ,"awayfr_playgrd"        ,"floor_plan"        ,    
  "ninety_ninetythree_sq" ,"airy"                  ,"awayfr_busstop"    ,
  "near_mrt"
)

blk_agg = subset(blk_agg,select = sel_variables)

write.csv(blk_agg,"scraped_data.csv",row.names = FALSE)

########################Merge in the manually inputed scores with gf########################
setwd("C:/Users/Huang Jirong/Desktop/hdb analysis")

#Merge in the manual inputs

sel_units = read.csv("selected flats.csv")
names(sel_units)

#clean the variable
sel_units$highfloor..3. = ifelse(sel_units$highestfloor..3. == 0, 0, sel_units$highfloor..3.)

#Linear combi of all the attributes to get the score
# sel_units$add_score = 5* sel_units$no_afternn_sun..5. + 5* sel_units$awayfr_mainrd..5. + 
#   5* sel_units$awayfr_rubbishbin..5. + 5* sel_units$awayfr_pavallion..5. + 3* sel_units$awayfr_hardcrt..3. + 3*sel_units$nothing_voiddeck..3.+
#   3*sel_units$highfloor..3. + 3*sel_units$awayfr_playgrd..3. + 3*sel_units$floor_plan..3. + 3*sel_units$airy..3. + 4*sel_units$awayfr_busstop..4. +
#   5*sel_units$near_mrt..5. + sel_units$Inauspicious..1.
  
#Geometric avg
agg_weights = 5+5+5+5+3+3+3+3+3+3+5+5

sel_units$mult_score = (sel_units$no_afternn_sun..5.^(5/agg_weights)) * (sel_units$awayfr_mainrd..5.^(5/agg_weights)) * 
  (sel_units$awayfr_rubbishbin..5.^(5/agg_weights)) * (sel_units$awayfr_pavallion..5.^(5/agg_weights)) * (sel_units$awayfr_hardcrt..3.^(3/agg_weights)) * (sel_units$nothing_voiddeck..3.^(3/agg_weights)) *
  (sel_units$highfloor..3.^(3/agg_weights)) * (sel_units$awayfr_playgrd..3.^(3/agg_weights)) * (sel_units$floor_plan..3.^(3/agg_weights)) * (sel_units$airy..3.^(3/agg_weights)) * (sel_units$awayfr_busstop..4.^(3/agg_weights)) *
  (sel_units$near_mrt..5.^(5/agg_weights)) * (sel_units$Inauspicious..1.^(5/agg_weights))

#Rank the scores in descending order 
library(dplyr)
sel_units = arrange(sel_units, desc(mult_score)) 

write.csv(sel_units,"ranked units.csv",row.names = FALSE)

#Noise travels upwards, so have to eyeball your choices 

















