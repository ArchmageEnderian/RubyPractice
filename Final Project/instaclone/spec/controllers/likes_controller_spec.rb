require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:created_post) { FactoryBot.create(:post, user: user) } # Используем имя переменной created_post

  before do
    sign_in user
  end

  # ... [пропущен начальный код]

  describe "POST #create" do
    context "when user is logged in" do
      context "when user has not liked the post" do
        # ... [пропущен код этого контекста]
      end

      context "when user has already liked the post" do
        before do
          FactoryBot.create(:like, user: user, post: created_post)
        end

        it "does not create a new like" do
          expect {
            post :create, params: { post_id: created_post.id }
          }.not_to change(Like, :count)
        end

      end
    end
  end

  describe "DELETE #destroy" do
    context "when user has liked the post" do
      let!(:like) { FactoryBot.create(:like, user: user, post: created_post) }

      it "deletes the like" do
        expect {
          delete :destroy, params: { post_id: created_post.id, id: like.id }
        }.to change(Like, :count).by(-1)
      end

      it "redirects to the post" do
        delete :destroy, params: { post_id: created_post.id, id: like.id }
        expect(response).to redirect_to(post_path(created_post))
      end
    end

    context "when user has not liked the post" do
      let!(:other_like) { FactoryBot.create(:like, user: other_user, post: created_post) }

      it "does not delete any likes" do
        expect {
          delete :destroy, params: { post_id: created_post.id, id: other_like.id }
        }.not_to change(Like, :count)
      end

      it "redirects to the post with a notice" do
        delete :destroy, params: { post_id: created_post.id, id: other_like.id }
        expect(response).to redirect_to(post_path(created_post))
        expect(flash[:notice]).to eq('Нельзя разлайкать')
      end
    end

  end

end
