class PhonesController < ApplicationController
  # GET /phones
  # GET /phones.xml
  def index
    @phones = Phone.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @phones }
    end
  end

  # GET /phones/1
  # GET /phones/1.xml
  def show
    @phone = Phone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @phone }
    end
  end

  # GET /phones/new
  # GET /phones/new.xml
  def new
    @phone = Phone.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @phone }
    end
  end

  # POST /phones
  # POST /phones.xml
  def create
    @phone = Phone.new(params[:Phone])      
    respond_to do |format|
      if @phone.save
        flash[:notice] = 'Phone was successfully created.'
        format.html { redirect_to(@phone) }
        format.xml  { render :xml => @phone, :status => :created, :location => @phone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @phone.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /phones/1/edit
  def edit
    @phone = Phone.find(params[:id])
  end

  # POST /phones
  # POST /phones.xml
  def update
    @phone = Phone.new(params[:Phone])      
    respond_to do |format|
      if @phone.save
        flash[:notice] = 'Phone was successfully updated.'
        format.html { redirect_to("/phones") }
        format.xml  { render :xml => @phone, :status => :created, :location => @phone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @phone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /phones/1
  # DELETE /phones/1.xml
  def destroy
    @phone = Phone.find(params[:id])
    @phone.destroy

    respond_to do |format|
      format.html { redirect_to(phones_url) }
      format.xml  { head :ok }
    end
  end
end
