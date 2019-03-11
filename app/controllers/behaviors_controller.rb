class BehaviorsController < ApplicationController

  def index
    render json: Behavior.all
  end

  def show
    render json: Behavior.find(params['id'])
  end

  def create
    render json: Behavior.create(params['behavior'], params['targeted_for'])
  end

  def delete
    render json: Behavior.delete(params['id'])
  end

  def update
    render json: Behavior.update(params['id'], params['behavior'], params['targeted_for'])
  end

end
