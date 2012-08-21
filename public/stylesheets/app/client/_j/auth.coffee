
$(function() {
  $.submitLock = (function(init) {
    var lock;
    lock = init;
    return {
      status: function() {
        return lock;
      },
      on: function(b) {
        lock = true;
        return b;
      },
      off: function(b) {
        lock = false;
        return b;
      },
      toggle: function(b) {
        lock = lock === true ? false : true;
        return b;
      }
    };
  })(false);
  $.validation = function(formId, inputIds) {
    var form;
    form = $("#" + formId);
    return form.submit(function(e) {
      var input, validate, _i, _len;
      if ($.submitLock.status()) return false;
      form = $("#" + formId);
      $.submitLock.on();
      validate = function(id) {
        var dom;
        dom = $("#" + id);
        $('.formError').remove();
        if (dom.attr('type') !== 'password') dom.val($.trim(dom.val()));
        if (dom.val() === '' && dom.attr('class').indexOf('required') > 0) {
          return true;
        } else {
          return form.validationEngine('validateField', "#" + id);
        }
      };
      for (_i = 0, _len = inputIds.length; _i < _len; _i++) {
        input = inputIds[_i];
        if (validate(input)) return $.submitLock.off(false);
      }
      setTimeout((function() {
        return submitLock.on(true);
      }), 10000);
      return true;
    });
  };
  return $.authErr = function(e) {
    var email, translate;
    if (e.indexOf("does not exist") > 0) {
      email = e.replace('User with login ', '').replace(" does not exist", '');
      e = "does not exist";
    }
    translate = {
      "Someone already has claimed that login.": "用户名或邮件已经注册过了",
      "Failed login.": "邮件或密码不正确",
      "Missing login.": "邮件或密码不正确",
      "Missing password.": "邮件或密码不正确",
      "does not exist": "\"" + email + "\"这个邮件没有注册过"
    };
    return translate[e];
  };
});
