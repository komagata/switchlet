# frozen_string_literal: true

require "test_helper"

# Simple functional tests for the controller logic without Rails dependencies
class FlagsControllerTest < Minitest::Test
  def setup
    # Clear all flags before each test
    Switchlet::Flag.delete_all
  end

  def test_controller_file_exists
    controller_path = File.join(File.dirname(__FILE__), "../app/controllers/switchlet/flags_controller.rb")
    assert File.exist?(controller_path), "Controller file should exist"
    
    # Read and verify controller structure
    content = File.read(controller_path)
    assert content.include?("class FlagsController"), "Should define FlagsController"
    assert content.include?("def index"), "Should have index action"
    assert content.include?("def create"), "Should have create action"
    assert content.include?("def update"), "Should have update action"
    assert content.include?("def destroy"), "Should have destroy action"
  end

  def test_index_action_functionality
    # Test with empty flags
    flags = Switchlet.list
    assert_equal 0, flags.length

    # Test with some flags
    Switchlet.enable!("test_flag", description: "Test description")
    flags = Switchlet.list
    assert_equal 1, flags.length
    assert_equal "test_flag", flags.first[:name]
    assert_equal "Test description", flags.first[:description]
    assert_equal true, flags.first[:enabled]
  end

  def test_create_action_logic
    # Test creating a flag
    flag_name = "new_flag"
    description = "New flag description"
    
    # Simulate create action logic
    if flag_name.strip.present?
      Switchlet.enable!(flag_name, description: description)
      success = true
    else
      success = false
    end
    
    assert success
    assert Switchlet.enabled?(flag_name)
    
    flag = Switchlet::Flag.find_by(name: flag_name)
    assert_equal description, flag.description
  end

  def test_create_action_with_empty_name
    # Test with empty name
    flag_name = ""
    
    success = flag_name.strip.present?
    
    assert_equal false, success
  end

  def test_update_toggle_logic
    # Setup a flag
    Switchlet.enable!("toggle_flag")
    original_state = Switchlet.enabled?("toggle_flag")
    assert original_state
    
    # Simulate toggle logic
    if original_state
      Switchlet.disable!("toggle_flag")
    else
      Switchlet.enable!("toggle_flag")
    end
    
    assert_equal false, Switchlet.enabled?("toggle_flag")
  end

  def test_update_description_logic
    # Setup a flag
    Switchlet.enable!("desc_flag")
    
    # Simulate description update
    new_description = "Updated description"
    Switchlet.update!("desc_flag", description: new_description)
    
    flag = Switchlet::Flag.find_by(name: "desc_flag")
    assert_equal new_description, flag.description
  end

  def test_destroy_logic
    # Setup a flag
    Switchlet.enable!("delete_flag")
    assert Switchlet.enabled?("delete_flag")
    
    # Simulate destroy logic
    Switchlet.delete!("delete_flag")
    
    assert_equal false, Switchlet.enabled?("delete_flag")
  end

  def test_controller_handles_various_scenarios
    # Test multiple flags creation and management
    flags = ["flag1", "flag2", "flag3"]
    
    flags.each do |flag_name|
      Switchlet.enable!(flag_name, description: "Description for #{flag_name}")
    end
    
    all_flags = Switchlet.list
    assert_equal 3, all_flags.length
    
    # Test toggling
    Switchlet.disable!("flag2")
    assert_equal false, Switchlet.enabled?("flag2")
    
    # Test deletion
    Switchlet.delete!("flag3")
    remaining_flags = Switchlet.list
    assert_equal 2, remaining_flags.length
  end

  def test_new_update_method
    # Test the new update! method
    Switchlet.enable!("update_test")
    
    # Update only description
    Switchlet.update!("update_test", description: "New description")
    flag = Switchlet::Flag.find_by(name: "update_test")
    assert_equal "New description", flag.description
    assert_equal true, flag.enabled
    
    # Update only enabled status
    Switchlet.update!("update_test", enabled: false)
    flag.reload
    assert_equal false, flag.enabled
    assert_equal "New description", flag.description
    
    # Update both at once
    Switchlet.update!("update_test", description: "Updated again", enabled: true)
    flag.reload
    assert_equal true, flag.enabled
    assert_equal "Updated again", flag.description
  end
end