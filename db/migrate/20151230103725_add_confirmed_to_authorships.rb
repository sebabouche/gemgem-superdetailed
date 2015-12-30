class AddConfirmedToAuthorships < ActiveRecord::Migration
  def change
    add_column :authorships, :confirmed, :integer
  end
end
