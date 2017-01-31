fs = require 'fs'


exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  pattern = RegExp('(.*?)'+countryCode+'.*?', 'gm')
  fs.readFile "#{__dirname}/../data/geo.txt", 'utf8', (err, data) ->
    if err then return cb err

    data = data.toString().match pattern
    counter = 0

    for line in data when line
      line = line.split '\t', 2
      # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
      # line[0],       line[1],       line[3]
      counter += +line[1] - +line[0]

    cb null, counter
