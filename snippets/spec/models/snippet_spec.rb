require 'spec_helper'

describe Snippet do

  before(:each) do
    @snippet = Snippet.new
  end

  it "should save a snippet" do
    @snippet.title = "teste"
    @snippet.save.should be_true
  end

  it 'should dont save a snippet' do
    @snippet.save.should be_false
  end

end
