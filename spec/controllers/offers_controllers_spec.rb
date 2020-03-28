# frozen_string_literal: true

require 'rails_helper'

describe OffersController, type: :controller do
  describe 'GET #index' do
    subject(:index) { get :index }

    let!(:enabled_offer) { create(:offer, :enabled) }
    let!(:disabled_offer) { create(:offer) }

    it 'return only enabled offers' do
      index
      expect(assigns(:offers)).to eq [enabled_offer]
    end
  end
end
