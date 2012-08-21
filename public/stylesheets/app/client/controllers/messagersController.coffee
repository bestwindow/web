var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

App.MessagersController = (function(_super) {

  __extends(MessagersController, _super);

  function MessagersController() {
    MessagersController.__super__.constructor.apply(this, arguments);
  }

  return MessagersController;

})(Tower.Controller);
