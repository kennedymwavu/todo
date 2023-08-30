#* Create a new todo list
#* @param todo Name of the todo list
#* @post /todo
\(todo) {
  create_todo(conn, todo = todo)
}

#* View available todo lists
#* @get /todo
\() {
  read_todos(conn)
}

#* Create new todo items
#* @param todo Name of the todo list
#* @param items The todo items to create
#* @post /todo/<todo>
\(todo, items) {
  create_items(conn, todo = todo, items = items)
}

#* Read all items in a todo
#* @param todo Name of the todo list
#* @get /todo/<todo>
\(todo) {
  read_items(conn, todo = todo)
}

#* Read a specific item in a todo
#* @param todo Name of the todo list
#* @param item_id Item id
#* @get /todo/<todo>/<item_id:int>
\(todo, item_id) {
  read_item(conn, todo = todo, item_id = item_id)
}

#* Update an item
#* @param todo Name of the todo list
#* @param item_id Item id
#* @param item The updated item
#* @put /todo/<todo>/<item_id:int>
\(todo, item_id, item) {
  update_item(conn, todo = todo, item_id = item_id, updated_item = item)
}

#* Delete todo items
#* @param todo Name of the todo list
#* @param item_ids Ids of the items to delete
#* @delete /todo/<todo>
\(todo, item_ids) {
  delete_items(conn, todo = todo, item_ids = item_ids)
}

#* Delete all items in a todo
#* @delete /todo
\(todo) {
  delete_all_items(conn, todo = todo)
}
