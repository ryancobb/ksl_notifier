require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "#update_listings" do
    context "existing listings" do
      let!(:existing_listing) { ::Listing.create(:link => "existing_listing.com") }
      let(:new_listing) { ::Listing.new(:link => "new_listing.com") }

      before { allow(subject.listings).to receive(:where).and_return [existing_listing] }

      it "creates one new listing" do
        allow(subject).to receive(:get_listings).and_return([existing_listing, new_listing])
        expect(new_listing).to receive(:save)

        subject.update_listings
      end
    end
  end
end
