class TasksController < ApplicationController

  def show
    render json: Task.all(params['id'])
  end

  def indexAssignments
    puts params
    render json: Task.indexAssignments(params['family_id'])
  end

  def create
    render json: Task.create(params['task'], params['family_id'])
  end

  def assignTask
    render json: Task.assignTask(params['task'])
  end

  def destroy

    render json: Task.delete(params['id'])
  end

  def deleteAssignedTask
    render json: Task.deleteAssignedTask(params['id'])
  end

  def update
    render json: Task.update(params['id'], params['task'], params['family_id'])
  end

  def updateAssignedTask
    puts '============== incoming params =============='
    puts params
    render json: Task.updateAssignedTask(params['id'], params['task'])
  end

end
