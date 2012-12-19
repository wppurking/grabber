cheerio = require 'cheerio'

@listing = (body) ->
  $ = cheerio.load(body)
  # 404 page
  return {code: 404} if $('title').text().indexOf('404') > -1
  # shared attrs
  asin = $('#ASIN').attr('value')
  market = $('.navFooterLogoLine a img').attr('alt')

  sale_rank = $('#SalesRank')
  review_li = sale_rank.prev()

  lst =
    market: market
    asin: asin
    variation: $('#asinRedirect').length == 1 or $('.variations').length >= 1
    title: $('#btAsinTitle').text()
    byWho: $("#btAsinTitle").parent().parent().find('a').text()
    review_score: parseFloat($(".asinReviewsSummary[name=#{asin}] .swSprite").eq(0).attr('title').split(' ')[0])
    reviews: Math.ceil(multi_market_num_parse(($(".asinReviewsSummary[name=#{asin}]").eq(0).next().text().split(' ')[0]), market))
    likes: Math.ceil(multi_market_num_parse($(".amazonLikeCount").text(), market))
    price: multi_market_price_parse($, market)
    sale: multi_market_sale_parse($, market)
    currency: multi_market_currency(market)
    main_pic: multi_market_main_pic($, market)
    product_features: multi_market_product_features($, market)
    also_bought: also_bought($, market)
    after_viewing: after_viewing($, market)
    seller_rank: multi_market_seller_rank($('#SalesRank'), market)
    product_desc: $('.productDescriptionWrapper').html().replace('<div class="emptyClear"> </div>', '').trim()
    promotes: promotes($, market)

multi_market_currency = (market) ->
  switch market
    when 'amazon.com'
      "USD"
    when 'amazon.de'
      "EUR"
    when 'amazon.co.uk'
      "GBP"
    else
      "USD"

# 解析不同市场的数字格式
multi_market_num_parse = (str, market) ->
  switch market
    when 'amazon.com'
      parseFloat(str.replace(/,/g, ''))
    when 'amazon.de'
      parseFloat(str.replace(/\./g, '').replace(/,/g, '.'))
    else
      0

multi_market_price_parse = (dom, market) ->
  switch market
    when 'amazon.com'
      multi_market_num_parse(dom('#listPriceValue').text()[1..-1], market)
    when 'amazon.de'
      multi_market_num_parse(dom('.priceLarge').text()[4..-1], market)
    else
      0

multi_market_sale_parse = (dom, market) ->
  switch market
    when 'amazon.com'
      multi_market_num_parse(dom('#actualPriceValue').text()[1..-1], market)
    when 'amazon.de'
      multi_market_num_parse(dom('.priceLarge').text()[4..-1], market)
    else
      0

multi_market_product_features = (dom, market) ->
  switch market
    when 'amazon.com'
      fetures = dom("h2:contains('Product Features')").next().find('li').map(-> @text().trim())
      if dom('#technical_details')
        fetures = fetures.concat dom('#technical_details').parent().find('li').map(-> @text().trim())
    when 'amazon.de'
      dom("h2:contains('Produktmerkmale')").next().find('li').map(-> @text().trim())
    else
      []

# 不同市场对 main_pic 字段的处理
multi_market_main_pic = (dom, market) ->
  switch market
    when 'amazon.com'
      dom('#prodImageCell img').attr('src')
    when 'amazon.de'
      dom('#main_image_0 img').attr('src')
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
    links.push str_to_rank(text, splitter) unless str_to_rank(text, splitter) == {}
  sale_rank_wrapper.find('.zg_hrsr_item').each (i) ->
    text = @text()[(@text().indexOf(num_prefix) + num_prefix.length)..-1]
    links.push str_to_rank(text, splitter) unless str_to_rank(text, splitter) == {}
  links

# 将 [27 in Electronics > Accessories & Supplies > Accessories > Batteries] 转换成为
# {rank:27, category:Electronics > Accessories & Supplies > Accessories > Batteries}
str_to_rank = (str, splitter) ->
  args = str.split(splitter)
  if args.length >= 2
    {rank: parseInt(args[0].trim()), category: args[1..-1].join('').trim().replace(/\n/g, '')}
  else
    {}


# 检查是否有优惠
promotes = (dom, market) ->
  lis = []
  # 现在不需要 market , 但保留这样的接口
  dom('#quickPromoBucketContent li').each (i) ->
    lis.push @html()
  lis


# 抓取这个 Listing 的 After Viewing 部分的 Listing 链接
after_viewing = (dom, market) ->
  links = []
  # 现在不需要 market , 但保留这样的接口
  for link in dom('#cpsims-feature li a[id]')
    links.push link.attribs['href']
  links


# 购买这个 Listing 也购买其他的 Listing
also_bought = (dom, market) ->
  links = []
  # 现在不需要 market , 但保留这样的接口
  for a in dom('#purchaseButtonWrapper li a.sim-img-title')
    links.push a.attribs['href']
  links

log = (msg) -> console.log msg
