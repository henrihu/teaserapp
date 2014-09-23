class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  belongs_to :favorite, :class_name => "Video", :foreign_key => "video_id"
end
