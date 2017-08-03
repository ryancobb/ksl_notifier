require 'rails_helper'
require 'ksl_client'

describe "auto client" do
  let(:search_query) { "some=query&some=otherquery"}
  let(:response) { File.open(Rails.root.join 'spec/fixtures/auto_results.html').read }
  let(:auto_client) { ::KslClient::Auto.new(search_query)}
  
  it "creates listings" do
    expect(auto_client).to receive(:html_results).and_return(response)
    expect{ auto_client.results }.to change{ ::Listing.all.count }.by(30)
  end

  it "correctly parses listings" do

  end
end

describe "classified client" do

end