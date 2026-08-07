#' sidebar_menu UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sidebar_menu_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::bs4SidebarMenu( 
    bs4Dash::bs4SidebarMenuItem("Background", tabName = "History", icon = shiny::icon("circle-info")),
    bs4Dash::bs4SidebarMenuItem("Plot Events", tabName = "Events", icon = shiny::icon("chart-line"))
    )
}

#'
#' @noRd
mod_sidebar_menu_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_sidebar_menu_ui("sidebar_menu_1")

## To be copied in the server
# mod_sidebar_menu_server("sidebar_menu_1")