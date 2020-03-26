# frozen_string_literal: true

class Offers::LaunchService < ApplicationService
  attr_reader :offer

  def initialize(offer)
    @offer = offer
  end

  def run
    activate_offer
    schedule_end_offer
  end

  private

  def activate_offer
    offer.update(status: :enable)
  end

  def schedule_end_offer
    return if offer.ends_at.nil?

    end_jid = ::Offers::EndWorker.perform_at(@offer.ends_at, @offer.id)
    offer.update(end_jid: end_jid)
  end
end
