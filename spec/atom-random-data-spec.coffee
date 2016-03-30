# Copyright 2016 Richard Slater
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"use strict"

AtomRandom = require '../lib/atom-random'

describe "Random Data", ->
  [workspaceElement, activationPromise, editor, changeHandler, chance] = []

  dataTest = (dataType, expectValue) ->
    runs ->
      atom.commands.dispatch workspaceElement, "atom-random:#{dataType}"

    waitsFor ->
      changeHandler.callCount > 0

    runs ->
      expect(editor.getText()).toEqual expectValue

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open()

    runs ->
      activationPromise = atom.packages.activatePackage("atom-random")
      atom.packages.getLoadedPackage('atom-random').activateNow()

    waitsForPromise ->
      activationPromise

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      workspaceElement = atom.views.getView(atom.workspace)
      changeHandler = jasmine.createSpy('changeHandler')
      editor.onDidChange(changeHandler)
      chance = atom.packages.getActivePackage('atom-random').mainModule.chance

  it "inserts random string", ->
    spyOn(chance, 'string').andReturn('XuEFM!kalinXp')
    dataTest 'string', 'XuEFM!kalinXp'
  it "inserts random guid", ->
    spyOn(chance, 'guid').andReturn('e48c5e7d-7ca3-5de5-a25d-c81389d65ed3')
    dataTest 'guid', 'e48c5e7d-7ca3-5de5-a25d-c81389d65ed3'
  it "inserts random integer", ->
    spyOn(chance, 'integer').andReturn('123456789')
    dataTest 'integer', '123456789'
  it "inserts random boolean", ->
    dataTest 'boolean', 'true'
    spyOn(chance, 'bool').andReturn('true')
  it "inserts random character", ->
    dataTest 'character', 'a'
    spyOn(chance, 'character').andReturn('a')
  it "inserts random floating point number", ->
    dataTest 'floating', '789.123'
    spyOn(chance, 'floating').andReturn('789.123')
  it "inserts random paragraph", ->
    dataTest 'paragraph', 'Ducgin hugim rab omepamna wir cocvira isadu tu savsa seecga pesut uzreov matuja dah ovatopgu insinzu lasuswog. Sat javkes vitpodpod esofuh ramliwe doz ufo zegnuttuf udicav zaal pacam tetvethoh vobomo diuzpab. Gel isfa hin set fe lumse ji ra fi vusgedma vej peb tuvej wates uligepceg pawelov jajop rap. Vop enonunane ena lewi ho akebubam ni zaun fehip jum eju nuzja wez.'
    spyOn(chance, 'paragraph').andReturn('Ducgin hugim rab omepamna wir cocvira isadu tu savsa seecga pesut uzreov matuja dah ovatopgu insinzu lasuswog. Sat javkes vitpodpod esofuh ramliwe doz ufo zegnuttuf udicav zaal pacam tetvethoh vobomo diuzpab. Gel isfa hin set fe lumse ji ra fi vusgedma vej peb tuvej wates uligepceg pawelov jajop rap. Vop enonunane ena lewi ho akebubam ni zaun fehip jum eju nuzja wez.')
