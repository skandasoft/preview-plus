module.exports =
  livePreview:
    title: 'Live Preview'
    type: 'boolean'
    default: false
  cursorFocusBack:
    default: true
    type: 'boolean'
    title: 'Set Cursor Focus Back'

  liveMilliseconds:
    title: 'MilliSeconds'
    type: 'number'
    default: 1200
    min: 600

  htmlp:
    title: 'HTML Preview'
    type: 'boolean'
    default: false
  htmlu:
    default: false
    type: 'boolean'
    title: 'HTML URL'
  webview:
    title: 'WebView'
    type: 'boolean'
    default: true

  coffeescript:
    name: 'CoffeeScript'
    title: 'CoffeeScript 2'
    # description: 'CoffeeScript 2'
    type: 'string'
    default: 'JavaScript'
    enum: ['JavaScript','HTML','htmlu','htmlp']
    alias: ['CoffeeScript (Literate)']
    fileTypes: ['coff']
    JavaScript:
      ext: 'js'
      compile: 'js'
      options: bare:true
    HTML:
      ext:'html'
      compile:'html'
    htmlp:
      ext:'htmlp'
      compile:'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'

  javascript:
    name: 'JavaScript'
    title: 'JavaScript 2'
    # description: 'JavaScript 2'
    type: 'string'
    default: 'CoffeeScript'
    enum: ['CoffeeScript','HTML','htmlp']
    CoffeeScript:
      ext: 'coffee'
      compile: 'cs'
      options: indent: "\t"
    HTML:
      ext:'html'
      compile:'html'
    htmlp:
      ext:'htmlp'
      compile:'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'

  ect:
    name: 'ECT'
    title: 'ECT 2'
    type: 'string'
    fileTypes: ['ect']
    alias: ['ECT <<','ECT {{','ECT <%','ECT <?']
    filePath: true
    default: 'HTML'
    enum: ['HTML','htmlu','htmlp']
    HTML:
      ext:'html'
      compile:'html'
      options:
        open: '{{'
        close: '}}'
      # options:
      #   open: '<%'
      #   close: '%>'

    htmlp:
      compile:'htmlp'
      ext:'htmlp'
      options:
        open: '{{'
        close: '}}'
      # options:
      #   open: '<%'
      #   close: '%>'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'

  jade:
    name: 'Jade'
    title: 'Jade 2'
    # description: 'Jade 2'
    type: 'string'
    default: 'HTML'
    enum: ['HTML','htmlp']
    HTML:
      ext:'html'
      compile:'html'
      options: pretty:true
    htmlp:
      compile:'htmlp'
      ext:'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'

  slim:
    name: 'Ruby Slim'
    title: 'Slim 2'
    # description: 'Slim 2'
    type: 'string'
    default: 'HTML'
    enum: ['HTML','htmlu','htmlp','erb']
    HTML:
      ext:'html'
      compile: 'html'
      options: ['-s','-p']
    erb:
      ext:'erb'
      compile: 'erb'
      options: ['-s','-e']
    htmlp:
      ext:'htmlp'
      compile: 'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'

  markdown:
    name: 'GitHub Markdown'
    title: 'MarkDown 2'
    # description: 'MarkDown 2'
    type: 'string'
    cssURL: 'http://jasonm23.github.io/markdown-css-themes/markdown1.css'
    default: 'HTML'
    enum: ['HTML','htmlu','htmlp']
    HTML:
      ext:'html'
      compile: 'html'
    htmlp:
      ext:'htmlp'
      compile: 'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'

  typescript:
    name: 'TypeScript'
    title: 'TypeScript 2'
    type: 'string'
    default: 'JavaScript'
    enum: ['JavaScript']
    JavaScript:
      ext:'js'
      compile:'js'
      options: {}
      tscArgs: {}

  jsx:
    name: 'JavaScript (JSX)'
    title: 'JSX 2'
    type: 'string'
    default: 'JavaScript'
    enum: ['JavaScript','HTML','htmlu','htmlp']
    JavaScript:
      ext:'js'
      compile:'js'
      options: sourceMap: true
    HTML:
      ext:'html'
      compile:'html'
    htmlp:
      ext:'htmlp'
      compile:'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'
    resources:
      csss:[]
      scripts:['react.js']

  erb:
    name: 'ERB'
    title: 'ERB 2'
    type: 'string'
    default: 'HAML'
    enum: ['HAML','htmlu','htmlp']
    fileTypes:['erb']
    HAML:
      ext:'haml'
      compile:'haml'
      options: ['-s','-e']
    htmlp:
      ext:'htmlp'
      compile:'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'

  haml:
    name: 'HAML'
    fileTypes:['haml']
    title: 'HAML 2'
    type: 'string'
    default: 'HTML'
    enum: ['HTML','htmlu','htmlp']
    HTML:
      ext:'html'
      compile:'html'
    htmlp:
      ext:'htmlp'
      compile:'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'

  html:
    name:'HTML'
    title: 'HTML 2'
    type: 'string'
    default: 'htmlp'
    # enum: ['htmlp','Jade','Ruby Slim','GitHub Markdown','JSX','HAML']
    enum: ['htmlp','htmlu','Jade','Ruby Slim','HAML','browser']
    Jade:
      ext: 'jade'
      compile:'jade'
    'Ruby Slim':
      ext: 'slim'
      compile:'slim'
      options: {}
    htmlp:
      ext: 'htmlp'
      compile:'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'
    'GitHub Markdown':
      ext: 'md'
      compile:'md'
    JSX:
      ext: 'jsx'
      compile: 'jsx'
      options: createClass: true
    HAML:
      ext: 'haml'
      compile: 'haml'
    browser:
      compile: 'browser'
      view: require('./status-view').BrowserView

  css:
    title: 'CSS 2'
    name: 'CSS'
    # description: 'CSS 2'
    type: 'string'
    default: 'Stylus'
    enum: ['Stylus','LESS','Sass','SCSS']
    Stylus:
      ext: 'styl'
      compile: 'stylus'
    LESS:
      ext: 'less'
      compile: 'less'
      options: {}

    Sass:
      ext: 'sass'
      compile: 'sass'
      options: ['SASS']

    SCSS:
      ext: 'scss'
      compile: 'scss'
      options: ['SCSS']

  less:
    name:'LESS'
    title: 'LESS 2'
    # description: 'LESS 2'
    type: 'string'
    default: 'CSS'
    enum: ['CSS']
    CSS:
      ext: 'css'
      compile: 'css'

  stylus:
    name: 'Stylus'
    title: 'Stylus 2'
    # description: 'Stylus 2'
    type: 'string'
    default: 'CSS'
    enum: ['CSS']
    CSS:
      ext: 'css'
      compile:'css'
      options: {}

  sass:
    name: 'Sass'
    title: 'Sass 2'
    type: 'string'
    default: 'CSS'
    enum: ['CSS']
    CSS:
      ext: 'css'
      compile:'css'
      options : ['-s']

  scss:
    name: 'SCSS'
    title: 'Scss 2'
    type: 'string'
    default: 'CSS'
    enum: ['CSS']
    CSS:
      ext: 'css'
      compile:'css'
      options : ['-s','--SCSS']

  handlebars:
    name: 'Handlebars'
    title: 'Handlebars 2'
    type: 'string'
    default: 'HTML'
    enum: ['HTML','htmlu','htmlp']
    alias: ['HTML (Mustache)']
    fileTypes: ['handlebars']
    HTML:
      ext:'html'
      compile:'html'
    htmlp:
      ext:'htmlp'
      compile:'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'

  cjsx:
    name: 'CoffeeScript (JSX)'
    title: 'CJSX 2'
    type: 'string'
    default: 'HTML'
    enum: ['JavaScript','HTML','htmlp','htmlu','CoffeeScript']
    scripts:['https://cdnjs.cloudflare.com/ajax/libs/react/0.12.2/react.js']
    resources:
      csss:[]
      scripts:[]
    HTML:
      ext:'html'
      compile:'html'
    htmlp:
      ext:'htmlp'
      compile:'htmlp'
    htmlu:
      ext:'htmlu'
      compile:'htmlu'
    JavaScript:
      ext:'js'
      compile:'js'
      options: [{bare:true}]

    CoffeeScript:
      ext: 'coffee'
      compile: 'cs'
      options: indent: "\t"

  browser:
    title: 'Browser'
    type: 'boolean'
    default: true
    win32:
      IE:
        cmd: 'start iexplore '
      CHROME:
        cmd:  'start chrome '
      FF:
        cmd:  'start firefox '
      OPERA:
        cmd: 'start opera '
      SAFARI:
        cmd: 'start safari '
    win64:
      IE:
        cmd: 'start iexplore '
      CHROME:
        cmd:  'start chrome '
      FF:
        cmd:  'start firefox '
      OPERA:
        cmd: 'start opera '
      SAFARI:
        cmd: 'start safari '
    darwin:
      CHROME:
        cmd: 'open -a "Google Chrome" '
      FF:
        cmd: 'open -a "Firefox" '
      SAFARI:
        cmd: 'open -a "Safari" '
      OPERA:
        cmd: 'open -a "Opera" '
    linux:
      CHROME:
        cmd: 'chrome '
      FF:
        cmd: 'firefox '
      SAFARI:
        cmd: 'safari '
      OPERA:
        cmd: 'opera '
