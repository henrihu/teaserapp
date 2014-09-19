class Video < ActiveRecord::Base
  
  has_many :favorites, :dependent => :destroy
  validates :name, presence: true, length: {  in: 3..100 }
  validates :director_name, presence: :true, length: {  in: 3..100 }
  validates :link, :presence => true, format: { with: /(?:.be\/|\s+|\/watch\?v=|\/(?=p\/))([\w\/\-]+)/}#, url: { message: "Please follow this format (http://www.youtube.com/)."}				
  validates :year, presence: true
  has_many :users_videos
  has_many :users, through: :users_videos
  has_many :histories, :dependent => :destroy
  has_and_belongs_to_many :genres,  :join_table => :genres_videos
end
