require 'rails_helper'

RSpec.describe ProgressController, type: :controller do
  describe "GET #show" do
    let(:user) { FactoryBot.create(:user) }
    before do
      sign_in user
      File.write(Rails.root.join('OtherThings/TODO.txt'), "Sample content for testing")
      get :show
    end

    after do
      File.delete(Rails.root.join('OtherThings/TODO.txt'))
    end

    it "responds successfully" do
      expect(response).to be_successful
    end

    it "reads the content of TODO.txt" do
      expect(assigns(:content)).to eq("Sample content for testing")
    end
  end
end
