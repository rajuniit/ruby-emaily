class CreateTopLevelDomains < ActiveRecord::Migration
  def change
    create_table :top_level_domains do |t|
      t.string :name

      t.timestamps
    end
  end
end
