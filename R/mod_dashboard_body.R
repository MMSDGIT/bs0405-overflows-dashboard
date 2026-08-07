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

      # ---- HISTORY ----
      bs4Dash::bs4TabItem(
        tabName = "History",
        mod_history_ui("history_1")
      ),

      # ---- EVENTS ----
      bs4Dash::bs4TabItem(
        tabName = "Events",

        mod_events_select_inputs_ui(
          "events_select_inputs_1"
        ),

        mod_events_summary_tbl_ui(
          "events_summary_tbl_1"
        ),

        mod_events_pump_plot_ui(
          "events_pump_plot_1"
        ),

        bs4Dash::bs4Card(
          title = "System Levels and Gate Positions",
          status = "primary",
          solidHeader = TRUE,
          width = 12,
          closable = FALSE,
          collapsible = TRUE,
          collapsed = FALSE,

          mod_events_level_plot_ui(
            "events_level_plot_1"
          ),

          mod_events_gate_plot_ui(
            "events_gate_plot_1"
          )
        )
      )
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