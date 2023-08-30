#' Run the api
#' @return [plumber::pr_run()]
#' @export
run_api <- \() {
  envir <- environment()
  envir$conn <- DBI::dbConnect(drv = RSQLite::SQLite(), Sys.getenv("db_name"))
  endpoints_file <- system.file("plumber", "endpoints.R", package = "todobend")
  if (endpoints_file == "") {
    stop(
      "Could not find the endpoints file. Try re-installing `todobend`.",
      call. = FALSE
    )
  }
  # plumb----
  plumber::pr(file = endpoints_file, envir = envir) |>
    plumber::pr_hook(
      stage = "exit",
      handler = \(req) {
        DBI::dbDisconnect(envir$conn)
      }
    ) |>
    plumber::pr_run(
      port = 8000,
      host = "0.0.0.0"
    )
}
