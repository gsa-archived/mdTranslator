# frozen_string_literal: true

# MdTranslator - minitest of
# readers / iso19115-3 / module_identification

require 'adiwg/mdtranslator/readers/iso19115_3/modules/module_identification'
require_relative 'iso19115_3_test_parent'

class TestReaderIso191153Identification < TestReaderIso191153Parent
   @@xDoc = TestReaderIso191153Parent.get_xml('iso19115-3.xml')
   @@nameSpace = ADIWG::Mdtranslator::Readers::Iso191153::Identification

   def test_identification_complete
      TestReaderIso191153Parent.set_xdoc(@@xDoc)

      xIn = @@xDoc.xpath('.//mdb:metadataIdentifier')[0]
      hResponse = Marshal.load(Marshal.dump(@@hResponseObj))
      hDictionary = @@nameSpace.unpack(xIn, hResponse)

      refute_empty hDictionary

      assert_equal('57c5c793e4b0f2f0cebdaa4d', hDictionary[:identifier])
      assert_equal('gov.sciencebase.catalog', hDictionary[:namespace])
      assert_equal('test version 1.0', hDictionary[:version])
      assert_equal('USGS ScienceBase Identifier', hDictionary[:description])
   end
end
