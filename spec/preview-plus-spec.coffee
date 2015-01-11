{WorkspaceView} = require 'atom'
PreviewPlus = require '../lib/preview-plus'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "PreviewPlus", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('preview-plus')

  describe "when the preview-plus:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.preview-plus')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch atom.workspaceView.element, 'preview-plus:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.preview-plus')).toExist()
        atom.commands.dispatch atom.workspaceView.element, 'preview-plus:toggle'
        expect(atom.workspaceView.find('.preview-plus')).not.toExist()
