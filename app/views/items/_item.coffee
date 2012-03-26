li class: "undefined", ->
  header class: "header", ->
    h3 @item.toLabel()
  dl class: "content", ->
    dt "Text:"
    dd @item.get("text")
    dt "Picture:"
    dd @item.get("picture")
    dt "Price:"
    dd @item.get("price")
  footer class: "footer", ->
    menu ->
      menuItem "Edit", urlFor(@item, action: "edit")
