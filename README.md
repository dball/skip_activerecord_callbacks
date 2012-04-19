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
    product.destroy_without_callbacks

## Implementation

The `update_without_callbacks` method edits the model's metaclass, hides
the original `run_callbacks` method, and inserts a replacement. The
replacement method calls the original, unless its argument is `:save`, in
which case it deletes itself, replaces the original `run_callbacks`
method, and yields to the given block to do the work of saving the
model.

The `destroy_without_callbacks` method does the same ninja editing for
`destroy`.

## Seriously?

Yeah, I know. But it seems to work just fine. The undecoration is the first
thing that happens when running the `:save` callbacks, so it would seem
the only way this could not work is if ActiveRecord failed to call the
`run_callbacks` method on save, or if ActiveSupport needed to call the
method twice in a save for some reason. Or if ActiveSupport stopped
implementing callbacks with the `run_callbacks method`, but the tests
should catch that.

## What Could Possibly Go Wrong?

`destroy_without_callbacks` seems to behave a little bit differently
than the Rails 2 version. In Rails 2, it would apparently not call the
model's `destroy` method if it happened to define one. In the project
for which I wrote this, we had a guard protecting models from being
destroyed except via `destroy_without_callbacks`:

    def destroy
      raise "hell"
    end

This is trivially fixable by moving the guard to a `before_destroy`
callback, or more correctly by moving the persistent object lifecycle
concerns up into a service model.

`update_without_callbacks` used to save the model without updating its
dirty attribute changes hash. This is no longer the case. I regard the
new behavior as more correct, to the extent that a hack built on a pile
of hacks can be considered to exhibit correctness, but if it's
problematic, it would be relatively easy to clone the changes hash and
push it back afterwards.
