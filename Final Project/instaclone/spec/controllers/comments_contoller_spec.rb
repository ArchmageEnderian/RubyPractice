require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:created_post) { FactoryBot.create(:post, user: user) }
  let!(:comment) { FactoryBot.create(:comment, user: user, post: created_post) }
  let(:valid_attributes) { { content: 'Sample comment' } }
  let(:invalid_attributes) { { content: '' } }

  describe "POST #create" do
    context "when user is logged in" do
      before do
        sign_in user
      end

      context "with valid attributes" do
        it "creates a new comment" do
          expect {
            post :create, params: { post_id: created_post.id, comment: valid_attributes }
          }.to change(Comment, :count).by(1)
        end

        it "redirects to the post with a notice" do
          post :create, params: { post_id: created_post.id, comment: valid_attributes }
          expect(response).to redirect_to(created_post)
          expect(flash[:notice]).to eq('Ваш комментарий был успешно добавлен.')
        end
      end

      context "with invalid attributes" do
        it "does not create a new comment" do
          expect {
            post :create, params: { post_id: created_post.id, comment: invalid_attributes }
          }.not_to change(Comment, :count)
        end


      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        post :create, params: { post_id: created_post.id, comment: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is the comment's author" do
      before do
        sign_in user
      end

      it "deletes the comment" do
        expect {
          delete :destroy, params: { id: comment.id }
        }.to change(Comment, :count).by(-1)
      end

      it "redirects to the post with a notice" do
        delete :destroy, params: { id: comment.id }
        expect(response).to redirect_to(created_post)
        expect(flash[:notice]).to eq('Комментарий успешно удален.')
      end
    end

    context "when user is the post's author but not the comment's author" do
      before do
        sign_in other_user
      end

      it "deletes the comment" do
        expect {
          delete :destroy, params: { id: comment.id }
        }.to change(Comment, :count).by(0)
      end


    end

    context "when user is neither the comment's author nor the post's author" do
      let(:third_user) { FactoryBot.create(:user) }

      before do
        sign_in third_user
      end

      it "does not delete the comment" do
        expect {
          delete :destroy, params: { id: comment.id }
        }.not_to change(Comment, :count)
      end

      it "redirects to the post with an alert" do
        delete :destroy, params: { id: comment.id }
        expect(response).to redirect_to(created_post)
        expect(flash[:alert]).to eq('Вы не можете удалить этот комментарий.')
      end
    end
  end
end
