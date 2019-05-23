require 'nokogiri'
require 'open-uri'
require 'httparty'
require 'sinatra'





get '/marvel2/page/:page' do |page|

  url = "https://kinokrad.co/marvel2/page/#{page}/"
 		
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  @film_cards = parsed_page.css('div.shorbox')

  erb :index
end





  

  