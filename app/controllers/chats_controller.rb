# frozen_string_literal: true

class ChatsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_chat, only: %i[show]

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chat }
      format.xml  { render xml: @chat }
    end
  end

  def create
    @chat = Chat.create(user: current_user)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chat }
      format.xml  { render xml: @chat }
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end
end
