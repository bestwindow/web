ul class:"breadcrumb",=>
  li ->
    a href:'/', '首页'
    span class:"divider",'/'
  li ->
    a href:'/chunks', '分类'
    span class:"divider",'/'
  li class:"active", =>"新建分类"

partial "form"
