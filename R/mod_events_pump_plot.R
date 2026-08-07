#' events_pump_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_events_pump_plot_ui <- function(id) {

  ns <- NS(id)

  tagList(
    bs4Dash::bs4Card(
      title = "Overflow Pump Volume",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      closable = FALSE,
      collapsible = TRUE,
      collapsed = FALSE,

      plotly::plotlyOutput(
        ns("pump_plot"),
        height = "650px"
      )
    )
  )
}
    
#' events_pump_plot Server Functions
#'
#' @noRd 
#' events_pump_plot Server Functions
#'
#' @noRd
mod_events_pump_plot_server <- function(id, dat) {

  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    output$pump_plot <- plotly::renderPlotly({

      shiny::req(dat())

      hist_dat <- dat()[["hist_dat"]]

      shiny::req(nrow(hist_dat) > 0)

      pump_dat <- hist_dat |>
        dplyr::filter(param_type == "pump")

      shiny::req(nrow(pump_dat) > 0)

      pump_totals <- pump_dat |>
        dplyr::summarise(
          value = sum_na(value),
          .by = c(site, date_time)
        )

      p1 <- ggplot2::ggplot() +
        ggplot2::geom_line(
          data = pump_dat,
          ggplot2::aes(
            x = date_time,
            y = value,
            color = description,
            group = interaction(site, description),
            text = paste0(
              "Site: ", site,
              "<br>Pump: ", description,
              "<br>Time: ", date_time,
              "<br>Volume: ", round(value, 2)
            )
          ),
          linewidth = 0.55,
          alpha = 0.65,
          na.rm = TRUE
        ) +
        ggplot2::geom_line(
          data = pump_totals,
          ggplot2::aes(
            x = date_time,
            y = value,
            group = site,
            text = paste0(
              "Site: ", site,
              "<br>Total",
              "<br>Time: ", date_time,
              "<br>Volume: ", round(value, 2)
            )
          ),
          color = "black",
          linewidth = 1.35,
          na.rm = TRUE
        ) +
        ggplot2::facet_wrap(
          ggplot2::vars(site),
          ncol = 1,
          scales = "free_y"
        ) +
        time_scale +
        ggplot2::labs(
          title = "Overflow Pump Volume",
          subtitle = "Black line shows combined overflow volume",
          x = NULL,
          y = "Volume (MG)",
          color = "Pump"
        ) +
        ggplot2::guides(
          color = ggplot2::guide_legend(
            nrow = 1,
            byrow = TRUE
          )
        ) + event_theme

      plotly::ggplotly(
        p1,
        tooltip = "text"
      )
    })

  })
}
    
## To be copied in the UI
# mod_events_pump_plot_ui("events_pump_plot_1")
    
## To be copied in the server
# mod_events_pump_plot_server("events_pump_plot_1")
