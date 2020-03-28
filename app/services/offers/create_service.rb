# frozen_string_literal: true

class Offers::CreateService < ApplicationService
  attr_reader :offer

  def initialize(offer_params)
    @offer = Offer.new(offer_params)
  end

  def run
    create_offer
    schedule_start_offer
    offer
  end

  private

  def create_offer
    @offer.save
  end

  def schedule_start_offer
    return unless @offer.persisted?

    launch_jid = Offers::LaunchWorker.perform_at(@offer.starts_at, @offer.id)
    @offer.update(launch_jid: launch_jid)
  end
end
