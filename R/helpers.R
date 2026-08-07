#helpers
library(ggplot2)

sum_na <- function(x) {
  if (all(is.na(x))) NA_real_ else sum(x, na.rm = TRUE)
}

  # Common time scale
  time_scale <- ggplot2::scale_x_datetime(
    date_breaks = "6 hours",
    date_labels = "%b %d\n%H:%M",
    expand = ggplot2::expansion(mult = c(0.01, 0.02))
  )


  event_theme <- theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 12,
      margin = margin(b = 3)
    ),
    plot.subtitle = element_text(
      size = 9,
      color = "grey40",
      margin = margin(b = 6)
    ),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(
      color = "grey90",
      linewidth = 0.3
    ),
    panel.grid.major.y = element_line(
      color = "grey88",
      linewidth = 0.35
    ),
    strip.text = element_text(
      face = "bold",
      size = 9
    ),
    strip.background = element_rect(
      fill = "grey94",
      color = NA
    ),
    axis.title = element_text(
      face = "bold",
      size = 9
    ),
    axis.text = element_text(size = 8),
    axis.title.x = element_blank(),
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.text = element_text(size = 8),
    legend.key.width = unit(14, "pt"),
    plot.margin = margin(5, 8, 5, 8)
  )
