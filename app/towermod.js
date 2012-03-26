//the path of view stored wrong 
Tower.View.Rendering._readTemplate = _readTemplate = function(template, prefixes, ext) {

    var result, _base, _name;
    if (typeof template !== "string") return template;
    //jerry's modify: https://github.com/viatropos/tower/issues/30
    path = prefixes?(prefixes+'/'+template):template
    result = (_base = this.constructor.cache)[_name = "app/views/" + path] || (_base[_name] = this.constructor.store().find({
      path: template,
      ext: ext,
      prefixes: prefixes
    }));
    if (!result) throw new Error("Template '" + template + "' was not found.");
    return result;
}
Tower.View.include(Tower.View.Rendering)





Tower.Store.MongoDB.Serialization.serializeOptions = function(options) {
    if (options == null) options = {};
    if (typeof(options.offset)!='undefined')options.skip = options.offset
    return options;
  }
Tower.Store.MongoDB.include(Tower.Store.MongoDB.Serialization);