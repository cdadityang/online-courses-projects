RSpec::Matchers.define :require_contact_hidden do |expected|
  match do |actual|
    expect(actual.reload.hidden?).to be true
  end
  
  failure_message do |actual|
    "expected the contact to be hidden"
  end
  
  failure_message_when_negated do |actual|
    "expected contact not to be hidden"
  end
  
  describe do
    "contact hidden to be true"
  end
end