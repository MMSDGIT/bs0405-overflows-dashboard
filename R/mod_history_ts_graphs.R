#' history_ts_graphs UI Function
#'
#' @description Reusable annual history bar chart.
#'
#' @param id Internal module id.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_history_ts_graphs_ui <- function(id) {

  ns <- NS(id)

  tagList(
    bs4Dash::bs4Card(
      title = NULL,
      status = "primary",
      width = 12,
      closable = FALSE,
      collapsible = TRUE,
      collapsed = FALSE,

      plotly::plotlyOutput(
        ns("history_plot"),
        height = "400px"
      )
    )
  )
}


#' history_ts_graphs Server Functions
#'
#' @param id Internal module id.
#' @param dat Annual history dataframe.
#' @param value_col Column to plot.
#' @param title Plot title.
#' @param y_label Y-axis label.
#'
#' @noRd
mod_history_ts_graphs_server <- function(
    id,
    dat,
    value_col,
    title,
    y_label
) {

  moduleServer(id, function(input, output, session) {

    output$history_plot <- plotly::renderPlotly({

      shiny::req(dat)
      shiny::req(nrow(dat) > 0)

      plot_dat <- dat |>
  dplyr::select(
    year,
    value = dplyr::all_of(value_col)
  ) |>
  dplyr::arrange(year) |>
  tidyr::complete(
    year = seq(
      min(year, na.rm = TRUE),
      max(year, na.rm = TRUE)
    ),
    fill = list(value = 0),
    explicit = FALSE
  ) |>
  dplyr::mutate(
    label = dplyr::case_when(
      is.na(value) ~ "",
      value_col == "annual_events_n" ~
        scales::comma(value, accuracy = 1),
      TRUE ~
        scales::comma(value, accuracy = 0.1)
    ),

    tooltip_value = dplyr::case_when(
      is.na(value) ~ "Not available",
      value_col == "annual_events_n" ~
        scales::comma(value, accuracy = 1),
      TRUE ~
        scales::comma(value, accuracy = 0.1)
    ),

    # Position label slightly above bar
    label_y = value + max(value, na.rm = TRUE) * 0.03
  )

     p <- ggplot2::ggplot(
  plot_dat,
  ggplot2::aes(
    x = factor(year),
    y = value
  )
) +
  ggplot2::geom_col(
    ggplot2::aes(
      text = paste0(
        "Year: ", year,
        "<br>", y_label, ": ",
        tooltip_value
      )
    ),
    fill = "#005A8B",
    width = 0.7,
    alpha = 0.9,
    na.rm = TRUE
  ) +

  ggplot2::geom_text(
    ggplot2::aes(
      y = label_y,
      label = label
    ),
    size = 3.5,
    na.rm = TRUE
  ) +

  ggplot2::scale_y_continuous(
    labels = scales::comma,
    expand = ggplot2::expansion(
      mult = c(0, 0.12)
    )
  ) +

  ggplot2::labs(
    title = title,
    x = NULL,
    y = y_label
  ) +

  event_theme


      plotly::ggplotly(
        p,
        tooltip = "text"
      )
    })
  })
}