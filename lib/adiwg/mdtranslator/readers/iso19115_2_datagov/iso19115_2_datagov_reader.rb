# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/module_utils'
require_relative 'version'
require_relative 'modules/module_iso19115_2'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
        @@rootXPath = 'gmi:MI_Metadata | gmd:MD_Metadata'
        def self.readFile(file, hResponseObj) # rubocop:disable Naming/MethodName
          # add Iso19115_2 reader version
          hResponseObj[:readerVersionUsed] = ADIWG::Mdtranslator::Readers::Iso191152datagov::VERSION

          # receive XML file
          if file.nil? || file == ''
            hResponseObj[:readerStructureMessages] << 'ERROR: XML file is missing'
            hResponseObj[:readerStructurePass] = false
            return {}
          end

          # file must be well formed XML
          begin
            xDoc = Nokogiri::XML(file, &:strict)
          rescue Nokogiri::XML::SyntaxError => e
            hResponseObj[:readerStructureMessages] << 'ERROR: XML file is not well formed'
            hResponseObj[:readerStructureMessages] << e.to_s
            hResponseObj[:readerStructurePass] = false
            return {}
          end

          AdiwgUtils.add_iso19115_namespaces(xDoc) # registers in-place

          # file must contain an ISO 19115-2 <gmi:MI_Metadata> tag
          xMetadata = xDoc.xpath(@@rootXPath)[0]
          if xMetadata.nil?
            msg = "ERROR: ISO 19115-2 file did not contain a #{@@rootXPath} tag"
            hResponseObj[:readerValidationMessages] << msg
            hResponseObj[:readerValidationPass] = false
            return {}
          end

          # load Iso19115_2 file into internal object
          Iso191152datagov.unpack(xMetadata, hResponseObj)
        end
      end
    end
  end
end
