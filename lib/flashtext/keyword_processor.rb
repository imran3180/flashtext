module Flashtext
  class KeywordProcessor
    require 'set'

    attr_accessor :_keyword, :_white_space_chars, :keyword_trie_hash, :case_sensitive, :word_boundaries

    def initialize case_sensitive = false
      self._keyword = '_keyword_'
      self._white_space_chars = Set.new(['.', '\t', '\n', '\a', ' ', ','])
      self.keyword_trie_hash = {}
      self.case_sensitive = case_sensitive
      self.word_boundaries = Set.new("0".upto("9").to_a + "A".upto("Z").to_a + "a".upto("z").to_a + ["_"])
    end

    def add_keyword keyword, clean_name = nil
      if not clean_name and keyword
        clean_name = keyword
      end

      if keyword and clean_name
        keyword = keyword.downcase if not case_sensitive
        current_hash = keyword_trie_hash
        keyword.each_char do |char|
          current_hash =  if current_hash.has_key?(char)
                            current_hash[char]
                          else
                            current_hash[char] = {}
                            current_hash[char]
                          end
        end
        current_hash[_keyword] = clean_name
      end
    end

    def add_keywords_from_hash keyword_hash
      raise ArgumentError, "#{keyword_hash} is not hash. argument expected: Hash" unless keyword_hash.instance_of?(Hash)
      keyword_hash.each do |clean_name, keywords|
        raise ArgumentError, "#{keyword_hash['clean_name']} is not array. expected: Array" unless keywords.instance_of?(Array)
        keywords.each do |keyword|
          add_keyword(keyword.to_s, clean_name.to_s)
        end
      end
    end

    def extract_keywords sentence
      keywords_extracted = []
      keywords_extracted if not sentence #if sentence is empty or none just return empty list
      sentence = sentence.downcase if not case_sensitive
      current_hash = keyword_trie_hash

      sequence_end_pos = 0
      idx = 0
      sentence_len = sentence.length

      while idx < sentence_len
        char = sentence[idx]
        # when we reach a character that might denote word end
        if not word_boundaries.member?(char)
          # If end is present OR ?? (confused)
          if current_hash.has_key?(_keyword) or current_hash.has_key?(char)
            # Update longest sequence found
            sequence_found = nil
            longest_sequence_found = nil
            is_longer_seq_found = false

            if current_hash.has_key?(_keyword)
              sequence_found = current_hash[_keyword]
              longest_sequence_found = current_hash[_keyword]
              sequence_end_pos = idx
            end

            # re look for longest_sequence from this position
            if current_hash.has_key?(char)
              current_hash_continued = current_hash[char]

              idy = idx + 1
              while idy < sentence_len
                inner_char = sentence[idy]
                if not word_boundaries.member?(inner_char) and current_hash_continued.has_key?(_keyword)
                  # update longest sequence found. This will keep updating longest_sequence if exists.
                  longest_sequence_found = current_hash_continued[_keyword]
                  sequence_end_pos = idy
                  is_longer_seq_found = true
                end
                if current_hash_continued.has_key?(inner_char)
                  current_hash_continued = current_hash_continued[inner_char]
                else
                  break
                end
                idy = idy + 1
              end
              # checked for end of sentenance
              if idy == sentence_len and current_hash_continued.has_key?(_keyword)
                # Update longest sequence found
                longest_sequence_found = current_hash_continued[_keyword]
                sequence_end_pos = idy
                is_longer_seq_found = true
              end
              idx = sequence_end_pos if is_longer_seq_found
            end
            current_hash = keyword_trie_hash # reset
            if longest_sequence_found
              keywords_extracted << longest_sequence_found
            end
          else
            # reset current_hash
            current_hash = keyword_trie_hash
          end
        elsif current_hash.has_key?(char)
          # we can continue from this char
          current_hash = current_hash[char]
        else
          # we reset current_hash
          current_hash = keyword_trie_hash
          # skip to end of keyword
          while idx < sentence_len
            char = sentence[idx]
            break if not word_boundaries.member?(char)
            idx = idx + 1
          end
        end
        # if we are end of sentence and have a sequence discovered
        if idx + 1 >= sentence_len
          if current_hash.has_key?(_keyword)
            sequence_found = current_hash[_keyword]
            keywords_extracted << sequence_found
          end
        end
        idx = idx + 1 # loop increment.
      end
      keywords_extracted
    end
  end
end