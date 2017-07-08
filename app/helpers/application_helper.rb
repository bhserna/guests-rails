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

  def form_control(form, field, field_method: :text_field, control_class: "", select_options: [])
    control_class = "form-control #{control_class}"
    if field_method == :select
      form.send(:select, field, select_options, class: control_class)
    else
      form.send(field_method, field, class: control_class)
    end
  end

  def form_group(form, field, options = {})
    content_tag :div, class: form_group_class(form, field) do
      concat form.label(field)
      concat form_control(form, field, options)
      concat form_field_errors(form, field)
    end
  end
end
