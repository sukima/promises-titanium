describe "TimeoutPromiser", ->
  TimeoutPromiser = proxyquire("timeout_promiser")

  # Even though the TimeoutPromiser uses setTimeout which is mocked in jasmine,
  # Q methods are asynchronous on their own. Meaning that we can control the
  # clock that effects TimeoutPromiser but not the clock that effects Q.
  # Therefore we still need to wrap the logic in runs/waits functions so that
  # we can allow the thread to finish and the Q library can catch up before the
  # next expect() clause. Since this is linear and not callback based we use
  # the waits function instead of waitsFor (deprecated to deter using this
  # pattern, but will remain in codebase for the rare occasions when we need
  # it).
  #
  # https://github.com/pivotal/jasmine/wiki/Asynchronous-specs#waitstimeout

  beforeEach ->
    # Redundant, but forces a consistent number regardless of what is defined
    # in the module.
    TimeoutPromiser.timeout = 100
    TimeoutPromiser.steps   = 3
    # Use Jasmine's mock timer for easier and consistent tests.
    jasmine.Clock.useMock()
    # Randomness should not be part of testing.
    spyOn(TimeoutPromiser, "randomFail").andReturn false

  describe "#run", ->

    beforeEach ->
      @promise = TimeoutPromiser.run()

    it "should return a promise", ->
      expect( @promise.then ).toBeDefined()

    it "should announce a countdown", ->
      progress_callback = createSpy "progress"
      @promise.progress progress_callback
      runs ->
        expect( progress_callback.callCount ).toBe 0
        jasmine.Clock.tick 101
      waits(1)
      runs ->
        expect( progress_callback.callCount ).toBe 1
        jasmine.Clock.tick 101
      waits(1)
      runs ->
        expect( progress_callback.callCount ).toBe 2
        @promise.done()

    it "should resolve the promise when timer runs out", ->
      runs ->
        jasmine.Clock.tick 301 # timeout * steps + 1
      waits(1)
      runs ->
        expect( @promise.isFulfilled() ).toBeTruthy()
        @promise.done()

    # Since steps is set to 3 we don't have to worry about the count < 6 logic.
    it "should reject the promise when randomFail returns false", ->
      TimeoutPromiser.randomFail.andReturn true
      runs ->
        jasmine.Clock.tick 301 # timeout * steps + 1
      waits(1)
      runs ->
        expect( @promise.isRejected() ).toBeTruthy()
        @promise.done()
