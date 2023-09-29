require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:story) { create(:story, user: user) }

  describe 'GET #index' do
    context 'when user is logged in' do
      before do
        sign_in user
        get :index
      end

      it 'responds successfully' do
        expect(response).to be_successful
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not logged in' do
      before { get :index }

      it 'responds successfully' do
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #new' do
    context 'when user is logged in' do
      before do
        sign_in user
        get :new
      end

      it 'responds successfully' do
        expect(response).to be_successful
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'when user is not logged in' do
      before { get :new }

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is logged in' do
      before { sign_in user }

      context 'with valid attributes' do
        let(:valid_attributes) { attributes_for(:story) }

        it 'creates a new story' do
          expect {
            post :create, params: { story: valid_attributes }
          }.to change(Story, :count).by(1)
        end

        it 'redirects to the stories index' do
          post :create, params: { story: valid_attributes }
          expect(response).to redirect_to(stories_path)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_attributes) { { description: '', image: '' } }

        it 'does not create a new story' do
          expect {
            post :create, params: { story: invalid_attributes }
          }.not_to change(Story, :count)
        end

        it 'renders the new template' do
          post :create, params: { story: invalid_attributes }
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the sign-in page' do
        post :create, params: { story: attributes_for(:story) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: story.id } }

    it 'responds successfully' do
      expect(response).to be_successful
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      before { sign_in user }

      it 'deletes the story' do
        story
        expect {
          delete :destroy, params: { id: story.id }
        }.to change(Story, :count).by(-1)
      end

      it 'redirects to the stories index' do
        delete :destroy, params: { id: story.id }
        expect(response).to redirect_to(stories_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: story.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
