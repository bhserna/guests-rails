require_relative "validations"
require_relative "lists/invitation"
require_relative "lists/list_creator"
require_relative "lists/access_control"

module Lists
  def self.new_list_form
    ListCreator.new_list_form
  end

  def self.create_list(*args)
    ListCreator.create_list(*args)
  end

  def self.edit_list_form(list_id, store)
    ListCreator.edit_list_form(list_id, store)
  end

  def self.update_list(list_id, data, store)
    ListCreator.update_list(list_id, data, store)
  end

  def self.lists_of_user(user, lists_store)
    lists_store.find_all_by_user_id(user.id).map { |record| List.new(record) }
  end

  def self.get_list(list_id, lists_store)
    List.new(lists_store.find_by_list_id(list_id))
  end

  def self.get_all_lists(lists_store, invitations_store, users_store)
    users = users_store.all.map{|data| User.new(data)}.group_by(&:id)
    invitations_counts = invitations_store.counts_by_list_id
    lists = lists_store.all
      .map{|data| List.new(data)}
      .map{|list| ListWithUser.new(list, users[list.user_id].first)}
      .map{|list| ListWithInvitationsCount.new(list, invitations_counts[list.id] || 0)}

    with_date, without_date = lists.partition(&:has_event_date?)
    without_date + with_date.sort_by(&:event_date)
  end

  def self.current_access_details(*args)
    AccessControl.current_access_details(*args)
  end

  def self.give_access_form
    AccessControl.give_access_form
  end

  def self.give_access_to_person(*args)
    AccessControl.give_access_to_person(*args)
  end

  def self.edit_access_form(*args)
    AccessControl.edit_access_form(*args)
  end

  def self.update_access_for_person(*args)
    AccessControl.update_access_for_person(*args)
  end

  def self.remove_access_for_person(*args)
    AccessControl.remove_access_for_person(*args)
  end

  def self.has_access?(*args)
    AccessControl.has_access?(*args)
  end

  def self.get_invitation_form
    InvitationForm.new(Invitation.new)
  end

  def self.add_invitation(list_id, params, store)
    invitation = Invitation.new(params)
    form = InvitationForm.new(invitation)
    errors = InvitationValidator.validate(form)

    if errors.empty?
      record = store.create(invitation.creation_data.merge(list_id: list_id))
      InvitationCreatedResponse.new(record[:id])
    else
      form.add_errors(errors)
      ErrorWithForm.new(form)
    end
  end

  def self.get_edit_invitation_form(id, store)
    invitation = get_invitation(id, store)
    InvitationForm.new(invitation)
  end

  def self.update_invitation(id, params, store)
    invitation = Invitation.new(params)
    form = InvitationForm.new(invitation)
    errors = InvitationValidator.validate(form)

    if errors.empty?
      store.update(id, invitation.creation_data)
      SuccessResponse
    else
      form.add_errors(errors)
      ErrorWithForm.new(form)
    end
  end

  def self.mark_invitation_as_delivered(id, store)
    store.update(id, is_delivered: true)
  end

  def self.mark_invitation_as_not_delivered(id, store)
    store.update(id, is_delivered: false)
  end

  def self.confirm_invitation_guests_form(id, store)
    InvitationForm.new(get_invitation(id, store))
  end

  def self.confirm_invitation_guests(id, count, store)
    store.update(id, confirmed_guests_count: count.to_i, is_assistance_confirmed: true)
  end

  def self.delete_invitation(id, store)
    store.update(id, is_deleted: true)
  end

  def self.get_invitation(id, store)
    Invitation.new(store.find(id))
  end

  def self.get_invitations(list_id, store, group: nil, search: nil)
    invitations = store.find_all_by_list_id(list_id).map{|data| Invitation.new(data)}.reject(&:deleted?)

    if group.present?
      invitations = invitations.select{|invitation| invitation.group == group}
    end

    if search.present?
      invitations = invitations.select{ |invitation| invitation.match_search?(search)}
    end

    invitations
  end

  def self.get_list_groups(list_id, store)
    store.find_all_groups_by_list_id(list_id).reject(&:blank?)
  end

  class List
    attr_reader :id, :name, :event_date, :user_id, :created_at

    def initialize(data)
      @id = data[:list_id]
      @name = data[:name]
      @event_date = data[:event_date]
      @user_id = data[:user_id]
      @created_at = data[:created_at]
    end

    def has_event_date?
      !event_date.nil?
    end
  end

  class User
    attr_reader :id, :first_name, :last_name

    def initialize(data)
      @id = data[:id]
      @first_name = data[:first_name]
      @last_name = data[:last_name]
    end

    def full_name
      [first_name, last_name].compact.join(" ")
    end
  end

  class ListWithUser < SimpleDelegator
    def initialize(list, user)
      super(list)
      @user = user
    end

    def user_full_name
      user.full_name
    end

    private

    attr_reader :user
  end

  class ListWithInvitationsCount < SimpleDelegator
    attr_reader :invitations_count

    def initialize(list, invitations_count)
      super(list)
      @invitations_count = invitations_count
    end
  end

  class ErrorWithForm
    attr_reader :form

    def initialize(form)
      @form = form
    end

    def success?
      false
    end
  end

  class InvitationCreatedResponse
    attr_reader :invitation_id

    def initialize(id)
      @invitation_id = id
    end

    def success?
      true
    end
  end

  class SuccessResponse
    def self.success?
      true
    end
  end

  class ErrorResponse
    def self.success?
      false
    end
  end

  class InvitationForm < SimpleDelegator
    attr_reader :errors

    def initialize(invitation)
      super(invitation)
      @errors = {}
    end

    def add_errors(errors)
      @errors = errors
    end
  end

  class InvitationValidator
    extend Validations

    def self.validate(form)
      [*validate_presence_of(form, :title)].compact.to_h
    end
  end
end
