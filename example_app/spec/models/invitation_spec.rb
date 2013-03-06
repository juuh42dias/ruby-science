require 'spec_helper'

describe Invitation, 'Associations' do
  it { should belong_to(:sender) }
  it { should belong_to(:survey) }
end

describe Invitation, 'Validations' do
  it { should validate_presence_of(:recipient_email) }
  it { should allow_value('user@example.com').for(:recipient_email) }
  it { should_not allow_value('invalid_email').for(:recipient_email) }
  it { should ensure_inclusion_of(:status).in_array(Invitation::STATUSES) }
end

describe Invitation, '#deliver' do
  it 'sends email notifications to new users' do
    inviter = stub('inviter', deliver: true)
    EmailInviter.stubs(new: inviter)
    invitation = build_stubbed(:invitation)

    invitation.deliver

    EmailInviter.should have_received(:new).with(invitation)
    inviter.should have_received(:deliver)
  end

  it 'creates private messages for existing users' do
    existing_user = build_stubbed(:user)
    User.stubs(:find_by_email).with(existing_user.email).returns(existing_user)
    inviter = stub('inviter', deliver: true)
    MessageInviter.stubs(new: inviter)
    invitation = build_stubbed(
      :invitation,
      recipient_email: existing_user.email
    )

    invitation.deliver

    MessageInviter.should have_received(:new).with(invitation, existing_user)
    inviter.should have_received(:deliver)
  end
end

describe Invitation, '#to_param' do
  it 'returns the invitation token' do
    invitation = create(:invitation)

    invitation.to_param.should eq invitation.token
  end
end
