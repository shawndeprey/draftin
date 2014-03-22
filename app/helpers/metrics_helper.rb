module MetricsHelper
  VIEW_INDEX              = "view index"
  CREATE_DRAFT            = "create draft"
  UPDATE_DRAFT            = "update draft"
  JOIN_DRAFT              = "join draft"
  START_DRAFT             = "start draft"
  LEAVE_DRAFT             = "leave draft"
  DESTROY_DRAFT           = "destroy draft"
  VIEW_DRAFT              = "view draft"
  LOGIN                   = "login"
  LOGOUT                  = "logout"
  CREATE_USER             = "create user"
  SELECT_CARD             = "select card"
  SUBMIT_FEEDBACK         = "submit feedback"
  VERIFY_USER             = "verify user"
  PASSWORD_RESET_REQUEST  = "password reset request"
  PASSWORD_RESET          = "password reset"

  def self.track(event, properties, user)
    return if !Rails.env.production? || user.blank?
    # Track using mixpanel's specification for tracking specific users
    properties["distinct_id"] = user.id
    properties["user_id"] = user.id
    mp = MetricsHelper::mixpanel(user)
    mp.track(properties["distinct_id"], event, properties)
  end

  def self.mixpanel(user)
    key = (user.blank? || !user.admin?) ? METRIC_API_KEY : METRIC_ADMIN_API_KEY
    Mixpanel::Tracker.new(key)
  end

  # People Metrics Section
  def self.send_user_to_mixpanel(user)
    return unless Rails.env.production?
    mp = MetricsHelper::mixpanel(user)
    mp.people.set("#{user.id}", {
      "$email"    => user.email,
      "$name"     => user.username,
      "$created"  => user.created_at.to_date
    });
  end

end