class KeyvaluesController < ApplicationController
  def index
    @ping = Ping.find(params[:ping_id])
    @keyvalues = @ping.keyvalues
  end

  def show
    @ping = Ping.find(params[:ping_id])
    @keyvalue = @ping.keyvalues.find(params[:id])
  end

  def new
    @ping = Ping.find(params[:ping_id])
    @keyvalue = @ping.keyvalues.build
  end

  def create
    @ping = Ping.find(params[:ping_id])
    @keyvalue = @ping.keyvalues.build(params[:keyvalue])
    if @keyvalue.save
      redirect_to ping_keyvalues_url
    else
      render :action => "new"
    end
  end
  
  def edit
    @ping = Ping.find(params[:ping_id])
    @keyvalue = @ping.keyvalues.find(params[:id])
  end

  def update
    @ping = Ping.find(params[:ping_id])
    @keyvalue = @ping.keyvalues.find(params[:id])
    if @keyvalue.update_attributes(params[:keyvalue])
      redirect_to ping_keyvalues_url
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @ping = Ping.find(params[:ping_id])
    @keyvalue = @ping.keyvalues.find(params[:id])
    @keyvalue.destroy
    redirect_to ping_keyvalues_url
  end
end
