class App.Item extends Tower.Model
  @store new Tower.Store.MongoDB name: "items", type: "Item"
  @field "id", type: "Id"
  @field "founder", type: "Id"
  @field "text", type: "String"
  @field "html", type: "String"
  @field "title", type: "String"
  @field "picture", type: "String"
  @field "chunk",type:"Array"
  
  @timestamps()
