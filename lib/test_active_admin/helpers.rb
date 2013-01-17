module TestActiveAdmin

  def create_resource(resource)
    return if resource.resource_class.first.present?

    factory_name = resource.resource_name.underscore.gsub(?/, ?_)
    if FactoryGirl.factories.registered? factory_name
      FactoryGirl.create factory_name
    else
      warn("WARNING! Active Admin test: #{resource.resource_name} has not created, so :edit and :show actions will not test. " +
               " Define factory '#{factory_name}' or create the resource manually.")
    end
  end
  module_function :create_resource

  def active_admin_resources
    ActiveAdmin.application.namespaces.values.collect{|n| n.resources.resources }.flatten.select { |r| r.kind_of? ActiveAdmin::Resource }
  end
  module_function :active_admin_resources

end