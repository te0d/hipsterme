class BandController < ApplicationController
  def index
    @new_bands = Band.includes(:creator, :bumps).order("created_at DESC").limit(5)
    @hot_bands = Band.top5
  end

  def show
    @band = Band.find(params[:id])
    @listens = @band.listens
  end
end
