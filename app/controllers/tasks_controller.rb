class TasksController < ApplicationController

  def index
    render json: Task.all
  end

  def create
    render json: Task.create(params['task'])
  end

  def delete
    render json: Task.delete(params['id'])
  end

  def update
    render json: Task.update(params['id'], params['task'])
  end

end
