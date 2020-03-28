# frozen_string_literal: true

class Offers::UpdateService < ApplicationService
  attr_reader :offer, :offer_params, :old_starts_at, :result, :old_ends_at

  def initialize(offer, offer_params)
    @offer = offer
    @offer_params = offer_params
    @old_starts_at = offer.starts_at
    @old_ends_at = offer.ends_at
  end

  def run
    update_offer
    schedule_start_offer
    schedule_end_offer
    result
  end

  private

  def update_offer
    @result = @offer.update(offer_params)
  end

  def schedule_start_offer
    return unless result && (@offer.starts_at != old_starts_at)

    launch_jid = Offers::LaunchWorker.perform_at(@offer.starts_at, @offer.id)
    @offer.update(launch_jid: launch_jid)
  end

  def schedule_end_offer
    return unless result && (@offer.ends_at != old_ends_at)

    end_jid = offer.ends_at.nil? ? nil : Offers::EndWorker.perform_at(offer.ends_at, offer.id)
    offer.update(end_jid: end_jid)
  end
end
