require 'spec_helper'

describe Dictionary::WordPath do
  subject { Dictionary::WordPath.new }

  describe '#leaf=' do
    it 'should set to false' do
      subject.leaf = false
      subject.should_not be_leaf
    end

    it 'should set to true' do
      subject.leaf = true
      subject.should be_leaf
    end
  end

  describe '#find' do
    before do
      subject << 'potato'
    end

    it 'finds existing word paths' do
      word_path = subject.find('potat')
      word_path.should be_a Dictionary::WordPath
      word_path.should eq Dictionary::WordPath.new.tap { |wp| wp << 'o' }
    end

    it 'does not find nonexistent word paths' do
      subject.find('potable').should be_nil
    end
  end

  describe '#<<' do
    before do
      subject.find('pot').should be_nil
    end

    it 'appends word to dictionary' do
      subject << 'potato'
      subject.find('pot').should_not be_nil
    end
  end

  describe '#suffixes' do
    before do
      subject << 'pot'
      subject << 'potato'
      subject << 'potable'
      subject << 'pert'
      subject << 'jar'
    end

    it 'finds all words with the given suffix' do
      word = subject.find('pot')
      word.suffixes.should eq %w(ato able)
    end
  end
end
