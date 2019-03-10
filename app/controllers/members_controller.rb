class MembersController < ApplicationController

  def index
    render json: Member.all
  end

  def show
    render json: Member.find(params['id'])
  end

  def children
    render json: Member.all
  end

  def create
    render json: Member.create(params['member'])
  end

  def delete
    render json: Member.delete(params['id'])
  end

  def update
    render json: Member.update(params['id'], params['member'])
  end

end
