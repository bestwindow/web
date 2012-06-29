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
  map:(data,fn)->
    @all =>
      for i in [0..data.length-1]
        if data[i] && data[i].chunk && data[i].chunk.push
          res = []
          for j in [0..data[i].chunk.length-1]
            res.push @show data[i].chunk[j]
          data[i].chunk = res
      fn data
)()
