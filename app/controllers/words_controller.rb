class WordsController < ApplicationController

  # @url /words
  # @action POST
  #
  # @required [Array] words - Array of words to add to the corpus.
  #
  # Given an array of words, attempts to add thw words to the corpus.  Will fail
  # silently to add a word if it already exists.
  def create
    Array(params[:words]).each do |word|
      Word.create(sorted_chars: Word.sort(word), chars: word)
    end

    head :created
  end

  # @url /anagrams/:word
  # @url /words/:word/anagrams
  # @action GET
  #
  # @required [String] word - The word to search for.
  #
  # Given a word, returns the anagrams for that word.
  def show
    results = Word
      .where(sorted_chars: Word.sort(params[:word]))
      .where("chars != ?", params[:word])
      .pluck(:chars)

      results = results.first(params[:limit].to_i) if(params[:limit])


    render json: { anagrams: results }
  end

  # @url /words/:word
  # @action DELETE
  #
  # @required [String] word - The word to delete.
  #
  # Delete the word in the corpus if it exists.  Itempotent.
  def destroy
    word = Word.find_by(chars: params[:word])
    word.delete if word

    head :ok
  end

  # @url /words
  # @action DELETE
  #
  # Delete all words from the corpus.
  def destroy_all
    Word.delete_all
    head :no_content
  end

  def stats
    stats = Word.select("MAX(LENGTH(sorted_chars)) as max_length, MIN(LENGTH(sorted_chars)) as min_length, AVG(LENGTH(sorted_chars)) as mean_length, COUNT(*) as word_count").first

    render json: {
      stats: {
        max_length:  stats.max_length,
        min_length:  stats.min_length,
        mean_length: stats.mean_length,
        word_count:  stats.word_count
      }
    }
  end
end
