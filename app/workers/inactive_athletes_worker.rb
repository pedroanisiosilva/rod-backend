require 'open-uri'
require 'tempfile'
require 'faraday'

class InactiveAthletesWorker
	include Sidekiq::Worker
  
	def perform

		access_token	= "ASRqfnHGiAMTmKJCdZy-xLMc_jDSFGiACpOBeYhDTiUfimBBrAAAAAA"
		end_point 		= "https://api.pinterest.com/v1/"
		bord_id			= "850336042081847522"
		cursor			= ""
		fields			= %{id%2Clink%2Cnote%2Curl%2Cimage}
		url 			= %{#{end_point}boards/#{bord_id}/pins/?cursor=#{cursor}&access_token=#{access_token}&fields=#{fields}}
		json 			= JSON.load(open(url))
		pins_array 		= json['data']

		while json['page']['next'] != nil do
			json = JSON.load(open(json['page']['next']))
			pins_array.concat json['data']
		end

		OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
		OpenURI::Buffer.const_set 'StringMax', 0


		@groups = Group.all.reject{|g|g.nil?}
		@groups.each do |group|

			## generate random file
			pin 		= random_object_array(pins_array)
			pin_image 	= pin["image"]["original"]["url"]
			name 		= (0...8).map { (65 + rand(26)).chr }.join
			extension 	= File.extname(pin_image) 
			tempfile 	= Tempfile.new([name, extension])
			tempfile.binmode
			tempfile.write open(pin_image).read
			tempfile.rewind
			##

			@begin_date = 2.week.ago
			@group_users_id = Membership.select(:user_id).where(:group_id => group.id)
			@active	= User.where(:id => @group_users_id).joins(:runs).where("datetime > ? and user_id IS NOT NULL", @begin_date).distinct
			@inactive = User.where('id NOT IN (?) and status = 0 and created_at < ? and id IN (?)',@active.map {|m| m.id},@begin_date,@group_users_id)
			@inactive = @inactive.map {|m| [m.name,m.runs.size]}.reject { |e|  e[1] == 0}
			@msg 				= ""

			build_inactive_call
			comunicator.send_image(Faraday::UploadIO.new(tempfile, 'octet/stream'),group.telegram_id)
			comunicator.send_text_only(@msg,group.telegram_id)

			tempfile.close			
		end


	end

	def build_inactive_call
		atlhetes_names = @inactive.map {|m| short_name(m[0])}.join(", ")
		@msg = %{⚠️ Grupo, não vamos deixar os nossos amigo(a)s #{atlhetes_names} desanimarem. Padrinhos, Madrinhas e amigos, mandem boas energias para eles💓 ! vamos incentivá-los a correr🏃🏃! ⚠️}

	end

	def comunicator
    	@comunicator ||= Comunicator::RodTelegram.new
    end

	def short_name(full_name)
		%{#{full_name.split(" ")[0]} #{full_name.split(" ")[-1]}}
	end 

	def random_object_array(array)
		array[Random.rand(0..array.size-1)]
	end	
end


