# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_distributor

require 'adiwg/mdtranslator/readers/iso19115_2_datagov/modules/module_distributor'
require_relative 'iso19115_2_test_parent'

class TestReaderIso191152datagovDistributor < TestReaderIso191152datagovParent
  @@xDoc = TestReaderIso191152datagovParent.get_xml('iso19115-2_distributor.xml')
  @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191152datagov::Distributor

  def test_distributor_complete
    TestReaderIso191152datagovParent.set_xdoc(@@xDoc)

    xIn = @@xDoc.xpath('.//gmd:distributor')[0]
    hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
    hDictionary = @@nameSpace.unpack(xIn, hResponse)

    refute_empty hDictionary
    assert hDictionary.instance_of? Hash
    refute_empty hDictionary[:transferOptions]
    assert hDictionary[:transferOptions].instance_of? Array
    assert_equal(1, hDictionary[:transferOptions].size)

    # distribution formats aren't calculated because they need to be
    # determined based on the url not on what's in the metadata
    assert hDictionary[:transferOptions][0][:distributionFormats].instance_of? Array
    assert_equal(0, hDictionary[:transferOptions][0][:distributionFormats].size)
    assert_equal('http://oneline-resource-url.gov', hDictionary[:transferOptions][0][:onlineOptions][0][:olResURI])
    assert_equal('Online Resource Name', hDictionary[:transferOptions][0][:onlineOptions][0][:olResName])
    assert_equal('Downloadable Data', hDictionary[:transferOptions][0][:onlineOptions][0][:olResDesc])
    assert_equal('WWW:LINK-1.0-http--link', hDictionary[:transferOptions][0][:onlineOptions][0][:olResProtocol])
  end
end
