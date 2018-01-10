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
    expect(auto_client.results.count).to eq(30)
  end

  it "correctly parses listings" do
    expect(auto_client.results.first).to have_attributes(
      :title => "2016 Toyota Tacoma TRD Sport",
      :short_description => "LONG BED. ONE-OWNER CLEAN CARFAX. Tacoma TRD Sport 4...",
      :location => "St. George, UT",
      :link => "https://www.ksl.com/auto/listing/3887365",
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
    expect(classified_client.results.count).to eq(24)
  end

  it "correctly parses listings" do
    expect(classified_client.results.first).to have_attributes(
      :title => "Vintage 1970's GE Mickey Mouse record player",
      :short_description => "Vintage 1970's GE Mickey Mouse record player. Very good condtion. No damage. Works great...",
      :location => "South Jordan Utah, UT",
      :link => "https://www.ksl.com/classifieds/listing/50719691",
      :price => Money.new(7500),
      :photo_url => "./New and Used listings in Utah, Idaho, and Wyoming _ ksl.com_files/2857164-1513882557-746845.JPG"
    )
  end
end