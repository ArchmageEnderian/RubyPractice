require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:created_post) { FactoryBot.create(:post, user: user) } # Изменено имя переменной
  let(:valid_attributes) {
    {
      image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample_image.jpg'), 'image/jpg'),
      description: 'Sample description'
    }
  }

  let(:invalid_attributes) { { image: '', description: '' } }

  describe 'GET #index' do
    context 'when user is not logged in' do
      before { get :index }

      it 'responds successfully' do
        expect(response).to be_successful
      end

      it 'assigns an empty array to @posts' do
        expect(assigns(:posts)).to eq([])
      end
    end

    context 'when user is logged in' do
      before do
        sign_in user
        get :index
      end

      it 'responds successfully' do
        expect(response).to be_successful
      end

      # Add more tests to check the posts of the users the current user is following
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
    end

    context 'when user is not logged in' do
      before { get :new }

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when user is logged in" do
      before do
        sign_in user
      end

      context "with valid attributes" do
        it "creates a new post" do
          expect {
            post :create, params: { post: valid_attributes }
          }.to change(Post, :count).by(1)
        end

        it "redirects to the new post" do
          post :create, params: { post: valid_attributes }
          expect(response).to redirect_to(Post.last)
        end
      end

    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        post :create, params: { post: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is logged in" do
      before do
        sign_in user
      end

      context "when user is the owner of the post" do
        it "deletes the post" do
          expect {
            request.env["HTTP_REFERER"] = posts_path
            delete :destroy, params: { id: created_post.id }
          }.to change(Post, :count).by(-1)
        end

        it "redirects to the posts path if referer is the post's show page" do
          request.env["HTTP_REFERER"] = post_url(created_post)
          delete :destroy, params: { id: created_post.id }
          expect(response).to redirect_to(posts_path)
        end

        it "redirects to the referer if it's not the post's show page" do
          request.env["HTTP_REFERER"] = root_url
          delete :destroy, params: { id: created_post.id }
          expect(response).to redirect_to(root_url)
        end
      end

      context "when user is not the owner of the post" do
        before do
          sign_in other_user
        end

        it "does not delete the post" do
          expect {
            delete :destroy, params: { id: created_post.id }
          }.not_to change(Post, :count)
        end

        it "redirects to the posts path with an alert" do
          delete :destroy, params: { id: created_post.id }
          expect(response).to redirect_to(posts_path)
          expect(flash[:alert]).to eq('Вы не можете удалить этот пост.')
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        delete :destroy, params: { id: created_post.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when user is logged in" do
      before do
        sign_in user
      end

      context "with valid attributes" do
        let(:new_attributes) { { description: 'Updated description' } }

        it "updates the post" do
          patch :update, params: { id: created_post.id, post: new_attributes }
          created_post.reload
          expect(created_post.description).to eq('Updated description')
        end

        it "redirects to the post" do
          patch :update, params: { id: created_post.id, post: new_attributes }
          expect(response).to redirect_to(created_post)
        end
      end

      context "with invalid attributes" do
        let(:invalid_attributes) { { description: '' } }

        it "does not update the post" do
          patch :update, params: { id: created_post.id, post: invalid_attributes }
          created_post.reload
          expect(created_post.description).not_to eq('')
        end

        it "renders the edit template" do
          patch :update, params: { id: created_post.id, post: invalid_attributes }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        patch :update, params: { id: created_post.id, post: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


end
