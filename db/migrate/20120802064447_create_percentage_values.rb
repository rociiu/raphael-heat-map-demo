class CreatePercentageValues < ActiveRecord::Migration
  def change
    create_table :percentage_values do |t|
      t.integer :country_id
      t.integer :browser_id
      t.float :value, :default => 0.0

      t.timestamps
    end
  end
end
