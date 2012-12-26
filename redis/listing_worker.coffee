RedisWorker = require './redis_worker'
amzParser = require '../models/amz_parser'
fs = require 'fs'

class ListingWorker extends RedisWorker
  @LISTINGS_QUEUE = "resque:queue:listings"

  perform: (err, link) =>
    self = @
    console.log link
    unless err
      self.get(link, (err, resp, body) ->
        fs.writeFile("./#{link[link.lastIndexOf('/')..-1]}.html", body, "utf8", -> console.log "Saved.")
        try
          json = amzParser.listing(body)
          self.push_back(json)
        catch e
          console.log e
        self.emit('done')
      )

  push_back: (json)=>
    self = @
    console.log 'set back to redis'
    self.redis.rpush(ListingWorker.LISTINGS_QUEUE, JSON.stringify(json))

new ListingWorker("links").work()
