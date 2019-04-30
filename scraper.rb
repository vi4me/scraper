require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper

	url = 'http://baskino.me/new/'
	unparsed_page = HTTParty.get(url)
	parsed_page = Nokogiri::HTML(unparsed_page)
	films = Array.new
	film_cards = parsed_page.css('div.shortpost') #12
	page = 1
	per_page = film_cards.count
	total = per_page*20
	last_page = (total.to_f / per_page.to_f).round
	while page <= last_page
		pagination_url = "http://baskino.me/new/page/#{page}"
		puts "Адрес страницы: " + pagination_url
		puts "Страница: #{page}"
		puts ""
		pagination_unparsed_page = HTTParty.get(pagination_url)
		pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
		pagination_film_cards = pagination_parsed_page.css('div.shortpost')
		pagination_film_cards.each do |film_card|
		
			film = {
				title: film_card.css('div.posttitle a').text,
				date: film_card.css('div.postdata .linline').text,
    			year: film_card.css('div.postdata .rinline').text,
    			img: film_card.css('div.postcover a img')[0].attributes["src"].value
			}
			films << film
			puts "Название фильма: #{film[:title]}"
			puts "Дата выпуска: #{film[:date]}"
			puts "#{film[:year]}"
			puts "Ссылка на картинку: #{film[:img]}"
		end
		page += 1
	end
	
end

scraper