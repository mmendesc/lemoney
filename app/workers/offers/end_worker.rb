class Offers::EndWorker
  include Sidekiq::Worker

  def perform(offer_id)
    offer = Offer.find(offer_id)

    return unless offer.end_jid == self.jid

    offer.update(status: :disabled)
  end
end