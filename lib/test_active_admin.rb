# encoding: utf-8

require "test_active_admin/version"
require "test_active_admin/config"
require "test_active_admin/helpers"

# Creates Active Admin tests in a application.
#
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
