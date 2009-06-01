class StreamsController < ApplicationController
  # GET /streams
  # GET /streams.xml
  def index
    @streams = Stream.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @streams }
    end
  end

  # GET /streams/1
  # GET /streams/1.xml
  def show
    @stream = Stream.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stream }
    end
  end

  # GET /streams/new
  # GET /streams/new.xml
  def new
    @stream = Stream.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stream }
    end
  end

  # GET /streams/1/edit
  def edit
    @stream = Stream.find(params[:id])
  end

  # POST /streams
  # POST /streams.xml
  def create
    @stream = Stream.new(params[:stream])

    respond_to do |format|
      if @stream.save
        flash[:notice] = 'Stream was successfully created.'
        format.html { redirect_to(@stream) }
        format.xml  { render :xml => @stream, :status => :created, :location => @stream }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stream.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /streams/1
  # PUT /streams/1.xml
  def update
    @stream = Stream.find(params[:id])

    respond_to do |format|
      if @stream.update_attributes(params[:stream])
        flash[:notice] = 'Stream was successfully updated.'
        format.html { redirect_to(@stream) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stream.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /streams/1
  # DELETE /streams/1.xml
  def destroy
    @stream = Stream.find(params[:id])
    @stream.destroy

    respond_to do |format|
      format.html { redirect_to(streams_url) }
      format.xml  { head :ok }
    end
  end
end
