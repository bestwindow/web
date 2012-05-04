$ ->
  $('body').prepend '<div id="impress" class="deck-container"></div>'
  book = $ "#impress"
  pageIndex = []
  top.page = []
  top.findChunk = (chunk)->
    for i in [0..page.length-1]
      return i if page[i] && page[i].chunk == chunk
    -1
  top.findItem = (itemId)->
    for i in [0..bookItems.length-1]
      return bookItems[i] if bookItems[i].id.toString() == itemId.toString()
    null

  top.showItem = (itemId)->
    item = findItem itemId
    return true if item == null
    html = [
      "<div class=img><img src=/image/#{item.picture}_7.jpg /></div>"
      "<div class=content><div class=\"price\">￥#{item.price}.00</div>"
      "<div class=\"text\">#{item.text}</div></div>"
    ].join ''
    $('#itemModal .modal-body').html html
    $('#itemModal .modal-footer').html item.text
    $('#itemModal').modal()


  makeBook = ->

    html =''
    pageTypeClass = 
      zero:['']
      three:['three']
      five:['five','five1','five2']
    for i in [0..bookItems.length-1]
      pagePos = findChunk bookItems[i].chunk
      pagePos = page.push({chunk:bookItems[i].chunk,chunkTitle:bookItems[i].chunktitle})-1 if pagePos < 0
      page[pagePos].items = [] if !page[pagePos].items
      page[pagePos].items.push bookItems[i]
    for i in [0..page.length-1]
      div = ''
      page[i].items.reverse()
      if page[i].items.length>=5
        blockLength = 5
      else if page[i].items.length>=3
        blockLength = 3
      else
        blockLength = page[i].items.length
      for j in [0..blockLength-1]
        div +=  "<span class=\"block#{j}\" onclick=\"showItem('#{page[i].items[j].id}')\"><div class=img><img src=/image/#{page[i].items[j].picture}_7.jpg /></div><div class=text>#{page[i].items[j].text}</div></span>"
        publishTime = page[i].items[j].createdAt
      div = "<div class=title>#{page[i].chunkTitle}&nbsp;&nbsp;<abbr class=\"timeago\" title=\"#{publishTime}\"> #{publishTime}</abbr></div>#{div}"
      if page[i].items.length>=5
        pageType = 'five'
      else if page[i].items.length>=3
        pageType = 'three'
      else
        pageType = 'zero'
      pageType = pageTypeClass[pageType][parseInt(Math.random()*pageTypeClass[pageType].length)]
      html+="<section class=\"bookpage slide #{pageType}\">#{div}</section>"
      html+='<p class="deck-status"><span class="deck-status-current"></span>/<span class="deck-status-total"></span></p>'
    book.html html
    $("abbr.timeago").timeago()
    $.deck '.slide'
  makeBook()



