require 'mechanize'
require 'scraperwiki'

url = "https://classic.scraperwiki.com/browse/scrapers/"

agent = Mechanize.new

page = agent.get(url)

page.search(".code_object_line").each do |scraper|
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
  record["notes"] = notes.inner_text if notes
  p record
  ScraperWiki.save_sqlite(['scraper_name'], record)
end
