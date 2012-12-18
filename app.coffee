express = require('express')
app = express()
amazon = require './routes/amazon'

app.get(/^\/listing\/(\w+)\/(\w+)/, amazon.listing)
app.get('/baidu', amazon.baidu)

app.use(express.logger('dev'))
app.use(app.router)
app.use((err, res, req, next)->
  req.send(500, err.stack)
)
#app.configure(->
#  app.use(express.logger('dev'))
#  app.use(express.bodyParser())
#  app.use(express.methodOverride())
#  app.use(app.router)
#)

app.listen(3000)
