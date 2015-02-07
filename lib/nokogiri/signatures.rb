require "nokogiri/signatures/version"
require "nokogiri"
require "openssl"

module Nokogiri
  module Signatures
    NAMESPACES = {
      "ds" => "http://www.w3.org/2000/09/xmldsig#"
    }.freeze

    TEMPLATE_SIGNATURE = Nokogiri::XML.fragment <<-XML
      <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:SignedInfo>
          <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
          <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
          <ds:Reference>
            <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>
            <ds:DigestValue />
          </ds:Reference>
        </ds:SignedInfo>
        <ds:SignatureValue />
      </ds:Signature>
    XML

    # Public: Returns an instance of Nokogiri::XML::DocumentFragment of a
    # template `Signature` element. This can then be inserted into a document.
    def self.template
      TEMPLATE_SIGNATURE.dup
    end

    # Public: Returns array of Nokogiri::XML::Element's in reverse order.
    #
    # I'm not sure why the order is reversed, but I'm basing this on
    # benoist/xmldsig gem implementation. My guess is that enveloped signatures
    # would need inner signatured signed before outter ones.
    def signatures
      xpath("descendant::ds:Signature", NAMESPACES).reverse
    end
  end
end

Nokogiri::XML::Node.send(:include, Nokogiri::Signatures)
