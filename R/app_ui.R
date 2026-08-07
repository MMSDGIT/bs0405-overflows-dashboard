#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  shiny::tagList(
    golem_add_external_resources(),

    tags$head(
      tags$script(src = "www/loc-map.js"),
      tags$script(
        src = "https://cdn.jsdelivr.net/npm/d3-textwrap@3/dist/d3-textwrap.min.js"
      ),
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "www/custom.css"
      )
    ),

    fresh::use_theme(bs4DashTheme),

    bs4Dash::bs4DashPage(
      title = "BS0405 viewR",
      dark = NULL,
      help = NULL,
      fullscreen = TRUE,

      header = bs4Dash::bs4DashNavbar(
        title = "BS0405 viewR",
        skin = "light"
      ),

      sidebar = bs4Dash::bs4DashSidebar(
        skin = "dark",
        status = "primary",
        minified = TRUE,

        br(),

        tags$a(
          href = "https://www.mmsd.com/",
          target = "_blank",
          tags$img(
            src = "www/mmsd_logo.jpg",
            style = "display:block; margin: 0 auto; width: 186px;"
          )
        ),

        tags$div(
          style = "padding: 12px 0;"
        ),

        mod_sidebar_menu_ui("sidebar_menu_1")
      ),

      body = bs4Dash::bs4DashBody(
        mod_dashboard_body_ui("dashboard_body_1")
      ),

      footer = bs4Dash::bs4DashFooter(
        left = "This application is proudly brought to you by the Water Systems Monitoring Department."
      )
    )
  )
}
#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "bs0405.vieweR"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
