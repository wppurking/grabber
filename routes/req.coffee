request = require 'request'
zlib = require 'zlib'
fs = require 'fs'

@get = (url, callback) ->
  opt =
    url: url,
    encoding: null,
    headers:
      "Accept-Encoding": 'gzip'
      "User-Agent": "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.95 Safari/537.11"
  request(opt, (err, req, dat) ->
    if req.headers['content-encoding'] == 'gzip'
      zlib.gunzip(dat, (e, unzip) ->
        callback(err, req, unzip)
      )
    else
      callback(err, req, dat)
  )
