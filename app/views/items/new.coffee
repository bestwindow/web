ul class:"breadcrumb",=>
  li ->
    a href:'/', '首页'
    span class:"divider",'/'
  li class:"active", =>"创建货物"

partial "form"

