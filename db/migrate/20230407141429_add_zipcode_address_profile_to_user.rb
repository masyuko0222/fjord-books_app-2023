class AddZipcodeAddressProfileToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :zipcode, :integer
    add_column :users, :address, :string
    add_column :users, :profile, :text
  end
end
