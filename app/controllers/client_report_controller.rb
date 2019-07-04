class ClientReportController < ApplicationController

  layout 'tclub'


  # POST: client_report_index_path
  def create
    build_new_issue_from_params
    @issue.attributes = params.require(:issue).permit(:subject, :issue_descriptions_attributes=> [:id, :description, :language, :_destroy])

    call_hook(:controller_issues_new_before_save, { :params => params, :issue => @issue })
    @issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
    if @issue.save
      call_hook(:controller_issues_new_after_save, { :params => params, :issue => @issue})
      respond_to do |format|
        format.html {
          render_attachment_warning_if_needed(@issue)
          if params[:continue]
            redirect_to "/client_report/#{@project.identifier}"
          else
            redirect_to "/client_report/#{@project.identifier}/thank_you?issue_id=#{@issue.id}"
          end
        }

      end
      return
    else
      respond_to do |format|
        format.html {
          if @issue.project.nil?
            render_error :status => 422
          else
            render :action => 'show'
          end
        }
      end
    end


  end


  # GET: client_report_path
  def show
    @project = Project.find(params[:id])
    @issue = Issue.new


  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def thank_you
    @project = Project.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def upload
    # Make sure that API users get used to set this content type
    # as it won't trigger Rails' automatic parsing of the request body for parameters
    # unless request.content_type == 'application/octet-stream'
    #   head 406
    #   return
    # end

    @attachment = Attachment.new(:file => request.raw_post)
    @attachment.author = User.current
    @attachment.filename = params[:filename].presence || Redmine::Utils.random_hex(16)
    @attachment.content_type = params[:content_type].presence
    saved = @attachment.save

    respond_to do |format|
      format.js
      format.api {
        if saved
          render :action => 'upload', :status => :created
        else
          render_validation_errors(@attachment)
        end
      }
    end
  end

  private

  def build_new_issue_from_params
    @project = Project.find(params[:project_id])
    @issue = Issue.new
    @issue.project = @project
    if request.get?
      @issue.project ||= @issue.allowed_target_projects.first
    end
    @issue.author ||= User.current
    @issue.start_date ||= User.current.today if Setting.default_issue_start_date_to_creation_date?

    attrs = (params[:issue] || {}).deep_dup
    @issue.safe_attributes = attrs

    if @issue.project
      @issue.tracker_id = Setting.plugin_redmine_tclub_support['tracker_id']
      @issue.tracker ||= @issue.allowed_target_trackers.first
      if @issue.tracker.nil?
        if @issue.project.trackers.any?
          # None of the project trackers is allowed to the user
          render_error :message => l(:error_no_tracker_allowed_for_new_issue_in_project), :status => 403
        else
          # Project has no trackers
          render_error l(:error_no_tracker_in_project)
        end
        return false
      end
      @issue.status_id = Setting.plugin_redmine_tclub_support['status_id'] ||  @issue.new_statuses_allowed_to(User.current).first.try(:id) ||IssueStatus.first.id
      if @issue.status.nil?

        render_error l(:error_no_default_issue_status)
        return false
      end
    elsif request.get?
      render_error :message => l(:error_no_projects_with_tracker_allowed_for_new_issue), :status => 403
      return false
    end

    @priorities = IssuePriority.active
    @allowed_statuses = @issue.new_statuses_allowed_to(User.current)
  end


end
