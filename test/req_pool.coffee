should = require 'should'
r = require '../utils/req'

describe "Request modeul", ->
  it "should turn on pool", (done)->
    r = r.get('http://www.baidu.com', (err, resp, body)->
      resp.request.agent.maxSockets.should.equal 15
      done()
    )
