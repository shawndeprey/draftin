class Feedback < ActiveRecord::Base
  nilify_blanks
  # attributes: title, content, handled, user_id, created_at, updated_at
  belongs_to :user

  # Eager load the user associated with the feedbacks
  default_scope includes(:user)
end