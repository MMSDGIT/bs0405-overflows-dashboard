#' events_summary_tbl UI Function
#'
#' @description Event summary table.
#'
#' @param id Internal module id.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_events_summary_tbl_ui <- function(id) {

  ns <- NS(id)

  tagList(
    bs4Dash::bs4Card(
      title = "Event Summary",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      closable = FALSE,
      collapsible = TRUE,
      collapsed = FALSE,

      shiny::uiOutput(ns("summary_table"))
    )
  )
}


#' events_summary_tbl Server Functions
#'
#' @noRd
mod_events_summary_tbl_server <- function(id, dat) {

  moduleServer(id, function(input, output, session) {

    output$summary_table <- shiny::renderUI({

      shiny::req(dat())

      event_summary <- dat()[["events"]]

      shiny::req(nrow(event_summary) > 0)

      # We expect one row per selected event
      event_summary <- event_summary[1, ]

      # ---- HELPERS ----
      display_value <- function(
          x,
          suffix = NULL,
          digits = NULL
      ) {

        if (
          length(x) == 0 ||
          is.na(x) ||
          identical(x, "")
        ) {
          return(
            shiny::tags$span(
              "Not available",
              style = "color: #777; font-style: italic;"
            )
          )
        }

        if (!is.null(digits) && is.numeric(x)) {
          x <- format(
            round(x, digits),
            big.mark = ",",
            nsmall = digits
          )
        }

        if (!is.null(suffix)) {
          x <- paste0(x, " ", suffix)
        }

        x
      }

      display_date <- function(x) {

        if (
          length(x) == 0 ||
          is.na(x)
        ) {
          return(
            shiny::tags$span(
              "Not available",
              style = "color: #777; font-style: italic;"
            )
          )
        }

        format(
          as.Date(x),
          "%b %d, %Y"
        )
      }

      # ---- TABLE ----
      shiny::tags$table(
        class = "table table-sm table-striped table-hover",
        style = "
          margin-bottom: 0;
          font-size: 0.95rem;
        ",

        shiny::tags$tbody(

          shiny::tags$tr(
            shiny::tags$th("Event ID"),
            shiny::tags$td(
              display_value(
                event_summary$event_id
              )
            ),

            shiny::tags$th("Year"),
            shiny::tags$td(
              display_value(
                event_summary$year
              )
            )
          ),

          shiny::tags$tr(
            shiny::tags$th("Start Date"),
            shiny::tags$td(
              display_date(
                event_summary$start_date
              )
            ),

            shiny::tags$th("End Date"),
            shiny::tags$td(
              display_date(
                event_summary$end_date
              )
            )
          ),

          shiny::tags$tr(
            shiny::tags$th("BS0405 Overflow Volume"),
            shiny::tags$td(
              display_value(
                event_summary$event_vol,
                suffix = "MG",
                digits = 2
              )
            ),

            shiny::tags$th("BS0405 Overflow Duration"),
            shiny::tags$td(
              display_value(
                event_summary$event_duration,
                suffix = "hr",
                digits = 1
              )
            )
          )
        )
      )
    })

  })
}
    
## To be copied in the UI
# mod_events_summary_tbl_ui("events_summary_tbl_1")
    
## To be copied in the server
# mod_events_summary_tbl_server("events_summary_tbl_1")
