require 'open-uri'
require 'tempfile'
require 'faraday'

class PinterestMondayWorker
	include Sidekiq::Worker

	def perform

		access_token	= "ASRqfnHGiAMTmKJCdZy-xLMc_jDSFGiACpOBeYhDTiUfimBBrAAAAAA"
		end_point 		= "https://api.pinterest.com/v1/"
		bord_id			= "850336042081846756"
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

		pin 		= random_object_array(pins_array)
		pin_image 	= pin["image"]["original"]["url"]
		name 		= (0...8).map { (65 + rand(26)).chr }.join
		extension 	= File.extname(pin_image) 
		tempfile 	= Tempfile.new([name, extension])
		tempfile.binmode

		tempfile.write open(pin_image).read
		tempfile.rewind
		comunicator.send_image(Faraday::UploadIO.new(tempfile, 'octet/stream'))
		tempfile.close
	end

	def comunicator
    	@comunicator ||= Comunicator::RodTelegram.new
    end

	def random_object_array(array)
		array[Random.rand(0..array.size-1)]
	end

end


