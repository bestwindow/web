
$ ->
  
  top.register = (->
    _dom = null
    anonymous = $ '.anonymous'
    registerDestoryCookie = $.cookie 'registerDestoryCookie'
    _dom = $ '#registerPanel'
    newRegisterPanel = (->
      if registerDestoryCookie or anonymous.length is 0 then return true
      _dom.removeClass 'hide'
    )()
    destoryer = $ '#registerDestoryBtn'
    if destoryer.length is 0 then return true
    destoryer.click ->
      $('#registerPanel').addClass 'hide'
      $.cookie 'registerDestoryCookie','true',expires:3600,path:'/'
  )()

  top.favorit = (->
    
    _show = (id)->
      return false if !favorits
      for el in favorits
        return true if id is el
      false
    init = ->
      return true if typeof(favorits) is 'undefined'
      dom = $ '.favorits'
      if $('.anonymous').length is 0 then dom.removeClass 'hide'
      for el in dom
        d = $(el)
        if _show d.attr('id').replace 'favorit-',''
          d.addClass 'favorited'
          d.html "取消收藏"
    init()
    create:(e)->
      dom = $ e.target
      itemId = dom.attr('id').replace 'favorit-',''
      url = "/favorit"
      $.post url,id:itemId,(data)->
        result = JSON.parse(data).result
        if result is null or result is true
          dom.addClass 'favorited'
          dom.html "取消收藏"
    destory:(e)->
      dom = $ e.target
      itemId = dom.attr('id').replace 'favorit-',''
      url = "/favorit/remove"
      $.post url,id:itemId,(data)->
        result = JSON.parse(data).result
        if result is null or result is true
          if dom.hasClass 'favoriteslist'
            top.location.reload()
          else
            dom.removeClass 'favorited'
            dom.html "收藏"
    toggle:(e)->
      dom = $ e.target
      itemId = dom.attr('id').replace 'favorit-',''
      isCreate = if dom.hasClass('favorited') then false else true
      if isCreate
        @create e
      else
        @destory e
  )()