class AddColumnToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :imdb_rating, :float, default: 0
  	add_column :videos, :rotten_tomatoes_rating, :float, default: 0
  end
end
