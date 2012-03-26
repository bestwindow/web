tableFor "messages", (t) =>
  t.head ->
    t.row ->
      t.cell "body", sort: true
      t.cell()
      t.cell()
  t.body =>
    for message in @messages
      t.row ->
        t.cell onclick:"window.location.replace('#{urlFor(message)}')",-> 
          text "与#{message.with.name}的私信"
        t.cell onclick:"window.location.replace('#{urlFor(message)}')",->
          if message.latestItem
            div class:"well span4",->
              img src:"/image/#{message.latestItem.picture}_0.jpg",class:"item_picture_small"
              span message.latestItem.text.split('\r\n')[0]
          div -> "#{App.sanitizer.escape message.get 'latest'}"
        t.cell onclick:"window.location.replace('#{urlFor(message)}')",->
          abbr class:"timeago",title:"#{App.moment(message.updatedAt).format(App.iso8601)}",->"#{App.moment(message.updatedAt).format(App.iso8601)}"
          if parseInt(message.get('read'),10)>0 then span class:"badge","#{message.get('read')}"
       # t.cell -> linkTo 'Destroy', urlFor(message), method: "delete"
