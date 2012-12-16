cheerio = require 'cheerio'

@listing = (body) ->
  $ = cheerio.load(body)
  # shared attrs
  asin = $('#ASIN').attr('value')

  sale_rank = $('#SalesRank')
  review_li = sale_rank.prev()

  lst =
    market: $('.navFooterLogoLine a img').attr('alt')
    asin: asin
    title: $('#btAsinTitle').text()
    byWho: $("#btAsinTitle").parent().parent().find('a').text()
    review_score: parseFloat(review_li.find('.swSprite').attr('title').split(' ')[0])
    reviews: parseInt(review_li.find('.crAvgStars > a').text().split(' ')[0])
    likes: parseInt($(".amazonLikeCount").text())
    price: parseFloat($('#listPriceValue').text()[1..-1])
    sale: parseFloat($('#actualPriceValue').text()[1..-1])
    currency: $('#listPriceValue').text()[0]
    main_pic: $('#prodImageCell img').attr('src')
    product_features: $("h2:contains('Product Features')").next().find('li').map(()-> $(@).text()).join('\n')
    also_bought: also_bought($('#purchaseButtonWrapper'))
    after_viewing: after_viewing($('#cpsims-feature'))
    seller_rank: seller_rank($('#SalesRank'))
    product_desc: $('.productDescriptionWrapper').html().replace('<div class="emptyClear"> </div>', '').trim()
    promotes: promotes($('#quickPromoBucketContent'))

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
  log ranks
  ranks

# 检查是否有优惠
# TODO 等待测试
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
