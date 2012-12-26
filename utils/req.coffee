request = require 'request'
zlib = require 'zlib'
fs = require 'fs'

@get = (url, callback) ->
  opt =
    url: url,
    timeout: 30000,
    encoding: null,
    headers:
      "Accept-Encoding": 'gzip'
      "User-Agent": "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.95 Safari/537.11"
    pool: # 每一个 pool
      maxSockets: 15

  request(opt, (err, resq, dat) ->
    if not err and resq.headers['content-encoding'] == 'gzip'
      zlib.gunzip(dat, (e, unzip) ->
        callback(err, resq, unzip) if callback
      )
    else
      callback(err, resq, dat) if callback
  )
