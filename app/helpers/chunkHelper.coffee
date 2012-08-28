App.chunkDef = 
  Style:
    apparel:[
      "coat"
      "tshirt"
      "tops"
      "bottom"
      "skirts"
      "dress" 
      "suits"
      "kids"
      "underdress"
    ]
    accessories:[
      "bags-handbags"
      "wallet"
      "jewelry"
      "shoes"
      "scarf-tie"
      "hats"
      "glasses"
      "belts"
      "watch"
    ]
  Lohas:
    zakka:[
      "kitchen"
      "stationery"
      "ware"
      "pets"
      "crafts"
      "paper"
    ]
    organic:[
      "plants"
      "Farming"
    ]
    food:[
      "drinks"
      "coffee-tea"
      "homemade"
      "vegeterian"
      "bakery"
      "localfood"
    ]
  Body:[
    "health-fitness" 
    "skin" 
    "hair" 
    "grooming" 
    "fragrances"
    ]
  Hobby:
    home:[
      "deco"
      "furniture"
      "lights"
      "appliance"
    ]
    geek:[
      "itech"
      "electronics"
      "toys"
      "tools"
    ]
    game:[
      "sports"
      "outfits"
    ]
  Creative:
    "photo-films":[
      "polariod"
      "photobook"
      "lomo"
    ]
    publication:[
      "western-zine"  
      "japan-zine"  
      "HK-TW"
      "indies"
    ]
    arts:[
      "sculpture"
      "cerimic"
      "prints"
    ]
    musics:[
      "Vinyl-Turntables"
      "Headphones-sounds"
      "Instruments"
    ]
  Vintage:[
    "fleamarket"
    "mid-century"
    "Antiques"
    "vintage-cloth"
    ]




App.ChunkHelper = (->
  renew:(fn)->
    App.Chunk.all (error, chunks)->
      App.chunks = chunks
      fn chunks
  all:(fn)->
    if !App.chunks
      @renew (chunks)->
        fn null,chunks
    else
      fn null,App.chunks
  show:(chunkid)->
    for el in App.chunks
      return el if "#{el.id}" == chunkid
  orderByTree:(chunks)->
    return chunks if chunks.length<=1 or !chunks.push
    result = []
    indexByPath = (p)->
      for i in [0..chunks.length-1]
        return i if chunks[i] && chunks[i].path==p.toLowerCase()
      return -1
    splice = (idx)->
      if idx >=0 then chunks.splice(idx,1)[0] else null
    push = (r)->
      if r then result.push r
    process = (path)->
      push splice indexByPath path
    for e1,valueE1 of App.chunkDef
      process e1
      if valueE1.push
        for e2 in valueE1
          process e2
      else
        for e2,valueE2 of valueE1
          process e2
          for e3 in valueE2
            process e3
    return result
  map:(data,fn)->
    @all =>
      dataIsArray = if data.push then true else false
      data = [data] if !dataIsArray
      for i in [0..data.length-1]
        if data[i] && data[i].chunk && data[i].chunk.push
          res = []
          for j in [0..data[i].chunk.length-1]
            res.push @show data[i].chunk[j]
          data[i].chunk = @orderByTree res
      if dataIsArray then fn data else fn data[0]
)()




