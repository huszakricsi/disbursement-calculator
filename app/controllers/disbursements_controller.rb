class DisbursementsController < ApplicationController
  def index
    render json: Disbursement.find_amount(year_param, week_param, merchant_id_param), except: :id
  end

  private

  def year_param
    params.permit(:year)[:year]
  end

  def week_param
    params.permit(:week)[:week]
  end

  def merchant_id_param
    params.permit(:merchant_id)[:merchant_id]
  end
end
