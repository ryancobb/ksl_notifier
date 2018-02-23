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

      expect(listing.title).to eq("Amazing Puppy 12 Weeks Old!")
      expect(listing.full_description).to eq("She is a lab and heeler mix with the cutest black spots. She is fully transitioned to hard food and loves it. Potty training has been great. She will tell you when she will need to go and will use a puppy pad to pee but does not like to use them for number 2. Instead she will wait until she\u2019s outside. She is so loving and loves to play with other dogs and kids. Really want to have you meet her and me to ensure the right home for her. ")
      expect(listing.location).to eq("Salt Lake City, UT")
      expect(listing.link).to eq("https://www.ksl.com/classifieds/listing/51304764")
      expect(listing.price_cents).to eq(15000)
      expect(listing.photo_url).to eq("//img.ksl.com/mx/mplace-classifieds.ksl.com/1114449-1519351437-130609.jpg")
    end
  end
end
