describe "TimeoutTestButton", ->
  TimeoutTestButton = proxyquire("timeout_test_button")

  # There is very little to test here. The inteface is very specific to a
  # running environment. Any tests would only be testing the mockti library not
  # our code.

  it "should provide a button property", ->
    timeout_test_button = new TimeoutTestButton
    expect( timeout_test_button.button ).toBeDefined()
