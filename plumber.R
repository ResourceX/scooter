#plumber.R
library(rjson)
library(RMySQL)

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @png
#* @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b){
  as.numeric(a) + as.numeric(b)
}

#* Recieve data to be uploaded to MySQL
#* curl --data '[{"id":123, "name": "Jennifer"},{"id":12, "name": "Mike"}]' "http://localhost:8000/swifter"
#* @post /swifter
function(req,msg=''){
  df<-rjson::fromJSON(req$postBody)
  list(msg = paste0("Message is received. Length of message=",length(df)))
}