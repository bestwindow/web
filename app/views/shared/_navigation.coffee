    div id: "navigation", class: "navbar navbar-site", role: "navigation", =>
      div class:"nav-header",->
        div class:"brand",->
          a href:"/"
          div "( ´ ▽ ` )ﾉ(￣▽￣)"
      div class: "navbar-inner", =>
        div class:"nav-collapse collapse",=>
          ul class:"nav",=>
            li ->
              a href:"/",->"首页"
            li class:"divider-vertical"
            li ->
              a href:"/chunks/guide",->"指南"
            li class:"divider-vertical"
            li ->
              a href:"/chunks/download",->"下载"
            li class:"divider-vertical"
            li ->
              a href:"/chunks/latest",->"正在发生的事"
            li class:"divider-vertical"
          div class:"pull-right hide",->
            if !@request or !@request.user
              a href:"/login", -> "用户登录&nbsp;&nbsp;"
            else
              linkTo "帐户","/ghosts/#{@request.user.id}/edit"
              text "&nbsp;&nbsp;"
        