redis = require 'redis'


@redis = redis.createClient()

base = "http://www.amazon.com/dp"
queue = "resque:queue:links"
urls = [
  "#{base}/B005VBNYDS",
  "#{base}/B005K7192G",
  "#{base}/B0073F92OK",
  "#{base}/B008TXFPS2"
]

for url in urls
  @redis.rpush(queue, url, redis.print)

@redis.lindex(queue, 0, redis.print)

@redis.quit()