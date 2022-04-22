library(shinydashboard)
library(shiny)
library(shinyjs)
library(ggplot2)
library(lubridate)
library(dplyr)
library(DT)
library(tidyverse)
library(tidyr)
library(scales)
library(leaflet)
library(sp)
library(stringr)


taxiDict <- read.csv(file = 'taxiDictReMap.csv', header=F)
# taxiDict[[2]][6] #i+1, if i=0 look up i+1
# taxiDict$V2

mapTaxi <- c()
for (row in 1:nrow(taxiDict)) {
  mapTaxi[taxiDict[row, "V2"]] <- taxiDict[row, "V1"]
}
# as.integer(mapTaxi["Checker Taxi"])

areaDict <- read.csv(file = 'CommAreas.csv')
areaDict <- areaDict[order(areaDict$AREA_NUMBE),]
areaDict$COMMUNITY <- str_to_title(areaDict$COMMUNITY)
new.outChicago <- list(AREA_NUMBE=78, COMMUNITY="Outside Chicago")
areaDict[nrow(areaDict) + 1, names(new.outChicago)] <- new.outChicago
# areaDict[[7]][35] #To look up community area i name areaDict[[7]][i]

mapArea <- c()
for (row in 1:nrow(areaDict)) {
  mapArea[areaDict[row, "COMMUNITY"]] <- areaDict[row, "AREA_NUMBE"]
}
# as.integer(mapArea["MOUNT GREENWOOD"])

CSS <- "
.dataTables_wrapper .dataTables_paginate .paginate_button {
  min-width: 1em !important; 
  padding: 0.5em 0.5em !important;
} 
"
chicagoMap <- rgdal::readOGR("Boundaries - Community Areas (current).geojson")
chicagoMap$area_numbe <- as.numeric(chicagoMap$area_numbe)
chicagoMap$community <- str_to_title(chicagoMap$community)


ui <- dashboardPage(skin = "yellow",
                    
                    #5,760 by 1,620
                    
                    #create dashboard and elements
                    dashboardHeader(title = "CS 424 Project 3"),
                    
                    dashboardSidebar(
                      disable = FALSE, collapsed = FALSE,
                      #menu bar with all 3 panels and about page
                      sidebarMenu(
                        br(),br(),br(),br(),br(),br(),br(),br(),br(),
                        br(),br(),br(),br(),br(),br(),br(),br(),br(),
                        br(),br(),br(),br(),br(),br(),br(),br(),br(),
                        br(),br(),br(),br(),br(),br(),br(),br(),br(),
                        menuItem("Taxi Trips", tabName = "taxi", icon = NULL),
                        menuItem("About Page", tabName = "about", icon = NULL)
                      )
                    ),
                    dashboardBody(
                      tabItems(
                        
                        tabItem(tabName="taxi",
                                
                                fluidPage(
                                  useShinyjs(),
                                  fluidRow(
                                    column(1,
                                           br(),br(),br(),br(),br(),br(),br(),br(),br(),
                                           br(),br(),br(),br(),br(),br(),br(),br(),br(),
                                           br(),br(),br(),br(),br(),
                                           
                                           box(solidHeader = TRUE, status = "primary", width=200,       
                                               checkboxInput("outsideChicago", "Outside Chicago Area", FALSE),
                                               
                                               radioButtons(inputId="toFrom",NULL,
                                                            choices=c("To","From"),selected="To"),
                                               p("Choose community area"),
                                               selectInput("area", NULL,
                                                           choices = c(areaDict[order(areaDict$COMMUNITY),]$COMMUNITY,"Chicago"), 
                                                           selected = "Chicago"
                                               ),
                                               p("Choose time format"),
                                               selectInput("time", NULL,
                                                           choices = c("AM/PM","24-Hour"), 
                                                           selected = "AM/PM"
                                               ),
                                               p("Choose distance unit"),
                                               selectInput("dist", NULL,
                                                           choices = c("KM","Miles"), 
                                                           selected = "KM"
                                               ),
                                               p("Choose taxi company"),
                                               selectInput("taxi", NULL,
                                                           choices = c(taxiDict[order(taxiDict$V2),]$V2, "All Taxi Companies"), 
                                                           selected = "All Taxi Companies"
                                               )
                                           )
                                    ),
                                    column(11,
                                           
                                           h1("Big Yellow Taxi",align="center",style = "color:#E6961F;text-decoration-line: underline;font-weight: bold;"),
                                           br(),br(),
                                           fluidRow(
                                             tags$head(tags$style(HTML(CSS))),
                                             
                                             column(4,
                                                    column(8,
                                                           box(solidHeader = TRUE, status = "primary", width=200,
                                                               plotOutput("Date_Bar")
                                                           )
                                                    ),
                                                    column(4,
                                                           box(solidHeader = TRUE, status = "primary", width = 200,
                                                               dataTableOutput("Date_Table")
                                                           )
                                                    )
                                             ),
                                             
                                             column(4,
                                                    column(8,
                                                           box(solidHeader = TRUE, status = "primary", width=200,
                                                               plotOutput("Month_Bar")
                                                           ) 
                                                    ),
                                                    column(4,
                                                           box(solidHeader = TRUE, status = "primary", width = 200,
                                                               dataTableOutput("Month_Table")
                                                           ) 
                                                    )
                                             ),
                                             
                                             column(4,
                                                    column(8,
                                                           box(solidHeader = TRUE, status = "primary", width=200,
                                                               plotOutput("Day_Bar")
                                                           ) 
                                                    ),
                                                    column(4,
                                                           box(solidHeader = TRUE, status = "primary", width = 200,
                                                               dataTableOutput("Day_Table")
                                                           )
                                                    )
                                             ),
                                             
                                             
                                             
                                             ###
                                             
                                             column(4,
                                                    column(8,
                                                           box(solidHeader = TRUE, status = "primary", width=200,
                                                               plotOutput("Hour_Bar")
                                                           )
                                                    ),
                                                    column(4,
                                                           box(solidHeader = TRUE, status = "primary", width = 200,
                                                               dataTableOutput("Hour_Table")
                                                           )
                                                    )
                                             ),
                                             
                                             column(4,
                                                    column(8,
                                                           box(solidHeader = TRUE, status = "primary", width=200,
                                                               plotOutput("Mileage_Bar")
                                                           )
                                                    ),
                                                    column(4,
                                                           box(solidHeader = TRUE, status = "primary", width = 200,
                                                               dataTableOutput("Mileage_Table")
                                                           )
                                                    )
                                             ),
                                             
                                             column(4,
                                                    column(8,
                                                           box(solidHeader = TRUE, status = "primary", width=200,
                                                               plotOutput("Time_Bar")
                                                           )
                                                    ),
                                                    column(4,
                                                           box(solidHeader = TRUE, status = "primary", width = 200,
                                                               dataTableOutput("Time_Table")
                                                           )
                                                    )
                                             ),
                                             
                                             ##
                                             column(8,
                                                    column(10,
                                                           plotOutput("Percentage_Trip_Plot")
                                                    ),
                                                    column(2,
                                                           dataTableOutput("Percentage_Trip_Table")
                                                    )
                                             ),
                                             column(4,
                                                    leafletOutput("mainMap")
                                             )
                                             
                                           )
                                    )
                                  ),
                                )
                                
                        ),
                        
                        
                        #About page
                        tabItem(tabName="about",
                                h1("About",style = "color:#E6961F;text-decoration-line: underline;font-weight: bold;"),
                                verbatimTextOutput("AboutOut")
                        )
                        
                      )
                    )
)





# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  observeEvent({
    input$outsideChicago
    input$toFrom
    input$area
    input$taxi
    input$time
    input$dist},
    
    {
      if(input$area=="Chicago"){
        boolPerct = FALSE
        shinyjs::disable("toFrom")
        shinyjs::hide("Percentage_Trip_Plot")
        shinyjs::hide("Percentage_Trip_Table")
        shinyjs::hide("mainMap")
        if(input$taxi=="All Taxi Companies"){
          path = "allAreaAllTaxi/"
        }
        else{
          path = paste("allArea/","Taxi-",as.integer(mapTaxi[input$taxi]),"/",sep="")
        }
      }
      else{
        shinyjs::show("Percentage_Trip_Plot")
        shinyjs::show("Percentage_Trip_Table")
        shinyjs::show("mainMap")
        boolPerct = TRUE
        shinyjs::enable("toFrom")
        if(input$taxi=="All Taxi Companies"){
          path = "allTaxi/"
        }
        else{
          path = paste("allCombination/","Taxi-",as.integer(mapTaxi[input$taxi]),"/" ,sep="")
        }
        
        if(input$toFrom=="To"){
          boolDrop = FALSE
          path = paste(path,"To/",sep="")
        }
        else{
          boolDrop = TRUE
          path = paste(path,"From/",sep="")
        }
        
        path = paste(path,"Area-",as.integer(mapArea[input$area]),"/" ,sep="")
      }
      
      if(input$outsideChicago){
        path = paste(path,"outsideCity/",sep="")
      }
      else{
        path = paste(path,"onlyCity/",sep="")
      }
      
      paste(path, "date.csv", sep="")
      date <- read.csv(file = paste(path, "date.csv", sep=""), header = TRUE)
      month <- read.csv(file = paste(path, "month.csv", sep=""), header = TRUE)
      day <- read.csv(file = paste(path, "day.csv", sep=""), header = TRUE)
      hour <- read.csv(file = paste(path, "hour.csv", sep=""), header = TRUE)
      mileage_km <- read.csv(file = paste(path, "mileage_km.csv", sep=""), header = TRUE)
      mileage_miles <- read.csv(file = paste(path, "mileage_miles.csv", sep=""), header = TRUE)
      time <- read.csv(file = paste(path, "time.csv", sep=""), header = TRUE)
      
      options(scipen=10000)
      date$Date <- ymd(date$Date)
      datebreaks <- seq(as.Date("2019-01-01"), as.Date("2019-12-31"), by="1 month")
      output$Date_Bar <- renderPlot({
        ggplot(date, aes(Date, Count)) +
          geom_col(fill="#E6961F") +
          labs(title="Taxi Rides by Date",
               x = "Date", y = "Rides")+
          scale_x_date(date_labels="%B",
                       breaks = datebreaks,
                       limits = c( as.Date(min(date$Date)), as.Date(max(date$Date))))+
          scale_y_continuous(label=scales::comma_format(accuracy=1), breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
      })
      
      output$Date_Table <- renderDataTable(
        datatable(
          format(date, format="%m/%d"),
          colnames=c("Date", "Rides"),
          options = list(
            searching = FALSE,
            pageLength = 7, 
            lengthChange = FALSE,
            columnDefs = list(list(className = 'dt-center', targets = "_all"))
          ),
          rownames = FALSE
        ) %>%
          formatCurrency(2, currency = "", interval = 3, mark = ",")%>%
          formatRound('Count', digits = 0)
      )
      
      month$Month <- factor(month$Month, levels=1:12,
                            labels=c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"))
      output$Month_Bar <- renderPlot({
        ggplot(month, aes(x = Month, y = Count))+
          geom_col(width = 0.8, fill="#E6961F") + 
          labs(title="Taxi Rides by Month",
               x = "Month", y = "Rides")+
          scale_y_continuous(label=scales::comma_format(accuracy=1), breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
      })
      
      output$Month_Table <- renderDataTable(
        datatable(
          month, 
          colnames=c("Month", "Rides"),
          options = list(
            searching = FALSE,
            pageLength = 7, 
            lengthChange = FALSE,
            columnDefs = list(list(className = 'dt-center', targets = "_all"))
          ),
          rownames = FALSE
        ) %>%
          formatCurrency(2, currency = "", interval = 3, mark = ",")%>%
          formatRound('Count', digits = 0)
      )
      
      day$Day <- factor(day$Day, levels=0:6,
                        labels=c("Monday", "Tuesday", "Wednesday",
                                 "Thursday", "Friday", "Saturday", "Sunday"))
      output$Day_Bar <- renderPlot({
        ggplot(day, aes(x = Day, y = Count))+
          geom_col(width = 0.8, fill="#E6961F") + 
          labs(title="Taxi Rides by Day of Week",
               x = "Day of Week", y = "Rides")+
          scale_y_continuous(label=scales::comma_format(accuracy=1), breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
      })
      
      output$Day_Table <- renderDataTable(
        datatable(
          day, 
          colnames=c("Day of Week", "Rides"),
          options = list(
            searching = FALSE,
            pageLength = 7, 
            lengthChange = FALSE,
            columnDefs = list(list(className = 'dt-center', targets = "_all"))
          ),
          rownames = FALSE
        ) %>%
          formatCurrency(2, currency = "", interval = 3, mark = ",")%>%
          formatRound('Count', digits = 0)
      )
      
      
      if(input$time=="AM/PM"){
        #AM/PM
        hour$Hour <- factor(hour$Hour, levels=0:23,
                            labels=c("12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM",
                                     "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"))
      }
      else{
        #24-Hour
        hour$Hour <- factor(hour$Hour, levels=0:23,
                            labels=c("00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00",
                                     "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"))
      }
      output$Hour_Bar <- renderPlot({
        ggplot(hour, aes(x = Hour, y = Count))+
          geom_col(width = 0.8, fill="#E6961F") + 
          labs(title="Taxi Rides by Hour of Day",
               x = "Hour of Day", y = "Rides")+
          scale_y_continuous(label=scales::comma_format(accuracy=1), breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
      })
      
      output$Hour_Table <- renderDataTable(
        datatable(
          hour, 
          colnames=c("Hour of Day", "Rides"),
          options = list(
            searching = FALSE,
            pageLength = 7, 
            lengthChange = FALSE,
            columnDefs = list(list(className = 'dt-center', targets = "_all"))
          ),
          rownames = FALSE
        ) %>%
          formatCurrency(2, currency = "", interval = 3, mark = ",")%>%
          formatRound('Count', digits = 0)
      )
      
      if(input$dist=="KM"){
        # mileage_KM
        mileage_km$Mileage_km <- factor(mileage_km$Mileage_km, levels= c("0.8 - 2", "2 - 5", "5 - 10", "10 - 15", "15 - 25", "25 - 35", "35 - 160"))
        output$Mileage_Bar <- renderPlot({
          ggplot(mileage_km, aes(x = Mileage_km, y = Count))+
            geom_col(width = 0.8, fill="#E6961F") +
            labs(title="Taxi Rides by Trip Distance",
                 x = "Distance (KM)", y = "Rides")+
            scale_y_continuous(label=scales::comma_format(accuracy=1), breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
        })
        
        output$Mileage_Table <- renderDataTable(
          datatable(
            mileage_km, 
            colnames=c("Distance (KM)", "Rides"),
            options = list(
              searching = FALSE,
              pageLength = 7, 
              lengthChange = FALSE,
              columnDefs = list(list(className = 'dt-center', targets = "_all"))
            ),
            rownames = FALSE
          ) %>%
            formatCurrency(2, currency = "", interval = 3, mark = ",")%>%
            formatRound('Count', digits = 0)
        )
      }
      else{
        # mileage_miles
        mileage_miles$Mileage_miles <- factor(mileage_miles$Mileage_miles, levels= c("0.5 - 1", "1 - 3", "3 - 5", "5 - 10", "10 - 15", "15 - 20", "20 - 100"))
        output$Mileage_Bar <- renderPlot({
          ggplot(mileage_miles, aes(x = Mileage_miles, y = Count))+
            geom_col(width = 0.8, fill="#E6961F") + 
            labs(title="Taxi Rides by Trip Distance",
                 x = "Distance (Miles)", y = "Rides")+
            scale_y_continuous(label=scales::comma_format(accuracy=1), breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
        })
        
        output$Mileage_Table <- renderDataTable(
          datatable(
            mileage_miles, 
            colnames=c("Distance (Miles)", "Rides"),
            options = list(
              searching = FALSE,
              pageLength = 7, 
              lengthChange = FALSE,
              columnDefs = list(list(className = 'dt-center', targets = "_all"))
            ),
            rownames = FALSE
          ) %>% 
            formatCurrency(2, currency = "", interval = 3, mark = ",")%>%
            formatRound('Count', digits = 0)
        )
      }
      
      time$timeTaken <- factor(time$timeTaken, levels= c("1 - 5 min", "5 - 10 min", "10 - 15 min", "15 - 20 min", "20 - 30 min", "1/2 hr - 1 hr", "> 1 hr"))
      output$Time_Bar <- renderPlot({
        ggplot(time, aes(x = timeTaken, y = Count))+
          geom_col(width = 0.8, fill="#E6961F") +
          labs(title="Taxi Rides by Trip Duration",
               x = "Trip Duration", y = "Rides")+
          scale_y_continuous(label=scales::comma_format(accuracy=1), breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
      })
      
      output$Time_Table <- renderDataTable(
        datatable(
          time, 
          colnames=c("Trip Duration", "Rides"),
          options = list(
            searching = FALSE,
            pageLength = 7, 
            lengthChange = FALSE,
            columnDefs = list(list(className = 'dt-center', targets = "_all"))
          ),
          rownames = FALSE
        ) %>% 
          formatCurrency(2, currency = "", interval = 3, mark = ",")%>%
          formatRound('Count', digits = 0)
      )
      
      if(boolPerct){
        # Percentage_Trip_Plot
        if(boolDrop){
          drop <- read.csv(file = paste(path, "drop.csv", sep=""), header = TRUE)
          
          chicago <- chicagoMap
          chicago <- chicago[order(chicago$area_numbe),]
          if(input$outsideChicago){
            new.row <- list(area_numbe=78, community="Outside Chicago")
            chicago[nrow(chicago) + 1, names(new.row)] <- new.row
          }
          
          chicago$Percentage <- as.list(as.numeric(drop$Percentage))
          if(input$outsideChicago) chicago<-head(chicago,-1)
          areaNo <- as.integer(mapArea[input$area])
          bins <- c(0, 0.05, 0.1, 0.5, 1, 3, 5, 10, Inf)
          qpal <- colorBin("RdYlBu", chicago$Percentage, bins = bins)
          labels= c("0 - 0.05", "0.05 - 0.1","0.1 - 0.5","0.5 - 1","1 - 3", "3 - 5", "5 - 10", ">10")
          
          for (row in 1:nrow(drop)) {
            drop[row, "dropArea"] <- areaDict[[7]][as.integer(drop[row, "dropArea"])]
          }
          drop <- drop[order(drop$dropArea),]
          row.names(drop) <- NULL
          drop <- drop %>% mutate( ToHighlight = ifelse( dropArea == "Outside Chicago", "yes", "no" ) )
          
          output$Percentage_Trip_Plot <- renderPlot({
            ggplot(drop, aes(x = dropArea, y = Percentage, fill = ToHighlight))+
              geom_col(width = 0.8) +
              labs(title="Percentage of Taxi Rides",
                   subtitle=paste("From: ",input$area, sep=""),
                   x = "Drop Off Area", y = "Percentage of Rides(%)")+
              scale_fill_manual( values = c( "yes"="#FB4D3D", "no"="#E6961F" ), guide = "none" )+
              scale_y_continuous(label=scales::comma_format(accuracy=1), breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1))))) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
          })
          
          output$Percentage_Trip_Table <- renderDataTable(
            datatable(
              drop, 
              colnames=c("Drop Off Area", "Percentage of Rides(%)"),
              options = list(
                searching = FALSE,
                pageLength = 7, 
                lengthChange = FALSE,
                columnDefs = list(list(className = 'dt-center', targets = "_all"))
              ),
              rownames = FALSE
            ) %>% 
              formatCurrency(2, currency = "", interval = 3, mark = ",")%>%
              formatRound('Percentage', digits = 2)
          )
          
          output$mainMap <- renderLeaflet({
            leaflet(chicago) %>%
              setView(-87.7, 41.8481, 10) %>%
              addProviderTiles(providers$CartoDB.Positron) %>%
              addPolygons(stroke = TRUE, weight = 1, color="black", smoothFactor = 0.3, fillOpacity = 1,
                          fillColor = ~qpal(as.numeric(unlist(chicago$Percentage))),
                          label = ~paste0(chicago$community, ": ", chicago$Percentage,"%")) %>%
              addLegend(values=~(chicago$Percentage), pal=qpal, opacity = 1.0, title="percentage of rides(%)",
                        labFormat = function(type, cuts, p) {
                          paste0(labels)
                        }) %>% 
              addPolygons(data=chicago[areaNo,], stroke = TRUE, weight = 3, color="black",
                          smoothFactor = 0.5, fillColor="black",
                          label = ~paste0(chicago[areaNo,]$community, ": ", chicago[areaNo,]$Percentage,"%"), fillOpacity = 0)
          })
        }
        else{
          pick <- read.csv(file = paste(path, "pick.csv", sep=""), header = TRUE)
          
          chicago <- chicagoMap
          chicago <- chicago[order(chicago$area_numbe),]
          if(input$outsideChicago){
            new.row <- list(area_numbe=78, community="Outside Chicago")
            chicago[nrow(chicago) + 1, names(new.row)] <- new.row
          }
          
          chicago$Percentage <- as.list(as.numeric(pick$Percentage))
          if(input$outsideChicago) chicago<-head(chicago,-1)
          areaNo <- as.integer(mapArea[input$area])
          bins <- c(0, 0.05, 0.1, 0.5, 1, 3, 5, 10, Inf)
          qpal <- colorBin("RdYlBu", chicago$Percentage, bins = bins)
          labels= c("0 - 0.05", "0.05 - 0.1","0.1 - 0.5","0.5 - 1","1 - 3", "3 - 5", "5 - 10", ">10")
          
          for (row in 1:nrow(pick)) {
            pick[row, "pickupArea"] <- areaDict[[7]][as.integer(pick[row, "pickupArea"])]
          }
          pick <- pick[order(pick$pickupArea),]
          row.names(pick) <- NULL
          pick <- pick %>% mutate( ToHighlight = ifelse( pickupArea == "Outside Chicago", "yes", "no" ) )
          
          output$Percentage_Trip_Plot <- renderPlot({
            ggplot(pick, aes(x = pickupArea, y = Percentage, fill = ToHighlight))+
              geom_col(width = 0.8) +
              labs(title="Percentage of Taxi Rides",
                   subtitle=paste("To: ",input$area, sep=""),
                   x = "Pick Up Area", y = "Percentage of Rides(%)")+
              scale_fill_manual( values = c( "yes"="#FB4D3D", "no"="#E6961F" ), guide = "none" )+
              scale_y_continuous(label=scales::comma_format(accuracy=1), breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1))))) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
          })
          
          output$Percentage_Trip_Table <- renderDataTable(
            datatable(
              pick, 
              colnames=c("Pick Up Area", "Percentage of Rides(%)"),
              options = list(
                searching = FALSE,
                pageLength = 7, 
                lengthChange = FALSE,
                columnDefs = list(list(className = 'dt-center', targets = "_all"))
              ),
              rownames = FALSE
            ) %>% 
              formatCurrency(2, currency = "", interval = 3, mark = ",")%>%
              formatRound('Percentage', digits = 2)
          )
          
          
          output$mainMap <- renderLeaflet({
            leaflet(chicago) %>%
              setView(-87.7, 41.8481, 10) %>%
              addProviderTiles(providers$CartoDB.Positron) %>%
              addPolygons(stroke = TRUE, weight = 1, color="black", smoothFactor = 0.3, fillOpacity = 1,
                          fillColor = ~qpal(as.numeric(unlist(chicago$Percentage))),
                          label = ~paste0(chicago$community, ": ", chicago$Percentage,"%")) %>%
              addLegend(values=~(chicago$Percentage), pal=qpal, opacity = 1.0, title="Percentage of Rides(%)",
                        labFormat = function(type, cuts, p) {
                          paste0(labels)
                        }) %>% 
              addPolygons(data=chicago[areaNo,], stroke = TRUE, weight = 3, color="black",
                          smoothFactor = 0.5, fillColor="black",
                          label = ~paste0(chicago[areaNo,]$community, ": ", chicago[areaNo,]$Percentage,"%"), fillOpacity = 0)
          })
        }
      }
      
    })
  
  observeEvent(input$mainMap_shape_click, {
    click <- input$mainMap_shape_click
    if (is.null(click))
      return()
    
    lat <- click$lat
    lon <- click$lng
    coords <- as.data.frame(cbind(lon, lat))
    
    point <- SpatialPoints(coords)
    proj4string(point) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
    
    coords <- as.data.frame(cbind(lon, lat))
    selected <- chicagoMap[point,]
    
    updateSelectInput(session, 'area', selected = areaDict[[7]][selected$area_numbe])
  })
  
  output$AboutOut <- renderText({
    "Created by: Kazi Shahrukh Omar & Akash Magnadia\n
         Created: April 18th, 2022\n
         Data Source:\n
         1. Taxi Trips Chicago - 2019: https://data.cityofchicago.org/Transportation/Taxi-Trips-2019/h4cq-z3dy\n
         2. Chicago Community Area Boundaries: https://data.cityofchicago.org/Facilities-Geographic-Boundaries/Boundaries-Community-Areas-current-/cauq-8yn6\n
         Data Category: Transportation\n
         Data Owner: Department of Business Affairs & Consumer Protection\n
         Intended for visualizing the trends and interesting patterns in Taxi ridership data (2019) in Chicago. Since the 2019 data is pre-COVID it is more representative of a 'typical' year."   
  })
  
}


# Run the application 
shinyApp(ui = ui, server = server)