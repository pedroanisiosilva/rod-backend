require 'pp'
require 'json'

describe "Run API", :type=> :request do
  it 'sends a list of runs' do

    user = create(:user)
    10.times do
      create(:run, :user=>user)
    end
    login_as user, :scope => :user
    get %{/api/v1/users/#{user.id}}

    json = JSON.parse(response.body)

    # test for the 200 status-code
    expect(response).to be_success

    #check to make sure the right amount of messages are returned
    expect(json['runs'].length).to eq(10)
  end

  it 'create a run via api' do

    user = create(:user)
    login_as user, :scope => :user
    runs = {:distance => "21.2", :duration =>2*60*60, :user=>user, :datetime => Time.now.in_time_zone.iso8601 }

    post %{/api/v1/users/#{user.id}/runs}, runs

    json = JSON.parse(response.body)

    # test for the 200 status-code
    expect(response).to be_success
    expect(json['duration']).to eq(2*60*60)

    #check to make sure the right amount of messages are returned
  end

  it 'create a run via api with notes and accent' do

    user = create(:user)
    login_as user, :scope => :user
    runs = {:distance => "21.2", :duration =>2*60*60, :user=>user, :datetime => Time.now.in_time_zone.iso8601, :note => "rápida"}

    post %{/api/v1/users/#{user.id}/runs}, runs

    json = JSON.parse(response.body)

    # test for the 200 status-code
    expect(response).to be_success
    expect(json['duration']).to eq(2*60*60)

    #check to make sure the right amount of messages are returned
  end  

  it 'create a run via api with a image' do

    user = create(:user)
    login_as user, :scope => :user
    runs = {:distance => "21.2", :duration =>2*60*60, :user=>user, :datetime => Time.now.in_time_zone.iso8601, %{rod_images_attributes][0][image]} => Rack::Test::UploadedFile.new(%{#{Rails.root.to_s}/spec/apis/v1/image.jpg}, "image/jpg")}

    post %{/api/v1/users/#{user.id}/runs}, runs

    json = JSON.parse(response.body)

    # test for the 200 status-code
    expect(response).to be_success
    expect(json["rod_images"][0]["image_file_name"]).to eq("image.jpg")
  end

  it 'delete a run via api' do

    user    = create(:user)
    run     = create(:run, :user=>user)
    login_as user, :scope => :user

    delete %{/api/v1/runs/#{run.id}}
    
    # test for the 204 status-code
    expect(response.code).to eq("204")
  end

  it 'update a run via api' do

    user    = create(:user)
    run     = create(:run, :user=>user)
    login_as user, :scope => :user

    runs = {:distance => "21.2", :duration =>2*60*60, :user=>user, :datetime => run.datetime }

    patch %{/api/v1/runs/#{run.id}}, runs
    
    json = JSON.parse(response.body)

    # test for the 200 status-code
    expect(response).to be_success
    expect(json['duration']).to eq(2*60*60)
  end     

end
