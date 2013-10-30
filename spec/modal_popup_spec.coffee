describe "ModalPopup", ->
  # Tests are run in Node which offers a global "util" module. Since while
  # testing we are not running in the Titanium environment which would read the
  # util.js file in the Resources directory, we have to force node to load the
  # correct one. proxyquire will prepend a relative path. This offers us the
  # correct module assigned to Util. We then pass this into the proxyquire
  # module to force the correct module when node encounters require("util")
  Util = proxyquire("util")
  # Since we want to overwite the node "util" module we do not want it merge
  # the node module with our own. @noCallThru prevents that.
  Util["@noCallThru"] = true
  # Load the ModalPopup now with the correct Util module.
  ModalPopup = proxyquire("modal_popup", {"util": Util})

  beforeEach ->
    @popup = new ModalPopup
    @promise = @popup.promise()
    spyOn @popup, "open"
    spyOn @popup, "close"
    spyOn(@popup.name_input, "getValue").andReturn "name value"

  describe "#promise", ->

    it "should return a promise", ->
      expect( @promise.then ).toBeDefined()

  describe "clicking done button", ->

    beforeEach ->
      ready = false
      runs ->
        @promise.fin -> ready = true
        @popup.onButtonClick("submit")
      waitsFor (-> ready), "promise to be resolved", 10
      runs -> @promise.done()

    it "should close the window", -> runs ->
      expect( @popup.close ).toHaveBeenCalled()

    it "should fulfill the promise with the value of the input box", -> runs ->
      expect( @promise.isFulfilled() ).toBeTruthy()
      expect( @promise.inspect().value ).toEqual "name value"

  describe "clicking the cancel button", ->

    beforeEach ->
      ready = false
      runs ->
        @promise.fin -> ready = true
        @popup.onButtonClick("cancel")
      waitsFor (-> ready), "promise to be resolved", 10

    it "should close the window", -> runs ->
      expect( @popup.close ).toHaveBeenCalled()

    it "should reject the promise with 'cancled' as a reason", -> runs ->
      expect( @promise.isRejected() ).toBeTruthy()
      expect( @promise.inspect().reason ).toEqual "cancled"
