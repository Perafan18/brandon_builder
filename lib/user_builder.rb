# frozen_string_literal: true

require "date"

class User
  attr_accessor :name, :email, :password, :active, :role, :birthday, :title
end

class Company
  attr_accessor :default_title
end

module BrandonBlueprint
  class Base
    def self.build(object)
      define_method(:object_to_build) { object }
    end

    def self.property(name, type = nil, required: false, default: nil)
      attr_accessor name.to_sym

      case type
      when :boolean
        define_method("is_#{name}") do
          send("#{name}=", true)
        end

        define_method("is_not_#{name}") do
          send("#{name}=", false)
        end
      end
    end
  end
end

module BrandonBuilder
  class Base
    def initialize(blueprint)
      @blueprint = blueprint
    end

    def instructions
      raise NotImplementedError
    end

    def build
      instructions
      object_to_build = @blueprint.object_to_build.new
      @blueprint.instance_variables.each do |var|
        object_to_build.instance_variable_set(var, @blueprint.instance_variable_get(var))
      end
      object_to_build
    end
  end
end

class UserBlueprint < BrandonBlueprint::Base
  build User
  property :name, :string, required: true
  property :email, :string, required: true
  property :password, :string, required: true
  property :password_confirmation, :string, required: true
  property :active, :boolean, default: true, required: true
  property :role, :string, default: "user", required: true
  property :birthday, :date, required: false
  property :title, :string, required: false

  def initialize(company:)
    @company = company
    super()
  end

  def assign_title
    self.title = (@company.default_title || "Mr.")
  end
end

class UserAdminBuilder < BrandonBuilder::Base

  def instructions
    @blueprint.name = "Brandon"
    @blueprint.email = "brandon@example.com"
    @blueprint.password = "password"
    @blueprint.is_not_active
    @blueprint.assign_title
    @blueprint.role = "admin"
  end
end

class UserCoordinatorBuilder < BrandonBuilder::Base

  def instructions
    @blueprint.name = "Ned"
    @blueprint.email = "Ned@example.com"
    @blueprint.password = "password"
    @blueprint.is_active
    @blueprint.assign_title
    @blueprint.role = "coordinator"
  end
end

company = Company.new
company.default_title = "Lord/Lady "

user_blueprint = UserBlueprint.new(company: company)
user_blueprint.birthday = ::Date.new(1980, 1, 1)

user_admin_builder = UserAdminBuilder.new(user_blueprint)
user = user_admin_builder.build
puts user.inspect

user_coordinator_builder = UserCoordinatorBuilder.new(user_blueprint)
user = user_coordinator_builder.build
puts user.inspect

# => #<User:0x00007f9b1a8b0b20
# @active=false,
# @admin=true,
# @birthday=#<Date: 1980-01-01 ((2444245j,0s,0n),+0s,2299161j)>,
# @email="brandon@example.com",
# @name="Brandon",
# @password="password",
# @password_confirmation="password",
# @role="user">
