# frozen_string_literal: true

class Offer < ApplicationRecord

  validates_presence_of :advertiser_name, :description, :url, :starts_at
  validates_uniqueness_of :advertiser_name
  validates :description, length: { maximum: 500 }
  validate :valid_url

  enum status: {
    disabled: 1,
    enabled: 2
  }

  def valid_url
    errors.add(:url, 'Invalid url') unless valid_url?
  end

  def valid_url?
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
