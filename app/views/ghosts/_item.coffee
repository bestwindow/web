li class: "undefined", ->
  header class: "header", ->
    h3 @ghost.toLabel()
  dl class: "content", ->
    dt "Email:"
    dd @ghost.get("email")
    dt "Name:"
    dd @ghost.get("name")
    dt "User:"
    dd @ghost.get("user")
  footer class: "footer", ->
    menu ->
      menuItem "Edit", urlFor(@ghost, action: "edit")
