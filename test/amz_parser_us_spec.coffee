should = require 'should'
fs = require 'fs'
amz_parser = require '../models/amz_parser'

describe "404 Page", ->
  it "should return 404 code", ->
    lst = amz_parser.listing(fs.readFileSync('./html/404.html', 'utf8'))
    lst.code.should.equal 404

#TODO 收集 Amazon 首页可能的其他情况, 按照情况进行更多的测试
# 1. 拥有价格/没有价格不可销售
# 2. 需要针对是否有更多 Offers 提供测试
describe "Amazon US Listing Parse", ->
  describe "Whole Listing", ->
    lst = {}
    before(->
      us_html = fs.readFileSync('./html/B008YRG5JQ.html', "utf8")
      lst = amz_parser.listing(us_html)
    )
    it "market, asin, title, byWho, variation success parsed", ->
      lst.market.should.equal 'amazon.com'
      lst.asin.should.equal 'B008YRG5JQ'
      lst.title.should.equal "EasyAcc 12000mAh 4 x USB Portable External Battery Pack Charger for Tablets: iPad 3, iPad mini; Kindle Fire HD, Google Nexus 7; Samsung Galaxy Tab; for Phones: iPhone 5, 4S; Samsung ; Motorola; HTC; LG; Nokia phones; for Kindle Paperwhite, Touch, Kindle and much more 5V device. [PB12000A; 4 USB OUTPUT: 0.5A~2A; Black]"
      lst.byWho.should.equal "EasyAcc"
      lst.variation.should.equal false
    it "review_score, reviews, likes success parsed", ->
      lst.review_score.should.equal 4.6
      lst.reviews.should.equal 25
      lst.likes.should.equal 1
    it "price, sale, currency success parsed", ->
      lst.price.should.equal 69.99
      lst.sale.should.equal 42.99
      lst.currency.should.equal 'USD'
    it "main_pic, product_features, product_desc success parsed", ->
      lst.main_pic.should.equal "http://ecx.images-amazon.com/images/I/41VuBkkagCL._SL500_AA280_.jpg"
      lst.product_features.length.should.equal 5
      lst.product_features[0].should.include('12000mAh with Reliable Lithium Polymer battery cells')
      lst.product_desc.should.include "Technical specification"
    it "also_bought, after_viewing success parsed", ->
      lst.also_bought.length.should.equal 6
      lst.after_viewing.length.should.equal 4
    it "seller_rank success parsed", ->
      lst.seller_rank.length.should.equal 2
      lst.seller_rank[0].rank.should.equal 847
      lst.seller_rank[0].category.should.equal "Cell Phones & Accessories"
      lst.seller_rank[1].rank.should.equal 27
      lst.seller_rank[1].category.should.equal "Electronics > Accessories & Supplies > Accessories > Batteries"
    it "promotes should be empty", ->
      lst.promotes.length.should.equal 0
  describe "single value test", ->
    lst = {}
    before(->
      lst = amz_parser.listing(fs.readFileSync('./html/number.us.html', 'utf8'))
    )
    it "should conver [.]->[] and [,]->[.]", ->
      lst.price.should.equal 1199.00
      lst.sale.should.equal 1099.94
    it "have variation", ->
      lst.variation.should.equal true

