module Inviter
  extend ActiveSupport::Concern

  included do
    include AbstractController::Rendering
    include Rails.application.routes.url_helpers

    self.view_paths = 'app/views'
    self.default_url_options = ActionMailer::Base.default_url_options
  end

  private

  def render_message_body
    render template: 'invitations/message'
  end
end