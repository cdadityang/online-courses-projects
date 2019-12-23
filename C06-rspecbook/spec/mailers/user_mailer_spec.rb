require 'rails_helper'

=begin
RSpec.describe UserMailer, type: :mailer do
  describe "friend request message", slow: true do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.friend_request(user, friend) }
    
    it "sends user a friend request" do
      expect(mail.subject).to eq "New friend request from #{friend.name}"
      expect(mail.to).to eq[user.email]
      expect(mail.from).to eq["from@example.com"]
      expect(mail.body.encoded).to match edit_friendship_url(user, friend)
    end
  end
end
=end