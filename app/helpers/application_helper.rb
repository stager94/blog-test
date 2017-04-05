module ApplicationHelper

  def render_errors_for(resource)
    render 'shared/errors', resource: resource
  end

end
