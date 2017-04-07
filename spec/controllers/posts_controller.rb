require 'rails_helper'

describe PostsController do

  describe 'GET index' do
    let!(:user) { create :user_with_posts }
    let!(:user2) { create :user_with_posts }

    context 'when user_id is passed' do
      before { get :index, params: { user_id: user.id } }

      it 'shows only user posts' do
        expect(assigns(:posts)).not_to be_nil
        assigns[:posts].map(&:user_id).uniq.should == [user.id]
        assigns[:posts].count.should <= 5
        expect(response).to render_template :index
      end
    end

    context 'when user_id is not passed' do
      before { get :index }

      it 'shows all posts' do
        expect(assigns(:posts)).not_to be_nil
        assigns[:posts].count.should <= 5
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET by_tag' do
    let!(:post) { create :post, tags_list: "test" }

    before { get :by_tag, params: { tag: "test" } }

    it 'shows posts only with tag test' do
      expect(assigns(:posts)).not_to be_nil
      assigns[:posts].count.should == 1
      assigns[:posts].should == [post]
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET show' do
    let!(:post) { create :post }

    let!(:comment1) { create :comment, post: post, state: "created" }
    let!(:comment2) { create :comment, post: post, state: "verified" }
    let!(:comment3) { create :comment, post: post, state: "locked" }

    before { get :show, params: { id: post.id } }

    it 'should load post' do
      assigns[:post].should == post
    end

    context 'when user is not authorized' do
      let!(:user) { nil }
      before { allow(subject).to receive(:current_user).and_return(user) }

      it 'should load only verified comments' do
        assigns[:comments].should == [comment2]
      end
    end

    context 'when user with user role' do
      let!(:user) { create :user, role: "user" }
      before { allow(subject).to receive(:current_user).and_return(user) }

      it 'should load only verified comments' do
        assigns[:comments].should == [comment2]
      end
    end

    context 'when user with moderator role' do
      let!(:user) { create :user, role: "moderator" }
      before { allow(subject).to receive(:current_user).and_return(user) }

      it 'should load only verified comments' do
        assigns[:comments].count == 3
      end
    end

    context 'when user whith admin role' do
      let!(:user) { create :user, role: "admin" }
      before { allow(subject).to receive(:current_user).and_return(user) }

      it 'should load only verified comments' do
        assigns[:comments].count == 3
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:user) { create :user }
    let!(:another_user) { create :user }
    let!(:admin_user) { create :user, role: "admin" }
    let!(:moderator_user) { create :user, role: "moderator" }
    let!(:post) { create :post, user: user }


    context 'when user is not authorized' do
      before { allow(subject).to receive(:current_user).and_return(nil) }

      it 'should redirect to home page' do
        allow(Post).to receive(:find).and_return post
        expect(post).not_to receive(:destroy)
        delete :destroy, params: { id: post.id }
        response.should redirect_to(root_path)
      end
    end

    context 'when user authorized' do
      context 'and it is not a user\'s post' do
        before { allow(subject).to receive(:current_user).and_return(another_user) }

        it 'should redirect to home page' do
          allow(Post).to receive(:find).and_return post
          expect(post).not_to receive(:destroy)
          delete :destroy, params: { id: post.id }
          response.should redirect_to(root_path)
        end
      end

      context 'and it is a user\'s post' do
        before { allow(subject).to receive(:current_user).and_return(user) }

        it 'should delete post' do
          expect(Post).to receive(:find).and_return post
          expect(post).to receive(:destroy).and_return true
          delete :destroy, params: { id: post.id }
          response.should redirect_to(root_path)
        end
      end

      context 'and user has moderator role' do
        before { allow(subject).to receive(:current_user).and_return(moderator_user) }

        it 'should redirect to home page' do
          allow(Post).to receive(:find).and_return post
          expect(post).not_to receive(:destroy)
          delete :destroy, params: { id: post.id }
          response.should redirect_to(root_path)
        end
      end

      context 'and user has admin role' do
        before { allow(subject).to receive(:current_user).and_return(admin_user) }

        it 'should delete post' do
          expect(Post).to receive(:find).and_return post
          expect(post).to receive(:destroy).and_return true
          delete :destroy, params: { id: post.id }
          response.should redirect_to(root_path)
        end
      end
    end
  end

  describe 'GET edit' do
    let!(:user) { create :user }
    let!(:another_user) { create :user }
    let!(:admin_user) { create :user, role: "admin" }
    let!(:moderator_user) { create :user, role: "moderator" }
    let!(:post) { create :post, user: user }


    context 'when user is not authorized' do
      before { allow(subject).to receive(:current_user).and_return(nil) }

      it 'should redirect to home page' do
        allow(Post).to receive(:find).and_return post
        get :edit, params: { id: post.id }
        response.should redirect_to(root_path)
      end
    end

    context 'when user authorized' do
      context 'and it is not a user\'s post' do
        before { allow(subject).to receive(:current_user).and_return(another_user) }

        it 'should redirect to home page' do
          allow(Post).to receive(:find).and_return post
          get :edit, params: { id: post.id }
          response.should redirect_to(root_path)
        end
      end

      context 'and it is a user\'s post' do
        before { allow(subject).to receive(:current_user).and_return(user) }

        it 'should update post' do
          expect(Post).to receive(:find).and_return post
          get :edit, params: { id: post.id }
          expect(response).to render_template :edit
        end
      end

      context 'and user has moderator role' do
        before { allow(subject).to receive(:current_user).and_return(moderator_user) }

        it 'should redirect to home page' do
          allow(Post).to receive(:find).and_return post
          get :edit, params: { id: post.id }
          response.should redirect_to(root_path)
        end
      end

      context 'and user has admin role' do
        before { allow(subject).to receive(:current_user).and_return(admin_user) }

        it 'should update post' do
          expect(Post).to receive(:find).and_return post
          get :edit, params: { id: post.id }
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'PUT update' do
    let!(:user) { create :user }
    let!(:another_user) { create :user }
    let!(:admin_user) { create :user, role: "admin" }
    let!(:moderator_user) { create :user, role: "moderator" }
    let!(:post) { create :post, user: user }


    context 'when user is not authorized' do
      before { allow(subject).to receive(:current_user).and_return(nil) }

      it 'should redirect to home page' do
        allow(Post).to receive(:find).and_return post
        expect(post).not_to receive(:update)
        put :update, params: { id: post.id, post: { tags_list: "another,one" } }
        response.should redirect_to(root_path)
      end
    end

    context 'when user authorized' do
      context 'and it is not a user\'s post' do
        before { allow(subject).to receive(:current_user).and_return(another_user) }

        it 'should redirect to home page' do
          allow(Post).to receive(:find).and_return post
          expect(post).not_to receive(:update)
          put :update, params: { id: post.id, post: { tags_list: "another,one" } }
          response.should redirect_to(root_path)
        end
      end

      context 'and it is a user\'s post' do
        before { allow(subject).to receive(:current_user).and_return(user) }

        it 'should update post' do
          expect(Post).to receive(:find).and_return post
          expect(post).to receive(:update).and_return true
          put :update, params: { id: post.id, post: { tags_list: "another,one" } }
          response.should redirect_to(post_path(post))
        end
      end

      context 'and user has moderator role' do
        before { allow(subject).to receive(:current_user).and_return(moderator_user) }

        it 'should redirect to home page' do
          allow(Post).to receive(:find).and_return post
          expect(post).not_to receive(:update)
          put :update, params: { id: post.id, post: { tags_list: "another,one" } }
          response.should redirect_to(root_path)
        end
      end

      context 'and user has admin role' do
        before { allow(subject).to receive(:current_user).and_return(admin_user) }

        it 'should update post' do
          expect(Post).to receive(:find).and_return post
          expect(post).to receive(:update).and_return true
          put :update, params: { id: post.id, post: { tags_list: "another,one" } }
          response.should redirect_to(post_path(post))
        end
      end
    end
  end

  describe 'GET new' do
    let!(:user) { create :user }

    context 'when user authorized' do
      before { allow(subject).to receive(:current_user).and_return(user) }

      it 'should render new post form' do
        get :new
        expect(response).to render_template :new
      end
    end

    context 'when user is not authorized' do
      before { allow(subject).to receive(:current_user).and_return(nil) }

      it 'should render new post form' do
        get :new
        response.should redirect_to(root_path)
      end
    end
  end

end
