class AddPaymentStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :payment_status, :boolean, default: false
  end
end
