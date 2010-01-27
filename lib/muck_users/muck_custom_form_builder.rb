module MuckUsersCustomFormBuilder

  # creates a select control with roles
  def roles_select(method, options = {}, html_options = {})
    self.select(method, Role.by_alpha, options.merge(:wrapper_id => 'roles-container'), html_options.merge(:id => 'roles'))
  end
  
end

MuckCustomFormBuilder.send :include, MuckUsersCustomFormBuilder