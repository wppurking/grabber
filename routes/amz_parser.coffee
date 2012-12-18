cheerio = require 'cheerio'

@listing = (body) ->
  $ = cheerio.load(body)
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
    price: multi_market_price_parse($, market)
    sale: multi_market_sale_parse($, market)
    currency: $('#listPriceValue').text()[0]
    main_pic: multi_market_main_pic($, market)
    product_features: multi_market_product_features($, market)
    also_bought: also_bought($('#purchaseButtonWrapper'))
    after_viewing: after_viewing($('#cpsims-feature'))
    seller_rank: multi_market_seller_rank($('#SalesRank'), market)
    product_desc: $('.productDescriptionWrapper').html().replace('<div class="emptyClear"> </div>', '').trim()
    promotes: promotes($('#quickPromoBucketContent'))

multi_market_price_parse = (wrapper, market) ->
  switch market
    when 'amazon.com'
      parseFloat(wrapper('#listPriceValue').text().replace(/,/g, '')[1..-1])
    when 'amazon.de'
      parseFloat(wrapper('.priceLarge').text().replace(/./g, '').replace(/,/g, '.')[4..-1])
    else
      0

multi_market_sale_parse = (wrapper, market) ->
  switch market
    when 'amazon.com'
      parseFloat(wrapper('#actualPriceValue').text().replace(/,/g, '')[1..-1])
    when 'amazon.de'
      parseFloat(wrapper('.priceLarge').text().replace(/./g, '').replace(/,/g, '.')[4..-1])
    else
      0

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

multi_market_seller_rank = (sale_rank_wrapper, market) ->
  ranks = []
  return ranks unless sale_rank_wrapper
  switch market
    when 'amazon.com'
    # 首先寻找大类别
    # 然后再寻找小类别
      ranks = ranks.concat extra_links(sale_rank_wrapper, '#', 'in')
    when 'amazon.de'
      ranks = ranks.concat extra_links(sale_rank_wrapper, 'Nr.', 'in')
    else
      ranks
  ranks

# 从排名的节点中提取排名的 数组对象 [{rank:xx, category:xx}]
extra_links = (sale_rank_wrapper, num_prefix, splitter) ->
  links = []
  text = sale_rank_wrapper.text()
  if text.indexOf('(') > -1
    text = text[(text.indexOf(num_prefix) + num_prefix.length)...text.indexOf('(')]
    links.push str_to_rank(text, splitter) unless str_to_rank(text, splitter) is {}
  sale_rank_wrapper.find('.zg_hrsr_item').each (i) ->
    text = @text()[(@text().indexOf(num_prefix) + num_prefix.length)..-1]
    links.push str_to_rank(text, splitter) unless str_to_rank(text, splitter) is {}
  links

# 将 [27 in Electronics > Accessories & Supplies > Accessories > Batteries] 转换成为
# {rank:27, category:Electronics > Accessories & Supplies > Accessories > Batteries}
str_to_rank = (str, splitter) ->
  args = str.split(splitter)
  if args.length == 2
    {rank: parseInt(args[0].trim()), category: args[1].trim().replace(/\n/g, '')}
  else
    {}


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
