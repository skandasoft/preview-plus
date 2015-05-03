# preview-plus package Preview Anything to Anything
----------------------------------------------------
INSTALL  BROWSER-PLUS --> apm install browser-plus or check out in the packages

One Utility to handle the following matrix of previews
* Coffeescript: ['JavaScript','HTML','htmlp']
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
for issues with installation please update the github for resolution.

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
[Here is quick getting started](https://skandasoft.wordpress.com/2015/01/19/atom-io-preview-plus-getting-started/)  

Go to the config settings in the preview-plus to change default (Live Switched on)  

You change the default preview for each format from the config file.  
Open the file using the command Preview-Plus:Config  
Add fileTypes to identify to a particular grammar  
All the available preview for each format is maintained in the config setting  
Double click on any format to display as HTMLPreview  

preview Typescript to JS  

Here is some video link to the demo  
-[![Preview-Plus](https://raw.github.com/skandasoft/preview-plus/master/Youtube_Video.png)](http://www.youtube.com/playlist?list=PLWe88FcgV1ft0TKra0gQBptfFc7jjEspC)



Issues
-----------
~~When the Compiler put up the preview in the split screen and the editor is closed with the preview tab still on Then there is a errror when reopening.  
I will raise it up in the discussion forum.~~
~~click on save when it asks for save/cancel..this bring it up in the same place but without the split screen.~~
The webview right now has issues in chrome. So for now there is option for iframes but they cannot execute javascript. So The webview closes as soon as it loses focus.(I think this is going to go away )
So 2 html previews cannot be open at one time. This will resolved once the chrome bug is resolved.
I have tested using windows. You are welcome put the test result /raise issues for other os. The Slim compiler which is installed as gems generate a batch file. So I have
the command as slim.bat for running as spawn.  if it is any other os I have it as just the command.  
~~There is a weird error (backspace/delete key would not work while update base href for html preview in the modal panel)~~

You are welcome to contribute by adding new precompile options/submit issues to the github repo.


TODO
-----

* Write test case for all the compilations
