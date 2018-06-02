system_calls_addin <- function() {

  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("List system calls"),
    miniUI::miniContentPanel(
      shiny::textInput('evil_path', 'path:', value = '.')
    )
  )

  server <- function(input, output, session) {

    shiny::observeEvent(input$done, {
      rstudioapi::sendToConsole(
        paste0("defender::summarize_system_calls('", input$evil_path, "')")
      )
      shiny::stopApp()
    })

  }

  viewer <- shiny::dialogViewer('system calls')
  shiny::runGadget(ui, server, viewer = viewer)
}

check_namespace_addin <- function() {

  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("List system imports"),
    miniUI::miniContentPanel(
      shiny::textInput('evil_path', 'path:', value = '.')
    )
  )

  server <- function(input, output, session) {

    shiny::observeEvent(input$done, {
      rstudioapi::sendToConsole(
        paste0("defender::check_namespace('", input$evil_path, "')")
      )
      shiny::stopApp()
    })

  }

  viewer <- shiny::dialogViewer('list system imports')
  shiny::runGadget(ui, server, viewer = viewer)
}
