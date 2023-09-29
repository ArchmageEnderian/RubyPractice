require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  describe '#create' do
    let(:current_user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    before { sign_in current_user }

    it 'follows another user' do
      post :create, params: { followed_id: other_user.id }
      expect(current_user.following?(other_user)).to be_truthy
    end
  end

  describe '#destroy' do
    let(:current_user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    before do
      current_user.follow(other_user)
      sign_in current_user
    end

    it 'unfollows another user' do
      delete :destroy, params: { id: current_user.active_relationships.find_by(followed_id: other_user.id).id }
      expect(current_user.following?(other_user)).to be_falsey
    end
  end
end
