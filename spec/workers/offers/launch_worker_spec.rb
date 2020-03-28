# frozen_string_literal: true

require 'rails_helper'

describe Offers::LaunchWorker, type: :worker do
  subject(:launch_worker) { described_class.new.perform(offer.id) }

  let(:offer) { create(:offer, launch_jid: 'launch_jid') }
  let(:launch_jid) { 'launch_jid' }
  before do
    allow_any_instance_of(Offers::LaunchWorker).to receive(:jid).and_return(launch_jid)
  end

  it 'update status to enabled' do
    launch_worker
    expect(offer.reload.enabled?).to be_truthy
  end

  context 'when launch_jid not matches' do
    let(:launch_jid) { 'other_jid' }

    it 'does not update status to enabled' do
      launch_worker
      expect(offer.reload.enabled?).to be_falsy
    end
  end
end