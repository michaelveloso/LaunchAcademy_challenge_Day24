require 'sinatra'
require 'sinatra/activerecord' if development?
require 'sinatra/flash'
require 'omniauth-github'
require 'sinatra/reloader'
require 'pry'

require_relative 'config/application'

CLIENT_ID = 'b11cf333fcefc5fcdafe'
ENV['GITHUB_KEY'] = CLIENT_ID
CLIENT_SECRET = '6c0b9f5a8c1c9e17b0adac448cb9604be5bbcdbb'
ENV['GITHUB_SECRET'] = CLIENT_SECRET

set :environment, :development

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  @meetups = Meetup.all.order(:name)
  erb :index
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end

get '/meetup' do
  if session[:user_id]
    @user = User.find(session[:user_id])
  else
    @user = User.new()
  end
  @meetup = Meetup.find_by(id: params[:id])
  @comments = @meetup.comments.order(created_at: :desc)
  erb :show_meetup
end

post '/meetup/join' do
  if signed_in?
    this_user = User.find(session[:user_id])
    this_meetup = Meetup.find(params['id'])
    if not this_meetup.users.include?(this_user)
      this_meetup.users << this_user
      flash[:notice] = "Successfully joined this meetup!"
    else
      flash[:notice] = "You're already signed up for this meetup!"
    end
  else
    flash[:notice] = "You need to be signed in to join a meetup!"
  end
  redirect "/meetup?id=#{params['id']}"
end

post '/meetup/leave' do
  if signed_in?
    this_user = User.find(session[:user_id])
    this_meetup = Meetup.find(params['id'])
    if this_meetup.users.include?(this_user)
      this_meetup.users.delete(this_user)
      flash[:notice] = "Successfully left this meetup!"
    else
      flash[:notice] = "You're not a part of this meetup!"
    end
  else
    flash[:notice] = "You need to be signed in to leave a meetup!"
  end
  redirect "/meetup?id=#{params['id']}"
end

post '/meetup/add_comment' do
  if signed_in?
    this_user = User.find(session[:user_id])
    this_meetup = Meetup.find(params['id'])
    if this_meetup.users.include?(this_user)
      comment_hash = params[:comment]
      comment_hash[:title] = "Untitled comment" unless comment_hash[:title].length > 0
      comment_hash[:user] = this_user
      comment_hash[:meetup] = this_meetup
      Comment.create(comment_hash)
      flash[:notice] = "Successfully commented!"
    else
      flash[:notice] = "You're not a part of this meetup!"
    end
  else
    flash[:notice] = "You need to be signed in to leave a comment!"
  end
  redirect "/meetup?id=#{params['id']}"
end

post '/create' do
  if signed_in?
    meetup = Meetup.create(params["meetup"])
    flash[:notice] = "Successfully created new meetup!"
    redirect "/meetup?id=#{meetup.id}"
  else
    flash[:notice] = "You need to sign in to create a new meetup!"
    redirect '/'
  end
end
