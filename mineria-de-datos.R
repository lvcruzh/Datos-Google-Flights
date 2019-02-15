####################################
###### Procesamiento de datos ######
####################################

#Elaboracion: Luis Valentin Cruz | lvcruz@colmex.mx
library(stringr)
library(rebus)
library(tidyverse)
library(readxl)

#1.Leer la base de datos y eliminar la primera columna
fecha <- "2019-05-08"
data <- readr::read_csv("D:/WebScraping-GoogleFlights/13-02-19/Resultados_12sem.csv")
data$X1 <- NULL
names(data) <- c("x")

#2.Determinamos los patrones
captura <- function(x) capture(one_or_more(x))

p_vuelo <- START %R% ANY_CHAR %R% ANY_CHAR %R% ANY_CHAR %R% "–" %R% ANY_CHAR %R% ANY_CHAR %R% ANY_CHAR %R% END 
p_hora <- START %R% captura(DGT) %R% ":" %R% captura(DGT) %R% SPC %R% "–" %R% SPC %R% captura(DGT) %R% ":" %R% captura(DGT)
p_precio <- START %R% "MXN"
p_precio2 <- START %R% "Precio no disponible"
p_duracion <- START %R% captura(DGT) %R% SPC %R% "h" %R% SPC %R% captura(DGT) %R% SPC %R% "min" %R% END               #Para vuelos de mas de una hora
p_duracion2 <- START %R% captura(DGT) %R% SPC %R% "min" %R% END                                                       #Para vuelos de menos de una hora
p_nescala <- START %R% captura(DGT) %R% SPC %R% "escala"                                                              #Numero de escalas
p_directo <- START %R% "Directo" %R% END
p_lescala <- START %R% captura(DGT) %R% SPC %R% "h" %R% SPC %R% captura(DGT) %R% SPC %R% "min" %R% SPC %R% ANY_CHAR   #Lugar de escala (cuando es solo una) y dura mas de una hora
p_lescala2 <- START %R% ANY_CHAR %R% ANY_CHAR %R% ANY_CHAR %R% "," %R% SPC %R% ANY_CHAR %R% ANY_CHAR %R% ANY_CHAR     #Lugar de escala (cuando es mas de una)
p_lescala3 <- START %R% captura(DGT) %R% SPC %R% "min" %R% SPC %R% ANY_CHAR                                           #Lugar de escala (cuando es solo una) y dura menos de una hora
p_operado <- "Operado por"
p_operado2 <- START %R% "Delta" %R% END
p_operado3 <- "Cambio de aeropuerto"
p_operado4 <- START %R% "WestJet" %R% END
p_operado5 <- START %R% "Avianca" %R% END

#Vemos que funcionen correctamente
#str_view(data$x, pattern = p_vuelo)

#3.Condicion logica para la construccion de la base de datos
data$vuelo <- str_detect(data$x, p_vuelo)
data$hora <- str_detect(data$x,p_hora)
data$precio <- str_detect(data$x,p_precio)
data$precio2 <- str_detect(data$x,p_precio2)
data$duracion <- str_detect(data$x,p_duracion)
data$duracion2 <- str_detect(data$x,p_duracion2)
data$n_escalas <- str_detect(data$x,p_nescala)
data$directo <- str_detect(data$x,p_directo)
data$lescala <- str_detect(data$x,p_lescala)
data$lescala2 <- str_detect(data$x,p_lescala2)
data$lescala3 <- str_detect(data$x,p_lescala3)
data$operado <- str_detect(data$x,p_operado)
data$operado2 <- str_detect(data$x,p_operado2)
data$operado3 <- str_detect(data$x,p_operado3)
data$operado4 <- str_detect(data$x,p_operado4)
data$operado5 <- str_detect(data$x,p_operado5)

#4.Eliminar los datos que no son necesarios
data <- data %>% filter(lescala != TRUE) %>% filter(lescala2 != TRUE) %>% filter(operado != TRUE) %>% filter(lescala3 != TRUE) %>%
        filter(operado2 != TRUE) %>% filter(operado3 != TRUE) %>% filter(operado4 != TRUE) %>% filter(operado5 != TRUE)
data$operado <- NULL
data$operado2 <- NULL
data$operado3 <- NULL
data$operado4 <- NULL
data$operado5 <- NULL
data$lescala <- NULL
data$lescala2 <- NULL
data$lescala3 <- NULL

#5.Construir los vectores de cada variable
vuelo <- data %>% filter(vuelo != FALSE)
vuelo <- vuelo$x 

hora <- data %>% filter(hora != FALSE)
hora <- hora$x

precio <- data %>% filter(precio != FALSE | precio2 != FALSE)
precio <- precio$x

duracion <- data %>% filter(duracion != FALSE | duracion2 != FALSE)
duracion <- duracion$x

escalas <- data %>% filter(n_escalas != FALSE | directo != FALSE) 
escalas <- escalas$x

aerolinea <- data %>% filter(vuelo != TRUE) %>% filter(hora != TRUE) %>% filter(precio != TRUE) %>% filter(duracion != TRUE) %>% 
             filter(n_escalas != TRUE) %>% filter(duracion2 != TRUE) %>% filter(precio2 != TRUE) %>% filter(directo != TRUE)
aerolinea <- aerolinea$x

#6. Concatenar los vectores resultantes y guardar en un archivo
sem <- 12
tab <- cbind(aerolinea,vuelo,hora,precio,duracion,escalas,fecha,sem)
names(tab) <- c("aerolinea","vuelo","horario","precio","duracion","escalas","fecha","semana-anticipada")
tab <- as.data.frame(tab)

#7.Guardar el archivo
write.csv(tab, "D:/WebScraping-GoogleFlights/13-02-19/Base12sem.csv", fileEncoding = "UTF-8")
