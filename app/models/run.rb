class Run < ActiveRecord::Base
	belongs_to :user, :validate => true
	validates_presence_of :distance
	validates_presence_of :user_id
end
