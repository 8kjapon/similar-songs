module ApplicationHelper
  def bootstrap_class_for_flash(message_type)
    case message_type.to_sym
    when :notice
      "success"
    when :alert
      "danger"
    when :warning
      "warning"
    else
      "info"
    end
  end
end
