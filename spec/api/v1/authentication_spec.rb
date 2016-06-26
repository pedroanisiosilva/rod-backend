require "spec_helper"

describe "API authentication" , :type => :api do

  let!(:user) { FactoryGirl.create(:user, :email=>"73730@uol.com.br") }

  it "making a request without cookie token " do
    visit "/api/v1/runs/1",:formate =>:json
    last_response.status.should eql(401)
    error = {:error=>'You need to sign in or sign up before continuing.'}
    last_response.body.should  eql(error.to_json)
  end

end 