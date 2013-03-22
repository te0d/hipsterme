class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @user = current_user
  end
  
  def show
    @user = current_user
    @other_user = User.includes(:bands).find(params[:id])
    @is_friend = current_user.friends.where(:friend_id => @other_user.id).exists? || current_user.id == @other_user.id
  end
  
  def add_friend
    other_user = User.find(params[:id])
    friend = Friend.new(:friend_id => other_user.id)
    current_user.friends.push(friend)
    
    redirect_to user_page_url
  end
  
  def del_friend
    friend = Friend.find(params[:id])
    current_user.friends.delete(friend)
    
    redirect_to user_page_url
  end
end
