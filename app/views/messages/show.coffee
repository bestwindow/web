javascriptTag "/_j/jquery.timeago.js"
javascriptTag "/_j/jquery.timeago.zh-CN.js"

coffeescript ->
  $ ->
    $("abbr.timeago").timeago()




contentFor "title", "全部私信"


ul class:"breadcrumb",=>
  li ->
    a href:'/', '首页'
    span class:"divider",'/'  
  li ->
    a href:'/messages', '私信'
    span class:"divider",'/'    
  li class:"active", =>"和#{@message.with.name}的私信对话"




user = @request.user

tableFor "messages", (t) ->
  t.head =>
    t.row =>
      t.cell()
      t.cell =>
        partial "form"
      t.cell()
      #t.cell()
  t.body ->
    for i in [@message.messages.length-1..0]
      message = @message.messages[i]
      t.row ->
        t.cell -> 
          if message.from.name==user.name
            text "我:"
          else
            linkTo "#{message.from.name}:","/shells/#{message.from.id}"
        t.cell -> 
          if message.item
            div class:"well span4",->
              a href:"/items/#{message.item.id}",->
                img src:"/image/#{message.item.picture}_0.jpg",class:"item_picture_small"
                span message.item.text.split('\r\n')[0]
          div -> App.sanitizer.escape message.body
        t.cell -> 
          abbr class:"timeago",title:"#{App.moment(message.createdAt).format(App.iso8601)}",->"#{App.moment(message.createdAt).format(App.iso8601)}"
        #t.cell -> linkTo 'Destroy', urlFor(message), method: "delete"

