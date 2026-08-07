#' selection_pane_table UI Function
#'
#' @noRd
#' events_select_inputs UI Function
#'
#' @noRd
mod_events_select_inputs_ui <- function(id) {

  ns <- NS(id)

  tagList(
    bs4Dash::bs4Card(
      title = "Select Event",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      closable = FALSE,
      collapsible = TRUE,
      collapsed = FALSE,

      shiny::uiOutput(
        ns("events")
      )
    )
  )
}

#' selection_pane_table Server Functions
#'
#' @noRd
#' events_select_inputs Server Function
#'
#' @noRd
mod_events_select_inputs_server <- function(id, dat) {

  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    events_dat <- dat[["events"]]
    hist_dat   <- dat[["hist_dat"]]

    # ---- EVENT SELECT ----
    output$events <- shiny::renderUI({

      shiny::req(events_dat)

      choices <- stats::setNames(
        events_dat$event_id,
        events_dat$start_date
      )

      shiny::selectInput(
        ns("event_id"),
        "Select Event",
        choices = choices,
        width = "100%"
      )
    })


    # ---- SELECTED EVENT DATA ----
    selected_data <- shiny::reactive({

      shiny::req(input$event_id)

      event_id_selected <- as.numeric(
        input$event_id
      )

      events_filt <- events_dat |>
        dplyr::filter(
          event_id == event_id_selected
        )

      hist_dat_filt <- hist_dat |>
        dplyr::filter(
          event_id == event_id_selected
        )

      message(
        "Selected event: ", event_id_selected,
        " | Event rows: ", nrow(events_filt),
        " | Historian rows: ", nrow(hist_dat_filt)
      )

      list(
        events = events_filt,
        hist_dat = hist_dat_filt
      )
    })

    return(selected_data)
  })
}