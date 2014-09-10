class AddDirectorNameToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :director_name, :string
  end
end
