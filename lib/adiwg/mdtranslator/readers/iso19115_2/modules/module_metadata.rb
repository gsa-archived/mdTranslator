# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_resource_info'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191152
            module Metadata
               @@identificationInfoXPath = 'gmd:identificationInfo'
               @@dataIdentificationXPath = 'gmd:MD_DataIdentification'
               @@fileIdentifierXPath = 'gmd:fileIdentifier//gco:CharacterString'
               @@parentIdentifierXPath = 'gmd:parentIdentifier//gco:CharacterString'
               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new
                  intMetadata = intMetadataClass.newMetadata

                  # :metadataInfo

                  # <xs:element name="identificationInfo"
                  # type="gmd:MD_Identification_PropertyType" maxOccurs="unbounded"/>
                  # TODO: what happens when >1 are present?
                  xIdentificationInfo = xMetadata.xpath(@@identificationInfoXPath)[0]
                  if xIdentificationInfo.nil?
                     msg = "ERROR: ISO19115-2 reader: element \'#{@@identificationInfoXPath}\'" \
                     " is missing in #{xMetadata.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return intMetadata
                  end

                  # <xs:element name="MD_DataIdentification" type="gmd:MD_DataIdentification_Type"
                  # substitutionGroup="gmd:AbstractMD_Identification"/>
                  xDataIdentification = xIdentificationInfo.xpath(@@dataIdentificationXPath)[0]
                  if xDataIdentification.nil?
                     msg = "ERROR: ISO19115-2 reader: element \'#{@@dataIdentificationXPath}\' " \
                     "is missing in #{xIdentificationInfo.name}"
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return intMetadata
                  end

                  intMetadata[:resourceInfo] = ResourceInformation.unpack(xDataIdentification, hResponseObj)

                  # <xs:element name="fileIdentifier" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  fileIdentifier = xMetadata.xpath(@@fileIdentifierXPath)[0]
                  intMetadata[:fileIdentifier] = fileIdentifier.text unless fileIdentifier.nil?

                  # <xs:element name="parentIdentifier" type="gco:CharacterString_PropertyType" minOccurs="0"/>
                  parentIdentifier = xMetadata.xpath(@@parentIdentifierXPath)[0]
                  intMetadata[:parentIdentifier] = parentIdentifier.text unless parentIdentifier.nil?

                  # :distributorInfo
                  # :associatedResources
                  # :additionalDocuments
                  # :lineageInfo
                  # :additionalDocuments
                  # :funding
                  # :dataQuality

                  intMetadata
               end
            end
         end
      end
   end
end
