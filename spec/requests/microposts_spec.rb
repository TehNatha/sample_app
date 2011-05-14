require 'spec_helper'

describe "Microposts" do
  
  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email,       :with => user.email
    fill_in :password,    :with => user.password
    click_button
  end
  
  describe "sidebar" do
    
    before(:each) do
      content = "Lorem ipsum dolor sit amet"
      visit root_path
      fill_in :micropost_content, :with => content
      click_button
    end
    
    describe "should have micropost count theat pluralizes" do
      
      it "properly for a single post" do
        response.should have_selector("span.microposts", :content => "1 micropost")
      end
      
      it "for two posts" do
        content = "Lorem ipsum dolor sit amet"
        fill_in :micropost_content, :with => content
        click_button
        response.should have_selector("span.microposts", :content => "2 microposts")
      end
    end
  end
  
  describe "creation" do
    
    describe "failure" do
    
      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end

    describe "success" do
    
      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end
end