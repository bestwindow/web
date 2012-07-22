    nav id: "navigation", class: "navbar navbar-site", role: "navigation", =>
      div class: "navbar-inner", =>
        div class: "container", =>
          a class:"brand",href:"/",->
            img src:"/images/logo.gif"
          if @request
            div class:"nav-sub",=>
              ul class:"nav pull-right",=>
                li class:"dropdown #{if !@request.user then 'anonymous' else 'logedin'}", =>
                  if !@request.user
                    a href:"/login", -> "用户登录"
                  else
                    a class:"dropdown-toggle","data-toggle":"dropdown",href:"#",->
                      text "帐户"
                      b class:"caret"
                    ul class:"dropdown-menu",=>
                      #li => linkTo "查看私信","/messages"
                      li => linkTo "帐户设置","/ghosts/#{@request.user.id}/edit"
                      li -> linkTo "退出登录","/exit"
              if @request.user
                a class:"fave",href:"/ghosts",-> "我的收藏"
    div id:"registerPanel",class:"hide",->
      div class:"words",->"果味调频是一个线上lifestyle指南，手工为你调试生活好品味。"
      div class:"pull-right",->
        span class:"registerBtn",onclick:"window.location.replace('/register')",->"&nbsp;注册"
        span id:"registerDestoryBtn",->"✕"
        
    div id:"sub-nav", ->
      div class:"upper", ->
        a href:"/","首页"
        a href:"/chunks/style","风格"
        a href:"/chunks/lohas","乐活"
        a href:"/chunks/body","身体"
        a href:"/chunks/creative","艺文"
        a href:"/chunks/hobby","兴趣"
        a href:"/chunks/vintage","VINTAGE"

