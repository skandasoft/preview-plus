var CompositeDisposable, PPError, PanelView, PreviewEditor, jQuery, loophole, path, _,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

path = require('path');

_ = require('lodash');

CompositeDisposable = require('atom').CompositeDisposable;

jQuery = require('jquery');

loophole = require('loophole');

PPError = function(name, message) {
  this.name = name;
  this.message = message;
};

PPError.prototype = new Error();

PreviewEditor = require('./editor');

PanelView = require('./panel-view');

module.exports = {
  config: require('./config'),
  toggleLive: function() {
    atom.config.set('preview-plus.livePreview', !atom.config.get('preview-plus.livePreview'));
    return this.previewStatus.live.toggleClass('on');
  },
  toggleHTML: function() {
    var editor, key;
    atom.config.set('preview-plus.htmlp', !atom.config.get('preview-plus.htmlp'));
    if (editor = atom.workspace.getActiveEditor()) {
      key = this.getGrammar(editor);
      if (atom.config.get('preview-plus.htmlp')) {
        if (__indexOf.call(this.config[key].enums, 'htmlu') >= 0 && atom.project.get('preview-plus.cproject').htmlu) {
          return this.previewStatus.updateCompileTo('htmlu');
        }
        if (__indexOf.call(this.config[key].enums, 'htmlp') >= 0) {
          return this.previewStatus.updateCompileTo('htmlp');
        }
      } else {
        return this.previewStatus.updateCompileTo(atom.config.get("preview-plus." + key));
      }
    }
  },
  showConfig: function() {
    var fileName, srcdir;
    srcdir = atom.project.get('preview-plus.srcdir');
    fileName = "" + srcdir + "/config.coffee";
    return atom.workspace.open(fileName, {
      searchAllPanes: true
    });
  },
  updateProject: function() {
    var cproject, project, _name, _ref;
    project = ((_ref = this.state) != null ? _ref.projectState : void 0) || {};
    cproject = project[_name = atom.project.path] != null ? project[_name] : project[_name] = {};
    if (cproject.base == null) {
      cproject.base = atom.project.path;
    }
    if (cproject.url == null) {
      cproject.url = 'http://localhost';
    }
    atom.project.set('preview-plus.project', project);
    atom.project.set('preview-plus.cproject', cproject);
    return atom.project.set('preview-plus.srcdir', __dirname);
  },
  activate: function(state) {
    var contextMenu, idx, itemSets;
    this.state = state;
    if (atom.project.path) {
      this.updateProject();
    }
    atom.project.on('path-changed', this.updateProject);
    atom.packages.onDidActivateAll((function(_this) {
      return function() {
        var PreviewStatusView, activePane, statusBar;
        statusBar = atom.workspaceView.statusBar;
        if (statusBar != null) {
          PreviewStatusView = require('./status-view');
          _this.previewStatus = new PreviewStatusView(_this);
          activePane = atom.workspace.getActivePaneItem();
          return _this.previewStatus.setCompilesTo(activePane);
        }
      };
    })(this));
    atom.workspace.addOpener(function(uri) {
      if (path.extname(uri) === '.htmlp') {
        return new PreviewEditor(uri);
      }
    });
    atom.workspace.onDidChangeActivePaneItem((function(_this) {
      return function(activePane) {
        var subscribe, _ref;
        if (!activePane) {
          return;
        }
        if ((_ref = _this.previewStatus) != null) {
          _ref.setCompilesTo(activePane);
        }
        if (typeof subscribe !== "undefined" && subscribe !== null) {
          if (typeof subscribe.dispose === "function") {
            subscribe.dispose();
          }
        }
        return subscribe = typeof activePane.onDidChangeGrammar === "function" ? activePane.onDidChangeGrammar(function() {
          var _ref1;
          activePane.set('preview-plus.compileTo');
          return (_ref1 = _this.previewStatus) != null ? _ref1.setCompilesTo(activePane) : void 0;
        }) : void 0;
      };
    })(this));
    atom.config.onDidChange('preview-plus.livePreview', (function(_this) {
      return function(obj) {
        var editor, editors, _i, _len;
        if (obj.newValue) {

        } else {
          _this.subscriptions.dispose();
          _this.subscriptions = new CompositeDisposable();
          _this.liveEditors = [];
        }
        editors = atom.workspace.getEditors();
        for (_i = 0, _len = editors.length; _i < _len; _i++) {
          editor = editors[_i];
          if (editor.get('preview-plus.livePreview') != null) {
            editor.set('preview-plus.livePreview', obj.newValue);
          }
        }
        if (atom.workspace.getActiveEditor()) {
          if (obj.newValue) {
            _this.previewStatus.live.removeClass('off');
            return _this.toggle();
          } else {
            return _this.previewStatus.live.addClass('off');
          }
        }
      };
    })(this));
    atom.commands.add('atom-workspace', {
      'preview-plus:base': (function(_this) {
        return function() {
          return _this.base();
        };
      })(this)
    });
    atom.commands.add('atom-workspace', {
      'preview-plus:preview': (function(_this) {
        return function() {
          return _this.toggle();
        };
      })(this)
    });
    atom.commands.add('atom-workspace', {
      'preview-plus:toggleLive': (function(_this) {
        return function() {
          return _this.toggleLive();
        };
      })(this)
    });
    atom.commands.add('atom-workspace', {
      'preview-plus:toggleHTML': (function(_this) {
        return function() {
          return _this.toggleHTML();
        };
      })(this)
    });
    atom.commands.add('atom-workspace', {
      'preview-plus:config': (function(_this) {
        return function() {
          return _this.showConfig();
        };
      })(this)
    });
    this.liveEditors = this.views = [];
    this.subscriptions = new CompositeDisposable();
    idx = null;
    itemSets = atom.contextMenu.itemSets;
    contextMenu = _.find(itemSets, function(item, itemIdx) {
      idx = itemIdx;
      return item.items[0].command === 'preview-plus:preview';
    });
    if (contextMenu != null) {
      itemSets.splice(idx, 1);
      itemSets.unshift(contextMenu);
    }
    return atom.contextMenu.itemSets = itemSets;
  },
  base: function() {
    var HTMLBaseView;
    if (this.htmlBaseView) {
      return this.htmlBaseView.parent().show();
    } else {
      HTMLBaseView = require('./htmlbase');
      this.htmlBaseView = new HTMLBaseView(this);
      atom.workspace.addModalPanel({
        item: this.htmlBaseView
      });
      return this.htmlBaseView.base.focus();
    }
  },
  toggle: function() {
    var cfgs, compiled, data, dfd, e, editor, error, first_line, lang, liveSubscription, options, text, to;
    try {
      if (!(editor = atom.workspace.getActiveEditor())) {
        return;
      }
      text = this.getText(editor);
      cfgs = atom.config.get('preview-plus');
      if (editor.get('preview-plus.livePreview') && !(__indexOf.call(this.liveEditors, editor) >= 0)) {
        this.liveEditors.push(editor);
        editor.buffer.stoppedChangingDelay = cfgs['liveMilliseconds'];
        liveSubscription = editor.onDidStopChanging(this.listen);
        editor.set('preview-plus.livePreview-subscription', liveSubscription);
        this.subscriptions.add(liveSubscription);
      }
      this.key = this.getGrammar(editor);
      this.toKey = this.getCompileTo(editor, this.key);
      if (this.toKey === 'htmlu') {
        return this.preview(editor);
      }
      to = this.config[this.key][this.toKey];
      lang = require("./lang/" + this.key);
      data = this.getContent('data', text);
      options = this.getContent('options', text);
      if (to.options instanceof Array && options) {
        to.options = _.union(to.options, options);
      } else {
        to.options = jQuery.extend(to.options, options);
      }
      compiled = lang[to.compile](text, to.options, data);
      if (typeof compiled === 'string') {
        return this.preview(editor, compiled);
      } else {
        dfd = compiled;
        dfd.done((function(_this) {
          return function(text) {
            if (_this.compiled = text) {
              return _this.preview(editor, text);
            }
          };
        })(this));
        return dfd.fail(function(text) {
          var e;
          e = new Error();
          e.name = 'console';
          e.message = text;
          throw e;
        });
      }
    } catch (_error) {
      e = _error;
      console.log(e.message);
      if (e.name === 'alert') {
        return alert(e.message);
      } else {
        if (e.location) {
          first_line = e.location.first_line;
          error = text.split('\n').slice(0, first_line).join('\n');
        }
        error += '\n' + e.toString().split('\n').slice(1).join('\n') + '\n' + e.message;
        return this.preview(editor, error, true);
      }
    }
  },
  getContent: function(tag, text) {
    var data, match, regex;
    regex = new RegExp("<pp-" + tag + ">([\\s\\S]*?)</pp-" + tag + ">");
    match = text.match(regex);
    if ((match != null) && match[1].trim()) {
      return data = loophole.allowUnsafeEval(function() {
        return eval("(" + match[1] + ")");
      });
    }
  },
  preview: function(editor, text, err) {
    var activePane, ext, grammar, split, syntax, title, to, _ref;
    if (err == null) {
      err = false;
    }
    activePane = atom.workspace.paneForItem(editor);
    split = this.getPosition(activePane);
    to = (_ref = this.config[this.key]) != null ? _ref[this.toKey] : void 0;
    if (!to) {
      return atom.confirm('Cannot Preview');
    }
    ext = err ? "" + to.ext + ".err" : to.ext;
    title = "preview~" + (editor.getTitle()) + "." + ext;
    grammar = to && !err ? to.ext : syntax = editor.getGrammar();
    if (syntax == null) {
      syntax = atom.syntax.selectGrammar(grammar);
    }
    if (!err && editor.getSelectedText() && (this.toKey !== 'htmlp' && this.toKey !== 'htmlu')) {
      if (this.panelItem) {
        return this.panelItem.showPanel(text, syntax);
      } else {
        this.panelItem = new PanelView(title, text, syntax);
        return atom.workspace.addBottomPanel({
          item: this.panelItem
        });
      }
    } else {
      return atom.workspace.open(title, {
        searchAllPanes: true,
        split: split
      }).then((function(_this) {
        return function(view) {
          var compiledPane, errView, uri;
          _this.view = view;
          _this.view.save = function() {};
          _this.views.push(_this.view);
          if (_this.toKey === 'htmlu') {
            _this.view.setTextorUrl({
              url: _this.getUrl(editor)
            });
          } else {
            if (_this.key === 'HTML') {
              _this.view.setTextorURL({
                url: editor.getPath()
              });
            } else {
              _this.view.setText(text);
            }
          }
          if (ext === 'htmlp') {
            console.log(text);
          } else {
            _this.view.setGrammar(syntax);
            _this.view.moveCursorToTop();
          }
          compiledPane = atom.workspace.getActivePane();
          uri = _this.view.getUri();
          if (path.extname(title) === '.err') {
            uri = uri.replace('.err', '');
            errView = compiledPane.itemForUri(uri);
          } else {
            errView = compiledPane.itemForUri("" + uri + ".err");
          }
          if (errView) {
            errView.destroy();
          }
          if (_this.view.get('preview-plus.cursorFocusBack') || atom.config.get('preview-plus.cursorFocusBack')) {
            return activePane.activate();
          }
        };
      })(this));
    }
  },
  getUrl: function(editor) {
    var text, url;
    text = editor.lineForScreenRow(editor.getCursor().getScreenRow()).text;
    url = this.getTextTag('pp-url', text) || this.getTextTag('pp-url', editor.getText()) || path.basename(editor.getPath());
    return "" + (atom.project.get('preview-plus.cproject').url) + "/" + url;
  },
  getTextTag: function(tag, text) {
    var match, regex;
    regex = new RegExp("<" + tag + ">([\\s\\S]*?)</" + tag + ">");
    match = text.match(regex);
    if (match != null) {
      return match[1].trim();
    }
  },
  deactivate: function() {
    return this.previewStatus.destroy();
  },
  serialize: function() {
    var view, viewState, _i, _len, _ref;
    viewState = [];
    _ref = this.views;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      view = _ref[_i];
      if (typeof view.serialize === "function" ? view.serialize() : void 0) {
        viewState.push;
      }
    }
    return {
      previewState: this.previewStatus.serialize(),
      viewState: viewState,
      projectState: atom.project.get('preview-plus.project')
    };
  },
  listen: function() {
    var view;
    view = atom.workspaceView.getActiveView();
    return atom.commands.dispatch(view[0], 'preview-plus:preview');
  },
  getGrammar: function(editor) {
    var cfg, editorPath, ext, grammar, key;
    grammar = editor.getGrammar();
    key = null;
    cfg = _.find(this.config, function(val, k) {
      key = k;
      return (val.name != null) && val.name === grammar.name;
    });
    if (cfg == null) {
      cfg = _.find(this.config, function(val, k) {
        var _ref;
        key = k;
        return (val.alias != null) && (_ref = grammar.name, __indexOf.call(val.alias, _ref) >= 0);
      });
    }
    if (!cfg) {
      editorPath = editor.getPath();
      ext = path.extname(editorPath).slice(1);
    }
    if (cfg == null) {
      cfg = _.find(this.config, function(val, k) {
        key = k;
        return (val.fileTypes != null) && __indexOf.call(val.fileTypes, ext) >= 0;
      });
    }
    if (cfg == null) {
      cfg = _.find(this.config, function(val, k) {
        var regx;
        key = k;
        regx = new RegExp(grammar.name, "gi");
        if ((val.name != null) && val.name.search(regx) >= 0) {
          return true;
        }
      });
    }
    if (cfg) {
      return key;
    } else {
      throw new PPError('alert', 'Set the Grammar for the Editor');
    }
  },
  getPosition: function(activePane) {
    var orientation, paneAxis, paneIndex, _ref;
    paneAxis = activePane.getParent();
    paneIndex = paneAxis.getPanes().indexOf(activePane);
    orientation = (_ref = paneAxis.orientation) != null ? _ref : 'horizontal';
    if (orientation === 'horizontal') {
      if (paneIndex === 0) {
        return 'right';
      } else {
        return 'left';
      }
    } else {
      if (paneIndex === 0) {
        return 'down';
      } else {
        return 'top';
      }
    }
  },
  getCompileTo: function(editor, key) {
    var toKey;
    if (!(toKey = editor.get('preview-plus.compileTo'))) {
      toKey = atom.config.get("preview-plus." + key);
      editor.set('preview-plus.compileTo', toKey);
    }
    return toKey || (function() {
      throw new PPError('alert', 'Cannot Preview');
    })();
  },
  getText: function(editor) {
    var selected, text;
    selected = editor.getSelectedText();
    text = selected || editor.getText();
    if (text.length === 0 || !text.trim()) {
      throw new PPError('alert', 'No Code to Compile');
    } else {
      return text;
    }
  }
};
