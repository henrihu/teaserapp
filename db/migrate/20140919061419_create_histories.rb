class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :user, index: true
      t.references :video, index: true

      t.timestamps
    end
  end
end
