class Disbursement < ApplicationRecord
  belongs_to :merchant

  validates_uniqueness_of :date, scope: :merchant_id

end
