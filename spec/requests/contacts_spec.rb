# spec/requests/contacts_spec.rb

describe "Manage contacts" do
  before :each do
    user = create :user
    sign_in user
  end

  it "deletes a contact", js: true do
    contact = create :contact, firstname: "Aaron", lastname: "Sumner"
    visit root_path
    expect{
      within "#contact_#{contact.id}" do
        click_link 'Destroy'
      end
      alert = page.driver.browser.switch_to.alert
      alert.accept
    }.to change(Contact,:count).by(-1)
    page.should have_content "Contact"
    page.should_not have_content "Aaron Sumner"
  end
end