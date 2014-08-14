class Dictionary
  class WordPath
    def initialize(case_sensitive)
      @case_sensitive = !!case_sensitive
      @is_leaf = false
      @word_paths = {}
    end

    def case_sensitive?
      @case_sensitive
    end

    def leaf?
      @is_leaf
    end

    def leaf=(is_leaf)
      @is_leaf = !!is_leaf
    end

    def <<(word)
      raise ArgumentError, 'must be a string' unless word.kind_of?(String)
      word = word.downcase unless @case_sensitive
      _append(word.strip)
    end

    def find(word)
      raise ArgumentError, 'must be a string' unless word.kind_of?(String)
      word = word.downcase unless @case_sensitive
      _find(word.strip)
    end

    def suffixes
      [].tap do |suffixes|
        @word_paths.each do |letter, path|
          suffixes << letter if path.leaf?
          suffixes.concat(path.suffixes.collect { |suffix| "#{letter}#{suffix}" })
        end
      end
    end

    def find_prefixes(string)
      raise ArgumentError, 'must be a string' unless string.kind_of?(String)
      string = string.downcase unless @case_sensitive
      _find_prefixes(string.strip)
    end


    def hash
      self.class.hash ^ @is_leaf.hash ^ @word_paths.hash ^ @case_sensitive.hash
    end

    def ==(obj)
      obj.class == self.class && obj.hash == self.hash
    end

    def inspect
      "#<WordPath @is_leaf=#@is_leaf @word_paths={#{@word_paths.keys.join(',')}}>"
    end

    def to_s
      inspect
    end

    protected

    def _find(word)
      word_path = @word_paths[word[0]]
      return nil unless word_path

      if word.size == 1
        word_path
      else
        word_path._find(word[1, word.size])
      end
    end

    def _find_prefixes(str)
      char = str[0]

      word_path = @word_paths[char]
      return [] unless word_path

      [].tap do |prefixes|
        prefixes << char if word_path.leaf?
        prefixes.concat(word_path._find_prefixes(str[1, str.size]).collect { |prefix| "#{char}#{prefix}" })
      end
    end

    def _append(word)
      return if word.empty?

      char = word[0]
      word_path = @word_paths[char] ||= self.class.new(@case_sensitive)

      if word.size == 1
        word_path.leaf = true
      else
        word_path._append(word[1, word.size])
      end
    end
  end
end
