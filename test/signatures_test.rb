require "nokogiri/signatures"
require "minitest/autorun"

class Nokogiri::SignaturesTest < Minitest::Test
  PRIVATE_KEY = OpenSSL::PKey::RSA.new(File.read(File.expand_path("../private_key.pem", __FILE__)))
  CERTIFICATE = OpenSSL::X509::Certificate.new(File.read(File.expand_path("../certificate.pem", __FILE__)))

  def test_signatures
    doc = Nokogiri::XML <<-XML
    <Outter>
      <Inner />
    </Outter>
    XML

    inner = doc.at_xpath("//Inner")
    inner.add_child(Nokogiri::Signatures.template)
    inner.add_previous_sibling(Nokogiri::Signatures.template)

    signatures = doc.signatures
    assert_equal 2, signatures.size

    assert_equal "Inner", signatures[0].parent.name
    assert_equal "Outter", signatures[1].parent.name

    assert_equal 1, inner.signatures.size
  end
end
