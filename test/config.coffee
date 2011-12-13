should = require 'should'
choco  = require '../src/choco'

test = (args) ->
  ->
    {render, output, opts} = args
    choco.render(opts, render).should.equal output

describe "the default @js helper", ->
  it 'works with relative paths', test
    render : ->
      @js 'main.min'
    output :
      '<script type="text/javascript" src="/javascripts/main.min.js"></script>'

  it 'works with relative paths, with .js', test
    render : ->
      @js 'slideshow/main.js'
    output :
      '<script type="text/javascript" src="/javascripts/slideshow/main.js"></script>'

  it 'works with absolute paths', test
    render : ->
      @js '/main'
    output :
      '<script type="text/javascript" src="/main.js"></script>'

  it 'works with absolute paths with .js', test
    render : ->
      @js '/slideshow/main.js'
    output :
      '<script type="text/javascript" src="/slideshow/main.js"></script>'

  it 'works with paths on another domain', test
    render : ->
      @js 'http://example.com/test'
    output :
      '<script type="text/javascript" src="http://example.com/test.js"></script>'

  it 'works with paths on another domain with .js', test
    render : ->
      @js '//example.com/test.js'
    output :
      '<script type="text/javascript" src="//example.com/test.js"></script>'

describe 'the default @css helper', ->
  it 'works with relative paths', test
    render : ->
      @css 'main'
    output : '<link type="text/css" rel="stylesheet" media="screen" href="/stylesheets/main.css"/>'
  # all other ways work as well since @css uses the same internal helper as @js

describe 'a helper function', ->
  helper_helper = (url) ->
    "#{url}.js"

  it "gets included", test
    render : ->
      @js2 'hullo'
    opts:
      helpers :
        js2 : (url) ->
          @script type: 'text/javascript', src: helper_helper(url)
    output : '<script type="text/javascript" src="hullo.js"></script>'

describe 'a configuration', ->
  helper_helper = (url, ext) ->
    if url.substr(-ext.length) isnt ext then "#{url}#{ext}" else url

  beforeEach ->
    choco.configure
      helpers :
        js2 : (url) ->
          @script type: 'text/javascript', src: helper_helper(url, '.js')

  afterEach ->
    choco.resetConfig()

  it "gets included", test
    render : ->
      @head ->
        @js2 'main'
        @css2 'style'
    opts:
      helpers :
        css2 : (url) ->
          @link rel: 'text/stylesheet', href: helper_helper(url, '.css')
    output : '<head><script type="text/javascript" src="main.js"></script><link rel="text/stylesheet" href="style.css"/></head>'

