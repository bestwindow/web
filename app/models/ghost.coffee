class App.Ghost extends Tower.Model
  @store new Tower.Store.MongoDB name: "ghosts", type: "Ghost"
  @field "id", type: "Id"
  @field "email", type: "String"
  @field "name", type: "String"
  @field "user", type: "String"
  @field "responsibility",type: "Number",default:10000
  @field "read",type:"Number",default:0
  @timestamps()
  #@hasMany "items"
  #@hasMany "chunks", type: "Chunk"

