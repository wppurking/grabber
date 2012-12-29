# 用来抽取不同 Link 的工作者
# 1. 解析从 redis 进来的结果
# 2. 判断如何更新到 Mongo
# 3. 抽取出需要重新抓取的 Links
# 4. 将需要继续抓取的 Links push 回 redis
class LinkWorker

  def initialize
    @redis = Redis.new(host: '127.0.0.1', port: 6379)
  end

  def perform(res)
  end

  # 将 res 变为 lising
  def lst(res)
    begin
      lst_obj = JSON.parse(res)
      lst = Listing.where(market: lst_obj.market, asin: lst_obj.asin)
    rescue Exception => e
      puts e.message
    end
  end

end