require "spec_helper"

describe "API authentication", :type => :request do 

  it 'making a request without token ' do

  	user = create(:user)
    get '/api/v1/users'
    json = JSON.parse(response.body)
    expect(response).to be_unauthorized
  end
end