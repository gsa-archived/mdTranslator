# frozen_string_literal: true

require 'nokogiri'
require 'uuidtools'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative '../version'
require_relative 'module_metadata'
require_relative 'module_responsibility'
require_relative 'module_feature_catalog'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Iso191153
               @@contactXPath = 'mdb:contact'
               @@contentInfoXPath = 'mdb:contentInfo'
               def self.unpack(xMetadata, hResponseObj)
                  intMetadataClass = InternalMetadata.new

                  intObj = intMetadataClass.newBase
                  @intObj = intObj
                  @contacts = intObj[:contacts]

                  # :schema
                  hSchema = intMetadataClass.newSchema
                  hSchema[:name] = 'iso19115_3'
                  hSchema[:version] = ADIWG::Mdtranslator::Readers::Iso191153::VERSION
                  @intObj[:schema] = hSchema

                  hMetadata = Metadata.unpack(xMetadata, hResponseObj)
                  @intObj[:metadata] = hMetadata

                  # :contacts (required)
                  # <element maxOccurs="unbounded" name="contact"
                  # type="mcc:Abstract_Responsibility_PropertyType">
                  xContacts = xMetadata.xpath(@@contactXPath)
                  if xContacts.empty?
                     msg = 'WARNING: ISO19115-3 reader: element \'mdb:contact\' '\
                        'is missing in mdb:MD_Metadata'
                     hResponseObj[:readerExecutionMessages] << msg
                     hResponseObj[:readerExecutionPass] = false
                     return intObj
                  end

                  # @intObj[:contacts] = xContacts.map { |c| Responsibility.unpack(c, hResponseObj) }

                  # :dataDictionaries
                  xContentInfos = xMetadata.xpath(@@contentInfoXPath)
                  @intObj[:dataDictionaries] = xContentInfos.map { |ci| FeatureCatalog.unpack(ci, hResponseObj) }

                  # :metadataRepositories
                  # @intObj[:metadataRepositories] = [] # TODO

                  intObj
               end

               # find the array pointer and type for a contact
               def self.find_contact_by_id(contactId)
                  contactIndex = nil
                  contactType = nil
                  unless @contacts.empty?
                     @contacts.each_with_index do |contact, i|
                        next unless contact[:contactId] == contactId

                        contactType = if contact[:isOrganization]
                                         'organization'
                                      else
                                         'individual'
                                      end
                        contactIndex = i
                     end
                  end
                  [contactIndex, contactType]
               end

               # find contact id for a name
               def self.find_contact_by_name(contactName)
                  @contacts.each do |contact|
                     return contact[:contactId] if contact[:name] == contactName
                  end
                  nil
               end

               # add new contact to contacts array
               def self.add_contact(name, isOrg)
                  return UUIDTools::UUID.random_create.to_s if @contacts.nil?

                  contactId = find_contact_by_name(name)
                  if contactId.nil?
                     intMetadataClass = InternalMetadata.new
                     hContact = intMetadataClass.newContact
                     contactId = UUIDTools::UUID.random_create.to_s
                     hContact[:contactId] = contactId
                     hContact[:name] = name
                     hContact[:isOrganization] = isOrg
                     @contacts << hContact
                  end
                  contactId
               end

               # return contact by id
               def self.get_contact_by_id(contactId)
                  index = find_contact_by_id(contactId)[0]
                  return @contacts[index] unless index.nil?

                  nil
               end

               # add or replace the contact
               def self.set_contact(hContact)
                  return 1 if @contacts.nil?

                  index = find_contact_by_id(hContact[:contactId])[0]
                  if index.nil?
                     @contacts << hContact
                     index = @contacts.length - 1
                  else
                     @contacts[index] = hContact
                  end
                  index
               end

               # set an internal object for tests
               def self.set_intobj(intObj)
                  @intObj = intObj
                  @contacts = @intObj[:contacts]
               end

               # get internal object
               def self.get_intobj
                  @intObj
               end

               # get metadata time convention
               def self.get_metadata_time_convention
                  @xDoc.xpath('./metadata/metainfo/mettc').text
               end

               # set @xDoc for minitests
               def self.set_xdoc(xDoc)
                  @xDoc = xDoc
               end

               # add new associated resource
               def self.add_associated_resource(hResource)
                  @intObj[:metadata][:associatedResources] << hResource
               end
            end
         end
      end
   end
end
