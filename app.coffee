express = require('express')
app = express()
amazon = require './routes/amazon'

app.get(/^\/listing\/(\w+)\/(\w+)/, amazon.listing)
app.get('/baidu', amazon.baidu)

app.use(express.logger('dev'))
#app.configure(->
#  app.use(express.logger('dev'))
#  app.use(express.bodyParser())
#  app.use(express.methodOverride())
#  app.use(app.router)
#)

app.listen(3000)
