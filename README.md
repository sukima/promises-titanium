# Promises Titanium Example [![Build Status](https://travis-ci.org/sukima/promises-titanium.png?branch=master)](https://travis-ci.org/sukima/promises-titanium)

An example on using promises in a Titanium application.

**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Getting Started](#getting-started)
- [How promises are used in titanium](#how-promises-are-used-in-titanium)
    - [Timeouts / delays](#timeouts--delays)
    - [Modal windows / controls](#modal-windows--controls)
    - [HTTP Requests](#http-requests)
- [Tests](#tests)
    - [Example specs in Jasmine](#example-specs-in-jasmine)
- [License](#license)

## Getting Started

First make sure you have a working titanium environment. NPM will install
titanium as a dependency however, it still needs to install the SDK manually.
It is recommended you install titanium globally first.

    $ npm install -g titanium
    $ titanium sdk install 3.1.3.GA

Once ready run the following in the projects working directory.

    $ npm install .
    $ npm start             # start server and compile app OR
    $ npm run-script debug  # for verbose debug output

This will spawn a small express server for demo uses and then will build the
application and spawn it in the iOS simulator.

## How promises are used in titanium

Promises offer a convenient way to make syntactical and logical sense of the
confusing nature of asynchronous code. If your reading this then you most
likely know what the patterns are surrounding callbacks and the difficulties
they pose in code readability and consistency.

In this project I outlined three use cases where asynchronous code is used and
how promises *could* be implemented to help.

#### Timeouts / delays

#### Modal windows / controls

#### HTTP Requests

## Tests

This project uses jasmine-node to run tests on the application. It is Node
based and therefore uses a [mocked out][mockti] version of the Titanium API.
Keeping this in mind that tests only test the behaviour of the code written
in this application and *not* the Titanium API. Which means testing that
views render correctly is out of scope with this setup.

[mockti]: https://github.com/rf/mockti

You run the tests with:

    $ npm test

The examples used illustrate how to properly handle the asynchronous nature
of promises. Synchronous assumptions in the usual tests will fail or offer
inconsistent results when promises are used and require the tests to be
written asynchronously.

#### Example specs in Jasmine

When testing promise code in [Jasmine][] you have to remember that despite
using any mock timer all methods in the [Q library][q] implementation are
asynchronous.

[Jasmine]: http://pivotal.github.io/jasmine/
[q]: http://documentup.com/kriskowal/q/

The following example **WILL HAVE PROMBLEMS**:

```CoffeeScript
describe "A broken test for promises", ->
  it "should call the callback but will fail instead", ->
    callback = createSpy "callback"
    promise = functionReturnsAResolvedPromise()
    promise.then(callback)
    expect( callback ).toHaveBeenCalled()
```

The reason is that the `then` method will return immediately but not run the
callback to next tick. So when we attempt to see if the spy was called it
hasn't yet.

To fix this use an asynchronous test pattern:

```CoffeeScript
describe "A working test for promises", ->
  beforeEach ->
    @promise = functionReturnsAResolvedPromise()

  it "should call the callback", ->
    ready = false # a flag to poll for when the test can continue
    callback = createSpy "callback"
    runs ->
      # force the flag to finish execution regardles of state of promise.
      @promise.fin -> ready = true # turn the flag to true
      @promise.then(callback)
    waitsFor (-> ready), "promise to be resolved", 10
    runs ->
      expect( callback ).toHaveBeenCalled()
      # Always offer a way for unhandle exceptions to get re-thrown
      @promise.done()
```

A little but more code but now we can guarantee that when we expect the
callback to have been called the `then` method will have had a chance to
finish.

# License

Promises Titanium Example by [Devin Weaver](http://tritarget.org/)
is dual licensed under a [Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/deed.en_US)
and a [Do What You Want To 3.0 Public License](http://tritarget.org/wywtpl/).

[![Creative Commons License](http://i.creativecommons.org/l/by/3.0/88x31.png)](http://creativecommons.org/licenses/by/3.0/deed.en_US)
