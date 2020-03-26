class Offers::LaunchWorker
  include Sidekiq::Worker

  def perform(offer_id)
    offer = Offer.find(offer_id)

    return unless offer.launch_jid == self.jid

    offer.update(status: :enabled)
  end
end