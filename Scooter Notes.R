
#******************************************
#
#  TEST Commands
#
#*******************************************
curl --data "a=4&b=3" "http://scooter.resourcex.net:8000/sum"

curl "http://scooter.resource.net:8000/get_RXProgInfo?db=RX_SalemOR_copy1"

curl "http://scooter.resource.net:8000/get_RXOrgInfo?db=RX_SalemOR_copy1"

curl "http://scooter.resource.net:8000/echo?msg=hello"

curl --data "db=3" "http://scooter.resourcex.net:8000/getProgInfo"

curl --data "db=RX_SalemOR_copy1" "http://scooter.resource.net:8000/getProgInfo"


curl "http://scooter.resourcex.net:8000/sum?a=2&b=4"


"http://scooter.resource.net:8000/getProgInfo?db=RX_SalemOR_copy1"


#**********************************
#
#  RETT Swifter
#
#**********************************



curl --data '{"MetricID":"100","ProgID":"2195","":["JUL","AUG","SEP"],"y":["RED","YELLOW","GREEN"]}' "http://localhost:8000/echo"

curl --data '[{"MetricID":"100","ProgID":"2195","x_data":["JUL","AUG","SEP"],"y_data":["GREEN","YELLow","GREEN"]}]' "http://scooter.resourcex.net:8000/updateCascade"

curl --data '[{"MetricID":"100","ProgID":"2195","x_data":["JUL","AUG","SEP"],"y_data":["GREEN","YELLOW","GREEN"]},{"MetricID":"200","ProgID":"1195","x_data":["JUL","AUG","SEP"],"y_data":["YELLOW","YELLOW","RED"]}]' "http://localhost:8000/updateCascade"

#* Recieve data to be uploaded to MySQL
#* curl --data '[{"id":123, "name": "Jennifer"},{"id":12, "name": "Mike"}]' "http://localhost:8000/swifter"
#* @post /swifter
function(req,msg=''){
  df<-rjson::fromJSON(req$postBody)
  updates<-list()
  for(i in 1:length(df)){
    updates[[i]]<-list()
    
    updates[[i]]$query<-paste0("INSERT INTO Alloc (ItemID, ProgID, Allocation) VALUES (",df[[i]]$ItemID,",",df[[i]]$ProgID,",",df[[i]]$Allocation,")")
    print(updates[[i]]$query)
  }
  
  list(msg =paste0("Message is received. Queries received=",length(updates)),
       queries=updates)
}




#***********************************
#
# Word Cloud Stuff
#
#*********************************

#Line to count words
#  http://yulijia.net/en/howto/r-language/2011/08/06/how-to-calculate-word-frequencies-with-r.html


install.packages("wordcloud2")
library(wordcloud2)
letterCloud(demoFreq,"Thanx")
wordcloud2(demoFreq)

library(wordcloud2)
figPath = system.file("examples/t.png",package = "wordcloud2")
wordcloud2(demoFreq, figPath = figPath, size = 1.5,color = "skyblue")

wordcloud2(demoFreq, figPath = "tree.png", backgroundColor = "white")

library(webshot)
library(htmlwidgets)
#webshot::install_phantomjs()
# Make the graph
my_graph=wordcloud2(demoFreq, size = 1.5,color = "green")
# save it in html

saveWidget(my_graph,"tmp.html",selfcontained = F)
# and in png
webshot("tmp.html","fig_1.png", delay =5, vwidth = 480, vheight=480)


write.csv(demoFreq,'demo_data.csv')

curl --data '{"words": "Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal. Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure.", We are met on a great battle-field of that war.,We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live., It is altogether fitting and proper that we should do this. But, in a larger sense, we can not dedicate -- we can not consecrate -- we can not hallow -- this ground. , 
 The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. , 
 The world will little note, nor long remember what we say here, but it can never forget what they did here. , 
 It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. , 
 It is rather for us to be here dedicated to the great task remaining before 
us -- that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion 
-- that we here highly resolve that these dead shall not have died in vain -- that this nation, under God, shall have a new birth of freedom -- 
and that government of the people, by the people, for the people, shall not perish from the earth."}' "http://localhost:8000/wordcloud"


* png output of a wordcloud
* @get /wordcloudpng
* @serializer contentType list(type='image/png')
function(req,res){

  # Make the graph
  my_graph<-wordcloud2(demoFreq, size = .5,color = "green")
  # save it in html
  htmlwidgets::saveWidget(my_graph,"tmp.html",selfcontained = F)
  # and in png
  webshot("tmp.html","fig_1.png", delay =2, vwidth = 480, vheight=480)

  readBin("fig_1.png", "raw", n=file.info("fig_1.png")$size)

}

#* Plot a wordcloud
#* @post /wordcloud
#* @serializer html
function(req){
  
  df<-rjson::fromJSON(req$postBody)
  
  words<-gsub("\\.","",df$words)
  words<-gsub("\\,","",words)
  words<-gsub("-","",words)
  words<-strsplit(words," ")
  
  words.freq<-table(unlist(words));
  words.freq<-data.frame(word=names(words.freq),freq=as.integer(words.freq))
  
  my_graph<-wordcloud2(words.freq,size = .8,color = "green")
  
  htmlwidgets::saveWidget(my_graph, "tmp.html", selfcontained=TRUE)
  
  # Read the file back in as a single string and return.
  paste(readLines("tmp.html"), collapse="")
  
}




