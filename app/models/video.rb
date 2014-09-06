class Video < ActiveRecord::Base
  belongs_to :genre
  YEAR = (1950..Time.now.year).to_a

end
