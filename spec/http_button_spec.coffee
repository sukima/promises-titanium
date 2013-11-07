describe "http_button controller", ->
  http_promise = null
  modal_popup_promise = null
  Q = proxyquire("q")

  MockHttpClient =
    request: createSpy("HttpClient.request").andCallFake -> http_promise
    "@noCallThru": true

  MockModalPopup =
    promise: createSpy("ModalPopup.promise").andCallFake -> modal_popup_promise
    getView: ->
      open: ->
      close: ->
    "@noCallThru": true

  HttpButtonController = proxyquire(
    "alloy/controllers/http_button", {
      "http_client": MockHttpClient
    }
  )

  goodHttpPromise = -> Q.resolve
    status: 200
    data:
      message: "test_http_response"

  badHttpPromise = -> Q.reject
    status: 500
    message: "test_http_error_response"

  beforeEach ->
    @notifySpy = spyOn(Ti.UI, "createAlertDialog").andCallThrough()
    spyOn(Alloy, "createController").andReturn MockModalPopup

  afterEach ->
    http_promise = null
    modal_popup_promise = null

  describe "when a user clicks the button", ->

    beforeEach ->
      @controller = new HttpButtonController

    describe "with a fulfilled HTTP response", ->

      beforeEach ->
        http_promise = goodHttpPromise()

      it "should pop up a notification", ->
        ready = false
        runs ->
          @controller.button.fireEvent("click")
          http_promise.fin(-> ready = true)
        waitsFor (->ready), "promise to resolve", 10
        runs ->
          expect( @notifySpy ).toHaveBeenCalledWith(
            jasmine.objectContaining message: "test_http_response"
          )

    describe "with a rejected HTTP response", ->

      beforeEach ->
        http_promise = badHttpPromise()

      it "should pop up a notification", ->
        ready = false
        runs ->
          @controller.button.fireEvent("click")
          http_promise.fin(-> ready = true)
        waitsFor (->ready), "promise to resolve", 10
        runs ->
          message = @notifySpy.mostRecentCall.args[0].message
          expect( message ).toContain "test_http_error_response"
          expect( message ).toContain "500"

  describe "login required", ->

    describe "when a user clicks the button", ->

      beforeEach ->
        @controller = new HttpButtonController(href: "test_url", login: "true")
        modal_popup_promise = Q.resolve("test_user_name")
        http_promise = goodHttpPromise()

      it "should pop up a modal window for a user name", ->

      it "should call the HttpClient with a URL that includes the user name", ->
        ready = false
        runs ->
          @controller.button.fireEvent("click")
          http_promise.fin(-> ready = true)
        waitsFor (->ready), "promise to resolve", 10
        runs ->
          expect( MockHttpClient.request ).toHaveBeenCalledWith "test_url/test_user_name"
