# preview-plus package Preview Anything to Anything
-------------------------------------------------------

One Utility to handle the following matrix of previews
* coffeescript: ['JavaScript','HTML','htmlp']
* javascript: ['CoffeeScript','HTML','htmlp']
* jade: ['HTML','htmlp']
* slim: ['HTML','htmlp','erb']
* markdown: ['HTML','htmlp']
* jsx: ['JavaScript','HTML','htmlp']
* typescript: ['JavaScript']
* erb: ['HAML']
* haml: ['HTML','htmlp']
* html:['htmlp','Jade','Ruby Slim','GitHub Markdown','JSX','HAML']
* css: ['Stylus','LESS','Sass','SCSS']
* less: ['CSS']
* stylus: ['CSS']
* sass: ['CSS']
* scss: ['CSS']
* handlebars: ['HTML','htmlp']
* cjsx: ['JavaScript','HTML','htmlp','CoffeeScript']

Install
-----------
apm install preview-plus

Features
-----------
* Live Preview
* HTML Preview
* Select Compile To using the down arrow in status bar (eg. Incase of HTML it can compiled to SLIM/JADE/HAML/HTML Preview)
* Switch on HTML/Live Preview by clicking on Live Button on statusbar or double click on the to compile in the status bar
* Pass Compile to options(eg. pass bare:true to pp-options in case of coffeescript from the editor locally/as well from config setting)
* easy access to config file --> preview-plus:config (ctrl+alt+p)
* Extensible. More Compiler can be added/contributed
* Pass data to compiler (for eg in handlebars using pp-data tag)
* choose the filetypes to compiled to using the config file settings(fileTypes/alias for each grammar)
* All preview can have Local setting / Config~global settings..
* Support for SLIM/SASS/SCSS. These are possible only after the gem is installed in the system.

Check if it is working by going to the test folder(preview-plus/spec/test/) and try previewing each of it.


Go to the config settings in the preview-plus to change default (Live Switched on)
You change the default preview for each format from the config file.
Open the file using the command Preview-Plus:Config
Add fileTypes to identify to a particular grammar
All the available preview for each format is maintained in the config setting


Double on any format to display as HTMLPreview

preview Typescript to JS

Here is some video link to the demo
[![part1](https://raw.github.com/skandasoft/preview-plus/master/Youtube_Video.png)](//youtu.be/k-IhPp5csNQ)
[![part2](https://raw.github.com/skandasoft/preview-plus/master/Youtube_Video.png)](//youtu.be/WxUR6Sxpi5k)
[![part3](https://raw.github.com/skandasoft/preview-plus/master/Youtube_Video.png)](//youtu.be/iuqcmPsf4uo)
[![part4](https://raw.github.com/skandasoft/preview-plus/master/Youtube_Video.png)](//youtu.be/7e7ueiiW60g)

Issues
-----------
Currently It supports windows because some of the node modules are precompiled and bundled. This could be avoided by using dependencies. But since they need vc++ compilations It fails during installation in the apm install.

TODO
-----

* Write test case for all the compilations
