class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   # if (params.has_key?("title"))
    #  @movies = Movie.find(:title)
    #else
    
    #if (params.has_value?("title"))
    #  @lite_title = "hilite"
    #elsif (params.has_value?("release_date"))
    #  @lite_date = "hilite"
    #end

    sort = params[:sort] || session[:sort]

    if sort == 'title'
      ordering, @lite_title = {:order => :title}, 'hilite'
    elsif sort == 'release_date'
      ordering, @lite_date = {:order => :release_date}, 'hilite'
    end

    @selected_ratings = params[:ratings] || session[:ratings] || {}
    @all_ratings = Movie.all_ratings

    if params[:sort] != session[:sort]
      session[:sort] = sort
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    #@movies = Movie.order(params[:sort]).all
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
