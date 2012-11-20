# spec/requests/users_spec.rb

describe "Contacts" do
  describe "View contacts" do
    before :each do
      @bob = create(:contact,
        firstname: 'Bob',
        lastname: 'Burns',
        email: 'bob@example.com')
      create :contact, firstname: 'Bob', lastname: 'Conway'
    end

    it "lists a contact's information", js: true do
      visit root_path
      sleep 1
      click_link 'Bob Burns'
      sleep 1
      within 'h1' do
        page.should have_content 'Bob Burns'
      end
      sleep 1
      page.should have_content 'bob@example.com'
    end

    it "filters contacts by letter" do
      visit contacts_url
      click_link 'B'
      page.should have_content 'Bob Burns'
      page.should_not have_content 'Bob Conway'
    end


  end
end

describe "User Management" do
  before :each do
    admin = create :admin
    sign_in admin
  end
  it "adds a new user" do
    visit root_path
    expect {
      click_link 'Users'
      click_link 'New User'
      fill_in 'Email', with: 'newuser@example.com'
      fill_in 'Password', with: 'secret123'
      fill_in 'Password confirmation', with: 'secret123'
      click_button 'Create User'
    }.to change(User, :count).by(1)
    current_path.should eq users_path
    page.should have_content 'New user created'
    within 'h1' do
      page.should have_content 'Users'
    end
    page.should have_content 'newuser@example.com'
  end

  it "adds a new contact and displays the results" do
    visit root_path
    expect{
      click_link 'New Contact'
      fill_in "Firstname", with: "John"
      fill_in "Lastname", with: "Smith"
      fill_in "Email", with: "johnsmith@example.com"
      fill_in "home", with: '555-1234'
      fill_in 'office', with: '555-3324'
      fill_in 'mobile', with: '555-7888'
      click_button "Create Contact"
    }.to change(Contact,:count).by(1)

    page.should have_content 'Contact was successfully created.'
    page.should have_content 'John Smith'
    page.should have_content 'johnsmith@example.com'
    page.should have_content 'home 555-1234'
    page.should have_content 'office 555-3324'
    page.should have_content 'mobile 555-7888'
  end

  it "edits a contact and displays the updated results" do
    contact = create :contact, firstname: 'Sam', lastname: 'Smith'
    visit root_path
    within "#contact_#{contact.id}" do
      click_link 'Edit'
    end
    fill_in "Firstname", with: "Samuel"
    fill_in "Lastname", with: "Smith, Jr."
    fill_in "Email", with: "samsmith@example.com"
    fill_in "home", with: '123-555-1234'
    fill_in 'work', with: '123-555-3324'
    fill_in 'mobile', with: '123-555-7888'
    click_button 'Update Contact'

    page.should have_content 'Contact was successfully updated'
    page.should have_content 'Samuel Smith, Jr.'
    page.should have_content 'samsmith@example.com'
    page.should have_content 'home 123-555-1234'
    page.should have_content 'work 123-555-3324'
    page.should have_content 'mobile 123-555-7888'
  end
end