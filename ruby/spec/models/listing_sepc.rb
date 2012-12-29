describe Listing do
  it "should correct load Listing" do
    Listing.methods.class.should == Array
    Listing.new.methods.should include(:update_or_save)
  end
end