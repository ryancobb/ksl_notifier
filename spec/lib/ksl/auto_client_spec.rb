require 'rails_helper'

describe ::Ksl::AutoClient do
  let(:search_url) { "http://www.somesearchurl.com" }
  subject { ::Ksl::AutoClient.new(search_url) }

  context "sucessfuly fetches page" do
    let(:response) { File.open(Rails.root.join 'spec/fixtures/auto_results.html').read }
    before { allow(subject).to receive(:fetch_page).and_return(response) }

    it "parses all listings" do
      expect(subject.listings.count).to eq(30)
    end

    it "correctly parses listing" do
      listing = subject.listings.first

      expect(listing.title).to eq("2016 Toyota Tacoma TRD Sport")
      expect(listing.short_description).to eq("LONG BED. ONE-OWNER CLEAN CARFAX. Tacoma TRD Sport 4...")
      expect(listing.location).to eq("St. George, UT")
      expect(listing.link).to eq("https://www.ksl.com/auto/listing/3887365")
      expect(listing.price_cents).to eq(3699900)
      expect(listing.photo_url).to eq("./auto_results_files/2269204-1501594790-280578.jpg")
    end
  end
end