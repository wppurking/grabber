express = require('express')
app = express()
router = require './routes'

log = (msg) -> console.log msg


app.use((req, res, next) ->
  req._log = log
  next()
)
app.use(express.bodyParser())
app.use(express.logger('dev'))

router(app)

app.use(express.errorHandler(showStack: true, dumpExceptions: true))

for i in process.argv
  if i.indexOf('env') > -1
    process.env['ENV'] = i.split('=')[1].toLowerCase()

process.env['ENV'] = 'dev' unless process.env['ENV']

log "grabber is in #{process.env['ENV']} #{process.env.NODE_ENV} mode."
app.listen(3000)
