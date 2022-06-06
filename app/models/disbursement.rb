class Disbursement < ApplicationRecord
  belongs_to :merchant

  validates_uniqueness_of :date, scope: :merchant_id

  after_create :calculate_disbursement

  scope :filled, -> { where.not(amount: nil) }

  class << self
    def find_amount(year = nil , week = nil , merchant_ids = nil)
      return { message: 'Year and week must exist' } unless year || week

      if merchant_ids
        merchants = Merchant.where(id: merchant_ids)
      else
        merchants = Merchant.all
      end
      disbursements = self.where(merchant: merchants, date: Date.commercial(year.to_i, week.to_i, 1))

      return { message: 'Merchant not found' } if merchants.empty? && merchant_ids.present?

      if merchants.size != disbursements.filled.size
        self.create(merchants.where.not(id: disbursements.select(:merchant_id)).map { |m|
          { merchant_id: m.id, date: Date.commercial(year.to_i, week.to_i, 1) }
        } )
        return { message: 'Calculation in progress' }
      end
    
      return disbursements.select(:merchant_id, :amount)
    end
  end

  private

  def calculate_disbursement
    CalculateDisbursementJob.perform_async(self.id)
  end
end
