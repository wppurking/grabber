redis = require 'redis'
r = require '../utils/req'
amz_parser = require '../models/amz_parser'

LINK_QUEUE = "resque:queue:links"
LISTING_QUEUE = "resque:queue:listings"

client = redis.createClient()
console.log "Moniting queue:links ..."

# 取出一个 Links
pop_link = () ->
  client.lpop(LINK_QUEUE, loop_handler)

# 当成功获取到信息时,的回掉处理器
loop_handler = (err, link) ->
  if err
    # 碰到异常, 3s 后重试
    setTimeout(->
      console.log err
      pop_link()
    , 3000)
  if not link
    setTimeout(pop_link, 100)
  else
    # 处理 links
    console.log link
    r.get(link, (err, req, body) ->
      push_json(LISTING_QUEUE, JSON.stringify(amz_parser.listing(body)))
    )
    pop_link()

# 将处理完成的结果 push 回去
push_json = (queue, json) ->
  client.rpush(queue, json, redis.print)

pop_link()
