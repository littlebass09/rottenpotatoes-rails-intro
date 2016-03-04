class MoviesController < ApplicationController

  attr_reader :all_ratings

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.GetRatings
    
    if params[:ratings] != [] and params[:ratings] != nil
      @ratingsSelected = params[:ratings].keys
      session[:ratings_selected] = @ratingsSelected
    end
    
    if session[:ratings_selected]
      @movies = Movie.where(rating: session[:ratings_selected])
    else
      @movies = Movie.all
    end
    
    if params[:sort]
      @movies = @movies.order(params[:sort])
    end
    
    if params[:sort] == "title"
      @title_header = :hilite
    end
    
    if params[:sort] == "release_date"
      @release_date_header = :hilite
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
