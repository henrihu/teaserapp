class Genre < ActiveRecord::Base
	has_many :videos, :dependent => :destroy
	validates :name, presence: true, length: {  in: 3..25 }
end
