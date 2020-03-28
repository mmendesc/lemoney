# frozen_string_literal: true

require 'rails_helper'

describe Offers::LaunchService, type: :service do
  subject(:launch_offer) { described_class.run(offer) }

  let(:offer) { create(:offer) }

  before do
    allow(Offers::EndWorker).to receive(:perform_at).with(offer.ends_at, offer.id).and_return('END_JID')
  end

  it 'update status to enabled' do
    launch_offer
    expect(offer.reload.enabled?).to be_truthy
  end

  context 'when offer has end date' do
    it 'schedule end offer' do
      launch_offer
      expect(offer.reload.end_jid).to eq 'END_JID'
    end
  end

  context 'when offer not defined end date' do
    let(:offer) { create(:offer, :endless) }

    it 'not schedule end offer' do
      launch_offer
      expect(offer.reload.end_jid).to be_nil
    end
  end
end