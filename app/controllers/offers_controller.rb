# frozen_string_literal: true

class OffersController < ApplicationController
  # before_action :set_offer, only: [:show, :edit, :update, :destroy]

  def index
    @offers = Offer.enabled.order(premium: :desc)
  end
end
