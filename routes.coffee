amazon = require('./controllers/amazon')


module.exports = (app) ->
  # after use...
  app.get(/^\/listing\/(\w+)\/(\w+)/, amazon.listing)
  app.get("/baidu", amazon.baidu)
