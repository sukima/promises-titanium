describe "HttpClient", ->
  HttpClient = proxyquire("http_client")

  beforeEach ->
    @mockXHR = createSpyObj("HTTPClient", ["open", "send"])
    @createHTTPClientSpy = spyOn(Ti.Network, "createHTTPClient")
      .andReturn @mockXHR

  describe "#request", ->

    it "should return a promise", ->
      promise = HttpClient.request()
      expect( promise.then ).toBeDefined()

  describe "Good Request (200)", ->

    it "should fulfill the promise", ->
      ready = false
      xhrResponse = { status: 200, responseText: '{"message":"test message"}' }
      runs ->
        @promise = HttpClient.request()
        @promise.fin -> ready = true
        expect( @createHTTPClientSpy ).toHaveBeenCalled()
        @options = @createHTTPClientSpy.mostRecentCall.args[0]
        @options.onload.call(xhrResponse, xhrResponse)
      waitsFor (-> ready), "promise to be resolved", 10
      runs ->
        expect( @promise.isFulfilled() ).toBeTruthy()
        expect( @promise.inspect().value ).toEqual(
          jasmine.objectContaining { status: 200, data: jasmine.any(Object) }
        )
        @promise.done()

  describe "Bad Request (404)", ->

    it "should reject the promise", ->
      ready = false
      xhrResponse = { status: 404, responseText: '{"message":"test message"}' }
      runs ->
        @promise = HttpClient.request()
        @promise.fin -> ready = true
        expect( @createHTTPClientSpy ).toHaveBeenCalled()
        @options = @createHTTPClientSpy.mostRecentCall.args[0]
        @options.onload.call(xhrResponse, xhrResponse)
      waitsFor (-> ready), "promise to be resolved", 10
      runs ->
        expect( @promise.isRejected() ).toBeTruthy()
        expect( @promise.inspect().reason ).toEqual(
          jasmine.objectContaining { status: 404, message: jasmine.any(String) }
        )

  describe "Malformed Response", ->

    it "should reject the promise", ->
      ready = false
      xhrResponse = { status: 200, responseText: 'Malformed JSON' }
      runs ->
        @promise = HttpClient.request()
        @promise.fin -> ready = true
        expect( @createHTTPClientSpy ).toHaveBeenCalled()
        @options = @createHTTPClientSpy.mostRecentCall.args[0]
        @options.onload.call(xhrResponse, xhrResponse)
      waitsFor (-> ready), "promise to be resolved", 10
      runs ->
        expect( @promise.isRejected() ).toBeTruthy()
        expect( @promise.inspect().reason ).toEqual(
          jasmine.objectContaining { status: 200, message: jasmine.any(Object) }
        )

  describe "System error", ->

    it "should reject the promise", ->
      ready = false
      xhrResponse = { status: 500 }
      runs ->
        @promise = HttpClient.request()
        @promise.fin -> ready = true
        expect( @createHTTPClientSpy ).toHaveBeenCalled()
        @options = @createHTTPClientSpy.mostRecentCall.args[0]
        @options.onerror.call(xhrResponse, xhrResponse)
      waitsFor (-> ready), "promise to be resolved", 10
      runs ->
        expect( @promise.isRejected() ).toBeTruthy()
        expect( @promise.inspect().reason ).toEqual(
          jasmine.objectContaining { status: 500 }
        )
