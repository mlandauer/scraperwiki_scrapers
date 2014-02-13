require 'mechanize'
require 'scraperwiki'

url = "https://classic.scraperwiki.com/browse/scrapers/"

agent = Mechanize.new

last_page = false
page_number = 0

until last_page
  puts "Scraping page #{page_number}..."
  page = agent.get(page_number == 0 ? url : url + "?page=#{page_number}")
  page_number += 1

  scrapers = page.search(".code_object_line")
  scrapers.each do |scraper|
    record = {}
    #puts scraper
    record["profile_name"] = scraper.at("a.owner").inner_html
    record["profile_url"] = (page.uri + scraper.at("a.owner")["href"]).to_s
    record["scraper_url"] = (page.uri + scraper.at("a.screenshot")["href"]).to_s
    record["scraper_name"] = scraper.at("a.screenshot")["href"].split("/")[2]
    record["type"] = scraper.at(".codewiki_type .link").inner_html
    record["language"] = scraper.at(".language .link a").inner_html
    record["status"] = scraper.at(".status .link").inner_html
    notes = scraper.at(".notes .link a")
    record["notes"] = notes.inner_html if notes
    record["description"] = scraper.at("p.description").inner_html
    #p record
    ScraperWiki.save_sqlite(['profile_name', 'scraper_name'], record)
  end
  last_page = true if scrapers.empty?  
end
