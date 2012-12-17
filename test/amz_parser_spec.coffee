should = require 'should'
fs = require 'fs'
amz_parser = require '../routes/amz_parser'

describe "Parser Amazon Listing", ->
  describe "US Listing", ->
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
      lst.currency.should.equal '$'
    it "main_pic, product_features, product_desc success parsed", ->
      lst.main_pic.should.equal "http://ecx.images-amazon.com/images/I/41VuBkkagCL._SL500_AA280_.jpg"
      lst.product_features.length.should.equal 5
      lst.product_features.should.include('Capacity: 12000mAh with Reliable Lithium Polymer battery cells, Supply about 600%~700% of iPhone 4 battery life, or 200%~250% of Google Nexus 7 battery life.')
      lst.product_desc.should.include "Technical specification"
    it "also_bought, after_viewing success parsed", ->
      lst.also_bought.length.should.equal 6
      lst.after_viewing.length.should.equal 4
    it "seller_rank success parsed", ->
      lst.seller_rank[0].rank.should.equal 847
      lst.seller_rank[0].category.should.equal "Cell Phones & Accessories"
      lst.seller_rank[1].rank.should.equal 27
      lst.seller_rank[1].category.should.equal "Electronics > Accessories & Supplies > Accessories > Batteries"
    it "promotes should be empty", ->
      lst.promotes.length.should.equal 0

  describe "DE Listing", ->
    lst = {}
    before(->
      de_html = fs.readFileSync('./html/B008YRG5JQ.de.html', 'utf8')
      lst = amz_parser.listing(de_html)
    )
    it "market, asin, title, byWho, variation success parsed", ->
      lst.market.should.equal 'amazon.de'
      lst.asin.should.equal 'B008YRG5JQ'
      lst.title.should.include('Smart Phone und Tablets Apple iPhone')
      lst.byWho.should.equal "EasyAcc"
      lst.variation.should.equal true
    it "review_score, reviews, likes success parsed", ->
      lst.review_score.should.equal 4.7
      lst.reviews.should.equal 585
      lst.likes.should.equal 22
    it "price, sale, currency success parsed", ->
      lst.price.should.equal 39.99
      lst.sale.should.equal 39.99
      lst.currency.should.equal 'EUR'
    it "main_pic, product_features, product_desc success parsed", ->
      lst.main_pic.should.equal "http://ecx.images-amazon.com/images/I/41VuBkkagCL._SL500_AA300_.jpg"
      lst.product_features.length.should.equal 5
      lst.product_features.should.include('Battery Type: Li-polymer battery, Li-polymer battery is more stable and safe than Li-ion battery, such as both iPad and iPhone use the safer Li-polymer battery. 500+ recharge cycles over the life of the battery.')
      lst.product_desc.should.include "Security Protection Design"
    it "also_bought, after_viewing success parsed", ->
      lst.also_bought.length.should.equal 6
      lst.also_bought.should.include('http://www.amazon.de/EasyAcc-5-Polig-Universal-Ladeger%C3%A4te-Smartphones/dp/B0091CJQMQ/ref=pd_sim_ce_1/276-5869019-3971841')
      lst.after_viewing.length.should.equal 4
      lst.after_viewing.should.include('http://www.amazon.de/Ladeger%C3%A4t-Sensation-Thunderbolt-Handy-Anschl%C3%BCsse-enthalten/dp/B0067XRL56/ref=pd_cp_ce_0/276-5869019-3971841')
    it "seller_rank success parsed", ->
      lst.seller_rank[0].rank.should.equal 3
      lst.seller_rank[0].category.should.equal "Elektronik > Smartphone- & Handyzubehör > Akkus"
      lst.seller_rank[1].rank.should.equal 27
      lst.seller_rank[1].category.should.equal " Elektronik > Zubehör > Zubehör für tragbare Geräte > MP3-Player-Zubehör > Ladegeräte"
    it "promotes should be empty", ->
      lst.promotes.length.should.equal 5
      lst.promotes[2].should.include('Google Nexus 7 aus dem Angebot')

