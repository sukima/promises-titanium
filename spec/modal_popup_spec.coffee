describe "ModalPopup", ->
  # Load the ModalPopup now with the correct Util module.
  ModalPopup = proxyquire("modal_popup")

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
