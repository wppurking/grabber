require "redis"
require 'json'
require 'active_support/core_ext'

redis = Redis.new(host: '127.0.0.1', port: 6379)

QUEUE = "resque:queue:listings"

# example
reply = redis.lindex QUEUE, 0
lst = JSON.parse(reply)
puts lst['asin']


# 将 redis 中的 resque:queue:listings 中抓取完成的 json 字符串拿出来进行解析,
# 生成 links 放回到 resque:queue:links .
# 1. listing 的信息原本进入 mongodb; 需要区分市场
# 2. aslo_bought 中的链接处理后放回 redis
# 3. after_viewing 中的链接处理后放回 redis
