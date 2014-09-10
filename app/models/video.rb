class Video < ActiveRecord::Base
  belongs_to :genre
  has_many :favorites, :dependent => :destroy
  validates :name, presence: true, length: {  in: 3..20 }
  validates :genre_id, presence: :true
  validates :director_name, presence: :true, length: {  in: 3..20 }
  validates :link, :presence => true, format: { with: /(?:.be\/|\s+|\/watch\?v=|\/(?=p\/))([\w\/\-]+)/}#, url: { message: "Please follow this format (http://www.youtube.com/)."}				
  validates :year, presence: true
end
