ul class:"breadcrumb",=>
  li ->
    a href:'/', '首页'
    span class:"divider",'/'
  li class:"active", =>"新建私信"

div class:"row",=>
  div class:"span8",=> 
    partial "form"