class BandController < ApplicationController
  def index
    @new_bumps = Band.order("created_at DESC").limit(5)

  end

  def show
    @band = Band.find(params[:id])
  end
end
