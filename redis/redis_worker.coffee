# 用来从 redis 中获取任务并且进行处理
# 1. 限制任务执行的数量
# 2. 任务执行发生错误, 需要将任务重新放回队列, 但不影响其他任务执行
# 3. 这是一个 Resque 的简单复制
redis = require 'redis'
events = require 'events'

class RedisWorker extends events.EventEmitter
  @QUEUE_PREFIX = "resque:queue:"
  # 将需要使用到的 http 给注册在这里
  @r = require '../utils/req'


  get: (url, callback) ->
    RedisWorker.r.get(url, callback)

  constructor: (@queue, @url, @port, @concurrent_size = 3) ->
    unless @queue
      throw "Must assign an queue name!"

    @full_queue = "#{RedisWorker.QUEUE_PREFIX}#{@queue}"
    @working_job_size = 0
    if @url and @port
      @redis = redis.createClient(port, url)
    else
      @redis = redis.createClient()

    @.on("done", @done)

  # 不停向 redis 询问需要处理的 links
  work: =>
    if @working_job_size >= @concurrent_size
      setTimeout(@work, 100)
    else
      @redis.lpop(@full_queue, (err, link) =>
        if err
          # 发生错误, 暂停 1s
          setTimeout(=>
            console.log "Error: #{@full_queue} " + err
          , 1000)

        # 如果没有元素, 则暂停一小会, 重新获取
        if not link
          setTimeout(@work, 100)
        else
          @working_job_size += 1
          console.log "Deal a job: " + @working_job_size
          @perform(err, link)
          @work()
      )

  # 停止任务
  exit: =>
    @redis.quit()

  # 执行一个任务
  perform: (err, link, worker) =>
    throw "Please implement your self job."

  done: =>
    @working_job_size -= 1
    console.log "Remain Jobs: " + @working_job_size


module.exports = RedisWorker

