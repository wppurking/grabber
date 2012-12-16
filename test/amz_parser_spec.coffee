should = require 'should'
fs = require 'fs'
amz_parser = require '../routes/amz_parser'

describe "Parser Amazon Listing", ->
  describe "US Listing", ->
    us_html = fs.readFileSync('./html/B008YRG5JQ.html', "utf8")
    product_features = "Capacity: 12000mAh with Reliable Lithium Polymer battery cells, Supply about 600%~700% of iPhone 4 battery life, or 200%~250% of Google Nexus 7 battery life.\nBattery Type: Li-polymer battery; more stable and safe than Li-ion battery, such as both iPad and iPhone use the safer Li-polymer battery. 500+ recharge cycles over the life of the battery.\n4 x USB Output: 5V 0.6A ~ 2.1A, design for charging Phones and Tablets, Can charge 2 Tablets or 3 Smart Phones simultaneously at most. 4 Integrated LED Power status indicator lets you know exactly how much power is left.\nSecurity protection design: short-circuit and over current protection; The device will automatic shutdown when short circuit or overload output happened to avoid destroy the device and accident\nSize: 14.2*7.3*2.3cm, Stylish & portable design; Ergonomic design for easy handle by one hand; Perfect for long plane flights, road trips; Carry the mobile power wherever you go; charge your devices any time any where"
    it "should pass all and get an listing json obj", ->
      lst = amz_parser.listing(us_html)
      lst.asin.should.equal 'B008YRG5JQ'
      lst.title.should.equal "EasyAcc 12000mAh 4 x USB Portable External Battery Pack Charger for Tablets: iPad 3, iPad mini; Kindle Fire HD, Google Nexus 7; Samsung Galaxy Tab; for Phones: iPhone 5, 4S; Samsung ; Motorola; HTC; LG; Nokia phones; for Kindle Paperwhite, Touch, Kindle and much more 5V device. [PB12000A; 4 USB OUTPUT: 0.5A~2A; Black]"
      lst.byWho.should.equal "EasyAcc"
      lst.review_score.should.equal 4.6
      lst.reviews.should.equal 25
      lst.likes.should.equal 1
      lst.price.should.equal 69.99
      lst.sale.should.equal 42.99
      lst.currency.should.equal '$'
      lst.main_pic.should.equal "http://ecx.images-amazon.com/images/I/41VuBkkagCL._SL500_AA280_.jpg"
      lst.product_features.should.equal product_features
      lst.also_bought.length.should.equal 6
      lst.seller_rank[0].rank.should.equal 847
      lst.seller_rank[1].category.should.equal "Electronics > Accessories & Supplies > Accessories > Batteries"
      lst.product_desc.length.should.equal 1979
      lst.after_viewing.length.should.equal 4
