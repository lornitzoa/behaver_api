class BehaviorsController < ApplicationController

  def index
    render json: Behavior.all
  end

  def create
    render json: Behavior.create(params['behavior'])
  end

  def delete
    render json: Behavior.delete(params['id'])
  end

  def update
    render json: Behavior.update(params['id'], params['behavior'])
  end

end
