#' selection_pane_table UI Function
#'
#' @noRd
mod_events_select_inputs_ui <- function(id) {

  ns <- NS(id)

  choices <- stats::setNames(
    all_dat[["events"]]$event_id,
    all_dat[["events"]]$start_date
  )

  tagList(
    bs4Dash::bs4Card(
      title = "Select Input",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      closable = FALSE,
      collapsible = TRUE,
      collapsed = FALSE,

      shiny::fluidRow(

        shiny::column(
          width = 8,

          shiny::selectInput(
            ns("event_id"),
            "Select Event",
            choices = choices
          )
        ),

        shiny::column(
          width = 4,

          shiny::tags$div(
            style = "padding-top: 25px;",

            shiny::actionButton(
              ns("get_data"),
              "Load Event",
              width = "100%"
            )
          )
        )
      )
    )
  )
}

#' selection_pane_table Server Functions
#'
#' @noRd
mod_events_select_inputs_server <- function(id) {

  moduleServer(id, function(input, output, session) {

    events_dat <- all_dat[["events"]]
    hist_dat   <- all_dat[["hist_dat"]]

    selected_data <- shiny::eventReactive(
      input$get_data,
      {

        shiny::req(input$event_id)

        event_id_selected <- as.numeric(input$event_id)

        events_filt <- events_dat |>
          dplyr::filter(
            event_id == event_id_selected
          )

        hist_dat_filt <- hist_dat |>
          dplyr::filter(
            event_id == event_id_selected
          )

        list(
          events = events_filt,
          hist_dat = hist_dat_filt
        )
      }
    )

    selected_data
  })
}