class ReinforcementsController < ApplicationController

  def index
    render json: Reinforcement.all(params['family_id'])
  end

  def indexReinforcements
    render json: Reinforcement.indexReinforcements
  end

  def create
    render json: Reinforcement.create(params['reinforcement'], params['family_id'])
  end

  def assignReinforcement
    render json: Reinforcement.assignReinforcement(params['reinforcement'])
  end

  def delete
    render json: Reinforcement.delete(params['id'])
  end

  def deleteAssignedReinforcement
    render json: Reinforcement.deleteAssignedReinforcement(params['id'])
  end

  def update
    render json: Reinforcement.update(params['id'], params['reinforcement'], params['family_id'])
  end

  def updateAssignedReinforcement
    render json: Reinforcement.updateAssignedReinforcement(params['id'], params['reinforcement'])
  end

end
