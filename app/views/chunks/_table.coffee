tableFor "chunks", (t) ->
  t.head ->
    t.row ->
      t.cell "title", sort: true
      t.cell "path", sort: true
      t.cell()
      t.cell()
      t.cell()
  t.body ->
    for chunk in @chunks
      t.row ->
        t.cell -> chunk.get("title")
        t.cell -> chunk.get("path")
        t.cell -> linkTo 'Show', "/chunks/#{chunk.get("path")}"
        t.cell -> linkTo 'Edit', urlFor(chunk, action: "edit")
        t.cell -> linkTo 'Destroy', urlFor(chunk), method: "delete"
  linkTo 'New Chunk', urlFor(App.Chunk, action: "new")
