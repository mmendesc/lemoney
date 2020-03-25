# frozen_string_literal: true

class Offer < ApplicationRecord

  enum status: {
    disabled: 1,
    enabled: 2
  }
end
