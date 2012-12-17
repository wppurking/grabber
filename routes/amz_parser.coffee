cheerio = require 'cheerio'

@listing = (body) ->
  $ = cheerio.load(body.toString('iso8859-1'))
  # shared attrs
  asin = $('#ASIN').attr('value')
  market = $('.navFooterLogoLine a img').attr('alt')

  sale_rank = $('#SalesRank')
  review_li = sale_rank.prev()

  lst =
    market: market
    asin: asin
    variation: $('#asinRedirect').length == 1
    title: $('#btAsinTitle').text()
    byWho: $("#btAsinTitle").parent().parent().find('a').text()
    review_score: parseFloat(review_li.find('.swSprite').attr('title').split(' ')[0])
    reviews: parseInt(review_li.find('.crAvgStars > a').text().split(' ')[0])
    likes: parseInt($(".amazonLikeCount").text())
    price: parseFloat($('#listPriceValue').text()[1..-1])
    sale: parseFloat($('#actualPriceValue').text()[1..-1])
    currency: $('#listPriceValue').text()[0]
    main_pic: multi_market_main_pic($, market)
    product_features: multi_market_product_features($, market)
    also_bought: also_bought($('#purchaseButtonWrapper'))
    after_viewing: after_viewing($('#cpsims-feature'))
    seller_rank: seller_rank($('#SalesRank'))
    product_desc: $('.productDescriptionWrapper').html().replace('<div class="emptyClear"> </div>', '').trim()
    promotes: promotes($('#quickPromoBucketContent'))

multi_market_product_features = (body, market) ->
  switch market
    when 'amazon.com'
      body("h2:contains('Product Features')").next().find('li').map(()-> @text())
    when 'amazon.de'
      body("h2:contains('Produktmerkmale')").next().find('li').map(()-> @text())
    else
      []

# 不同市场对 main_pic 字段的处理
multi_market_main_pic = (body, market) ->
  switch market
    when 'amazon.com'
      body('#prodImageCell img').attr('src')
    when 'amazon.de'
      body('#main_image_0 img').attr('src')
    else
      ""


# 检查 Listing 的所有 Seller Rank
seller_rank = (rank_li) ->
  str_to_rank = (str) ->
    rank_obj = str.split('in')
    rank_str = rank_obj[0].trim()
    # 美国
    if rank_str.indexOf('#') > -1
      rank = parseInt(rank_str[1..-1])
    else if not rank_str
      rank = 0
    else
      rank = parseInt(rank_str)
    {rank: rank, category: rank_obj[1].trim()}

  text = rank_li.text()
  text = text[(text.indexOf("#") + 1)...text.indexOf('(')]
  ranks = [str_to_rank(text)]
  rank_li.find('.zg_hrsr_item').each (i) ->
    ranks.push str_to_rank(@text())
  ranks

# 检查是否有优惠
promotes = (wrapper) ->
  lis = []
  wrapper.find('li').each (i) ->
    lis.push @html()
  lis


# 抓取这个 Listing 的 After Viewing 部分的 Listing 链接
after_viewing = (wrapper) ->
  links = []
  for link in wrapper.find('li a[id]')
    links.push link.attribs['href']
  links


# 购买这个 Listing 也购买其他的 Listing
also_bought = (wrapper) ->
  links = []
  for a in wrapper.find("li a.sim-img-title")
    links.push a.attribs['href']
  links

log = (msg) -> console.log msg
