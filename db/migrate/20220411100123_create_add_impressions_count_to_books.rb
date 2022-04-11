class CreateAddImpressionsCountToBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :add_impressions_count_to_books do |t|

      t.timestamps
    end
  end
end
