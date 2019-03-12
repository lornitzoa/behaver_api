class BehaviorsController < ApplicationController

  def index
    render json: Behavior.all
  end

  def indexBehaviors
    render json: Behavior.indexAssignments
  end

  def create
    render json: Behavior.create(params['behavior'], params['targeted_for'], params['family_id'])
  end

  def assignBehaviors
    render json: Behavior.assignBehaviors(params['behavior'])
  end

  def delete
    render json: Behavior.delete(params['id'])
  end

  def deleteAssignedBehavior
    render json: Behavior.deleteAssignedBehavior(params['id'])
  end

  def update
    render json: Behavior.update(params['id'], params['behavior'], params['targeted_for'], params['family_id'])
  end

  def updateAssignedBehavior
    render json: Behavior.updateAssignedBehavior(params['id'], params['behavior'])
  end

end
