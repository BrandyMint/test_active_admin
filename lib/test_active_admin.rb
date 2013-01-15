# encoding: utf-8

require "test_active_admin/version"

module TestActiveAdmin

  class Config
    attr_reader :before_block, :login_block

    def before(&block)
      @before_block = block if block_given?
    end

    def login(&block)
      @login_block = block if block_given?
    end
  end

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

def self.test_active_admin(&config_block)

  def test_active_admin_resource(resource)

    TestActiveAdmin.create_resource(resource)

    path = "/admin/" + resource.resource_name.route_key

    visit path
    page.status_code.should eq(200), "visit error: '#{path}'"

    if resource.defined_actions.include? :new
      test_active_admin_resource_path(path + "/new")
      page.should have_content("Создать")
    end

    resource_instance = resource.resource_class.first
    if resource_instance.present?
      instance_path = path + "/#{resource_instance.id}"
      if resource.defined_actions.include?(:show)
        test_active_admin_resource_path(instance_path)
      end

      if resource.defined_actions.include?(:edit)
        test_active_admin_resource_path(instance_path + "/edit")
      end
    end

  end

  def test_active_admin_resource_path(path)
    visit path
    page.status_code.should eq(200), "visit error: '#{path}'\n status code: #{page.status_code} \n body: #{page.body} "
  end

  def test_active_admin_resources(&config_block)

    feature 'Active Admin resources', :js => true do

      config = TestActiveAdmin::Config.new
      config_block.call(config) if block_given?

      background do
        instance_eval &config.before_block if config.before_block.present?
        instance_eval &config.login_block if config.login_block.present?
      end

      TestActiveAdmin.active_admin_resources.each do |active_admin_resource|
        resource_class = active_admin_resource.resource_class
        scenario "Test '#{resource_class.name}' resource" do
          test_active_admin_resource(active_admin_resource)
        end
      end

    end
  end

  test_active_admin_resources(&config_block)

end
