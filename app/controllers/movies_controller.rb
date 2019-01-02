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
    session[:ratings] = @all_ratings unless session[:ratings]
    session[:ratings] = params[:ratings].present? ? params[:ratings].keys : session[:ratings]
    sort = params[:sortMovies].present? ? params[:sortMovies] : session[:sort]
    if sort == "Title"
      @movies = Movie.order(:title)
      @movies = @movies.where({ rating: session[:ratings] })
      @clicked = "Title"
      session[:sort] = "Title"
    elsif sort == "Release"
      @movies = Movie.order(:release_date)
      @movies = @movies.where({ rating: session[:ratings] })
      @clicked = "Release"
      session[:sort] = "Release"
    else
      @movies = Movie.where({ rating: session[:ratings] })
      session.delete(:sort)
    end
    return @movies
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
