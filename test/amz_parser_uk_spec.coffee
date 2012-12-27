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
      lst.price.should.equal 74.99
      lst.sale.should.equal 29.99
      lst.currency.should.equal 'GBP'
    it "main_pic, product_features, product_desc success parsed", ->
      lst.main_pic.should.equal "http://ecx.images-amazon.com/images/I/41mXwpwYWeL._SL500_AA300_.jpg"
      lst.product_features.length.should.equal 5
      lst.product_features[3].should.include('Lithium Polymer battery ensures high quality')
      lst.product_desc.should.include "Sony Ericsson Xperia X10, X8, Arc"
    it "also_bought, after_viewing success parsed", ->
      lst.also_bought.length.should.equal 6
      lst.also_bought.should.include("http://www.amazon.co.uk/StarTech-feet-Barrel-Power-Cable/dp/B003MQO96U/ref=pd_sim_computers_1")
      lst.after_viewing.length.should.equal 4
      lst.after_viewing.should.include("http://www.amazon.co.uk/PowerGen-External-sensation-Thunderbolt-Blackberry/dp/B0073F92OK/ref=pd_cp_computers_3")
    it "seller_rank success parsed", ->
      lst.seller_rank.length.should.equal 3
      lst.seller_rank[0].rank.should.equal 1248
      lst.seller_rank[0].category.should.include('Computers & Accessories')
      lst.seller_rank[1].rank.should.equal 6
      lst.seller_rank[1].category.should.include('Batteries')
      lst.seller_rank[2].rank.should.equal 39
      lst.seller_rank[2].category.should.include('Chargers')
    it "should have 2 promotes", ->
      lst.promotes.length.should.equal 2
      lst.promotes[0].should.include('Dual Output Port Car Charger')
      lst.promotes[1].should.include('purchase 1 or more Qualifying Items')