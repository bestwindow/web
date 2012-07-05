class App.ChunksController extends App.ApplicationController
  @param "title"
  @param "path"

  @beforeAction (next)->
    switch @action
      when 'admin' then @loadUser =>@nextUrl @isMaster(),next,'/chunks'
      when 'create','new','update','edit' then @loadUser =>@nextUrl @request.user,next,'/chunks'
      else @loadUser next

  
  admin: ->
    App.ChunkHelper.all (error, chunks) =>
      @chunks = chunks
      @render "admin"

  index: ->
    if @format=='json'
      App.ChunkHelper.all (error, chunks) =>@render json:chunks
    else
      App.ChunkHelper.all (error, chunks) =>
        @paginate = 
          limit:App.pageLimit
          page:@pagination.current @params.page
          route:"/chunks/page/" 
        App.Item
        .paginate(@paginate)
        .order('createdAt',"desc")
        .find (error,items)=>
          @chunks = chunks
          @paginate.end = @pagination.end items 
          @items = items
          @render "index"
      
  new: ->
    @chunk = new App.Chunk
    @render "new"

  create:->
    chunk = @params.chunk
    chunk.path = @params.chunk.path.toLowerCase().trim().split ','
    chunk.title = chunk.title.trim().split ','
    chunks = []  
    succeed= =>
      App.ChunkHelper.renew =>
        @response.redirect "/chunks"
    
    creater = (fn)->
      chunk = chunks.splice(0,1)[0]
      console.log JSON.stringify chunk
      App.Chunk.create chunk,->
        fn null  
    waterfall = []
    for i in [0..chunk.path.length-1]
      chunks.push 
        founder:@request.user.attributes.user
        path:chunk.path[i].trim()
        title:chunk.title[i].trim()
      waterfall.push creater
    waterfall.push succeed
    v.waterfall.apply this,waterfall

  show:  ->
    
    App.Chunk.where(path:@params.id).first (error, resource) =>
      if resource
        @chunk = resource
        @paginate = 
          limit:App.pageLimit
          page:@pagination.current @params.page
          route:"/chunks/#{@params.id}/page/" 
        App.Item
        .paginate(@paginate)
        .where(chunk:String resource.id)#.where(chunk:$nin:[String resource.id])
        .order('createdAt',"desc")
        .find (error,items)=>
          items = [items] if !items.push
          @paginate.end = @pagination.end items
          @items = items
          @render "show"
      else
        @response.redirect "/chunks"

  edit: ->
    App.Chunk.find @params.id, (error, resource) =>
      if resource
        @chunk = resource
        @render "edit"
      else
        @response.redirect "/chunks"
      
  update: ->
    App.Chunk.find @params.id ,(error, resource) =>
      if error
        @response.redirect "/chunks/#{@params.id}/edit"
      else
        resource.updateAttributes @params.chunk, (error) =>
          @response.redirect "/chunks/#{@params.id}"

  destroy: ->
    App.Chunk.find @params.id, (error, resource) =>
      console.log "@chunk:"+resource
      if error
        @response.redirect "/chunks"
      else
        resource.destroy (error) =>
          @response.redirect "/chunks"
          
          
          
###chunks
风格,服装,外套,T恤,上衣,下装,裙子,礼服,西服,童装,内衣,配饰,包及手袋,钱夹,首饰,鞋,围巾领带,帽子,眼镜,皮带,乐活,杂货,餐厨,文具,器皿,宠物,手工艺品,纸品,有机,植物,农场,食材,酒品,咖啡与茶,自制,素食,烘焙,特产,身体,塑型,护肤,护发,剃须,香水,兴趣,家居,饰品,家具,灯具,电器,极客,数码周边,电子设备,玩具,工具,运动户外,运动,户外,艺文,影像,宝丽来,影像书,出版,欧美刊,日刊,港台书籍,独立出版,艺术,雕塑,陶瓷,印品,音乐,唱片-唱机,耳机音响,乐器,Vintage,旧货,20世纪设计,古董,古董衣

Style,apparel,coat,tshirt,tops,bottom,skirts,dress,suits,kids,underdress,accessories,bags-handbags,wallet,jewelry,shoes,scarf-tie,hats,glasses,belts,Lohas,zakka,kitchen,stationery,ware,pets,crafts,paper,organic,plants,Farming,food,drinks,coffee-tea,homemade,vegeterian,bakery,localfood,Body,health-fitness,skin,hair,grooming,fragrances,Hobby,home,deco,furniture,lights,appliance,geek,itech,electronics,toys,tools,game,sports,outfits,Creative,photo-films,polariod,photobook,publication,western-zine,japan-zine,HK-TW,indies,arts,sculpture,cerimic,prints,musics,Vinyl-Turntables,Headphones-sounds,Instruments,Vintage,fleamarket,mid-century,Antiques,vintage-cloth
###          

