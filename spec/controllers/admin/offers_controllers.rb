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
end
