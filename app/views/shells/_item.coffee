li class: "undefined", ->
  header class: "header", ->
    h3 @ghost.toLabel()
  dl class: "content", ->
    dt "Name:"
    dd @ghost.get("name")
