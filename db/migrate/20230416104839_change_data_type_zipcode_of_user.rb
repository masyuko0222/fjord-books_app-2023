class ChangeDataTypeZipcodeOfUser < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :zipcode, :string
  end
end
