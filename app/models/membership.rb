class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	enum member_type: [:member, :admin, :staff]
end
