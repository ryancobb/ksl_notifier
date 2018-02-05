require 'rails_helper'

describe ::Ksl::ClassifiedClient do
  let(:search_url) { "http://www.somesearchurl.com" }
  subject { ::Ksl::ClassifiedClient.new(search_url) }

  context "sucessfuly fetches page" do
    let(:response) { File.open(Rails.root.join 'spec/fixtures/classified_results.html').read }
    before { allow(subject).to receive(:fetch_page).and_return(response) }

    it "parses all listings" do
      expect(subject.listings.count).to eq(24)
    end

    it "correctly parses listing" do
      listing = subject.listings.first
      
      expect(listing.title).to eq("Female Pomeranian puppy")
      expect(listing.full_description).to eq("Adorable, great personality, first shot and vet checked,, 8 weeks and ready for her new home, can meet 1/2 way Vernal Utah 435-789-7191 call or text 435-828-7197 or 7198.  (Will sell for $650 this Wednesday if you can meet in fruitland)")
      expect(listing.location).to eq("Vernal, UT")
      expect(listing.link).to eq("https://www.ksl.com/classifieds/listing/51136875")
      expect(listing.price_cents).to eq(70000)
      expect(listing.photo_url).to eq("//img.ksl.com/mx/mplace-classifieds.ksl.com/266671-1517785115-30349.jpeg")
    end
  end
end