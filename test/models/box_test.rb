require File.dirname(__FILE__) + '/../test_helper'
class BoxTest < ActiveSupport::TestCase

  test 'test init box' do
    test_box = Box.new(1,2,3,0)
    assert_equal(0 , test_box.value)
    assert_equal(9 , test_box.possibilities.length)

    test_box = Box.new(1,2,3,1)
    assert_equal(1 , test_box.value)
    assert_equal(8 , test_box.possibilities.length)
    assert_equal(false , test_box.possibilities.include?(1))
  end

  test 'test remove possibility' do
    test_box = Box.new(1,2,3,0)

    test_box.remove_possibility(1)
    assert_equal(8 , test_box.possibilities.length)
    assert_equal(0 , test_box.value)
    assert_equal(false , test_box.has_value)

    test_box.remove_possibility(2)
    assert_equal(7 , test_box.possibilities.length)
    assert_equal(0 , test_box.value)
    assert_equal(false , test_box.has_value)

    test_box.remove_possibility(3)
    assert_equal(6 , test_box.possibilities.length)
    assert_equal(0 , test_box.value)
    assert_equal(false , test_box.has_value)

    test_box.remove_possibility(4)
    assert_equal(5 , test_box.possibilities.length)
    assert_equal(0 , test_box.value)
    assert_equal(false , test_box.has_value)

    test_box.remove_possibility(5)
    assert_equal(4 , test_box.possibilities.length)
    assert_equal(0 , test_box.value)
    assert_equal(false , test_box.has_value)

    test_box.remove_possibility(6)
    assert_equal(3 , test_box.possibilities.length)
    assert_equal(0 , test_box.value)
    assert_equal(false , test_box.has_value)

    test_box.remove_possibility(7)
    assert_equal(2 , test_box.possibilities.length)
    assert_equal(0 , test_box.value)
    assert_equal(false , test_box.has_value)

    test_box.remove_possibility(8)
    assert_equal(0 , test_box.possibilities.length)
    assert_equal(9 , test_box.value)
    assert_equal(true , test_box.has_value)
  end

end