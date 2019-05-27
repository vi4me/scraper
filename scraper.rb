require 'nokogiri'
require 'open-uri'
require 'httparty'
require 'json'
require 'mechanize'
require 'sinatra'

get '/' do

  agent = Mechanize.new
  page  = agent.get('https://pampik.com/category/ergo-rukzaki')
  
  review_links = page.links_with(:class => 'product-item__img')
  
  reviews = review_links.map do |link|
  	review = link.click
  	@review_metas = review.search('.main')

  	erb :index
  end
end





  

  