class AddActorsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :actors, :string
  end
end
