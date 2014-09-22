class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  belongs_to :history, :class_name => "Video", :foreign_key => "video_id"
end
