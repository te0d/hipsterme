class BandController < ApplicationController
  def index
    @new_bumps = Band.order("created_at DESC")[0...5]
  end

  def show
    @band = Band.find(params[:id])
  end
end
