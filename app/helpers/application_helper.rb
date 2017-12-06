module ApplicationHelper
  def errors_for_field(form, field)
    return [] unless form.object.respond_to? :errors
    form.object.errors[field]
  end

  def form_field_errors(form, field)
    errors = errors_for_field(form, field)
    content_tag(:span, errors) if errors.present?
  end

  def form_group_class(form, field)
    errors = errors_for_field(form, field)
    "form-group #{"form-group--with-errors" if errors.present?}"
  end

  def form_control(form, field, field_method: :text_field, control_class: "", choices: [], select_options: {}, control_options: {})
    options = {class: "form-control #{control_class}"}.merge(control_options)

    if field_method == :select
      form.send(:select, field, choices, select_options, options)
    else
      form.send(field_method, field, options)
    end
  end

  def form_label(form, field, options)
    label = options.delete(:label)
    form.label(field, label) unless label == false
  end

  def form_group(form, field, options = {})
    content_tag :div, class: form_group_class(form, field) do
      concat form_label(form, field, options)
      concat form_control(form, field, options)
      concat form_field_errors(form, field)
    end
  end
end
