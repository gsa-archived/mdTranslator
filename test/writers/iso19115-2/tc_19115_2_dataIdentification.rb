# MdTranslator - minitest of
# writers / iso19115_2 / class_dataIdentification

# History:
#   Stan Smith 2016-12-20 original script

require 'minitest/autorun'
require 'json'
require 'rexml/document'
require 'adiwg/mdtranslator'
include REXML

class TestWriter191152DataIdentification < MiniTest::Test

   # read the ISO 19115-2 reference file
   fname = File.join(File.dirname(__FILE__), 'resultXML', '19115_2_dataIdentification.xml')
   file = File.new(fname)
   iso_xml = Document.new(file)
   @@aRefXML = []
   XPath.each(iso_xml, '//gmd:identificationInfo') {|e| @@aRefXML << e}

   # read the mdJson 2.0 file
   fname = File.join(File.dirname(__FILE__), 'testData', '19115_2_dataIdentification.json')
   file = File.open(fname, 'r')
   @@mdJson = file.read
   file.close

   def test_19115_2_dataIdentification

      hResponseObj = ADIWG::Mdtranslator.translate(
         file: @@mdJson, reader: 'mdJson', writer: 'iso19115_2', showAllTags: true
      )

      metadata = hResponseObj[:writerOutput]
      iso_out = Document.new(metadata)

      checkXML = XPath.first(iso_out, '//gmd:identificationInfo')

      assert_equal @@aRefXML[0].to_s.squeeze, checkXML.to_s.squeeze

   end

end
