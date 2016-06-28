require "spec_helper"

describe "API authentication", :type => :request do 

  it 'making a request without token' do

    get '/api/v1/users', nil, {'HTTP_ACCEPT' => "application/json"}
    expect(response).to have_http_status(401)
  end

  it 'making a request with user authenticated' do

  	u = create(:user, :email=> "pedroanisio@me.com", :password=>"teste1234")

	request_params = {:email => u.email, :password => "teste1234"}
	post "/api/v1/sessions", request_params
	expect(response).to have_http_status(200)

    get '/api/v1/users', nil, {'HTTP_ACCEPT' => "application/json", "X-User-Email" => u.email, "X-User-Token" => u.authentication_token}
    expect(response).to have_http_status(200)
  end

end