# frozen_string_literal: true

require 'rails_helper'

describe Admin::OffersController, type: :controller do
  describe 'GET #index' do
    subject(:index) { get :index }

    let!(:enabled_offer) { create(:offer, :enabled) }
    let!(:disabled_offer) { create(:offer) }

    it 'return all offers' do
      index
      expect(assigns(:offers)).to  include(enabled_offer, disabled_offer)
    end
  end

  describe 'POST #create' do
    subject(:create_offer) { post :create, params: { offer: params } }

    let(:offer) { create(:offer) }
    let(:advertiser_name) { 'Amazon' }
    let(:url) { 'http://www.amazon.com.br' }
    let(:description) { 'offer' }
    let(:params) do
      {
        advertiser_name: advertiser_name,
        url: url,
        description: description,
        starts_at: (Time.now + 2.days).to_s,
        ends_at: (Time.now + 4.days).to_s
      }
    end

    before do
      double = double(result: offer)
      allow(Offers::CreateService).to receive(:run).with(ActionController::Parameters.new(params).permit!).and_return(double)
    end

    it 'call create service' do
      create_offer
      expect(Offers::CreateService).to have_received(:run).with(ActionController::Parameters.new(params).permit!)
    end

    it 'redirect to show' do
      create_offer
      expect(response).to redirect_to [:admin, offer]
    end
  end

  describe 'PATCH #update' do
    subject(:update_offer) { patch :update, params: { id: offer.id, offer: params } }

    let(:offer) { create(:offer) }
    let(:advertiser_name) { 'Amazon' }
    let(:url) { 'http://www.amazon.com.br' }
    let(:description) { 'offer' }
    let(:params) do
      {
        advertiser_name: advertiser_name,
        url: url,
        description: description,
        starts_at: (Time.now + 2.days).to_s,
        ends_at: (Time.now + 4.days).to_s
      }
    end

    before do
      allow(Offers::UpdateService).to receive(:run).with(offer, ActionController::Parameters.new(params).permit!).and_return(offer)
    end

    it 'call update service' do
      update_offer
      expect(Offers::UpdateService).to have_received(:run).with(offer, ActionController::Parameters.new(params).permit!)
    end

    it 'redirect to show' do
      update_offer
      expect(response).to redirect_to [:admin, offer]
    end
  end

  describe 'DELETE #destroy' do
    subject(:destroy_offer) { delete :destroy, params: { id: offer.id } }

    let!(:offer) { create(:offer) }

    it 'destroy a offer' do
      expect { destroy_offer }.to change(Offer, :count).from(1).to(0)
    end
  end

  describe 'patch #enable' do
    subject(:enable_offer) { patch :enable, params: { id: offer.id } }

    let(:offer) { create(:offer) }

    it 'enable offer' do
      enable_offer
      expect(offer.reload.enabled?).to be_truthy
    end
  end

  describe 'patch #disable' do
    subject(:disable_offer) { patch :disable, params: { id: offer.id } }

    let(:offer) { create(:offer) }

    it 'disable offer' do
      disable_offer
      expect(offer.reload.disabled?).to be_truthy
    end
  end
end
