require 'rails_helper'

RSpec.describe WordsController, type: :controller do
  describe "adding one or more words to the corpus" do
    it "adds the words if they dont already exist" do
      expect {
        post :create, words: ['silent', 'enlist']
      }.to change {
        Word.count
      }.by(2)

      expect(response.status).to eql(200)
    end

    it "succeeds if one or more words are already in the corpus" do
      expect {
        # should create the words enlist and silent, and fail on read
        post :create, words: ['silent', 'enlist', 'read']
      }.to change {
        Word.count
      }.by(2)

      expect(response.status).to eql(200)
    end
  end

  describe "fetching anagrams for a word" do
    it "returns the anagrams for the given word" do
      get :show, word: 'dare'

      result = JSON.parse(response.body)
      expect(result["anagrams"].sort).to eql(['dear', 'read'])
    end

    it "returns an empty array if the word is not in the dictionary" do
      get :show, word: 'snufflufagus'

      result = JSON.parse(response.body)
      expect(result["anagrams"]).to eql([])
    end
  end

  describe "deleting a word from the corpus" do
    it "deletes the word if it exists" do
      delete :destroy, word: 'read'
      word = Word.find_by(chars: 'read')
      expect(response.status).to eql(200)
      expect(word).to be_nil
    end

    it "sends a 200 if the word does not exist in the dictionary" do
      delete :destroy, word: 'supercalifragilisticexpialidocious'
      expect(response.status).to eql(200)
    end
  end

  describe "deleting all words from the corpus" do
    it "deletes all words" do
      delete :destroy_all
      count = Word.count
      expect(response.status).to eql(204)
      expect(Word.count).to eql(0)
    end
  end
end
