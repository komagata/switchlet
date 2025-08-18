# frozen_string_literal: true

require "test_helper"

class SwitchletTest < Minitest::Test
  def setup
    Switchlet::Flag.delete_all
  end

  def test_version
    assert_kind_of String, Switchlet::VERSION
  end

  def test_enabled_returns_false_for_unregistered_flag
    assert_equal false, Switchlet.enabled?(:unknown_flag)
  end

  def test_enable_creates_and_enables_flag
    result = Switchlet.enable!(:test_flag)
    assert_equal true, result
    assert_equal true, Switchlet.enabled?(:test_flag)
  end

  def test_disable_creates_and_disables_flag
    result = Switchlet.disable!(:test_flag)
    assert_equal false, result
    assert_equal false, Switchlet.enabled?(:test_flag)
  end

  def test_enable_and_disable_toggle
    Switchlet.enable!(:test_flag)
    assert_equal true, Switchlet.enabled?(:test_flag)

    Switchlet.disable!(:test_flag)
    assert_equal false, Switchlet.enabled?(:test_flag)
  end

  def test_delete_removes_flag
    Switchlet.enable!(:test_flag)
    assert_equal true, Switchlet.enabled?(:test_flag)

    Switchlet.delete!(:test_flag)
    assert_equal false, Switchlet.enabled?(:test_flag)
  end

  def test_delete_nonexistent_flag_does_not_raise
    assert_nil Switchlet.delete!(:nonexistent_flag)
  end

  def test_list_returns_empty_array_when_no_flags
    assert_equal [], Switchlet.list
  end

  def test_list_returns_correct_format
    Switchlet.enable!(:flag1)
    Switchlet.disable!(:flag2)

    list = Switchlet.list
    assert_equal 2, list.size

    flag1 = list.find { |f| f[:name] == "flag1" }
    flag2 = list.find { |f| f[:name] == "flag2" }

    assert_equal true, flag1[:enabled]
    assert_equal false, flag2[:enabled]
    assert_kind_of Time, flag1[:updated_at]
    assert_kind_of Time, flag2[:updated_at]
  end

  def test_list_returns_flags_ordered_by_name
    Switchlet.enable!(:z_flag)
    Switchlet.enable!(:a_flag)
    Switchlet.enable!(:m_flag)

    list = Switchlet.list
    names = list.map { |f| f[:name] }
    assert_equal ["a_flag", "m_flag", "z_flag"], names
  end

  def test_name_conversion_to_string
    Switchlet.enable!("string_flag")
    assert_equal true, Switchlet.enabled?(:string_flag)

    Switchlet.enable!(:symbol_flag)
    assert_equal true, Switchlet.enabled?("symbol_flag")
  end
end
