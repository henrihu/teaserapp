class Video < ActiveRecord::Base
  
  has_many :favorites, :dependent => :destroy
  validates :name, presence: true, length: {  in: 3..100 }
  validates :director_name, presence: :true, length: {  in: 3..100 }
  validates :link, :presence => true, format: { with: /(?:.be\/|\s+|\/watch\?v=|\/(?=p\/))([\w\/\-]+)/}#, url: { message: "Please follow this format (http://www.youtube.com/)."}				
  validates :year, presence: true
  validate :require_at_least_one_genre
  has_many :users_videos, :dependent => :destroy
  has_many :users, through: :users_videos
  has_many :histories, :dependent => :destroy
  has_and_belongs_to_many :genres,  :join_table => :genres_videos

  private

	def require_at_least_one_genre
	  errors.add(:genre_ids, "Please select atleast one genre.") if (genre_ids.length < 1)
	end

end
