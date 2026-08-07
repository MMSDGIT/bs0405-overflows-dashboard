#' dashboard_body UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_dashboard_body_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::bs4DashBody(
    bs4Dash::bs4TabItems(
      bs4Dash::bs4TabItem(tabName = "History", mod_history_ui("history_1")),
      bs4Dash::bs4TabItem(tabName = "Events", mod_events_ui("plot_1"))
    )
  )
}

#' dashboard_body Server Functions
#'
#' @noRd
mod_dashboard_body_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}

## To be copied in the UI
# mod_dashboard_body_ui("dashboard_body_1")

## To be copied in the server
# mod_dashboard_body_server("dashboard_body_1")