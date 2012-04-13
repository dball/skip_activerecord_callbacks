# Skip ActiveRecord Callbacks

[![Build Status](https://secure.travis-ci.org/dball/skip_activerecord_callbacks.png)](http://travis-ci.org/dball/skip_activerecord_callbacks)

Do you miss update_without_callbacks from Rails 2? You shouldn't,
because ActiveRecord callbacks are not a particularly good way to
implement system behavior. If you have to skip them routinely in the
course of doing business, something smells.

If you're upgrading a Rails 2 app though, you've probably got a bunch of
smells to contend with, so this plugin lets you put off the inevitable a
little while longer. I'm sorry.

## Usage

    product.update_without_callbacks

## Implementation

The `update_without_callbacks` method edits the model's metaclass, hides
the original `run_callbacks` method, and inserts a replacement. The
replacement method calls the original, unless its argument is `:save`, in
which case it deletes itself, replaces the original `run_callbacks`
method, and yields to the given block to do the work of saving the
model.

## Seriously?

Yeah. But it seems to work just fine. The undecoration is the first
thing that happens when running the `:save` callbacks, so it would seem
the only way this could not work is if ActiveRecord failed to call the
`run_callbacks` method on save, or if ActiveSupport needed to call the
method twice in a save for some reason. Or if ActiveSupport stopped
implementing callbacks with the `run_callbacks method`, but the tests
should catch that.
