(function() {

  $(function() {
    top.register = (function() {
      var anonymous, destoryer, newRegisterPanel, registerDestoryCookie, registerPanel, sloganPanel;
      registerPanel = null;
      sloganPanel = null;
      anonymous = $('.anonymous');
      registerDestoryCookie = $.cookie('registerDestoryCookie');
      registerPanel = $('#registerPanel');
      sloganPanel = $('#sloganPanel');
      newRegisterPanel = (function() {
        if (registerDestoryCookie || anonymous.length === 0) {
          return sloganPanel.removeClass('hide');
        }
        registerPanel.removeClass('hide');
        return sloganPanel.addClass('hide');
      })();
      destoryer = $('#registerDestoryBtn');
      if (destoryer.length === 0) return true;
      return destoryer.click(function() {
        $('#registerPanel').addClass('hide');
        $('#sloganPanel').removeClass('hide');
        return $.cookie('registerDestoryCookie', 'true', {
          expires: 3600,
          path: '/'
        });
      });
    })();
    return top.favorit = (function() {
      var init, _show;
      _show = function(id) {
        var el, _i, _len;
        if (!favorits) return false;
        for (_i = 0, _len = favorits.length; _i < _len; _i++) {
          el = favorits[_i];
          if (id === el) return true;
        }
        return false;
      };
      init = function() {
        var d, dom, el, _i, _len, _results;
        if (typeof favorits === 'undefined') return true;
        dom = $('.favorits');
        if ($('.anonymous').length === 0) dom.removeClass('hide');
        _results = [];
        for (_i = 0, _len = dom.length; _i < _len; _i++) {
          el = dom[_i];
          d = $(el);
          if (_show(d.attr('id').replace('favorit-', ''))) {
            d.addClass('favorited');
            _results.push(d.html("取消收藏"));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };
      init();
      return {
        create: function(e) {
          var dom, itemId, url;
          dom = $(e.target);
          itemId = dom.attr('id').replace('favorit-', '');
          url = "/favorit";
          return $.post(url, {
            id: itemId
          }, function(data) {
            var result;
            result = JSON.parse(data).result;
            if (result === null || result === true) {
              dom.addClass('favorited');
              return dom.html("取消收藏");
            }
          });
        },
        destory: function(e) {
          var dom, itemId, url;
          dom = $(e.target);
          itemId = dom.attr('id').replace('favorit-', '');
          url = "/favorit/remove";
          return $.post(url, {
            id: itemId
          }, function(data) {
            var result;
            result = JSON.parse(data).result;
            if (result === null || result === true) {
              if (dom.hasClass('favoriteslist')) {
                return top.location.reload();
              } else {
                dom.removeClass('favorited');
                return dom.html("收藏");
              }
            }
          });
        },
        toggle: function(e) {
          var dom, isCreate, itemId;
          dom = $(e.target);
          itemId = dom.attr('id').replace('favorit-', '');
          isCreate = dom.hasClass('favorited') ? false : true;
          if (isCreate) {
            return this.create(e);
          } else {
            return this.destory(e);
          }
        }
      };
    })();
  });

}).call(this);
