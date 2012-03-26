tableFor "items", (t) ->
  t.head ->
    t.row ->
      t.cell "text", sort: true
      t.cell "picture", sort: true
      t.cell "price", sort: true
      t.cell()
      t.cell()
      t.cell()
  t.body ->
    for item in @items
      t.row ->
        t.cell -> item.get("text")
        t.cell -> item.get("picture")
        t.cell -> item.get("price")
        t.cell -> linkTo 'Show', urlFor(item)
        t.cell -> linkTo 'Edit', urlFor(item, action: "edit")
        t.cell -> linkTo 'Destroy', urlFor(item), method: "delete"
  linkTo 'New Item', urlFor(App.Item, action: "new")
