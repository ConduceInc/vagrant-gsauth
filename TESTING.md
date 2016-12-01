# Testing

No unit testing, since the project is so small. But a full suite of acceptance
tests that run using [Bats: Bash Automated Testing System][bats]! Basically, the
acceptance tests run `vagrant box add GS_URL` with a bunch of GS URLs and box
types, and assert that everything works!

See [the .travis.yml CI configuration](.travis.yml) for a working example.

## Environment variables

You'll need to export the below. Recommended values included when not sensitive.

```bash
# Base name of bucket. Must be unique.
export VAGRANT_GSAUTH_BUCKET="vagrant-gsauth"
# The test box to use. Currently only 1.
export VAGRANT_GSAUTH_BOX_BASE="minimal"
# The Google Cloud project that the tests will create buckets and objects under.
export VAGRANT_GSAUTH_PROJECT="someproject-1234567"
```

[bats]: https://github.com/sstephenson/bats

## Running tests

You'll need [Bats][bats] installed! Then:

```bash
# export env vars as described
$ test/setup.rb
$ rake test
# hack hack hack
$ rake test
$ test/cleanup.rb
```

## Scripts

### test/setup.rb

Creates a Google Cloud Storage bucket with the contents of the box
directory.

### test/cleanup.rb

Destroys GS buckets and objects.

## run.bats

Attempts to `vagrant box add` the boxes from Google Storage.
