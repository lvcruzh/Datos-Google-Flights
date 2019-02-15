##############################################################
############# Web Scraping de Google Flights #################
##############################################################

#Elaboracion: Luis Valentin Cruz | lvcruz@colmex.mx

rm(list = ls())

#1.Navegacion con Selenium
library("RSelenium", lib.loc="~/R/win-library/3.5")
library(dplyr)
library(rebus)
library(stringr)
library(readxl)
library(MASS)

rD <- rsDriver(verbose = FALSE, browser = c("firefox"), version = "latest")
remDr <- rD$client

#2.Crear las urls
fecha <- "2019-02-08"

viajes <- readxl::read_xlsx("rutas.xlsx")
viajes$url <- paste0("https://www.google.com/flights?lite=0#flt=",viajes$aero_orig,".",viajes$aero_dest,".",fecha,";c:MXN;e:1;sd:1;t:f;tt:o")
length(viajes$url)

#3.Comprobar que la navegacion funciona a partir de las urls que se crearon
remDr$navigate(viajes$url[1])

#4.Declarar funciones utiles 
extraerTexto <- function(x){
  c <- unlist(lapply(x, function(x){x$getElementText()}))
  c <- unlist(strsplit(c, "[\n]"))
  return(c)
}

#5.Guardar la informacion en un vector
v <- c()
for (i in 1:length(viajes$url)){
  remDr$navigate(viajes$url[i]) 
  print(i)
  Sys.sleep(runif(1,7,10))
  try(
    {flights <- remDr$findElements("class", "gws-flights-results__result-list")
    extraerTexto(flights)
    d <- unlist(extraerTexto(flights))
    v <- append(v, d)}
  )
}

datos <- as.data.frame(v)
#6.Guardar los resultados en archivo csv para su procesamiento

write.csv(datos, "Resultados_1sem.csv", fileEncoding = "UTF-8")
save.image("~/WebScraping-GoogleFlights/1sem.RData")

#Repetir para todas las semanas

######2 Semanas
fecha <- "2019-02-15"

viajes <- readxl::read_xlsx("rutas.xlsx")
viajes$url <- paste0("https://www.google.com/flights?lite=0#flt=",viajes$aero_orig,".",viajes$aero_dest,".",fecha,";c:MXN;e:1;sd:1;t:f;tt:o")
length(viajes$url)

v <- c()
for (i in 1:length(viajes$url)){
  remDr$navigate(viajes$url[i]) 
  print(i)
  Sys.sleep(runif(1,7,10))
  try(
    {flights <- remDr$findElements("class", "gws-flights-results__result-list")
    extraerTexto(flights)
    d <- unlist(extraerTexto(flights))
    v <- append(v, d)}
  )
}
datos <- as.data.frame(v)
write.csv(datos, "Resultados_2sem.csv", fileEncoding = "UTF-8")
save.image("~/WebScraping-GoogleFlights/2sem.RData")

######4 Semanas
fecha <- "2019-03-01"

viajes <- readxl::read_xlsx("rutas.xlsx")
viajes$url <- paste0("https://www.google.com/flights?lite=0#flt=",viajes$aero_orig,".",viajes$aero_dest,".",fecha,";c:MXN;e:1;sd:1;t:f;tt:o")
length(viajes$url)

v <- c()
for (i in 1:length(viajes$url)){
  remDr$navigate(viajes$url[i]) 
  print(i)
  Sys.sleep(runif(1,7,10))
  try(
    {flights <- remDr$findElements("class", "gws-flights-results__result-list")
    extraerTexto(flights)
    d <- unlist(extraerTexto(flights))
    v <- append(v, d)}
  )
}
datos <- as.data.frame(v)
write.csv(datos, "Resultados_4sem.csv", fileEncoding = "UTF-8")
save.image("~/WebScraping-GoogleFlights/4sem.RData")

######8 Semanas
fecha <- "2019-03-29"

viajes <- readxl::read_xlsx("rutas.xlsx")
viajes$url <- paste0("https://www.google.com/flights?lite=0#flt=",viajes$aero_orig,".",viajes$aero_dest,".",fecha,";c:MXN;e:1;sd:1;t:f;tt:o")
length(viajes$url)

v <- c()
for (i in 1:length(viajes$url)){
  remDr$navigate(viajes$url[i]) 
  print(i)
  Sys.sleep(runif(1,7,10))
  try(
    {flights <- remDr$findElements("class", "gws-flights-results__result-list")
    extraerTexto(flights)
    d <- unlist(extraerTexto(flights))
    v <- append(v, d)}
  )
}
datos <- as.data.frame(v)
write.csv(datos, "Resultados_8sem.csv", fileEncoding = "UTF-8")
save.image("~/WebScraping-GoogleFlights/8sem.RData")

######12 Semanas
fecha <- "2019-04-26"

viajes <- readxl::read_xlsx("rutas.xlsx")
viajes$url <- paste0("https://www.google.com/flights?lite=0#flt=",viajes$aero_orig,".",viajes$aero_dest,".",fecha,";c:MXN;e:1;sd:1;t:f;tt:o")
length(viajes$url)

v <- c()
for (i in 1:length(viajes$url)){
  remDr$navigate(viajes$url[i]) 
  print(i)
  Sys.sleep(runif(1,7,10))
  try(
    {flights <- remDr$findElements("class", "gws-flights-results__result-list")
    extraerTexto(flights)
    d <- unlist(extraerTexto(flights))
    v <- append(v, d)}
  )
}
datos <- as.data.frame(v)
write.csv(datos, "Resultados_12sem.csv", fileEncoding = "UTF-8")
save.image("~/WebScraping-GoogleFlights/12sem.RData")
