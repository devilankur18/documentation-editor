require_dependency "documentation_editor/application_controller"

module DocumentationEditor
  class PagesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def admin
    end

    def edit
      @page = Page.find(params[:id])
    end

    def source
      render json: (Page.find(params[:id]).content || 'FIXME').to_json
    end

    def save
      p = Page.new
      p.author_id = respond_to?(:current_user) ? current_user.id : nil
      p.slug = Page.find(params[:id]).slug
      p.preview = params[:preview]
      p.content = params[:data]
      p.save!
      render json: { id: p.id, slug: p.slug }
    end

    def create
      p = Page.new
      p.slug = params[:page][:slug]
      p.save!
      redirect_to edit_page_path(p)
    end

    def preview
      @html = Kramdown::Document.new(Page.find(params[:id]).content, :input => 'ReadmeIOKramdown').to_html
    end

    def show
      @html = Kramdown::Document.new(Page.where(preview: true).where(slug: params[:slug]).order('id DESC').first!.content, :input => 'ReadmeIOKramdown').to_html
      render :preview
    end
  end
end
