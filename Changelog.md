# Change Log

## Branch escape
### DONE
  - [X] `value!` returns the value or raises an exception which is caught by `escape`
  - [X] rename `value!` to `v!`.
    - It looks a little nicer in a void context.
    - I realised the `!` is the `not` operator, so `monad.!` is the same as `!monad` which
      could easily be confused for a binary operator.  `v!` is easy to type and doesn't look
      bad, I think.

## Branch maybe (actually in main :-P)
### DONE
  - [X] Sketch in a `Maybe` class
    - Is `Maybe` a good name?  I guess most people know what it means.
      Rust uses `Option`, which is also good.  Hmm...
  - [X] Tests
    - [X] `Mixin`
    - [X] `Some`
    - [X] `None`
  - [X] Escape
    - This is my version of "Do" notation.  It's closer to Rust's ? operator.
      Basically `monad.!` returns the value in the monad or raises an exception.
      `escape { some(monad.!) }` will catch the exception and return the monad
      that did not have the value.

## Branch setup
### DONE
  - [X] Add a Changelog
  - [X] Test that `!` is a valid identifier in Ruby
    - It's weird that `!` is fine, but `?` is not.
  - [X] Set up stuff
    - [X] ruby
      - Go with Ruby 3.2.2 for no good reason
    - [X] bundler,
    - [X] rubocop
    - [X] rspec,
    - [X] guard,
  - [X] Make a minimal gem
