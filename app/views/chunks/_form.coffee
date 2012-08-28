formFor @chunk, (f) =>
  f.fieldset (fields) =>
    fields.field "title", as: "string" , value: @chunk.get("title")
  
    fields.field "path", as: "string" , value: @chunk.get("path")
  
  f.fieldset (fields) ->
    fields.submit "Submit"
