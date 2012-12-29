require "redis"
# 一直不断循环的从 redis 中抓取信息, 一旦拥有信息, 则派发出去
class Looper

  # 1. 初始化与 Redis 的链接
  # 2. 设定需要监控的 Queue
  def initialize(queue)
    host = ENV['redis_host'] if ENV['redis_host']
    port = ENV['redis_port'] if ENV['redis_port']
    host ||= '127.0.0.1'
    port ||= 6379
    @redis = Redis.new(host: host, port: port)
    @queue = queue
  end

  # 查看一次, 如果有则派发, 没有则停留一个片段继续查看
  def watch
    res = @redis.lpop(@queue)
    if res
    else
      sleep 0.1
      watch
    end
  end

end