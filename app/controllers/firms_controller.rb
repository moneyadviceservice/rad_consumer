class FirmsController < ApplicationController
  def show
    @firm = FirmResult.new(firm_repository.find(params[:id]))
  end

  def firm_repository
    @firm_repository ||= FirmRepository.new
  end
end
