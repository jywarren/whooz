class PlacemarksController < ApplicationController
  # GET /placemarks
  # GET /placemarks.xml
  def index
    @placemarks = Placemark.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @placemarks }
    end
  end

  # GET /placemarks/1
  # GET /placemarks/1.xml
  def show
    @placemark = Placemark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @placemark }
    end
  end

  # GET /placemarks/new
  # GET /placemarks/new.xml
  def new
    @placemark = Placemark.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @placemark }
    end
  end

  # GET /placemarks/1/edit
  def edit
    @placemark = Placemark.find(params[:id])
  end

  # POST /placemarks
  # POST /placemarks.xml
  def create
    @placemark = Placemark.new(params[:placemark])

    respond_to do |format|
      if @placemark.save
        flash[:notice] = 'Placemark was successfully created.'
        format.html { redirect_to(@placemark) }
        format.xml  { render :xml => @placemark, :status => :created, :location => @placemark }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @placemark.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /placemarks/1
  # PUT /placemarks/1.xml
  def update
    @placemark = Placemark.find(params[:id])

    respond_to do |format|
      if @placemark.update_attributes(params[:placemark])
        flash[:notice] = 'Placemark was successfully updated.'
        format.html { redirect_to(@placemark) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @placemark.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /placemarks/1
  # DELETE /placemarks/1.xml
  def destroy
    @placemark = Placemark.find(params[:id])
    @placemark.destroy

    respond_to do |format|
      format.html { redirect_to(placemarks_url) }
      format.xml  { head :ok }
    end
  end
end
