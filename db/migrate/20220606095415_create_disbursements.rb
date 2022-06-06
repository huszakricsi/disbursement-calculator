class CreateDisbursements < ActiveRecord::Migration[5.2]
  def change
    create_table :disbursements do |t|
      t.references :merchant, null: false, foreign_key: true
      t.decimal :amount # would rather use decimal than float since we need precision more than speed
      t.date :date

      t.timestamps
    end
  end
end
