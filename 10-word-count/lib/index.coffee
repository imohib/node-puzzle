through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1

  checkCamelCasedWord = (token) ->
    result = token.match(/([A-Z][a-z0-9]+){2,}/g)
    if result
      return true
    else
      return false

  checkNonCamelCasedWord = (token) ->
    result = token.match(/([A-Z][a-z0-9]+){2,}/g)
    if result
      return false
    else
      return true

  addCamelCasedWords = (camelCasedTokens) ->
    for cct in camelCasedTokens
      subTokens = cct.match(/((?:^|[A-Z])[a-z]+)/g) || []
      words += subTokens.length

  transform = (chunk, encoding, cb) ->
    chunks = chunk.split(/\r\n|\r|\n/)
    lines = chunks.length

    for line in chunks
      lineTokens = line.match(/\S+/g) || []
      if lineTokens.length > 1 and lineTokens[0].startsWith('"') and lineTokens[lineTokens.length - 1].endsWith('"')
        words += 1
      else
        camelCasedTokens = lineTokens.filter(checkCamelCasedWord)
        # console.log("CC: " + camelCasedTokens)
        nonCamelCasedTokens = lineTokens.filter(checkNonCamelCasedWord)
        # console.log("NCC: " + nonCamelCasedTokens)

        addCamelCasedWords(camelCasedTokens)
        words += nonCamelCasedTokens.length

    return cb()

  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  return through2.obj transform, flush
