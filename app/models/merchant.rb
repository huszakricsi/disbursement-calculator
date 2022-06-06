class Merchant < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :disbursement, dependent: :destroy
end
