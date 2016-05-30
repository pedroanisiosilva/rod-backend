class User < ActiveRecord::Base
	has_many :runs
	validates_presence_of :email
end
