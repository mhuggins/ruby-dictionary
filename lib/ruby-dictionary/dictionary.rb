# encoding: utf-8

require 'zlib'
require 'ruby-dictionary/word_path'

class Dictionary
  def initialize(word_list, case_sensitive = false)
    @word_path = parse_words(word_list, case_sensitive)
  end

  def case_sensitive?
    @word_path.case_sensitive?
  end

  def exists?(word)
    path = word_path(word)
    !!(path && path.leaf?)
  end

  def starting_with(prefix)
    prefix = prefix.to_s.strip
    prefix = prefix.downcase unless case_sensitive?

    path = word_path(prefix)
    return [] if path.nil?

    words = [].tap do |words|
      words << prefix if path.leaf?
      words.concat(path.suffixes.collect! { |suffix| "#{prefix}#{suffix}" })
    end

    words.sort!
  end

  def prefixes(string)
    string = string.to_s.strip
    string = string.downcase unless case_sensitive?

    @word_path.find_prefixes(string).sort
  end


  def hash
    self.class.hash ^ @word_path.hash
  end

  def ==(obj)
    obj.class == self.class && obj.hash == self.hash
  end

  def inspect
    "#<#{self.class.name}>"
  end

  def to_s
    inspect
  end

  def self.from_file(path, separator = "\n", case_sensitive = false)
    contents = case path
                 when String then File.read(path)
                 when File then path.read
                 else raise ArgumentError, 'path must be a String or File'
               end

    if contents.start_with?("\x1F\x8B")
      gz = Zlib::GzipReader.new(StringIO.new(contents))
      contents = gz.read
    end

    new(contents.split(separator), case_sensitive)
  end

  private

  def parse_words(word_list, case_sensitive)
    raise ArgumentError, 'word_list should be an array of strings' unless word_list.kind_of?(Array)

    WordPath.new(case_sensitive).tap do |word_path|
      word_list.each { |word| word_path << word.to_s }
    end
  end

  def word_path(str)
    @word_path.find(str)
  end
end
