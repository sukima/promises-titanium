describe "timeout_button controller", ->
  timeout_promise = null
  Q = proxyquire("q")

  MockTimeoutPromiser =
    run: -> timeout_promise

  TimeoutButtonController = proxyquire(
    "alloy/controllers/timeout_button",
    {"timeout_promiser": MockTimeoutPromiser}
  )

  beforeEach ->
    @controller = new TimeoutButtonController
    @setTitleSpy = spyOn(@controller.button, "setTitle").andCallFake (val) -> @title = val
    @setEnabled = spyOn(@controller.button, "setEnabled").andCallFake (val) -> @enabled = val

  afterEach ->
    timeout_promise = null

  describe "when the user clicks the button", ->

    beforeEach ->
      @defer = Q.defer()
      timeout_promise = @defer.promise

    it "should update the button title as progress is made", ->
      runs -> @controller.button.fireEvent("click")
      waits 1
      runs -> @defer.notify(123)
      waits 1
      runs -> expect( @controller.button.title ).toContain "123"

  describe "when user clicks button with a resolved promise", ->

    beforeEach ->
      timeout_promise = Q.resolve("test_fulfilled")

    it "should set the title appropriately", ->
      ready = false
      runs ->
        @controller.button.fireEvent("click")
        timeout_promise.fin(-> ready = true).fail (reason) ->
          expect( reason ).not.toBeDefined()
      waitsFor (-> ready), "promise to resolve", 10
      runs ->
        expect( @controller.button.title ).toContain "test_fulfilled"

  describe "when user clicks button with a rejected promise", ->

    beforeEach ->
      timeout_promise = Q.reject("test_rejected")

    it "should set the title appropriately", ->
      ready = false
      runs ->
        @controller.button.fireEvent("click")
        timeout_promise.fin(-> ready = true)
      waitsFor (-> ready), "promise to resolve", 10
      runs ->
        expect( @controller.button.title ).toContain "test_rejected"
