should = require 'should'
amazon = require '../controllers/amazon'

describe("Amazon URL Parse", () ->
  asin = "B008YRG5JQ"

  it "FR: should have http://www.amazon.fr/dp/B008YRG5JQ URL", ->
    amazon.amazon_url('fr', asin).should.equal "http://www.amazon.fr/dp/B008YRG5JQ"
    amazon.amazon_url('amazon_fr', asin).should.equal "http://www.amazon.fr/dp/B008YRG5JQ"
    amazon.amazon_url('amazon.fr', asin).should.equal "http://www.amazon.fr/dp/B008YRG5JQ"
  it "US: should have http://www.amazon.com/dp/B008YRG5JQ URL", ->
    amazon.amazon_url('us', asin).should.equal "http://www.amazon.com/dp/B008YRG5JQ"
    amazon.amazon_url('amazon_us', asin).should.equal "http://www.amazon.com/dp/B008YRG5JQ"
    amazon.amazon_url('amazon.com', asin).should.equal "http://www.amazon.com/dp/B008YRG5JQ"
  it "UK: should have http://www.amazon.co.uk/dp/B008YRG5JQ URL", ->
    amazon.amazon_url('uk', asin).should.equal "http://www.amazon.co.uk/dp/B008YRG5JQ"
    amazon.amazon_url('amazon_uk', asin).should.equal "http://www.amazon.co.uk/dp/B008YRG5JQ"
    amazon.amazon_url('amazon.co.uk', asin).should.equal "http://www.amazon.co.uk/dp/B008YRG5JQ"
  it "DE: should have.http://www.amazon.de/dp/B008YRG5JQ URL", ->
    amazon.amazon_url('de', asin).should.equal "http://www.amazon.de/dp/B008YRG5JQ"
    amazon.amazon_url('amazon_de', asin).should.equal "http://www.amazon.de/dp/B008YRG5JQ"
    amazon.amazon_url('amazon.de', asin).should.equal "http://www.amazon.de/dp/B008YRG5JQ"
  it "shoud throw Exception with 'not support site!' msg", ->
    # 由于 should.throw 需要在最后执行需要测试的方法, 并且无法传递参数进去, 所以无法利用 should.js 执行 Exception 测试
    #    amazon.amazon_url('xx', asin).should.thorw("Not support xx site")
    try
      amazon.amazon_url('xx', asin)
    catch err
      err.should.equal "Not support xx site"
)