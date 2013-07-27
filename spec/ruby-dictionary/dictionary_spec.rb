require 'spec_helper'

describe Dictionary do
  subject { Dictionary.new(word_list, case_sensitive) }

  let(:word_list) { %w(a ab abs absolute absolutely be bee bees been zoo zoos zebra yuck) }
  let(:case_sensitive) { false }

  describe '#case_sensitive?' do
    describe 'when case-insensitive' do
      it { should_not be_case_sensitive }
    end

    describe 'when case-sensitive' do
      let(:case_sensitive) { true }

      it { should be_case_sensitive }
    end
  end

  describe '#exists?' do
    describe 'when case-insensitive' do
      it 'finds existing single-letter words regardless of casing' do
        subject.exists?('a').should be_true
        subject.exists?('A').should be_true
      end

      it 'finds existing multi-letter words regardless of casing' do
        subject.exists?('ab').should be_true
        subject.exists?('AB').should be_true
      end

      it "doesn't find non-existing single-letter words regardless of casing" do
        subject.exists?('e').should be_false
        subject.exists?('E').should be_false
      end

      it "doesn't find non-existing multi-letter words regardless of casing" do
        subject.exists?('eggsactly').should be_false
        subject.exists?('EGGSACTLY').should be_false
      end
    end

    describe 'when case-sensitive' do
      let(:case_sensitive) { true }

      it 'finds existing single-letter words of the same casing' do
        subject.exists?('a').should be_true
      end

      it 'finds existing multi-letter words of the same casing' do
        subject.exists?('ab').should be_true
      end

      it "doesn't find existing single-letter words of a different casing" do
        subject.exists?('A').should be_false
      end

      it "doesn't find existing multi-letter words of a different casing" do
        subject.exists?('AB').should be_false
      end

      it "doesn't find non-existing single-letter words of any casing" do
        subject.exists?('e').should be_false
        subject.exists?('E').should be_false
      end

      it "doesn't find non-existing multi-letter words of any casing" do
        subject.exists?('eggsactly').should be_false
        subject.exists?('EGGSACTLY').should be_false
      end
    end
  end

  describe '#starting_with' do
    describe 'when case-insensitive' do
      it 'finds all words starting with a single letter regardless of casing' do
        %w(a A).each do |prefix|
          subject.starting_with(prefix).should eq %w(a ab abs absolute absolutely)
        end
      end

      it 'finds all words starting with multiple letters regardless of casing' do
        %w(abso ABSO).each do |prefix|
          subject.starting_with(prefix).should eq %w(absolute absolutely)
        end
      end

      it 'finds no words starting with unmatched single letter regardless of casing' do
        %w(e E).each do |prefix|
          subject.starting_with(prefix).should be_empty
        end
      end

      it 'finds no words starting with unmatched multiple letters regardless of casing' do
        %w(absolutetastic ABSOLUTETASTIC).each do |prefix|
          subject.starting_with(prefix).should be_empty
        end
      end
    end

    describe 'when case-sensitive' do
      let(:case_sensitive) { true }

      it 'finds all words starting with a single letter of the same casing' do
        subject.starting_with('a').should eq %w(a ab abs absolute absolutely)
        subject.starting_with('A').should be_empty
      end

      it 'finds all words starting with multiple letters of the same casing' do
        subject.starting_with('abso').should eq %w(absolute absolutely)
        subject.starting_with('ABSO').should be_empty
      end

      it 'finds no words starting with unmatched single letter of the same casing' do
        subject.starting_with('e').should be_empty
        subject.starting_with('E').should be_empty
      end

      it 'finds no words starting with unmatched multiple letters of the same casing' do
        subject.starting_with('absolutetastic').should be_empty
        subject.starting_with('ABSOLUTETASTIC').should be_empty
      end
    end
  end

  describe '#inspect' do
    specify { subject.inspect.should eq '#<Dictionary>' }
  end

  describe '#to_s' do
    specify { subject.to_s.should eq '#<Dictionary>' }
  end

  describe '.from_file' do
    subject { Dictionary.from_file(dictionary_path, separator, case_sensitive) }

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

      describe 'when case-insensitive' do
        let(:case_sensitive) { false }
        it { should_not be_case_sensitive }
      end

      describe 'when case-sensitive' do
        let(:case_sensitive) { true }
        it { should be_case_sensitive }
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
