li class: "undefined", ->
  header class: "header", ->
    h3 @chunk.toLabel()
  dl class: "content", ->
    dt "Title:"
    dd @chunk.get("title")
    dt "Path:"
    dd @chunk.get("path")
  footer class: "footer", ->
    menu ->
      menuItem "Edit", urlFor(@chunk, action: "edit")
