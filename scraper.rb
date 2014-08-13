# scraper.rb
require 'nokogiri'
require 'open-uri'
require 'awesome_print'


# filter links
def filter_links(rows)
  dogs = []
  dog_pics = []

  # search for dogs
  rows.each do |row|
    dog_match = row[:title].match(/(puppy)|puppies|pup|dog/)
    item_match = row[:title].match(/house|item|boots/)
    if dog_match && !item_match
      dogs.push(row)
    end
  end

  # search for dogs with pics
  dogs.each do |dog|
    pic_match = dog[:pic].match(/pic/)
    if pic_match
      dog_pics.push(dog)
    end
  end

  ap dog_pics
end


# get today's rows
def get_todays_rows(doc, date_str)
  todays_rows = []

  doc.each do |row|
    if row[:date] == date_str
      todays_rows.push(row)
    end
  end

  filter_links(todays_rows)
end


# get all page results
def get_page_results(date_str)
  url = "http://sfbay.craigslist.org/sfc/pet/"
  # url = "today.html"
  page = Nokogiri::HTML(open(url).read)

  rows = page.css(".row .txt").map do |row|
    {date: row.css(".pl .date").text,
      title: row.css(".pl a").text,
      loc: row.css(".l2 .pnr small").text,
      pic: row.css(".l2 .pnr .px .p").text}
  end

  get_todays_rows(rows, date_str)
end


# search function
def search(date_str)
  get_page_results(date_str)
end


# Learn more about time in ruby:
# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/date/rdoc/Date.html#strftime-method
today = Time.now.strftime("%b %d")


# call search function with today's date
search(today)