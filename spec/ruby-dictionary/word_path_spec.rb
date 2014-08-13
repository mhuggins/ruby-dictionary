require 'spec_helper'

describe Dictionary::WordPath do
  subject { Dictionary::WordPath.new(case_sensitive) }

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

  describe '#leaf=' do
    it 'should set to false' do
      subject.leaf = false
      expect(subject).not_to be_leaf
    end

    it 'should set to true' do
      subject.leaf = true
      expect(subject).to be_leaf
    end
  end

  describe '#find' do
    describe 'when case-insensitive' do
      before do
        subject << 'potato'
      end

      it 'finds existing word paths of matching case-sensitivity' do
        word_path = subject.find('potat')
        expect(word_path).to be_a Dictionary::WordPath
        expect(word_path).to eq Dictionary::WordPath.new(case_sensitive).tap { |wp| wp << 'o' }
      end

      it 'finds existing word paths of unmatching case-sensitivity' do
        word_path = subject.find('poTAt')
        expect(word_path).to be_a Dictionary::WordPath
        expect(word_path).to eq Dictionary::WordPath.new(case_sensitive).tap { |wp| wp << 'o' }
      end

      it 'does not find nonexistent word paths' do
        expect(subject.find('potable')).to be_nil
      end
    end

    describe 'when case-sensitive' do
      before do
        subject << 'poTAto'
      end

      let(:case_sensitive) { true }

      it 'finds existing word paths of matching case-sensitivity' do
        word_path = subject.find('poTAt')
        expect(word_path).to be_a Dictionary::WordPath
        expect(word_path).to eq Dictionary::WordPath.new(case_sensitive).tap { |wp| wp << 'o' }
      end

      it 'does not find existing word paths of unmatching case-sensitivity' do
        expect(subject.find('potat')).to be_nil
      end

      it 'does not find nonexistent word paths' do
        expect(subject.find('potat')).to be_nil
      end
    end
  end

  describe '#<<' do
    before do
      subject << 'potato'
    end

    describe 'when case-insensitive' do
      it 'appends case-insensitive word to word path' do
        expect(subject.find('potato')).to be_a Dictionary::WordPath
        expect(subject.find('poTAto')).to eq subject.find('potato')
      end
    end

    describe 'when case-sensitive' do
      let(:case_sensitive) { true }

      it 'appends case-sensitive word to word path' do
        expect(subject.find('potato')).to be_a Dictionary::WordPath
        expect(subject.find('poTAto')).to be_nil
      end
    end
  end

  describe '#suffixes' do
    before do
      subject << 'pot'
      subject << 'poTAto'
      subject << 'potABle'
      subject << 'POTTY'
      subject << 'pert'
      subject << 'jar'
    end

    describe 'when case-insensitive' do
      it 'finds all words with the given suffix' do
        word = subject.find('pot')
        expect(word.suffixes).to eq %w(ato able ty)
      end
    end

    describe 'when case-sensitive' do
      let(:case_sensitive) { true }

      it 'finds all words with the given suffix' do
        word = subject.find('pot')
        expect(word.suffixes).to eq %w(ABle)
      end
    end
  end
end
