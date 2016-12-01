# vagrant-gsauth

<a href="https://travis-ci.org/ConduceInc/vagrant-gsauth">
  <img src="https://travis-ci.org/ConduceInc/vagrant-gsauth.svg?branch=master"
    align="right">
</a>

Private, versioned Vagrant boxes hosted in Google Cloud Storage.

## Installation

From the command line:

```bash
$ vagrant plugin install vagrant-s3auth
```

### Requirements

* [Vagrant][vagrant], v1.5.1+

## Usage

vagrant-gsauth will automatically sign requests for GS URLs

```
gs://bucket/path/to/metadata
```

with your Google Cloud Application Credentials.

This means you can host your team's sensitive, private boxes in Google Storage, and use your
developers' existing Google credentials to securely grant access.

If you've already got your credentials stored in the standard environment
variables:

```ruby
# Vagrantfile

Vagrant.configure('2') do |config|
  config.vm.box     = 'simple-secrets'
  config.vm.box_url = 'gs://example.com/secret.box'
end
```

### Configuration

#### Google Cloud credentials

https://cloud.google.com/sdk/

#### GS URLs

You can use the gs protocol shorthand

```
gs://bucket/resource
```

which expands to full path HTTPS URL.

#### Simple boxes

Simply point your `box_url` at a google storage URL:

```ruby
Vagrant.configure('2') do |config|
  config.vm.box     = 'simple-secrets'
  config.vm.box_url = 'gs://bucket/secret.box'
end
```

#### Metadata (versioned) boxes

[Metadata boxes][metadata-boxes] were added to Vagrant in 1.5 and power Vagrant
Cloud. You can host your own metadata and bypass Vagrant Cloud entirely.

Essentially, you point your `box_url` at a [JSON metadata file][metadata-boxes]
that tells Vagrant where to find all possible versions:

```ruby
# Vagrantfile

Vagrant.configure('2') do |config|
  config.vm.box     = 'examplecorp/secrets'
  config.vm.box_url = 'gs://bucket/secrets'
end
```

```json
"gs://bucket/secrets"

{
  "name": "examplecorp/secrets",
  "description": "This box contains company secrets.",
  "versions": [{
    "version": "0.1.0",
    "providers": [{
      "name": "virtualbox",
      "url": "gs://bucket/secrets/1.0.0/secrets.box",
      "checksum_type": "sha1",
      "checksum": "foo"
    }]
  }]
}
```

**IMPORTANT:** Your metadata *must* be served with `Content-Type: application/json`
or Vagrant will not recognize it as metadata! Most S3 uploader tools (and most
webservers) will *not* automatically set the `Content-Type` header when the file
extension is not `.json`. Consult your tool's documentation for instructions on
manually setting the content type.

## Auto-install

The beauty of Vagrant is the magic of "`vagrant up` and done." Making your users
install a plugin is lame.

But wait! Just stick some shell in your Vagrantfile:

```ruby
unless Vagrant.has_plugin?('vagrant-gsauth')
  # Attempt to install ourself. Bail out on failure so we don't get stuck in an
  # infinite loop.
  system('vagrant plugin install vagrant-gsauth') || exit!

  # Relaunch Vagrant so the plugin is detected. Exit with the same status code.
  exit system('vagrant', *ARGV)
end
```

[metadata-boxes]: http://docs.vagrantup.com/v2/boxes/format.html
[vagrant]: http://vagrantup.com
