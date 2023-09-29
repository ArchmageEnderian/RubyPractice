require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#show' do
    let(:user) { FactoryBot.create(:user) }

    subject { get :show, params: { id: user.id } }

    context 'when user not logged in' do
      it 'should be redirected to sign-in form', :aggregate_failures do
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before { sign_in user }

      it 'should return 200', :aggregate_failures do
        subject
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end

    end
  end

  describe '#update' do
    let(:user) { FactoryBot.create(:user) }
    let(:new_email) { FFaker::Internet.email }

    before { sign_in user }

    context 'with valid attributes' do
      it 'updates the user profile' do
        patch :update, params: { id: user.id, user: { email: new_email } }
        user.reload
        expect(user.email).to eq(new_email)
      end

      it 'redirects to the user profile' do
        patch :update, params: { id: user.id, user: { email: new_email } }
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'with invalid attributes' do
      let(:invalid_email) { "invalid" }

      it 'does not update the user profile' do
        patch :update, params: { id: user.id, user: { email: invalid_email } }
        user.reload
        expect(user.email).not_to eq(invalid_email)
      end

      it 're-renders the edit template' do
        patch :update, params: { id: user.id, user: { email: invalid_email } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'profile' do
    let(:user) { FactoryBot.create(:user) }
    before { sign_in user }
    context 'when user logged in' do


      it 'renders the profile view' do
        get :profile
        expect(response).to render_template(:show)
      end

      it 'returns a successful response' do
        get :profile
        expect(response).to have_http_status(:success)
      end


    end

  end

  describe '#follow' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    before { sign_in user }

    it 'allows the current user to follow another user' do
      post :follow, params: { id: other_user.id }
      expect(user.following?(other_user)).to be_truthy
    end


    it 'shows a success notice' do
      post :follow, params: { id: other_user.id }
      expect(flash[:notice]).to eq('Вы успешно подписались!')
    end
  end

  describe '#unfollow' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    before { sign_in user }

    before do
      user.follow(other_user)
    end

    it 'allows the current user to unfollow another user' do
      delete :unfollow, params: { id: other_user.id }
      expect(user.following?(other_user)).to be_falsey
    end

    it 'shows a success notice' do
      delete :unfollow, params: { id: other_user.id }
      expect(flash[:notice]).to eq('Вы отписались.')
    end
  end

  describe 'GET #followers' do
    let(:user) { create(:user) }
    let(:follower1) { create(:user) }
    let(:follower2) { create(:user) }

    before do
      sign_in user
      follower1.follow(user)
      follower2.follow(user)
      get :followers, params: { id: user.id }
    end

    it "assigns @followers" do
      get :followers, params: { id: user.id }
      fail "Response status: #{response.status}, body: #{response.body}" unless response.successful?
      expect(assigns(:followers)).to include(follower1, follower2)
    end


    it 'renders the followers template' do
      expect(response).to render_template(:followers)
    end
  end

  describe 'GET #followings' do
    let(:user) { create(:user) }
    let(:following1) { create(:user) }
    let(:following2) { create(:user) }

    before do
      sign_in user
      user.follow(following1)
      user.follow(following2)
      get :followings, params: { id: user.id }
    end

    it 'assigns @followings' do
      expect(assigns(:followings)).to match_array([following1, following2])
    end

    it 'renders the followings template' do
      expect(response).to render_template(:followings)
    end
  end

  describe 'GET #searchPage' do
    let!(:user1) { create(:user, username: 'john_doe') }
    let!(:user2) { create(:user, username: 'jane_doe') }
    let!(:user3) { create(:user, username: 'alice') }

    context 'when search parameter is not provided' do
      before do
        sign_in user3
        get :searchPage
      end

      it 'assigns an empty array to @users' do
        expect(assigns(:users)).to eq([])
      end
    end

    context 'when search parameter is provided' do

      before do
        sign_in user3
        get :searchPage, params: { search: 'john' }
      end

      it 'assigns the correct users to @users' do
        expect(assigns(:users)).to include(user1)
        expect(assigns(:users)).not_to include(user2, user3)
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { FactoryBot.create(:user) }

    context 'when user is logged in' do
      before do
        sign_in user
        get :edit, params: { id: user.id }
      end

      it 'responds successfully' do
        expect(response).to be_successful
      end

      it 'assigns the current user to @user' do
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'when user is not logged in' do
      before { get :edit, params: { id: user.id } }

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end