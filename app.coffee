express = require('express')
app = express()
amazon = require('./routes/amazon')

log = (msg) -> console.log msg



app.use((req, res, next) ->
  req._log = log
  next()
)
app.use(express.bodyParser())
app.use(express.logger('dev'))
#app.use(app.router)


# after use...
app.get(/^\/listing\/(\w+)\/(\w+)/, amazon.listing)
app.get("/baidu", amazon.baidu)

log express.errorHandler.toString()
app.use(express.errorHandler(showStack: true, dumpExceptions: true))

for i in process.argv
  if i.indexOf('env') > -1
    process.env['ENV'] = i.split('=')[1].toLowerCase()

process.env['ENV'] = 'dev' unless process.env['ENV']

log "grabber is in #{process.env['ENV']} mode."
app.listen(3000)
