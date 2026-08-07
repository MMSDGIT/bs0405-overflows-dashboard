#' selection_pane_table UI Function
#'
#' @noRd
#' events_select_inputs UI Function
#'
#' @noRd
#' events_select_inputs UI Function
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

      shiny::fluidRow(

        shiny::column(
          width = 8,

shiny::selectInput(
  ns("event_id"),
  "Select Event",
  choices = NULL,
  width = "100%",
  selectize = FALSE
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
#' events_select_inputs Server Function
#'
#' @noRd
#' events_select_inputs Server Function
#'
#' @noRd
#' events_select_inputs Server Function
#'
#' @noRd
mod_events_select_inputs_server <- function(id, dat) {

  moduleServer(id, function(input, output, session) {

    events_dat <- dat[["events"]]
    hist_dat   <- dat[["hist_dat"]]

    # ---- POPULATE EVENT SELECT ----
    choices <- stats::setNames(
      events_dat$event_id,
      events_dat$start_date
    )

    shiny::updateSelectInput(
      session = session,
      inputId = "event_id",
      choices = choices,
      selected = events_dat$event_id[1]
    )

    # ---- STORAGE ----
    selected_data <- shiny::reactiveVal(NULL)

    # ---- LOAD EVENT ON BUTTON CLICK ----
    shiny::observeEvent(
      input$get_data,
      {

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
          "Loaded event: ", event_id_selected,
          " | Event rows: ", nrow(events_filt),
          " | Historian rows: ", nrow(hist_dat_filt)
        )

        selected_data(
          list(
            events = events_filt,
            hist_dat = hist_dat_filt
          )
        )
      },
      ignoreInit = TRUE
    )

    return(selected_data)
  })
}