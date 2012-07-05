    nav id: "navigation", class: "navbar navbar-site", role: "navigation", ->
      div class: "navbar-inner", ->
        div class: "container", ->
          a class:"brand",href:"/","guofm"
          div ->
            ul class:"nav", ->
              li ->"线上Lifestyle指南， 手工为你调拭生活好品味。 每日发布10件精品。总计已发布1000件商品"
    div id:"sub-nav", ->
      div class:"upper", ->
        a href:"#","男装"
        a href:"#","女装"
        a href:"#","配饰"
        a href:"#","装备"
        a href:"#","旧货"
        a href:"#","日用杂货"
        a href:"#","居住"
        a href:"#","艺文"
        a class:"last",href:"#","食才美酒"    
      div class:"down", ->
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
                #li => linkTo "查看私信","/messages"
                li => linkTo "帐户设置","/ghosts/#{@request.user.id}/edit"
                li -> linkTo "退出登录","/exit"
