require 'flashtext'

RSpec.describe "Version" do
  it "has a version number" do
    expect(Flashtext::VERSION).not_to be nil
  end
end
