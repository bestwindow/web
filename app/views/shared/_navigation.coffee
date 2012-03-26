ul class:"nav", ->
  li ->
    linkTo "分类", "/chunks"
ul class:"nav pull-right",=>
  li class:"dropdown", =>
    if !@request.user
      linkTo "登录", "/login"
    else
      a class:"dropdown-toggle","data-toggle":"dropdown",href:"#",->
        text "#{@request.user.name}"
        b class:"caret"
      ul class:"dropdown-menu",=>
        li -> linkTo "我的首页","/ghosts"
        li => linkTo "查看私信","/messages"
        li => linkTo "帐户设置","/ghosts/#{@request.user.id}/edit"
        li -> linkTo "退出登录","/exit"
  if @request.user.read && @request.user.read>0
    li =>
      a href:"/messages", =>
        span class:"badge","#{@request.user.read}"
