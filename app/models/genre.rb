class Genre < ActiveRecord::Base
	has_and_belongs_to_many :videos,  :join_table => :genres_videos
	validates :name, presence: true, length: {  in: 3..25 }
	mount_uploader :avatar, AvatarUploader

	# def image
	# 	nil
	# end	
end
