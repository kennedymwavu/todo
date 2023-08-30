conn <- DBI::dbConnect(drv = RSQLite::SQLite(), Sys.getenv("db_name"))

# plumb----
plumber::pr(file = "todo.R") |>
  plumber::pr_hook(
    stage = "exit",
    handler = \(req) {
      DBI::dbDisconnect(conn)
    }
  ) |>
  plumber::pr_run(
    port = 8000,
    host = "0.0.0.0"
  )
