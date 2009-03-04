require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    @expected.subject = 'UserMailer#welcome'
    @expected.body    = read_fixture('welcome')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMailer.create_welcome(@expected.date).encoded
  end

  test "forgot_password" do
    @expected.subject = 'UserMailer#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMailer.create_forgot_password(@expected.date).encoded
  end

end
