# frozen_string_literal: true

class ResourceController < ApplicationController
  before_action :set_resource, only: %i[show edit update destroy]

  def index
    @page_title = resource_human_name.pluralize.titleize

    @collection = resource_scope.all
    instance_variable_set("@#{resource_collection_name}", @collection)
  end

  def new
    @page_title = "New #{resource_human_name}"

    @resource = resource_scope.new
    set_resource_variable!
  end

  def edit
    @page_title = "Edit #{resource_human_name}"
  end

  def show
    @page_title = resource_human_name.to_s
  end

  def create
    @resource = resource_scope.new(create_params)
    set_resource_variable!

    respond_to do |format|
      if @resource.save
        format.html { redirect_to after_create_path, notice: "#{resource_human_name} was successfully created." }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @resource.update(update_params)
        format.html { redirect_to after_update_path, notice: "#{resource_human_name} was successfully updated." }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to after_destroy_path, notice: "#{resource_human_name} was successfully destroyed." }
    end
  end

  private

  def set_resource
    @resource = resource_scope.find(params[:id])
    set_resource_variable!
  end

  def set_resource_variable!
    instance_variable_set("@#{resource_instance_name}", @resource)
  end

  def resource_instance_name
    @resource_instance_name ||= self.class.name
                                    .demodulize
                                    .gsub('Controller', '')
                                    .singularize
                                    .underscore
  end

  def resource_human_name
    resource_instance_name.humanize
  end

  def resource_collection_name
    resource_instance_name.pluralize
  end

  def scaffold_instance_name
    @scaffold_instance_name ||= self.class.name
                                    .gsub('Controller', '')
                                    .gsub('::', '')
                                    .singularize
                                    .underscore
  end

  def scaffold_collection_name
    scaffold_instance_name.pluralize
  end

  def after_create_path
    @resource
  end

  def after_update_path
    @resource
  end

  def after_destroy_path
    { action: 'index' }
  end

  def create_params
    resource_params
  end

  def update_params
    resource_params
  end
end
