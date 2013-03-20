class WelcomeController < ApplicationController
  def index
    @new_bumps = Band.order("created_at DESC")[0...5]
  end
end
