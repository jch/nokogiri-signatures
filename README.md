# Nokogiri::Signatures

nokogiri enhancement to support [XML digital
signatures](http://www.w3.org/TR/xmldsig-core/).

This gem is based upon [benoist/xmldsig](https://github.com/benoist/xmldsig),
but mixes in the behavior into nokogiri's interface.

## Installation

Add this line to your application's Gemfile:

    gem 'nokogiri-signatures'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nokogiri-signatures

## Usage

First, let's generate a RSA key-pair and a X509 certificate for our examples:

```ruby
require "openssl"

# TODO: generate RSA keypair
# TODO: generate certificate, sign with keypair
```

### Signing

To sign a `Nokogiri::XML::Document`, you need to add `<Signature />` elements to
where you want them in your document. You may add multiple signatures if you
need you are signing different sections of a document. This allows you to have
**enveloped signatures**. For example:

```ruby
document = Nokogiri::XML <<-XML
<OutterDocument>
  <InnerDocument>
  </InnerDocument>
</OutterDocument>
XML

inner = document.at_xpath("//InnerDocument")

# Sign the element `InnerDocument`
inner.add_child(Nokogiri::Signatures.template)

# Then envelope the `OutterDocument` with a different signature
inner.add_previous_sibling(Nokogiri::Signatures.template)
```

With the signature templates in place, we can now sign each `Signature` element.
`certificate` is optional when we sign, but including it allows the message to
have everything we need to verify the document. This will come up again when we
look at how signatures are verified.

```ruby
document.sign(:private_key => private_key, :certificate => certificate)
```

### Verifying signatures

Because we included the `certificate` earlier, we can verify the signature
without specifying it again:

```ruby
document.verify
```

If a signature does not have an embedded certificate, then this example will
raise `Nokogiri::Signatures::NoCertificateError`. You may explicitly specify a
certificate:

```ruby
document.verify(:certificate => certificate)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/nokogiri-signatures/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
