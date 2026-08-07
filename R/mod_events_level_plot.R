#' events_level_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_events_level_plot_ui <- function(id) {

  ns <- NS(id)

  tagList(
      plotly::plotlyOutput(
        ns("level_plot"),
        height = "650px"
      )
  )
}
    
#' events_level_plot Server Functions
#'
#' @noRd 
#' events_level_plot Server Functions
#'
#' @noRd
mod_events_level_plot_server <- function(id, dat) {

  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    output$level_plot <- plotly::renderPlotly({

      shiny::req(dat())

      hist_dat <- dat()[["hist_dat"]]

      shiny::req(nrow(hist_dat) > 0)

      level_dat <- hist_dat |>
        dplyr::filter(param_type == "level")

      level_dat <- hist_dat |>
  dplyr::filter(param_type == "level") |>
  dplyr::mutate(
    site = factor(
      site,
      levels = c(
        "MS0401",
        "BS0405",
        "DC0402"
      )
    )
  )

      shiny::req(nrow(level_dat) > 0)

      p2 <- ggplot2::ggplot(
        level_dat,
        ggplot2::aes(
          x = date_time,
          y = value,
          color = description,
          group = interaction(site, description),
          text = paste0(
            "Site: ", site,
            "<br>Parameter: ", description,
            "<br>Time: ", date_time,
            "<br>Level: ", round(value, 2)
          )
        )
      ) +
        ggplot2::geom_line(
          linewidth = 0.75,
          alpha = 0.9,
          na.rm = TRUE
        ) +
        ggplot2::facet_wrap(
          ggplot2::vars(site),
          ncol = 1,
          scales = "free_y"
        ) +
        time_scale +
        ggplot2::scale_y_continuous(
          breaks = scales::pretty_breaks(n = 4),
          expand = ggplot2::expansion(
            mult = c(0.05, 0.08)
          )
        ) +
        ggplot2::labs(
          title = "System Levels",
          x = NULL,
          y = "Level (FT)",
          color = "Parameter"
        ) +
        ggplot2::guides(
          color = ggplot2::guide_legend(
            nrow = 1,
            byrow = TRUE
          )
        ) +
      event_theme

      plotly::ggplotly(
        p2,
        tooltip = "text"
      )
    })

  })
}
## To be copied in the UI
# mod_events_level_plot_ui("events_level_plot_1")
    
## To be copied in the server
# mod_events_level_plot_server("events_level_plot_1")
