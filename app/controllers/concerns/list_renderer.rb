module ListRenderer
  def render_list(list_id)
    render "lists/show", locals: list_locals
  end

  def update_list(list_id, opts = {})
    defaults = { focus_invitation_title: false }
    render "lists/show.js", locals: list_locals.merge(defaults).merge(opts)
  end

  def list_locals
    {
      list: Lists.get_list(list_id, ListRecord),
      groups: Lists.get_list_groups(list_id, ListInvitationRecord),
      invitations: Lists.get_invitations(list_id, ListInvitationRecord, search: params[:search], group: params[:group]),
      invitation_form: Lists.get_invitation_form
    }
  end
end
