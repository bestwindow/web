tableFor "ghosts", (t) =>
  t.head ->
    t.row ->
      t.cell "name", sort: true
  t.body =>
    for ghost in @ghosts
      t.row ->
        t.cell -> linkTo ghost.get("name"),"/shells/#{ghost.id}"
