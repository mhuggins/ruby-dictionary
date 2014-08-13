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
        expect(subject.exists?('a')).to be_truthy
        expect(subject.exists?('A')).to be_truthy
      end

      it 'finds existing multi-letter words regardless of casing' do
        expect(subject.exists?('ab')).to be_truthy
        expect(subject.exists?('AB')).to be_truthy
      end

      it "doesn't find non-existing single-letter words regardless of casing" do
        expect(subject.exists?('e')).to be_falsey
        expect(subject.exists?('E')).to be_falsey
      end

      it "doesn't find non-existing multi-letter words regardless of casing" do
        expect(subject.exists?('eggsactly')).to be_falsey
        expect(subject.exists?('EGGSACTLY')).to be_falsey
      end
    end

    describe 'when case-sensitive' do
      let(:case_sensitive) { true }

      it 'finds existing single-letter words of the same casing' do
        expect(subject.exists?('a')).to be_truthy
      end

      it 'finds existing multi-letter words of the same casing' do
        expect(subject.exists?('ab')).to be_truthy
      end

      it "doesn't find existing single-letter words of a different casing" do
        expect(subject.exists?('A')).to be_falsey
      end

      it "doesn't find existing multi-letter words of a different casing" do
        expect(subject.exists?('AB')).to be_falsey
      end

      it "doesn't find non-existing single-letter words of any casing" do
        expect(subject.exists?('e')).to be_falsey
        expect(subject.exists?('E')).to be_falsey
      end

      it "doesn't find non-existing multi-letter words of any casing" do
        expect(subject.exists?('eggsactly')).to be_falsey
        expect(subject.exists?('EGGSACTLY')).to be_falsey
      end
    end
  end

  describe '#starting_with' do
    describe 'when case-insensitive' do
      it 'finds all words starting with a single letter regardless of casing' do
        %w(a A).each do |prefix|
          expect(subject.starting_with(prefix)).to eq %w(a ab abs absolute absolutely)
        end
      end

      it 'finds all words starting with multiple letters regardless of casing' do
        %w(abso ABSO).each do |prefix|
          expect(subject.starting_with(prefix)).to eq %w(absolute absolutely)
        end
      end

      it 'finds no words starting with unmatched single letter regardless of casing' do
        %w(e E).each do |prefix|
          expect(subject.starting_with(prefix)).to be_empty
        end
      end

      it 'finds no words starting with unmatched multiple letters regardless of casing' do
        %w(absolutetastic ABSOLUTETASTIC).each do |prefix|
          expect(subject.starting_with(prefix)).to be_empty
        end
      end
    end

    describe 'when case-sensitive' do
      let(:case_sensitive) { true }

      it 'finds all words starting with a single letter of the same casing' do
        expect(subject.starting_with('a')).to eq %w(a ab abs absolute absolutely)
        expect(subject.starting_with('A')).to be_empty
      end

      it 'finds all words starting with multiple letters of the same casing' do
        expect(subject.starting_with('abso')).to eq %w(absolute absolutely)
        expect(subject.starting_with('ABSO')).to be_empty
      end

      it 'finds no words starting with unmatched single letter of the same casing' do
        expect(subject.starting_with('e')).to be_empty
        expect(subject.starting_with('E')).to be_empty
      end

      it 'finds no words starting with unmatched multiple letters of the same casing' do
        expect(subject.starting_with('absolutetastic')).to be_empty
        expect(subject.starting_with('ABSOLUTETASTIC')).to be_empty
      end
    end
  end

  describe '#inspect' do
    specify { expect(subject.inspect).to eq '#<Dictionary>' }
  end

  describe '#to_s' do
    specify { expect(subject.to_s).to eq '#<Dictionary>' }
  end

  describe '.from_file' do
    subject { Dictionary.from_file(dictionary_path, separator, case_sensitive) }

    let(:separator) { "\n" }

    shared_examples 'loaded dictionary' do
      it 'loads all words' do
        expect(subject.starting_with('a').size).to eq 5
        expect(subject.starting_with('b').size).to eq 4
        expect(subject.starting_with('y').size).to eq 1
        expect(subject.starting_with('z').size).to eq 3
      end

      it 'does not load nonexistent words' do
        ('c'..'x').each do |letter|
          expect(subject.starting_with(letter)).to be_empty
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
