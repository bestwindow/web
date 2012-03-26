li class: "undefined", ->
  header class: "header", ->
    h3 @message.toLabel()
  dl class: "content", ->
    dt "Body:"
    dd @message.get("body")
  footer class: "footer", ->
    menu ->
      menuItem "Edit", urlFor(@message, action: "edit")
