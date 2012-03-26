tableFor "ghosts", (t) ->
  t.head ->
    t.row ->
      t.cell "email", sort: true
      t.cell "name", sort: true
      t.cell "user", sort: true
      t.cell()
      t.cell()
      t.cell()
  t.body ->
    for ghost in @ghosts
      t.row ->
        t.cell -> ghost.get("email")
        t.cell -> ghost.get("name")
        t.cell -> ghost.get("user")
        t.cell -> linkTo 'Show', urlFor(ghost)
        t.cell -> linkTo 'Edit', urlFor(ghost, action: "edit")
        t.cell -> linkTo 'Destroy', urlFor(ghost), method: "delete"
  linkTo 'New Ghost', urlFor(App.Ghost, action: "new")
