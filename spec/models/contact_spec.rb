# spec/models/contact_spec.

require 'spec_helper'

describe Contact do
  it "has a valid factory" do
    create(:contact).should be_valid
  end

  it 'is invalid without a firstname' do
    build(:contact, firstname: nil).should_not be_valid
  end

  it 'is invalid with a blank firstname' do
    build(:contact, firstname: ' ').should_not be_valid
  end

  it 'is invalid without a lastanme' do
    build(:contact, lastname: nil).should_not be_valid
  end

  it 'is invalid with a blank lastname' do
    build(:contact, lastname: ' ').should_not be_valid
  end

  it 'is invalid with a duplicate email address' do
    create(:contact, email: 'nick@example.com')
    build(:contact, email: 'nick@example.com').should_not be_valid
  end

  it "returns a contact's full name as a string" do
    contact = create(:contact)
    contact.name.should eq "#{contact.firstname} #{contact.lastname}"
  end

  it "has three phone numbers" do
    create(:contact).phones.count.should eq 3
  end

  describe "filter last name by letter" do
    before :each do
      @smith = create(:contact, lastname: "Smith")
      @jones = create(:contact, lastname: "Jones")
      @johnson = create(:contact, lastname: "Johnson")
    end

    context 'matching letters' do
      it 'returns a sorted array of results that match' do
        Contact.by_letter("J").should eq [@johnson, @jones]
      end
    end

    context 'non-matching letters' do
      it 'does not return a match that does not belong' do
        Contact.by_letter("J").should_not include @smith
      end
    end
  end
end
