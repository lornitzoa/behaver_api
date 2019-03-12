class TasksController < ApplicationController

  def index
    render json: Task.all
  end

  def indexAssignments
    render json: Task.childAssignments(params['child_id'])
  end

  def create
    render json: Task.create(params['task'])
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
    render json: Task.update(params['id'], params['task'])
  end

  def updateAssignedTask
    render json: Task.updateAssignedTask(params['id'], params['task'])
  end

end
