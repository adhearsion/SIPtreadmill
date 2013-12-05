module ApplicationHelper
  def status_label(status)
    case status
    when 'pending'
      text = 'Pending'
      css = ''
    when 'queued'
      text = 'Queued'
      css = 'label-inverse'
    when 'running'
      text = 'Running'
      css = 'label-info'
    when 'complete'
      text = 'Complete'
      css = 'label-success'
    when 'complete_with_warnings'
      text = 'Warnings'
      css = 'label-warning'
    when 'complete_with_errors'
      text = 'Errors'
      css = 'label-important'
    end
    capture_haml do
      haml_tag :span, text, {class: "label #{css}"}
    end
  end
end
