express = require('express')
app = express()
amazon = require './routes/amazon'

log = (msg) -> console.log msg

app.get(/^\/listing\/(\w+)\/(\w+)/, amazon.listing)
app.get('/baidu', amazon.baidu)

app.use(express.bodyParser())
app.use(express.logger('dev'))
app.use(app.router)
app.use(express.errorHandler(showStack: true, dumpExceptions: true))

#app.configure(->
#  app.use(express.logger('dev'))
#  app.use(express.bodyParser())
#  app.use(express.methodOverride())
#  app.use(app.router)
#)

for i in process.argv
  if i.indexOf('env') > -1
    process.env['ENV'] = i.split('=')[1].toLowerCase()

process.env['ENV'] = 'dev' unless process.env['ENV']

log "grabber is in #{process.env['ENV']} mode."
app.listen(3000)
