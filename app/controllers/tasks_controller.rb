class TasksController < ApplicationController

  def index
    render json: Task.all
  end

  def show
    render json: Task.indexAssignments
  end

  def create
    render json: Task.create(params['task'], params['family_id'])
  end

  def assignTask
    render json: Task.assignTask(params['task'])
  end

  def destroy
    puts 'destroy method running'
    render json: Task.delete(params['id'])
  end

  def deleteAssignedTask
    render json: Task.deleteAssignedTask(params['id'])
  end

  def update
    render json: Task.update(params['id'], params['task'], params['family_id'])
  end

  def updateAssignedTask
    render json: Task.updateAssignedTask(params['id'], params['task'])
  end

end
