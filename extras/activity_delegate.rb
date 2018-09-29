class ActivityDelegate
  class << self
    def handle(action, with: nil, &block)
      method_name = with ? "handle_#{action}_#{with}" : "handle_#{action}"
      define_method(method_name, &block)
    end
  end

  def call(params)
    user, action, type = *user_action_type_for(params)
    method_name = (params[:object].is_a? String) ? "handle_#{action}" : "handle_#{action}_#{type}"
    self.send(method_name, user, params[:object])
  end

  private

  def user_action_type_for(params)
    user = object_for(params[:actor])
    action = params[:type].downcase.to_sym
    type = if params[:object].is_a? String
             params[:object]
           else
             params[:object][:type].downcase.to_sym
           end

    [user, action, type]
  end

  def object_for(id)
    path_params =  Rails.application.routes.recognize_path(id)

    case path_params[:controller]
    when 'stories'
      Story.find_by(short_id: path_params[:id])
    when 'users'
      User.find_by(username: path_params[:username])
    when 'comments'
      Comment.find_by(short_id: path_params[:id])
    else
      nil
    end
  rescue ActionController::RoutingError
    nil
  end
end
