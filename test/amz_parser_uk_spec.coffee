should = require 'should'
fs = require 'fs'
amzParser = require '../models/amz_parser'

describe "Amazon UK Listing Parse", ->
  describe "Whole Listing", ->
    lst = {}
    before(->
      de_html = fs.readFileSync('./html/B0063AAIRG.html', 'utf8')
      lst = amzParser.listing(de_html)
    )
    it "market, asin, title, byWho, variation success parsed", ->
      lst.market.should.equal 'amazon.co.uk'
      lst.asin.should.equal 'B0063AAIRG'
      lst.title.should.include('Astro3E 10000mAh Dual 5V 3A')
      lst.byWho.should.equal "Anker"
      lst.variation.should.equal true
    it "review_score, reviews, likes success parsed", ->
      lst.review_score.should.equal 4.7
      lst.reviews.should.equal 270
      lst.likes.should.equal 11
    it "price, sale, currency success parsed", ->
      lst.price.should.equal 33.81
      lst.sale.should.equal 33.81
      lst.currency.should.equal 'EUR'
    it "main_pic, product_features, product_desc success parsed", ->
      lst.main_pic.should.equal "http://ecx.images-amazon.com/images/I/41OEY74%2BQkL._SL500_AA300_.jpg"
      lst.product_features.length.should.equal 5
      lst.product_features[3].should.include('Mit den eleganten')
      lst.product_desc.should.include "kabellose Steuerung Ihres Notebooks &ndash;"
    it "also_bought, after_viewing success parsed", ->
      lst.also_bought.length.should.equal 6
      lst.also_bought.should.include("http://www.amazon.de/Rikomagic-Android-schwarz-PC-System-Mediaplayer/dp/B00A3S4XW0/ref=pd_sim_computers_2/279-1786366-4113547")
      lst.after_viewing.length.should.equal 4
      lst.after_viewing.should.include("http://www.amazon.de/Logitech-Tastatur-schnurlos-deutsches-Tastaturlayout/dp/B003Y3M93Q/ref=pd_cp_computers_1/279-1786366-4113547")
    it "seller_rank success parsed", ->
      lst.seller_rank[0].rank.should.equal 1
      lst.seller_rank[0].category.should.include('Computer & Zubeh')
      console.log lst.seller_rank[1]
      lst.seller_rank[1].rank.should.equal 1
      lst.seller_rank[1].category.should.include('> Tastaturen')
    it "promotes should be empty", ->
      lst.promotes.length.should.equal 3
      lst.promotes[2].should.include('Besuchen Sie auch den')