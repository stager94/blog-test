class AddStateToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :state, :integer, default: 0
  end
end
