RedisWorker = require './redis_worker'
amz_parser = require '../routes/amz_parser'

class ListingWorker extends RedisWorker
  perform: (err, link, worker) =>
    console.log link
    unless err
      @get(link, (err, resp, body) ->
        json = amz_parser.listing(body)
        console.log JSON.stringify(json).length
        worker.done()
      )


new ListingWorker("links").work()
