require 'mechanize'
require 'date'
require 'json'

agent = Mechanize.new
page  = agent.get('https://loveandcarry.com/ua/shop/view/')
url_img = ('https://loveandcarry.com/')
review_links = page.links_with(:class => 'bprod')

review_links = review_links[0...4]

reviews = review_links.map do |link|
  review = link.click
  review_meta = review.search('div.out')
  title = review_meta.search('h1.title-p').text
  color = review_meta.search('.title-p-sm').text
  img = review_meta.search('.psliders__inner img').map{ |i| url_img + i.attr('src').to_s }
  price = review_meta.search('#item-price').text
  description = review_meta.css('ul.list li').map{ |i| i.text.strip}
  feature = review_meta.css('.flist-block__text').map{ |i| i.text.strip}
  instruction = review_meta.search('.image-instruction__list-block').map{ |i| i.text.gsub(/\s+/, ' ').strip}
  complectacion = review_meta.search('.descrblock-spec li').map{ |i| i.text.strip}
  {
    Название: title,
    Цвет: color,
    Фото: img,
    Цена: price,
    Описание: description,
    Особенности: feature,
    Инструкции: instruction,
    Комплектация: complectacion
  }
end

puts JSON.pretty_generate(reviews)
	
	