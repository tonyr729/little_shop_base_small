class SessionController < ApplicationController
  def new
  end

  def destroy
    redirect_to root_path
  end
end