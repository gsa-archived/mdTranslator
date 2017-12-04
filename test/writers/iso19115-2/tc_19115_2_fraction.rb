# MdTranslator - minitest of
# writers / iso19115_2 / class_fraction

# History:
#  Stan Smith 2017-11-19 replace REXML with Nokogiri
#  Stan Smith 2017-01-02 original script

require 'minitest/autorun'
require 'json'
require 'adiwg/mdtranslator'
require_relative 'iso19115_2_test_parent'

class TestWriter191152Fraction < TestWriter191152Parent

   # read the ISO 19110 reference file
   @@xFile = TestWriter191152Parent.get_xml('19115_2_fraction.xml')

   # read the mdJson 2.0 file
   @@mdJson = TestWriter191152Parent.get_json('19115_2_fraction.json')

   def test_19115_2_aggregateInfo

      axExpect = @@xFile.xpath('//gmd:equivalentScale')

      hResponseObj = ADIWG::Mdtranslator.translate(
         file: @@mdJson, reader: 'mdJson', writer: 'iso19115_2', showAllTags: true
      )

      xMetadata = Nokogiri::XML(hResponseObj[:writerOutput])
      axGot = xMetadata.xpath('//gmd:equivalentScale')

      axExpect.length.times {|i|
         assert_equal axExpect[i].to_s.squeeze(' '), axGot[i].to_s.squeeze(' ')
      }

   end

end
