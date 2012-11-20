describe Phone do
  it 'does not allow duplicate phone numbers per contact' do
    contact = create(:contact)
    create(:phone,
      contact: contact,
      phone_type: 'home',
      phone: '123-456-7890')
    build(:phone,
      contact: contact,
      phone_type: 'mobile',
      phone: '123-456-7890').should_not be_valid
  end

  it 'allows two contacts to share a phone number' do
    create(:work_phone,
      phone: '785-555-1234')
    build(:work_phone,
      phone: '785-555-1234').should be_valid
  end
end