require 'mechanize'
require 'date'
require 'json'

agent = Mechanize.new
page  = agent.get('http://pitchfork.com/reviews/albums/')

review_links = page.links_with(href: %r{^/reviews/albums/\w+})

review_links = review_links.reject do |link|
  parent_classes = link.node.parent['class'].split
  parent_classes.any? { |p| %w[next-container page-number].include?(p) }
end

review_links = review_links[0...4]

reviews = review_links.map do |link|
  review = link.click
  review_meta = review.search('div#site-content')
  artist = review_meta.search('h1').text
  album = review_meta.search('h2').text
  img = review_meta.search('.single-album-tombstone__art img').attr('src')
  reviewer = review_meta.search('.review-detail__abstract').text.strip
  #contents = review_meta.search('.contents').text.strip
  review_date = review_meta.css('.pub-date').text
  genre = review_meta.search('.genre-list__link').text
  score = review_meta.search('.score').text.to_f
  {
    artist: artist,
    album: album,
    img: img,
    reviewer: reviewer,
    #contents: contents,
    review_date: review_date,
    genre: genre,
    score: score
  }
end

puts JSON.pretty_generate(reviews)
	
	