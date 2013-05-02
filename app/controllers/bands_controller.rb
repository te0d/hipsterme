class BandsController < ApplicationController
  def index
    @new_bands = Band.includes(:creator, :bumps).order("created_at DESC").limit(5)
    @hot_bands = Band.top5
    
    respond_to do |format|
      format.html
      format.json { render json: @groups }
    end
  end

  def show
    @band = Band.find(params[:id])
    @listens = @band.listens
    
    respond_to do |format|
      format.html
      format.json { render json: @groups }
    end    
  end
end
