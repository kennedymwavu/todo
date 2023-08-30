#' Create todo list
#'
#' Creates a new todo list (sqlite table) with the given name. Uses
#' \href{https://solutions.posit.co/connections/db/best-practices/run-queries-safely/#interpolation-by-hand}{interpolation by hand}
#' @param conn DB connection
#' @param todo Name of the todo list
#' @export
create_todo <- \(conn, todo) {
  if (DBI::dbExistsTable(conn = conn, name = todo)) {
    stop(sprintf("Todo list '%s' already exists.", todo), call. = FALSE)
  }
  query <- DBI::sqlInterpolate(
    conn = conn,
    sql = "CREATE TABLE ?table_name (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, item TEXT);",
    table_name = todo
  )
  DBI::dbExecute(conn = conn, statement = query)
}

#' Show all available todos
#'
#' @param conn DB connection
#' @export
read_todos <- \(conn) {
  todos <- DBI::dbListTables(conn = conn)
  setdiff(todos, "sqlite_sequence")
}

#' Deletes a todo list
#'
#' @param conn DB connection
#' @param todo Name of the todo list
#' @export
delete_todo <- \(conn, todo) {
  if (!DBI::dbExistsTable(conn = conn, name = todo)) {
    stop(sprintf("Todo list '%s' does not exist.", todo), call. = FALSE)
  }
  DBI::dbRemoveTable(conn = conn, name = todo)
}

#' Create todo items
#'
#' @param conn DB connection
#' @param todo Name of the todo list
#' @param items A character vector of the new todo items
#' @export
create_items <- \(conn, todo, items) {
  if (!DBI::dbExistsTable(conn = conn, name = todo)) {
    stop(sprintf("Todo list '%s' does not exist.", todo), call. = FALSE)
  }
  lapply(items, \(item) {
    query <- DBI::sqlInterpolate(
      conn = conn,
      sql = "INSERT INTO ?table_name (item) VALUES(?new_item);",
      table_name = todo,
      new_item = item
    )
    DBI::dbExecute(conn = conn, statement = query)
  })
}

#' Read items of a todo list
#'
#' @param conn DB connection
#' @param todo Name of the todo list
#' @export
read_items <- \(conn, todo) {
  if (!DBI::dbExistsTable(conn = conn, name = todo)) {
    stop(sprintf("Todo list '%s' does not exist.", todo), call. = FALSE)
  }
  DBI::dbReadTable(conn = conn, name = todo)
}

#' Read a specific item in a todo list
#'
#' @param conn DB connection
#' @param todo Name of the todo list
#' @param item_id Item id
#' @export
read_item <- \(conn, todo, item_id) {
  if (!DBI::dbExistsTable(conn = conn, name = todo)) {
    stop(sprintf("Todo list '%s' does not exist.", todo), call. = FALSE)
  }
  query <- DBI::sqlInterpolate(
    conn = conn,
    sql = "SELECT * FROM ?table_name WHERE id = ?item_id;",
    table_name = todo,
    item_id = item_id
  )
  DBI::dbGetQuery(conn = conn, statement = query)
}

#' Update a todo list item
#'
#' @param conn DB connection
#' @param todo Name of the todo list
#' @param item_id Item id
#' @param updated_item Updated item
#' @export
update_item <- \(conn, todo, item_id, updated_item) {
  if (!DBI::dbExistsTable(conn = conn, name = todo)) {
    stop(sprintf("Todo list '%s' does not exist.", todo), call. = FALSE)
  }
  query <- DBI::sqlInterpolate(
    conn = conn,
    sql = "UPDATE ?table_name SET item = ?updated_item WHERE id = ?item_id;",
    table_name = todo,
    updated_item = updated_item,
    item_id = as.integer(item_id)
  )
  DBI::dbExecute(conn = conn, statement = query)
}

#' Delete todo items
#'
#' @param conn DB connection
#' @param todo Name of the todo list
#' @param item_ids Ids of the items to delete
#' @export
delete_items <- \(conn, todo, item_ids) {
  if (!DBI::dbExistsTable(conn = conn, name = todo)) {
    stop(sprintf("Todo list '%s' does not exist.", todo), call. = FALSE)
  }
  lapply(item_ids, \(item_id) {
    query <- DBI::sqlInterpolate(
      conn = conn,
      sql = "DELETE FROM ?table_name WHERE id = ?item_id;",
      table_name = todo,
      item_id = as.integer(item_id)
    )
    DBI::dbExecute(conn = conn, statement = query)
  })
}

#' Delete all items in a todo list
#'
#' @param conn DB connection
#' @param todo Name of the todo list
#' @export
delete_all_items <- \(conn, todo) {
  if (!DBI::dbExistsTable(conn = conn, name = todo)) {
    stop(sprintf("Todo list '%s' does not exist.", todo), call. = FALSE)
  }
  query <- DBI::sqlInterpolate(
    conn = conn,
    sql = "DELETE FROM ?table_name;",
    table_name = todo
  )
  DBI::dbExecute(conn = conn, statement = query)
}
