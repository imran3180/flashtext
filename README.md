# Flashtext Ruby Gem

### Ruby (zero dependencies) gem for amazing Python package [flashtext](https://github.com/vi3k6i5/flashtext)

This module can be used to replace keywords in sentences or extract keywords from sentences. It is based on the [FlashText algorithm](https://arxiv.org/abs/1711.00046)

#### More about Flashtext algorithm.
The original paper published on [FlashText algorithm](https://arxiv.org/abs/1711.00046>)

The article published on [Medium freeCodeCamp](https://medium.freecodecamp.org/regex-was-taking-5-days-flashtext-does-it-in-15-minutes-55f04411025f)


Installation
------------
    $ gem install flashtext


API doc
-------

Documentation can be found at [FlashText Read the Docs](http://www.rubydoc.info/gems/flashtext/)

## Usage
#### Extract keywords
```ruby
keyword_processor = Flashtext::KeywordProcessor.new
# keyword_processor.add_keyword(<unclean name>, <standardised name>)
keyword_processor.add_keyword('Big Apple', 'New York')
keyword_processor.add_keyword('Bay Area')
keywords_found = keyword_processor.extract_keywords('I love Big Apple and Bay Area.')
keywords_found
#=> ["New York", "Bay Area"]
```

#### Replace keywords
```ruby
keyword_processor.add_keyword('New Delhi', 'NCR region')
new_sentence = keyword_processor.replace_keywords('I love Big Apple and new delhi.')
new_sentence
#=> "I love New York and NCR region."
```

#### Replace keywords
```ruby
keyword_processor = Flashtext::KeywordProcessor.new(case_sensitive = true)
keyword_processor.add_keyword('Big Apple', 'New York')
keyword_processor.add_keyword('Bay Area')
keywords_found = keyword_processor.extract_keywords('I love big Apple and Bay Area.')
keywords_found
#=> ['Bay Area']
```


Test
----------
```ruby
rspec spec
```

Contribute
----------

- Issue Tracker: https://github.com/imran3180/flashtext/issues
- Source Code: https://github.com/imran3180/flashtext/issues

Implementation in other languages
---------------------------------

- Python: https://github.com/vi3k6i5/flashtext (Core Project)
- JavaScript: https://github.com/drenther/flashtext.js
- Golang: https://github.com/sundy-li/flashtext


## License

This code is under MIT license.
