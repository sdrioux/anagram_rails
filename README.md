# anagram_rails

##Project

* Rails
* RSpec
* MySQL

## Setup
```
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
```
Data can be loaded into the database from the dictionary.txt file through the rails console.  Seeding the database with the 235889 words in the file takes approximately 10 seconds.
```
rails c
Word.load
```

## Testing
Tests are run with a test database, and fixtures.

```
rspec spec
```
