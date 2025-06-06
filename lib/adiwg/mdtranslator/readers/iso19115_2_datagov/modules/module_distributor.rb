# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_transfer'
require_relative 'module_format'

module ADIWG
  module Mdtranslator
    module Readers
      module Iso191152datagov
        module Distributor
          @@distributorXPath = 'gmd:MD_Distributor'
          @@distributorTransferOptionsXpath = 'gmd:distributorTransferOptions'
          @@distributorFormatOptionsXpath = 'gmd:distributorFormat'
          def self.unpack(xDistributor, hResponseObj)
            intMetadataClass = InternalMetadata.new
            hDistributor = intMetadataClass.newDistributor

            # MD_Distributor (optional)
            # <xs:sequence minOccurs="0">
            #   <xs:element ref="gmd:MD_Distributor"/>
            # </xs:sequence>
            xMdDistributor = xDistributor.xpath(@@distributorXPath)[0]
            return nil if xMdDistributor.nil?

            # distributorTransferOptions (optional)
            # <xs:element name="distributorTransferOptions" type="gmd:MD_DigitalTransferOptions_PropertyType"
            # minOccurs="0" maxOccurs="unbounded"/>
            xDistrTransferOptions = xMdDistributor.xpath(@@distributorTransferOptionsXpath)
            hDistributor[:transferOptions] = xDistrTransferOptions.map do |t|
              Transfer.unpack(t, hResponseObj)
            end.compact

            # distributorFormat (optional)
            # <xs:element name="distributorFormat" type="gmd:MD_Format_PropertyType"
            # minOccurs="0" maxOccurs="unbounded"/>

            # distribution formats aren't processed in this application so
            # empty strings are used instead.
            xDistrFormats = xMdDistributor.xpath(@@distributorFormatOptionsXpath)
            unless xDistrFormats.empty?
              distributionFormats = xDistrFormats.map { |f| Format.unpack(f, hResponseObj) }.compact
              if !distributionFormats.empty? && !hDistributor[:transferOptions].empty?
                hDistributor[:transferOptions].map.with_index do |opts, _|
                  opts[:distributionFormats] = []
                end
              end
            end

            # TODO: (not required by dcatus writer)
            # :distributorContact (required, but not by DCAT-US)
            # <xs:element name="distributorContact" type="gmd:CI_ResponsibleParty_PropertyType"/>

            # :distributionOrderProcess (optional)
            # <xs:element name="distributionOrderProcess"
            #   type="gmd:MD_StandardOrderProcess_PropertyType" minOccurs="0" maxOccurs="unbounded"/>

            hDistributor
          end
        end
      end
    end
  end
end
