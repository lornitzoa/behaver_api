class ScoresController < ApplicationController

  def index
    render json: Score.all
  end

  def create
    render json: Score.create(params['score'])
  end

  def delete
    render json: Score.delete(params['member_id'])
  end

  def update
    render json: Score.update(params['member_id'],params['score'])
  end

end