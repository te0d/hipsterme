class FriendsController < ApplicationController
  def index
    @friendships = current_user.friends
    @friends = @friendships.map {|ship| User.find(ship.friend_id)}
  end
  
  def create
    @friend_name = params[:friend_name]
  end
end
