var $, $$, $$$, HTMLBase, View, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ref = require('atom'), $ = _ref.$, $$ = _ref.$$, $$$ = _ref.$$$, View = _ref.View;

module.exports = HTMLBase = (function(_super) {
  __extends(HTMLBase, _super);

  function HTMLBase() {
    return HTMLBase.__super__.constructor.apply(this, arguments);
  }

  HTMLBase.content = function() {
    var project;
    project = atom.project.get('preview-plus.cproject');
    return this.div({
      "class": 'preview-plus-base'
    }, (function(_this) {
      return function() {
        _this.div({
          "class": 'base',
          outlet: 'base'
        }, function() {
          _this.span("HTML Base");
          return _this.input({
            "class": 'native-key-bindings',
            type: 'text',
            id: 'href',
            value: "" + project.base
          });
        });
        _this.div({
          "class": 'url',
          outlet: 'url'
        }, function() {
          _this.span("HTML URL");
          return _this.input({
            "class": 'native-key-bindings',
            type: 'text',
            id: 'url',
            value: "" + project.url
          });
        });
        _this.div(function() {
          _this.span("Use Default - URL/Local Server For HTML Preview  ");
          if (project.htmlu) {
            return _this.input({
              type: 'checkbox',
              id: 'htmlu',
              checked: 'checked'
            });
          } else {
            return _this.input({
              type: 'checkbox',
              id: 'htmlu'
            });
          }
        });
        return _this.div(function() {
          return _this.input({
            type: 'button',
            value: 'confirm',
            click: 'onConfirm'
          });
        });
      };
    })(this));
  };

  HTMLBase.prototype.setURL = function(evt, ele) {
    this.url.toggle();
    return this.base.toggle();
  };

  HTMLBase.prototype.initialize = function(model) {
    this.model = model;
    atom.commands.add(this.element, {
      'core:confirm': (function(_this) {
        return function() {
          return _this.onConfirm();
        };
      })(this),
      'core:cancel': (function(_this) {
        return function() {
          return _this.cancel();
        };
      })(this)
    });
    return this.element.onblur = (function(_this) {
      return function() {
        return _this.close;
      };
    })(this);
  };

  HTMLBase.prototype.close = function() {
    atom.workspace.getActivePane().activate();
    return this.parent().hide();
  };

  HTMLBase.prototype.cancel = function() {
    return this.close();
  };

  HTMLBase.prototype.onConfirm = function() {
    var cproject, key, project, val, _ref1;
    cproject = atom.project.get('preview-plus.cproject');
    cproject.htmlu = this.find('#htmlu').prop('checked');
    cproject.url = this.find('#url').val();
    cproject.base = this.find('#href').val();
    atom.project.set('preview-plus.cproject', cproject);
    project = atom.project.get('preview-plus.project');
    for (key in cproject) {
      val = cproject[key];
      project[key] = val;
    }
    atom.project.set('preview-plus.project', project);
    if ((_ref1 = this.model.previewStatus) != null) {
      _ref1.setCompilesTo(atom.workspace.getActivePaneItem());
    }
    this.model.toggle();
    return this.close();
  };

  return HTMLBase;

})(View);
