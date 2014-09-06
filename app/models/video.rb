class Video < ActiveRecord::Base
  belongs_to :genre
  has_many :favorites, :dependent => :destroy
end
