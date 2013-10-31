describe "HttpTestButton", ->
  HttpTestButton = proxyquire("http_test_button")

  # There is very little to test here. The inteface is very specific to a
  # running environment. Any tests would only be testing the mockti library not
  # our code.

  it "should provide a button property", ->
    http_test_button = new HttpTestButton
    expect( http_test_button.button ).toBeDefined()
