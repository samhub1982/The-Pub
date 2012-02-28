require 'spec_helper'

describe "Static pages" do

	describe "Home page" do

		it "should have the content 'The Pub'" do
			visit '/static_pages/home'
			page.should have_selector('h1', :text => 'The Pub')
		end

		it "should have the title 'Home'" do
			visit '/static_pages/home'
			page.should have_selector('title',
												:text => "The Pub | Home")
		end
	end

	describe "Help page" do

		it "should have the content 'Help'" do
			visit '/static_pages/help'
			page.should have_selector('h1', :text => 'Help')
		end

		it "should have the title 'Help'" do
			visit '/static_pages/help'
			page.should have_selector('title', 
												:text => "The Pub | Help")
		end
	end

	describe "About page" do

		it "should have the content 'About The Pub'" do
			visit '/static_pages/about'
			page.should have_selector('h1', :text => 'About The Pub')
		end

		it "should have the title 'About us'" do
			visit '/static_pages/about'
			page.should have_selector('title', 
												:text => "The Pub | About us")
		end
	end
end
