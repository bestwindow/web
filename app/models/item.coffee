class App.Item extends Tower.Model
  @store new Tower.Store.MongoDB name: "items", type: "Item"
  @field "id", type: "Id"
  @field "founder", type: "Id"
  @field "chunk",type:"Id"
  @field "text", type: "String"
  @field "picture", type: "String"
  @field "price", type: "Number"
  
  @timestamps()
