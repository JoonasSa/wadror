class Rating < ActiveRecord::Base
	belongs_to :beer

	def to_s
		"#{score}"
	end
end
