library(querychat)
library(shiny)
library(bslib)

con = DBI::dbConnect(RSQLite::SQLite(), "data/midwest_airbnb.db")

client = ellmer::chat_openai(
  model = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
)

qc = querychat::QueryChat$new(
  con, "listings",
  client = client,
  tools = c("filter", "query", "visualize"),
  greeting = "Ask me about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.",
  data_description = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md"
)

ui = page_sidebar(
  title = "Midwest Airbnb Analyzer",
  fillable = FALSE,
  
  theme = bs_theme(
    version = 5,
    bg = "#7D99AA",
    fg = "#142B3A",
    primary = "#66F4FF",
    secondary = "#FFC067",
    base_font = font_collection("Segoe UI", "Arial", "sans-serif"),
    "headings-color" = "#142B3A",
    "link-color" = "#154E70",
    "link-hover-color" = "#142B3A",
    "font-size-base" = "1rem",
    "line-height-base" = 1.6
  ),
  
  sidebar = qc$sidebar(),
  
  tags$head(
    tags$style(HTML("
      .bslib-page-title {
        color: #142B3A;
        font-weight: 700;
      }

      .card,
      .bslib-sidebar-layout > .sidebar {
        background: #F5FAFD;
        color: #142B3A;
        border: 1px solid #486779;
        border-radius: 14px;
      }

      .card-header {
        background: #66C4FF;
        color: #142B3A;
        padding: 16px 20px;
        font-weight: 700;
        border-bottom: 1px solid #486779;
      }

      .card-body {
        padding: 20px;
        min-width: 0;
      }

      .form-control,
      .form-select {
        background: #FFFFFF;
        color: #142B3A;
        border-color: #486779;
      }

      .form-control::placeholder {
        color: #536777;
        opacity: 1;
      }

      .form-control:focus,
      .form-select:focus {
        background: #FFFFFF;
        color: #142B3A;
        border-color: #154E70;
      }

      .btn-primary {
        color: #142B3A;
        font-weight: 600;
      }

      table.dataTable th,
      table.dataTable td {
        padding: 12px 16px !important;
        font-size: 16px;
        line-height: 1.6;
        vertical-align: top;
      }

      table.dataTable thead th {
        background: #66C4FF;
        color: #142B3A;
        white-space: nowrap;
      }

      table.dataTable tbody td {
        background: #F5FAFD;
        color: #142B3A;
      }

      #sql {
        background: #FFFFFF;
        color: #142B3A;
        border: 1px solid #486779;
        border-left: 5px solid #FFC067;
        border-radius: 10px;
        padding: 18px;
        white-space: pre-wrap;
        overflow-wrap: anywhere;
        font-family: Consolas, monospace;
        font-size: 15px;
        line-height: 1.7;
      }

      a {
        text-decoration: underline;
        text-underline-offset: 3px;
      }

      :focus-visible {
        outline: 3px solid #142B3A;
        outline-offset: 3px;
      }
    "))
  ),
  
  card(
    card_header("Airbnb listings"),
    p("Scroll sideways to view all columns. Use the page controls below to view more listings."),
    DT::DTOutput("listings")
  ),
  
  card(
    card_header("SQL for the current table"),
    p("Updates when you filter the listings. Separate summary queries appear in the chat."),
    verbatimTextOutput("sql")
  ),
  
  card(
    card_header("About"),
    p("Created by Griffin Rosbottom - Info Systems & Economics @ Miami University."),
    p(
      "Source: ",
      a("Inside Airbnb", href = "https://insideairbnb.com/get-the-data/"),
      ". This dataset contains 14,887 listings."
    ),
    tags$ul(
      tags$li("Chicago snapshot: July 20, 2026."),
      tags$li("Columbus snapshot: July 23, 2026."),
      tags$li("Twin Cities MSA snapshot: July 21, 2026.")
    )
  )
)

server = function(input, output, session) {
  chat = qc$server()
  
  output$listings = DT::renderDT({
    DT::datatable(
      chat$df(),
      rownames = FALSE,
      selection = "none",
      escape = TRUE,
      options = list(
        pageLength = 10,
        lengthMenu = c(10, 25, 50),
        scrollX = TRUE,
        autoWidth = TRUE,
        columnDefs = list(
          list(
            width = "280px",
            targets = which(names(chat$df()) == "name") - 1
          )
        )
      )
    )
  }, server = TRUE)
  
  output$sql = renderText({
    if (is.null(chat$sql())) {
      "SELECT * FROM listings"
    } else {
      chat$sql()
    }
  })
}

shinyApp(ui, server)