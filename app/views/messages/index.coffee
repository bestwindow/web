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
  li class:"active", =>"私信"

div class:"messageslist",=>
  partial "table"
partial "shared/paginate"


