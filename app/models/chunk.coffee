class App.Chunk extends Tower.Model
  @store new Tower.Store.MongoDB name: "chunks", type: "Chunk"
  @field "id", type: "Id"
  @field "founder", type: "Id"
  @field "title", type: "String"
  @field "path", type: "String"
  @timestamps()
  #@belongsTo "ghosts",type:'Ghost'

