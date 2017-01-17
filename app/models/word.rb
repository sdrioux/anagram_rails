class Word < ActiveRecord::Base
  validates :chars, uniqueness: true

  def self.sort(chars)
    chars.split('').sort.join
  end

  def self.load
    # uses activerecord-import, imports the entire database in ~10 seconds.
    # Note, bypasses validations.  Make sure database is clean beforehand.

    Word.transaction do
      words_to_import = []
      words = File.read("dictionary.txt").split(/\n/)
      words.each do |word|
        words_to_import << [Word.sort(word), word]
      end

      columns = [:sorted_chars, :chars]

      Word.import columns, words_to_import, validate: false
      # import returns all the data imported, which is a lot of info to put on
      # your console.
      return true
    end
  end
end
