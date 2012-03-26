formFor @message, (f) =>
  div class:"well",=>
    input name:"message[item]",type:"hidden",value:String(@item.id) if @item?
    input name:"message[to]",type:"hidden",value:String(@to.id)
    div "询价&购买#{@item.get('text')}" if @item?
    div "发私信给:#{@to.name}"

    textarea id:"message-textarea",name:"message[body]",style:"width:99%;height:100px"
    input type:"submit",class:"btn btn-primary",value:"发送"
    a class:"btn",href:"javascript:history.back()","取消" if @item?

coffeescript ->
  $("#message-form").submit (e) ->
    if $('#message-textarea').val() is '' then false else true
