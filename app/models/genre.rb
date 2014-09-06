class Genre < ActiveRecord::Base
	has_many :videos, :dependent => :destroy
end
