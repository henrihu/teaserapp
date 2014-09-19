class CreateJoinTable < ActiveRecord::Migration
  def self.up
	  create_table 'genres_videos', :id => false do |t|
	    t.column :genre_id, :integer
	    t.column :video_id, :integer
	  end
  end
end
