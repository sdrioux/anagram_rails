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

    head :ok
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
end
