require 'spec_helper'

describe Dictionary do
  subject { Dictionary.new(word_list) }

  let(:word_list) { %w(a ab abs absolute absolutely be bee bees been zoo zoos zebra yuck) }

  describe '#exists?' do
    it 'finds existing single-letter words' do
      subject.exists?('a').should be_true
    end

    it 'finds existing multi-letter words' do
      subject.exists?('ab').should be_true
    end

    it "doesn't find non-existing single-letter words" do
      subject.exists?('e').should be_false
    end

    it "doesn't find non-existing multi-letter words" do
      subject.exists?('eggsactly').should be_false
    end
  end

  describe '#starting_with' do
    it 'finds all words starting with a single letter' do
      words = subject.starting_with('a')
      words.size.should eq 5
      words.should include 'a'
      words.should include 'absolutely'
      words.each { |word| word.should start_with 'a' }
    end

    it 'finds all words starting with multiple letters' do
      words = subject.starting_with('abso')
      words.size.should eq 2
      words.should include 'absolute'
      words.should include 'absolutely'
      words.each { |word| word.should start_with 'a' }
    end

    it 'finds no words starting with unmatched single letter' do
      subject.starting_with('e').should be_empty
    end

    it 'finds no words starting with unmatched multiple letters' do
      subject.starting_with('absolutetastic').should be_empty
    end
  end

  describe '#inspect' do
    specify { subject.inspect.should eq '#<Dictionary>' }
  end

  describe '#to_s' do
    specify { subject.to_s.should eq '#<Dictionary>' }
  end

  describe '.from_file' do
    subject { Dictionary.from_file(dictionary_path, separator) }

    let(:separator) { "\n" }

    shared_examples 'loaded dictionary' do
      it 'loads all words' do
        subject.starting_with('a').size.should eq 5
        subject.starting_with('b').size.should eq 4
        subject.starting_with('y').size.should eq 1
        subject.starting_with('z').size.should eq 3
      end

      it 'does not load nonexistent words' do
        ('c'..'x').each do |letter|
          subject.starting_with(letter).should be_empty
        end
      end
    end

    describe 'with compressed file' do
      describe 'separated by line' do
        let(:dictionary_path) { 'spec/fixtures/compressed_lined.txt.gz' }
        it_behaves_like 'loaded dictionary'
      end

      describe 'separated by pipe' do
        let(:dictionary_path) { 'spec/fixtures/compressed_piped.txt.gz' }
        let(:separator) { '|' }
        it_behaves_like 'loaded dictionary'
      end
    end

    describe 'with uncompressed file' do
      describe 'separated by line' do
        let(:dictionary_path) { 'spec/fixtures/uncompressed_lined.txt' }
        it_behaves_like 'loaded dictionary'
      end

      describe 'separated by pipe' do
        let(:dictionary_path) { 'spec/fixtures/uncompressed_piped.txt' }
        let(:separator) { '|' }
        it_behaves_like 'loaded dictionary'
      end
    end
  end
end
