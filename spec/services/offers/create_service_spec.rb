# frozen_string_literal: true

require 'rails_helper'

describe Offers::CreateService, type: :service do
  subject(:create_offer) { described_class.run(offer_params) }

  let(:advertiser_name) { 'Amazon' }
  let(:url) { 'http://www.amazon.com.br' }
  let(:description) { 'offer' }
  let(:offer_params) do
    {
      advertiser_name: advertiser_name,
      url: url,
      description: description,
      starts_at: Time.now + 2.days,
      ends_at: Time.now + 4.days
    }
  end

  before do
    allow(Offers::LaunchWorker).to receive(:perform_at).and_return('LAUNCH_JID')
  end

  context 'with valid params' do
    it 'creates a offer' do
      expect { create_offer }.to change(Offer, :count).from(0).to(1)
    end

    it 'schedule launch offer' do
      expect(create_offer.result.launch_jid).to eq 'LAUNCH_JID'
    end
  end

  context 'with invalid params' do
    context 'with invalid url' do
      let(:url) { 'notvalidurl' }

      it "won't create a offer"do
        expect { create_offer }.not_to change(Offer, :count)
      end

      it 'not schedule launch offer' do
        expect(Offers::LaunchWorker).not_to receive(:perform_at)
        create_offer
      end
    end

    context 'with duplicated name' do
      let!(:offer) { create(:offer, advertiser_name: 'Amazon') }

      it "won't create a offer"do
        expect { create_offer }.not_to change(Offer, :count)
      end

      it 'not schedule launch offer' do
        expect(Offers::LaunchWorker).not_to receive(:perform_at)
        create_offer
      end
    end

    context 'when description has more than 500 characters' do
      let(:description) { Faker::Lorem.characters(501) }

      it "won't create a offer"do
        expect { create_offer }.not_to change(Offer, :count)
      end

      it 'not schedule launch offer' do
        expect(Offers::LaunchWorker).not_to receive(:perform_at)
        create_offer
      end
    end
  end
end
