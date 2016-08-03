require 'open-uri'


class ImagesController < ApplicationController

	def index
		@kit = IMGKit.new('http://localhost:3000/week_status/31/red',:quality => 100)
		
		send_data(@kit.to_png, :type => "image/png", :disposition => 'inline')

		# url = URI.parse('http://localhost:3000/week_status/31')
		# open(url) do |http|
		#   response = http.read
		#   puts "response: #{response.inspect}"
		# end

	end
end