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
    session[:ratings] = Movie.all_ratings_hash if session[:ratings].nil?
    if params[:ratings].nil?
      flash.keep
      redirect_to movies_path(order: session[:order], ratings: session[:ratings])
    end
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    @selected_ratings = session[:ratings].keys
    session[:order] = params[:order] unless params[:order].nil?
    @movies = Movie.where(rating: @selected_ratings)
    @movies = @movies.order(session[:order]) unless session[:order].nil?
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
