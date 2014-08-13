require "./scraper"

describe "scraper" do 

  before(:each) do
    @doc = Nokogiri::HTML(open("today.html"))
    @today = "Aug 12"

    @rows = @doc.css(".row .txt").map do |row|
      {date: row.css(".pl .date").text,
        title: row.css(".pl a").text,
        loc: row.css(".l2 .pnr small").text,
        pic: row.css(".l2 .pnr .px .p").text}
    end
  end

  describe "get_page_results" do
    it "should return all results from the page" do
      expect(@rows.length).to eql(100)
    end
  end

  describe "get_todays_rows" do
    it "should return only today's results" do
      todays_rows = []
      @rows.each do |row|
        if row[:date] == @today
          todays_rows.push(row)
        end
      end
      expect(todays_rows.length).to eql(52)
    end
  end

  describe "filter_links" do
    it "should return only results related to dogs" do
      dogs = []
      @rows.each do |row|
        dog_match = row[:title].match(/(puppy)|puppies|pup|dog/)
        item_match = row[:title].match(/house|item|boots/)
        if dog_match && !item_match
          dogs.push(row)
        end
      end
      expect(dogs.length).to eql(7)
    end
  end

end