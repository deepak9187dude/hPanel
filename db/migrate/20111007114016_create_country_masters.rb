class CreateCountryMasters < ActiveRecord::Migration
  def self.up
    create_table :country_masters do |t|
      t.string :country_name, :null => false
      t.string :code_two, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :country_masters
  end
end
