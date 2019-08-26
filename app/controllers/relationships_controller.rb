class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user_follow, only: :create
  before_action :load_relationship, only: :destroy
  after_action :respond

  def create
    current_user.follow(user)
  end

  def destroy
    current_user.unfollow(relationship).followed
  end

  private
  def load_user_follow
    user = User.find_by id: params[:followed_id]
    return if user
    flash[:danger] = t ".notfound_follower"
    render :no_user
  end

  def load_relationship
    relationship = Relationship.find_by id: params[:id]
    return if relationship
    flash[:danger] = t ".notfound_relationship"
    render :no_user
  end

  def respond
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end
