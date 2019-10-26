module Validations
  def validate_presence_of(data, *attrs)
    attrs.map do |attr|
      value = data.send(attr)
      message = "no puede estar en blanco"
      [attr, message] if value.nil? || value == ""
    end
  end
end
