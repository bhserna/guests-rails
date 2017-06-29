class RegistrationsController < ApplicationController
  def new
    form = Users.register_form
    render locals: { form: form }
  end
end
