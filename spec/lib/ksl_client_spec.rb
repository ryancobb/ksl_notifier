require 'rails_helper'
require 'ksl_client'

describe "auto client" do
  let(:search_query) { "some=query&some=otherquery"}
  let(:response) { File.open(Rails.root.join 'spec/fixtures/auto_results.html').read }
  let(:auto_client) { ::KslClient::Auto.new(search_query)}

  before do
    expect(auto_client).to receive(:html_results).and_return(response)
  end
  
  it "creates listings" do
    expect{ auto_client.results }.to change{ ::Listing.all.count }.by(30)
  end

  it "correctly parses listings" do
    expect(auto_client.results.first).to have_attributes(
      :title => "2016 Toyota Tacoma TRD Sport",
      :short_description => "LONG BED. ONE-OWNER CLEAN CARFAX. Tacoma TRD Sport 4...",
      :location => "St. George, UT",
      :link => "https://www.ksl.com/auto/listing/3887365?ad_cid=1",
      :price => Money.new(3699900)
    )
  end
end

describe "classified client" do
  let(:search_query) { "some=query&some=otherquery"}
  let(:response) { File.open(Rails.root.join 'spec/fixtures/classified_results.html').read }
  let(:classified_client) { ::KslClient::Classified.new(search_query)}

  before do
    expect(classified_client).to receive(:html_results).and_return(response)
  end
  
  it "creates listings" do
    expect{ classified_client.results }.to change{ ::Listing.all.count }.by(24)
  end

  it "correctly parses listings" do
    expect(classified_client.results.first).to have_attributes(
      :title => "Rooftop cargo box Thule 669ES",
      :short_description => "Key FeaturesPassenger-side opening for easier loading and unloadingEasy-Snap...",
      :location => "Draper, UT",
      :link => "https://www.ksl.com/classifieds/listing/45249878",
      :price => Money.new(18000)
    )
  end
end