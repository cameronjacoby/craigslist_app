require "./scraper"

describe "scraper" do 

  before(:each) do
    @doc = Nokogiri::HTML(open("today.html"))
    @today = "Aug 12"
  end

  describe "search" do
    it "should return today's dog results with pics" do
      expect(search(@today).length).to eql(41)
    end
  end

end