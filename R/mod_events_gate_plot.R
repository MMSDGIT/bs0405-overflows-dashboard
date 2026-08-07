#' events_gate_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_events_gate_plot_ui <- function(id) {

  ns <- NS(id)

  tagList(
      plotly::plotlyOutput(
        ns("gate_plot"),
        height = "650px"
      )
    )
}
    
#' events_gate_plot Server Functions
#'
#' @noRd 
#' events_gate_plot Server Functions
#'
#' @noRd
mod_events_gate_plot_server <- function(id, dat) {

  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    output$gate_plot <- plotly::renderPlotly({

      shiny::req(dat())

      hist_dat <- dat()[["hist_dat"]]

      shiny::req(nrow(hist_dat) > 0)

      gate_dat <- hist_dat |>
        dplyr::filter(param_type == "gate")

      shiny::req(nrow(gate_dat) > 0)

      p3 <- ggplot2::ggplot(
        gate_dat,
        ggplot2::aes(
          x = date_time,
          y = value,
          color = description,
          group = interaction(site, description),
          text = paste0(
            "Site: ", site,
            "<br>Gate: ", description,
            "<br>Time: ", date_time,
            "<br>Position: ", round(value, 1), "%"
          )
        )
      ) +
        ggplot2::geom_line(
          linewidth = 0.8,
          alpha = 0.9,
          na.rm = TRUE
        ) +
        ggplot2::facet_wrap(
          ggplot2::vars(site),
          ncol = 1
        ) +
        time_scale +
     #   ggplot2::scale_y_continuous(
     #     limits = c(0, 100),
     #     breaks = c(0, 25, 50, 75, 100),
     #     expand = ggplot2::expansion(
     #       mult = c(0.02, 0.04)
     #     )
     #   ) +
        ggplot2::labs(
          title = "Gate Positions (Percent Open)",
          x = NULL,
          y = "Position (%)",
          color = "Gate"
        ) +
        ggplot2::guides(
          color = ggplot2::guide_legend(
            nrow = 1,
            byrow = TRUE
          )
        ) +
      event_theme

      plotly::ggplotly(
        p3,
        tooltip = "text"
      )
    })

  })
}
    
## To be copied in the UI
# mod_events_gate_plot_ui("events_gate_plot_1")
    
## To be copied in the server
# mod_events_gate_plot_server("events_gate_plot_1")
