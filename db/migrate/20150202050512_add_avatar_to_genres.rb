class AddAvatarToGenres < ActiveRecord::Migration
  def change
    add_column :genres, :avatar, :string
  end
end
