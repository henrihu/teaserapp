class RemoveGenreId < ActiveRecord::Migration
  def change
  	remove_column :videos, :genre_id
  end
end
