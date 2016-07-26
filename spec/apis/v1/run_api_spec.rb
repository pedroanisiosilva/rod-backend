require "rails_helper"

describe Api::V1::RunsController do

  describe "DELETE #destroy" do
    before(:each) do
      first_run = create(:run, :distance =>'10',:duration=>'3600')
      delete :destroy, { id: first_run.id }, format: :json
    end

    it { should respond_with 204 }

  end

  # describe "DELETE #destroy" do
  #   before(:each) do
  #     @user = FactoryGirl.create :user
  #     delete :destroy, { id: @user.id }, format: :json
  #   end

  #   it { should respond_with 204 }
  # end  

  #   before(:each) do
		# user = create(:user, :name => "Pedro")
		# login_as user, :scope => :user	
		# first_run = create(:run, :distance =>'10',:duration=>'3600')
  #       second_run = create(:run, :distance =>'11',:duration=>'3700')
  #       # page.execute_script(%{$.ajax({type:'DELETE',url:'/api/v1/runs/#{first.id}'})})
  #       #delete :destroy, { id: first_run.id }, format: :json
  #   end

  #   it 'should return status 200' do
  #       expect { delete :destroy, :id => first_run.id }.should change(Run, :count)
  #   end

  #   it 'should delete the run' do
  #       expect(Run.all).to eq second_run
  #   end
end
