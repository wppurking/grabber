request = require 'request'
zlib = require 'zlib'
fs = require 'fs'

@get = (url, callback) ->
  opt =
    url: url,
    encoding: null,
    headers:
      "Accept-Encoding": 'gzip'
  request(opt, (err, req, dat) ->
    if req.headers['content-encoding'] == 'gzip'
      zlib.gunzip(dat, (e, unzip) ->
        callback(err, req, unzip)
      )
    else
      callback(err, req, dat)
  )
