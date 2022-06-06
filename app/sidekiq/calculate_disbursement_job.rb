class CalculateDisbursementJob
  include Sidekiq::Job

  def perform(id)
    disbursement = Disbursement.find_by(id: id)

    return unless disbursement

    orders = Order.where(merchant_id: disbursement.merchant_id)
                  .where.not(completed_at: nil)
                  .where(
                    "date(completed_at) >= ? AND date(completed_at) <= ?",
                    disbursement.date,
                    disbursement.date.at_end_of_week
                  )
    
    disbursement.update(amount: orders.map { |o|
      case
      when o.amount < 50
        (o.amount * 0.01).round(2)
      when o.amount < 300
        (o.amount * 0.0095).round(2)
      else
        (o.amount * 0.0085).round(2)
      end
    }.sum)
  end
end