# Dictionary

[![Build Status](https://secure.travis-ci.org/mhuggins/ruby-dictionary.png)](http://travis-ci.org/mhuggins/ruby-dictionary)
[![Code Climate](https://codeclimate.com/github/mhuggins/ruby-dictionary.png)](https://codeclimate.com/github/mhuggins/ruby-dictionary)

[ruby-dictionary](https://github.com/mhuggins/ruby-dictionary) provides a
simple dictionary that allows for checking existence of words and finding a
subset of words given a prefix.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-dictionary'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-dictionary

## Usage

A dictionary is created by passing an array of strings to the initializer.

    dictionary = Dictionary.new(%w(a ab abs absolute absolutes absolutely
                                   absolve be bee been bees bend bent best))

Alternatively, words can be read in from a file (raw or gzip compressed) as
well.

    dictionary = Dictionary.from_file('path/to/uncompressed.txt')
    dictionary = Dictionary.from_file('path/to/compressed.txt.gz')

It is assumed that the file contains one word per line.  However, a separator
can be passed to the method as an optional second parameter if that's not the
case.

    dictionary = Dictionary.from_file('path/to/uncompressed.txt', ' ')
    dictionary = Dictionary.from_file('path/to/compressed.txt.gz', ',')

Once a dictionary is loaded, the `#exists?` method can be used to determine if
a word exists.

    dictionary.exists?('bees')       # => true
    dictionary.exists?('wasps')      # => false

The `#starting_with` method returns a sorted array of all words starting with
the provided string.

    dictionary.starting_with('bee')  # => ["bee", "been", "bees"]
    dictionary.starting_with('foo')  # => []

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
