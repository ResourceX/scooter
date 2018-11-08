# plumber.R
library(RMySQL)



#*****************************************
#
#        KNOVOS client data portals
#
#*****************************************

convert_df<-function(df){
  
  data<-list()
  for(i in 1:nrow(df)){
    
    data[[i]]<-list()
    for(j in 1:length(colnames(df))){
      data[[i]][colnames(df)[j]]<-iconv(df[i,j],to="utf-8")
    }
    
  }
  
  return(data)
  
}

ProgInfo<-function(database){
  
  db_host<-'ec2-52-11-250-69.us-west-2.compute.amazonaws.com'
  db_name<-database
  
  con <- dbConnect(MySQL(),
                   user="mtseman",
                   password="cree1234",
                   host=db_host,
                   dbname=db_name)
  
  statement<-paste("SELECT * FROM ProgInfo;",sep='')
  ProgInfo<-dbGetQuery(con,statement)
  
  dbDisconnect(con)
  
  return(ProgInfo)
  
}

ProgInfo_simple<-function(ProgInfo){
  
  if(is.element('hasPerformance',colnames(ProgInfo)))(hasPerformance<-'hasPerformance')else(hasPerformance<-NULL)
  ProgInfo<-ProgInfo[c(hasPerformance,'ProgID','ProgName','ProgDept','ProgDiv')]
  
  return(ProgInfo)
}

OrgInfo<-function(database){
  
  db_host<-'ec2-52-11-250-69.us-west-2.compute.amazonaws.com'
  #db_name<-database
  
  con <- dbConnect(MySQL(),
                   user="mtseman",
                   password="cree1234",
                   host=db_host,
                   dbname='RX_Admin')
  
  statement<-paste("SELECT * FROM OrgInfo;",sep='')
  OrgInfo<-dbGetQuery(con,statement)
  
  dbDisconnect(con)
  
  OrgInfo<-OrgInfo[OrgInfo$DatabaseName==database,]
  
  return(OrgInfo)
  
}

BudgetInfo<-function(database){
  
  db_host<-'ec2-52-11-250-69.us-west-2.compute.amazonaws.com'
  db_name<-database
  
  con <- dbConnect(MySQL(),
                   user="mtseman",
                   password="cree1234",
                   host=db_host,
                   dbname=db_name)
  
  statement<-paste("SELECT * FROM BudgetInfo;",sep='')
  BudgetInfo<-dbGetQuery(con,statement)
  
  dbDisconnect(con)
  
  return(BudgetInfo)
  
}

ProgBudgetInfo<-function(database){
  
  db_host<-'ec2-52-11-250-69.us-west-2.compute.amazonaws.com'
  db_name<-database
  
  con <- dbConnect(MySQL(),
                   user="mtseman",
                   password="cree1234",
                   host=db_host,
                   dbname=db_name)
  
  statement<-paste("SELECT * FROM ProgBudgetInfo;",sep='')
  ProgBudgetInfo<-dbGetQuery(con,statement)
  
  dbDisconnect(con)
  
  return(ProgBudgetInfo)
  
}


#* access point for knovos to access ProgInfo table
#* @param db org db to get proginfo
#' @serializer unboxedJSON
#* @get /get_RXProgInfo
function(db,res){
  
  msg<-NULL
  
  try_this<-function(){
    
    df<-ProgInfo(db)
    
    df<-ProgInfo_simple(df)
    
    msg<-convert_df(df)
  }
  
  msg<-tryCatch(try_this(),
                
                warning=function(w){try_this()},
                
                error=function(e){return(NULL)}
                
  )
  
  
  if(is.null(msg)){
    
    msg <- "Please specify a valid db"
    res$status <- 400 # Bad request
    list(error=jsonlite::unbox(msg))
    
  }
  
  msg
  
  
}

#* access point for knovos to access OrgInfo Table
#* @param db The org database to use
#' @serializer unboxedJSON
#* @get /get_RXOrgInfo
function(db,res){
  
  msg<-NULL

  try_this<-function(){
    
    df<-OrgInfo(db)
    
    msg<-convert_df(df)
  }
  
  msg<-tryCatch(try_this(),
                
                warning=function(w){try_this()},
                
                error=function(e){return(NULL)}
                
  )
  

  if(is.null(msg)){
    
    msg <- "Please specify a valid db"
    res$status <- 400 # Bad request
    list(error=jsonlite::unbox(msg))
    
  }
  
  msg
  
  
}

#* access point for knovos to access BudgetInfo Table
#* @param db The org database to use
#' @serializer unboxedJSON
#* @get /get_RXBudgetInfo
function(db,res){
  
  msg<-NULL
  
  try_this<-function(){
    
    df<-BudgetInfo(db)
    
    msg<-convert_df(df)
  }
  
  msg<-tryCatch(try_this(),
                
                warning=function(w){try_this()},
                
                error=function(e){return(NULL)}
                
  )
  
  
  if(is.null(msg)){
    
    msg <- "Please specify a valid db"
    res$status <- 400 # Bad request
    list(error=jsonlite::unbox(msg))
    
  }
  
  msg
  
  
}

#* access point for knovos to access ProgBudgetInfo Table
#* @param db The org database to use
#' @serializer unboxedJSON
#* @get /get_RXProgBudgetInfo
function(db,res){
  
  msg<-NULL
  
  try_this<-function(){
    
    df<-ProgBudgetInfo(db)
    
    msg<-convert_df(df)
  }
  
  msg<-tryCatch(try_this(),
                
                warning=function(w){try_this()},
                
                error=function(e){return(NULL)}
                
  )
  
  
  if(is.null(msg)){
    
    msg <- "Please specify a valid db"
    res$status <- 400 # Bad request
    list(error=jsonlite::unbox(msg))
    
  }
  
  msg
  
  
}

# #* Echo back the input
# #* @param msg The message to echo
# #* @get /echo
# function(msg=""){
#   list(msg = paste0("The message is: '", msg, "'"))
# }
# 
# #* Plot a histogram
# #* @png
# #* @get /plot
# function(){
#   rand <- rnorm(100)
#   hist(rand)
# }
# 
# #* Return the sum of two numbers
# #* @param a The first number to add
# #* @param b The second number to add
# #* @post /sum
# function(a, b){
#   as.numeric(a) + as.numeric(b)
# }