r = require './req'
amz_parser = require './amz_parser'
fs = require 'fs'


@listing = (req, res) ->
  market = req.params[0].toLowerCase()
  asin = req.params[1].toUpperCase()
  url = exports.amazon_url market, asin
  console.log "Fetch URL: #{url}"
  r.get(url, (err, request_req, body) ->
    fs.writeFile('./B008YRG5JQ.html', body, (err) -> console.log "Saved." if not err)
    res.json(amz_parser.listing(body))
  )

@baidu = (req, res) ->
  r.get('http://www.baidu.com', (err, request_req, body) ->
    res.set("Content-Type", 'text/html')
    res.send(body)
  )

@amazon_url = (market, asin) ->
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

