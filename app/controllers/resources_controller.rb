class ResourcesController < ApplicationController

  # GET /resources
  def index
    @import_type = params[:import_type] || "poi"
    @resources = Resource.where(import_type: @import_type).sort_by(&:title)
    @resources = @resources.sort_by(&:created_at).reverse if params[:sort_by] == 'created_at'
    @resources = @resources.sort_by(&:title) if params[:sort_by] == 'title' || params[:sort_by].blank?
  end

end
