class AddDefaultValueToPrivateAttribute < ActiveRecord::Migration[5.0]
  def up
  change_column :wikis, :private, :boolean, :default => false
  end

  def down

  end
end
