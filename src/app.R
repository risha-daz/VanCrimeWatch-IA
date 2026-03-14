library(shiny)
library(bslib)
library(here)
library(dplyr)
library(ggplot2)
library(lubridate)

# Load data
crime_data <- read.csv(here("data", "combined_crime_data_2023_2025.csv"))

# Pre-process
crime_data <- crime_data |>
  mutate(
    YEAR  = as.factor(YEAR),
    MONTH = as.integer(MONTH),
    HOUR  = as.integer(HOUR)
  )

crime_types <- sort(unique(crime_data$TYPE))

app_theme <- bs_theme(
  navbar_bg    = "#1a1a2e",
  navbar_color = "#e0e0e0",
)

ui <- page_sidebar(
  
  theme = app_theme,
  title = "VanCrimeWatch",
  
  sidebar = sidebar(
    selectInput(
      inputId  = "crime_type",
      label    = "Select Crime Type:",
      choices  = crime_types,
      selected = crime_types[1]
    )
  ),
  
  layout_columns(
    col_widths = c(6, 6),
    
    # KPI 1 - Night-time crimes
    value_box(
      title    = "Night-time Crimes (20:00 – 06:00)",
      value    = textOutput("nighttime_count"),
      showcase = bsicons::bs_icon("moon-stars-fill"),
      theme    = value_box_theme(bg = "#0d0d0d", fg = "#ffffff")
    ),
    
    # KPI 2 - Peak crime month
    value_box(
      title    = "Peak Crime Month",
      value    = textOutput("peak_month"),
      showcase = bsicons::bs_icon("graph-up-arrow")
    )
  ),
  
  card(
    card_header("Monthly Crime Trend by Year"),
    plotOutput(outputId = "crime_trend_plot")
  )
)


server <- function(input, output) {
  
  # Reactive: filter by selected crime type
  filtered_data <- reactive({
    crime_data |>
      filter(TYPE == input$crime_type)
  })
  
  # KPI 1: night-time crimes from filtered data
  output$nighttime_count <- renderText({
    filtered_data() |>
      filter(HOUR >= 20 | HOUR < 6) |>
      nrow() |>
      format(big.mark = ",")
  })
  
  # KPI 2: peak crime month
  output$peak_month <- renderText({
    peak <- filtered_data() |>
      count(MONTH) |>
      slice_max(n, n = 1, with_ties = FALSE) |>
      pull(MONTH)
    month.name[peak]
  })
  
  # Line chart: count by month × year
  output$crime_trend_plot <- renderPlot({
    
    plot_data <- filtered_data() |>
      group_by(YEAR, MONTH) |>
      summarise(count = n(), .groups = "drop")
    
    ggplot(plot_data, aes(x = MONTH, y = count, color = YEAR, group = YEAR)) +
      geom_line(linewidth = 1.1) +
      geom_point(size = 2.5) +
      scale_x_continuous(
        breaks = 1:12,
        labels = month.abb
      ) +
      labs(
        x     = "Month",
        y     = "Number of Incidents",
        color = "Year",
        title = paste("Monthly Trend –", input$crime_type)
      ) +
      theme_minimal(base_size = 14) +
      theme(
        plot.title       = element_text(face = "bold", margin = margin(b = 10)),
        panel.grid.minor = element_blank(),
        legend.position  = "top"
      )
  })
}

shinyApp(ui = ui, server = server)