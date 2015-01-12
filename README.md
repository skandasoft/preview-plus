# preview-plus package

Preview Anything to Anything

One Utility to handle the following matrix of previews
1. coffeescript: ['JavaScript','HTML','htmlp']
2. javascript: ['CoffeeScript','HTML','htmlp']
3. jade: ['HTML','htmlp']
4. slim: ['HTML','htmlp','erb']
5. markdown: ['HTML','htmlp']
6. jsx: ['JavaScript','HTML','htmlp']
7. typescript: ['JavaScript']
8. erb: ['HAML']
9. haml: ['HTML','htmlp']
10. html:['htmlp','Jade','Ruby Slim','GitHub Markdown','JSX','HAML']
11. css: ['Stylus','LESS','Sass','SCSS']
12. less: ['CSS']
13. stylus: ['CSS']
14. sass: ['CSS']
15. scss: ['CSS']
16. handlebars: ['HTML','htmlp']
17. cjsx: ['JavaScript','HTML','htmlp','CoffeeScript']

Features
1. Live Preview
2. HTML Preview
3. Select Compile To using the down arrow in status bar (eg. Incase of HTML it can compiled to SLIM/JADE/HAML/HTML Preview)
4. Switch on HTML/Live Preview by clicking on Live Button on statusbar or double click on the to compile in the status bar
5. Pass Compile to options(eg. pass bare:true to pp-options in case of coffeescript from the editor locally/as well from config setting)
6. easy access to config file --> preview-plus:config (ctrl+alt+p)
7. Extensible. More Compiler can be added/contributed
8. Pass data to compiler (for eg in handlebars using pp-data tag)
9. choose the filetypes to compiled to using the config file settings(fileTypes/alias for each grammar)
10. All preview can have Local setting / Config~global settings..
11. Support for SLIM/SASS/SCSS. These are possible only after the gem is installed in the system.

Check if it is working by going to the test folder(preview-plus/spec/test/) and try previewing each of it.

Below are some screen shots from them
Coffeescript to Javascript
![Coffeescript2Javascript](https://github.com/skandasoft/preview-plus/blob/master/coffee-js.gif?raw=true)

Javascript to Coffeescript
![Javascript2Coffeescript](https://github.com/skandasoft/preview-plus/blob/master/js-coffee.gif?raw=true)

Live Script Changes
All Preview can be switched live on/off by double clicking on the Live button on the status bar
Markdown to HTML / HTML Live Preview
![MarkDown2HTML](https://github.com/skandasoft/preview-plus/blob/master/markdown-live-htmlp.gif?raw=true)

css to any format LESS,Stylus,SASS,SCSS choose from dropdown
![CSS2Any](https://github.com/skandasoft/preview-plus/blob/master/css-live-stylus-scss-sass-less.gif?raw=true)

HTML to any format Slim/Jade/HAML/HTMLPreview/React JSX
![HTML2Any](https://github.com/skandasoft/preview-plus/blob/master/html-react-slim.gif?raw=true)

Preview Handlebar file to HTMLP and Double Click on Live to Stop Live display
use the block comment to pass data/options

use <pp-data> tag to pass data during preview

![handlebars2HTMLP](https://github.com/skandasoft/preview-plus/blob/master/handlebars-live-data-htmlp.gif?raw=true)


use <pp-options> tag to pass options to the compiler
![options-fileTypes](https://github.com/skandasoft/preview-plus/blob/master/options-filetypes.gif?raw=true)

FaceBook's React Preview for CJSX(coffeescript JSX) and JSX in HTML/HTML Preview
![facebook-react](https://github.com/skandasoft/preview-plus/blob/master/facebook-react-coffee-js.gif?raw=true)

Convert Jade to HTML
![jade2html](https://github.com/skandasoft/preview-plus/blob/master/jade-htmlp.gif?raw=true)

Convert Less to CSS
![less2css](https://github.com/skandasoft/preview-plus/blob/master/less-css.gif?raw=true)

Convert stylus to CSS
![stylus2css](https://github.com/skandasoft/preview-plus/blob/master/stylus-less.gif?raw=true)

Convert HAML to html/html Preview
![haml2html](https://github.com/skandasoft/preview-plus/blob/master/haml-htmp.gif?raw=true)

Open small set of lines using preview panel by selecting and right click on preview-plus to open the panel
and ESC to close it
![preview-panel](https://github.com/skandasoft/preview-plus/blob/master/preview-panel.gif?raw=true)

Go to the config settings in the preview-plus to change default (Live Switched on)
You change the default preview for each format from the config file.
Open the file using the command Preview-Plus:Config
Add fileTypes to identify to a particular grammar
All the available preview for each format is maintained in the config setting


Double on any format to display as HTMLPreview

preview Typescript to JS


Issues
Currently It supports windows because some of the node modules are precompiled and bundled. This could be avoided by using dependencies. But since they need vc++ compilations It fails during installation in the apm install.

TODO

1. Write test case for all the compilations
