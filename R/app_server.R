#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  #history
  mod_history_server("history_1")
  #events logic
  filt_dat_events <- mod_events_select_inputs_server("events_select_inputs_1")
  mod_events_pump_plot_server("events_pump_plot_1", filt_dat_events)
  mod_events_level_plot_server("events_level_plot_1", filt_dat_events)
  mod_events_gate_plot_server('events_gate_plot_1', filt_dat_events)
  mod_events_summary_tbl_server('events_summary_tbl_1', filt_dat_events)
}
