r = require '../utils/req'
amzParser = require '../models/amz_parser'
fs = require 'fs'


@listing = (req, res) ->
  market = req.params[0].toLowerCase()
  asin = req.params[1].toUpperCase()
  url = amazon_url market, asin
  req._log "Fetch URL: #{url}"
  r.get(url, (err, request_req, body) ->
    if process.env['ENV'] == 'dev'
      fs.writeFileSync("./#{asin}.html", body, "utf8", -> console.log 'Save Success.')
    try
      res.json(amzParser.listing(body))
    catch e
      res.send(500, "<ul>" + e.stack.split('\n').map((v)->"<li>#{v}</li>").join('') + "</ul>")
  )

@baidu = (req, res) -> r.get('http://www.baidu.com', (err, request_req, body) ->
  res.set("Content-Type", 'text/html')
  t = JSON.stringify(req.app.settings)
  res.send(t + body)
)

amazon_url = (market, asin) ->
  prefix = "http://www.amazon"
  switch market
    when "us", 'amazon_us', 'amazon.com' then prefix += ".com"
    when "de", 'amazon_de', 'amazon.de' then prefix += ".de"
    when "uk", 'amazon_uk', 'amazon.co.uk' then prefix += ".co.uk"
    when "fr", 'amazon_fr', 'amazon.fr' then prefix += ".fr"
    else
      throw "Not support #{market} site"
  sufix = "/dp/#{asin}"
  "#{prefix}#{sufix}"

