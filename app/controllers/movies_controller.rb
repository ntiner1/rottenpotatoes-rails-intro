class MoviesController < ApplicationController
  

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    unless params[:ratings].present? && params[:sortMovies].present?
      ratings = params[:ratings].present? ? params[:ratings] : (session[:ratings].present? ? session[:ratings] : @all_ratings)
      sortMovies = params[:sortMovies].present? ? params[:sortMovies] : (session[:sortMovies].present? ? session[:sortMovies] : "none")
      redirect_to action: "index", params: { ratings: ratings, sortMovies: sortMovies } and return
    end
    session[:ratings] = params[:ratings]
    @ratings = params[:ratings]
    sortMovies = params[:sortMovies]
    if sortMovies == "Title"
      @movies = Movie.where({ rating: @ratings.keys }).order(:title)
      @clicked = "Title"
      session[:sortMovies] = "Title"
    elsif sortMovies == "Release"
      @movies = Movie.where({ rating: @ratings.keys }).order(:release_date)
      @clicked = "Release"
      session[:sortMovies] = "Release"
    else
      @movies = Movie.where({ rating: @ratings.keys })
    end
    @movies
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
