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
    enums: ['JavaScript','HTML','htmlp']
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

  javascript:
    name: 'JavaScript'
    title: 'JavaScript 2'
    # description: 'JavaScript 2'
    type: 'string'
    default: 'CoffeeScript'
    enums: ['CoffeeScript','HTML','htmlp']
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

  jade:
    name: 'Jade'
    title: 'Jade 2'
    # description: 'Jade 2'
    type: 'string'
    default: 'HTML'
    enums: ['HTML','htmlp']
    HTML:
      ext:'html'
      compile:'html'
      options: pretty:true
    htmlp:
      compile:'htmlp'
      ext:'htmlp'

  slim:
    name: 'Ruby Slim'
    title: 'Slim 2'
    # description: 'Slim 2'
    type: 'string'
    default: 'HTML'
    enums: ['HTML','htmlp','erb']
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

  markdown:
    name: 'GitHub Markdown'
    title: 'MarkDown 2'
    # description: 'MarkDown 2'
    type: 'string'
    cssURL: 'http://jasonm23.github.io/markdown-css-themes/markdown1.css'
    default: 'HTML'
    enums: ['HTML','htmlp']
    HTML:
      ext:'html'
      compile: 'html'
    htmlp:
      ext:'htmlp'
      compile: 'htmlp'
  typescript:
    name: 'TypeScript'
    title: 'TypeScript 2'
    type: 'string'
    default: 'JavaScript'
    enums: ['JavaScript']
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
    enums: ['JavaScript','HTML','htmlp']
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
    resources:
      csss:[]
      scripts:['react.js']

  erb:
    name: 'ERB'
    title: 'ERB 2'
    type: 'string'
    default: 'HAML'
    enums: ['HAML']
    HAML:
      ext:'haml'
      compile:'haml'
      options: ['-s','-e']

  haml:
    name: 'HAML'
    fileTypes:['haml']
    title: 'HAML 2'
    type: 'string'
    default: 'HTML'
    enums: ['HTML','htmlp']
    HTML:
      ext:'html'
      compile:'html'
    htmlp:
      ext:'htmlp'
      compile:'htmlp'

  html:
    name:'HTML'
    title: 'HTML 2'
    # description: 'HTML 2'
    type: 'string'
    default: 'htmlp'
    enums: ['htmlp','Jade','Ruby Slim','GitHub Markdown','JSX','HAML']
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

  css:
    title: 'CSS 2'
    name: 'CSS'
    # description: 'CSS 2'
    type: 'string'
    default: 'Stylus'
    enums: ['Stylus','LESS','Sass','SCSS']
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
    enums: ['CSS']
    CSS:
      ext: 'css'
      compile: 'css'

  stylus:
    name: 'Stylus'
    title: 'Stylus 2'
    # description: 'Stylus 2'
    type: 'string'
    default: 'CSS'
    enums: ['CSS']
    CSS:
      ext: 'css'
      compile:'css'
      options: {}

  sass:
    name: 'Sass'
    title: 'Sass 2'
    type: 'string'
    default: 'CSS'
    enums: ['CSS']
    CSS:
      ext: 'css'
      compile:'css'
      options : ['-s']

  scss:
    name: 'SCSS'
    title: 'Scss 2'
    type: 'string'
    default: 'CSS'
    enums: ['CSS']
    CSS:
      ext: 'css'
      compile:'css'
      options : ['-s','--SCSS']

  handlebars:
    name: 'Handlebars'
    title: 'Handlebars 2'
    type: 'string'
    default: 'HTML'
    enums: ['HTML','htmlp']
    alias: ['HTML (Mustache)']
    fileTypes: ['handlebars']
    HTML:
      ext:'html'
      compile:'html'
    htmlp:
      ext:'htmlp'
      compile:'htmlp'

  cjsx:
    name: 'CoffeeScript (JSX)'
    title: 'CJSX 2'
    type: 'string'
    default: 'HTML'
    enums: ['JavaScript','HTML','htmlp','CoffeeScript']
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
    JavaScript:
      ext:'js'
      compile:'js'
      options: [{bare:true}]

    CoffeeScript:
      ext: 'coffee'
      compile: 'cs'
      options: indent: "\t"
