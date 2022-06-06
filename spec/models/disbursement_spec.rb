require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  let(:current_year) { DateTime.now.year.to_s }
  let(:current_week) { DateTime.now.cweek.to_s }
  let(:merchant)     { Merchant.create }
  let!(:merchant_2)  { Merchant.create }
  let(:shopper)      { Shopper.create }
  let!(:orders)      { Order.create(merchant: merchant, shopper: shopper, amount: 10, completed_at: DateTime.now)
                       Order.create(merchant: merchant, shopper: shopper, amount: 1000, completed_at: DateTime.now)
                       Order.create(merchant: merchant, shopper: shopper, amount: 300) }

  after :context do
    Merchant.destroy_all
    Shopper.destroy_all
  end

  context '#find_amount method' do
    it 'year and week must exist' do
      expect(Disbursement.find_amount()[:message]).to eq 'Year and week must exist'
    end

    it 'Does not accept an invalid merchant' do
      expect(Disbursement.find_amount(current_year, current_week, 0)[:message]).to eq 'Merchant not found'
    end

    it 'returns progress message if disbursement is not generated' do
      expect(Disbursement.find_amount(current_year, current_week, merchant.id)[:message]).to eq 'Calculation in progress'
    end

    it 'returns disbursement if generated' do
      Disbursement.find_amount(current_year, current_week, merchant.id)

      allow_any_instance_of(Disbursement).to receive(:calculate_disbursement)
      CalculateDisbursementJob.new.perform(Disbursement.first.id)

      disbursement = Disbursement.find_amount(current_year, current_week, merchant.id)[0]
      expect(disbursement.merchant_id).to eq merchant.id
      expect(disbursement.amount).to eq 8.6
    end


    it 'returns all merchants if merchant ids are not definde' do
      Disbursement.find_amount(current_year, current_week)

      allow_any_instance_of(Disbursement).to receive(:calculate_disbursement)
      Disbursement.all.each { |d| CalculateDisbursementJob.new.perform(d.id) }
      
      expect(Disbursement.find_amount(current_year, current_week).size).to eq 2
    end
  end
end
