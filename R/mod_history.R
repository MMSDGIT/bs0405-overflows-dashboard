mod_history_ui <- function(id) {

  ns <- NS(id)

  tagList(

    # ---- INTRO / DISCLAIMER ----
    bs4Dash::bs4Card(
      title = "BS0405 Overflow History",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      closable = FALSE,
      collapsible = FALSE,

  shiny::tags$p(
    "This application provides interactive visualizations and historical summaries
    of overflow events at BS0405. The application includes event
    exploration, historical trends, and supporting operational data."
  ),

      shiny::tags$p(
        "The charts and tables included are intended to support historical review and trend
        exploration across overflow events."
      ),

      shiny::tags$div(
        class = "alert alert-warning",
        role = "alert",

        shiny::tags$strong("Data note: "),

        "Historical records are not complete for all fields in earlier years.
        Where recorded event duration was unavailable, duration has been
        supplemented using available historian pump-status data. Pump-based
        overflow volumes shown elsewhere in this application are estimates derived
        from historian pump status and assumed pump rates and may not exactly match
        volumes reported in official overflow records or other District reporting
        systems."
      ),

      shiny::tags$div(
        class = "alert alert-info",
        role = "alert",

        shiny::tags$strong("Use of data: "),

        "This application is intended for internal review, investigation, and
        operational analysis and should not be used as the source for regulatory,
        external, or other official reporting. If values will be shared externally
        or used for reporting purposes, please request verified values from Systems
        Monitoring."
      )
    ),   # <----- THIS WAS MISSING

    # ---- ANNUAL VOLUME ----
    mod_history_ts_graphs_ui(
      ns("history_volume")
    ),

    # ---- ANNUAL EVENT COUNT ----
    mod_history_ts_graphs_ui(
      ns("history_events")
    ),

    # ---- ANNUAL DURATION ----
    mod_history_ts_graphs_ui(
      ns("history_duration")
    ),

    # ---- EVENT TABLE ----
    bs4Dash::bs4Card(
      title = "Historical Events",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      closable = FALSE,
      collapsible = TRUE,
      collapsed = FALSE,

      shiny::downloadButton(
        ns("download_events"),
        "Download Event Data"
      ),

      shiny::br(),
      shiny::br(),

      DT::DTOutput(
        ns("events_table")
      )
    )
  )
}

#' history Server Functions
#'
#' @noRd
mod_history_server <- function(id, dat) {

  moduleServer(id, function(input, output, session) {

    history_dat <- dat[["history"]]
    events_dat  <- dat[["events"]]

    # ---- HISTORY PLOTS ----

    mod_history_ts_graphs_server(
      "history_volume",
      dat = history_dat,
      value_col = "annual_vol",
      title = "Annual Overflow Volume",
      y_label = "Volume (MG)"
    )

    mod_history_ts_graphs_server(
      "history_events",
      dat = history_dat,
      value_col = "annual_events_n",
      title = "Annual Overflow Events",
      y_label = "Number of Events"
    )

    mod_history_ts_graphs_server(
      "history_duration",
      dat = history_dat,
      value_col = "annual_duration",
      title = "Annual Overflow Duration",
      y_label = "Duration (Hours)"
    )


    # ---- EVENT TABLE ----

    table_dat <- events_dat |>
      dplyr::select(
        year,
        event_id,
        start_date,
        end_date,
        event_vol,
        event_duration
      ) |>
      dplyr::arrange(
        dplyr::desc(start_date)
      ) |>
dplyr::mutate(
  event_vol = round(event_vol, 2),
  start_date = format(as.Date(start_date), "%m/%d/%Y"),
  end_date   = format(as.Date(end_date), "%m/%d/%Y")
)

    output$events_table <- DT::renderDT({

      DT::datatable(
        table_dat,
        rownames = FALSE,
        filter = "top",
        options = list(
          pageLength = 10,
          scrollX = TRUE
        ),
        colnames = c(
          "Year",
          "Event ID",
          "Start Date",
          "End Date",
          "Volume (MG)",
          "Duration (Hours)"
        )
      )
    })


    # ---- DOWNLOAD ----

    output$download_events <- shiny::downloadHandler(

      filename = function() {
        paste0(
          "BS0405_overflow_history_",
          Sys.Date(),
          ".csv"
        )
      },

      content = function(file) {

        readr::write_csv(
          table_dat,
          file,
          na = ""
        )
      }
    )
  })
}