class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end
  def current_user
    @current_user = User.where({:id => session[:user_id]}).at(0)
    return @current_user
  end
  def create
    the_follow_request = FollowRequest.new
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    recipient_user_id = the_follow_request.recipient_id
    @current_user = self.current_user
    the_follow_request.sender_id = @current_user.id
    
    recipient_user = User.where({:id => recipient_user_id}).at(0)
    if recipient_user.private == true
      the_follow_request.status = "pending"
    else
      the_follow_request.status = "accepted"
    end

    save_status = the_follow_request.save

    if save_status == true
      if recipient_user.private == true
        redirect_to("/", {:notice => "Follow request created successfully."})
      else
        redirect_to("/users/"+recipient_user.username, {:notice => "Follow request created successfully."})
      end
    else
      redirect_to("/", {:notice => "Follow request failed to create successfully."})
    
  end


    #the_follow_request.sender_id = params.fetch("query_sender_id")
    #the_follow_request.status = params.fetch("query_status")
    # if the_follow_request.valid?
    #   the_follow_request.save
    #   redirect_to("/follow_requests", { :notice => "Follow request created successfully." })
    # else
    #   redirect_to("/follow_requests", { :alert => the_follow_request.errors.full_messages.to_sentence })
    # end
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    #the_follow_request.recipient_id = params.fetch("query_recipient_id")
    #the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.status = params.fetch("query_status")

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/users/#{the_follow_request.recipient_id}", { :notice => "Follow request updated successfully." })
    else
      redirect_to("/follow_requests/#{the_follow_request.id}", { :alert => the_follow_request.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.destroy

    redirect_to("/follow_requests", { :notice => "Follow request deleted successfully."} )
  end
end
