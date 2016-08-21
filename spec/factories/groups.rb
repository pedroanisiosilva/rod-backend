FactoryGirl.define  do
	factory :group do
		name Forgery::Name.company_name
		group_alias 'RoD' 
		description Forgery('lorem_ipsum').paragraph
		locale "pt-BR"
		geolat Forgery('geo').latitude
		geolng Forgery('geo').longitude
		is_public Forgery('basic').boolean
		needs_admin_aproval Forgery('basic').boolean

	end
end