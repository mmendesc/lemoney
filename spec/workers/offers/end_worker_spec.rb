# frozen_string_literal: true

require 'rails_helper'

describe Offers::EndWorker, type: :worker do
  subject(:end_worker) { described_class.new.perform(offer.id) }

  let(:offer) { create(:offer, end_jid: 'end_jid', status: :enabled) }
  let(:end_jid) { 'end_jid' }

  before do
    allow_any_instance_of(Offers::EndWorker).to receive(:jid).and_return(end_jid)
  end

  it 'update status to disabled' do
    end_worker
    expect(offer.reload.disabled?).to be_truthy
  end

  context 'when end_jid not matches' do
    let(:end_jid) { 'other_jid' }

    it 'does not update status to disabled' do
      end_worker
      expect(offer.reload.disabled?).to be_falsy
    end
  end
end