should = require 'should'
fs = require 'fs'
amz_parser = require '../routes/amz_parser'

describe "Amazon DE Listing Parse", ->
  describe "Whole Listing", ->
    lst = {}
    before(->
      de_html = fs.readFileSync('./html/B005G16098.html', 'utf8')
      lst = amz_parser.listing(de_html)
    )
    it "market, asin, title, byWho, variation success parsed", ->
      lst.market.should.equal 'amazon.de'
      lst.asin.should.equal 'B005G16098'
      lst.title.should.include('Logitech K400 Tastatur schnurlos')
      lst.byWho.should.equal "Logitech"
      lst.variation.should.equal false
    it "review_score, reviews, likes success parsed", ->
      lst.review_score.should.equal 4.5
      lst.reviews.should.equal 379
      lst.likes.should.equal 88
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

  describe "single value test", ->
    lst = {}
    before(->
      lst = amz_parser.listing(fs.readFileSync('./html/number.de.html', 'utf8'))
    )
    it "should conver [.]->[] and [,]->[.]", ->
      lst.price.should.equal 1134.14
      lst.sale.should.equal 1134.14
    it "have variation", ->
      lst.variation.should.equal true
