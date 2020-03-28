# frozen_string_literal: true

require 'rails_helper'

describe Offers::UpdateService, type: :service do
  subject(:update_offer) { described_class.run(offer, offer_params) }

  let(:offer) { create(:offer, launch_jid: 'old_launch', end_jid: 'old_end') }
  let(:advertiser_name) { 'Amazon' }
  let(:url) { 'http://www.amazon.com.br' }
  let(:description) { 'offer' }
  let(:starts_at) { offer.starts_at }
  let(:ends_at) { offer.ends_at }
  let(:offer_params) do
    {
      advertiser_name: advertiser_name,
      url: url,
      description: description,
      starts_at: starts_at,
      ends_at: ends_at
    }
  end

  before do
    allow(Offers::LaunchWorker).to receive(:perform_at).and_return('LAUNCH_JID')
    allow(Offers::EndWorker).to receive(:perform_at).and_return('END_JID')
  end

  context 'with valid params' do
    it 'updates offer' do
      update_offer
      expect(offer.reload.advertiser_name).to eq advertiser_name
    end

    it 'keep same launch jid' do
      update_offer
      expect(offer.reload.launch_jid).to eq 'old_launch'
    end

    context 'when change starts_at' do
      let(:starts_at) { Time.now + 1.day }

      it 'updates launch jid' do
        update_offer
        expect(offer.reload.launch_jid).to eq 'LAUNCH_JID'
      end
    end

    context 'when change ends_at' do
      context 'when change to not nil' do
        let(:ends_at) { Time.now + 6.days }

        it 'updates end jid' do
          update_offer
          expect(offer.reload.end_jid).to eq 'END_JID'
        end
      end

      context 'when change to nil' do
        let(:ends_at) { nil }

        it 'updates end jid' do
          update_offer
          expect(offer.reload.end_jid).to be_nil
        end
      end
    end
  end

  context 'with invalid params' do
    context 'with invalid url' do
      let(:url) { 'notvalidurl' }

      it "won't update offer" do
        update_offer
        expect(offer.reload.advertiser_name).not_to eq advertiser_name
      end

      it 'not schedule launch offer' do
        expect(Offers::LaunchWorker).not_to receive(:perform_at)
        update_offer
      end

      it 'not schedule end offer' do
        expect(Offers::EndWorker).not_to receive(:perform_at)
        update_offer
      end
    end

    context 'with duplicated name' do
      let!(:offer2) { create(:offer, advertiser_name: 'Amazon') }

      it "won't update offer" do
        update_offer
        expect(offer.reload.advertiser_name).not_to eq advertiser_name
      end

      it 'not schedule launch offer' do
        expect(Offers::LaunchWorker).not_to receive(:perform_at)
        update_offer
      end

      it 'not schedule end offer' do
        expect(Offers::EndWorker).not_to receive(:perform_at)
        update_offer
      end
    end

    context 'when description has more than 500 characters' do
      let(:description) { Faker::Lorem.characters(501) }

      it "won't update offer" do
        update_offer
        expect(offer.reload.advertiser_name).not_to eq advertiser_name
      end

      it 'not schedule launch offer' do
        expect(Offers::LaunchWorker).not_to receive(:perform_at)
        update_offer
      end

      it 'not schedule end offer' do
        expect(Offers::EndWorker).not_to receive(:perform_at)
        update_offer
      end
    end
  end
end
