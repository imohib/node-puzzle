assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!

  it 'should count number of lines', (done) ->
    input = 'The\n"Quick Brown Fox"\njumps over the lazy dog'
    expected = words: 7, lines: 3
    helper input, expected, done

  it 'Camel cased words should be counted as multiple words', (done) ->
    input = 'TheQuick\nBrownFox\njumps\nOverTheLazy\ndog'
    expected = words: 9, lines: 5
    helper input, expected, done

  # !!!!!
  # Could cover more tests here for when text includes
  # characters other than alpha-numeric and chars and
  # bytes count
  # !!!!!
