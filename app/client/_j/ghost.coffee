
$ ->

  top.favorit = (->
    
    _show = (id)->
      return false if !favorits
      for el in favorits
        return true if id is el
      false
    init = ->
      return true if !favorits or favorits.length<=0
      dom = $ '.favorits'
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