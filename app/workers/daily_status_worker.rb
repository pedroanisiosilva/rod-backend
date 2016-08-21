require 'open-uri'
require 'tempfile'
require 'faraday'

class DailyStatusWorker
	include Sidekiq::Worker
  
	def perform

		@groups = Group.all.reject{|g|g.nil?}
		@groups.each do |group|
			pin_image = ""

			if Rails.env.development?
				pin_image 	= "http://localhost:3000/week_status/#{group.id}/image.png"
			else
				pin_image 	= "https://app.runordie.run/week_status/#{group.id}/image.png"
			end

			name 		= (0...8).map { (65 + rand(26)).chr }.join
			extension 	= File.extname(pin_image) 
			tempfile 	= Tempfile.new([name, extension])
			tempfile.binmode

			tempfile.write open(pin_image).read
			tempfile.rewind

			msg = %{Fechamento do dia: #{60.minutes.ago.strftime("%d-%b-%Y")}}

			comunicator.send_image_with_caption(Faraday::UploadIO.new(tempfile, 'octet/stream'),msg,group.telegram_id)
			tempfile.close
		end
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


