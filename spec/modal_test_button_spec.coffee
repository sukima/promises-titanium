describe "ModalTestButton", ->
  ModalTestButton = proxyquire("modal_test_button")

  # There is very little to test here. The inteface is very specific to a
  # running environment. Any tests would only be testing the mockti library not
  # our code.

  it "should provide a button property", ->
    modal_test_button = new ModalTestButton
    expect( modal_test_button.button ).toBeDefined()
