class App.Message extends Tower.Model
  @store new Tower.Store.MongoDB name: "messages", type: "Message"
  @field "id", type: "Id"
  @field "owner",type:"Id"
  @field "with", type: "Id" 
  @field "messages", type: "Array"
  @field "read",type:"Number",default:0
  @timestamps()

  #__insc @constructor.find
  #@__super__.constructor.find

App.Message.relate = (data,relation,collection,next)->
  toArray = (one)->if !one.push then [one] else one
  Ids = []
  data = toArray data
  relation = toArray relation
  for i in [0..data.length-1]
    relation.forEach (el)->if data[i][el] then Ids.push String data[i][el]
  v.uniq Ids
  App[collection].find Ids,(e,rels)->
    rels = toArray rels
    ref2source = (item)->(v.find rels,(el)->String(el.id) == String(item)).attributes
    for i in [0..data.length-1]
      data[i]["$ref_#{collection.toLowerCase()}"]={}
      relation.forEach (el)->
        ell = if data[i]["attributes"] then data[i]["attributes"][el] else data[i][el]
        if ell
          data[i][el] = ref2source ell
          data[i]["$ref_#{collection.toLowerCase()}"][String(data[i][el].id)]=data[i][el]
    if data.length==1 then data = data[0]
    next null,data

App.Message.getFromRef = (data,collection,field)->
  data["$ref_#{collection.toLowerCase()}"][field]

App.Message._find = App.Message.find
App.Message.find=(query,next)->
  @_find query,(e,msgs)=>
    getItem = (next)->
      App.Message.relate msgs.messages ,['item'],'Item',(e,message)->
        msgs.messages = if !message.push then [message] else message
        next null,msgs

    getGhost = (e,msgWithItem)->
      App.Message.relate msgWithItem,['owner','with'],'Ghost',(e,messages)->
        for message in (if messages and messages.push then messages else [messages])
          for m in message.messages
            m.from = App.Message.getFromRef messages,'Ghost',m.from
        next null,messages
    
    getItem getGhost




