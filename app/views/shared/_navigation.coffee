    div id: "navigation", class: "navbar navbar-site", role: "navigation", =>
      div class:"nav-header",->
        div class:"brand",->
          a href:"#"
          div "1234"
      div class: "navbar-inner", =>
        div class:"nav-collapse collapse",=>
          ul class:"nav",=>
            li ->
              a href:"#",->"下载"
            li class:"divider-vertical"
            li ->
              a href:"#",->"SUBMIT"
            li class:"divider-vertical"


        