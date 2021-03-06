class FriendRequestsController < ApplicationController
  before_action :current_user_must_be_friend_request_user, :only => [:show, :edit, :update, :destroy]

  def current_user_must_be_friend_request_user
    friend_request = FriendRequest.find(params[:id])

    unless current_user == friend_request.sender
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @friend_requests = current_user.sent_friend_requests.page(params[:page]).per(10)

    render("friend_requests/index.html.erb")
  end

  def show
    @friend_request = FriendRequest.find(params[:id])

    render("friend_requests/show.html.erb")
  end

  def new
    @friend_request = FriendRequest.new

    render("friend_requests/new.html.erb")
  end

  def create
    @friend_request = FriendRequest.new

    @friend_request.sender_id = params[:sender_id]
    @friend_request.recipient_id = params[:recipient_id]
    @friend_request.accepted = params[:accepted]

    save_status = @friend_request.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/friend_requests/new", "/create_friend_request"
        redirect_to("/friend_requests")
      else
        redirect_back(:fallback_location => "/", :notice => "Friend request created successfully.")
      end
    else
      render("friend_requests/new.html.erb")
    end
  end

  def edit
    @friend_request = FriendRequest.find(params[:id])

    render("friend_requests/edit.html.erb")
  end

  def update
    @friend_request = FriendRequest.find(params[:id])

    @friend_request.sender_id = params[:sender_id]
    @friend_request.recipient_id = params[:recipient_id]
    @friend_request.accepted = params[:accepted]

    save_status = @friend_request.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/friend_requests/#{@friend_request.id}/edit", "/update_friend_request"
        redirect_to("/friend_requests/#{@friend_request.id}", :notice => "Friend request updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Friend request updated successfully.")
      end
    else
      render("friend_requests/edit.html.erb")
    end
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])

    @friend_request.destroy

    if URI(request.referer).path == "/friend_requests/#{@friend_request.id}"
      redirect_to("/", :notice => "Friend request deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Friend request deleted.")
    end
  end
end
