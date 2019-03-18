# ISO <<Class>> CI_Contact
# 19115-1 writer output in XML

# History:
# 	Stan Smith 2019-03-14 original script

require_relative 'class_phone'
require_relative 'class_address'
require_relative 'class_email'
require_relative 'class_onlineResource'

module ADIWG
   module Mdtranslator
      module Writers
         module Iso19115_1

            class CI_Contact

               def initialize(xml, hResponseObj)
                  @xml = xml
                  @hResponseObj = hResponseObj
               end

               def writeXML(hContact)

                  # classes used
                  phoneClass = CI_Telephone.new(@xml, @hResponseObj)
                  addClass = CI_Address.new(@xml, @hResponseObj)
                  emailClass = Email.new(@xml, @hResponseObj)
                  resourceClass = CI_OnlineResource.new(@xml, @hResponseObj)

                  # outContext
                  outContext = 'contact information'
                  outContext +=  ' ' + hContact[:name] unless hContact[:name].nil?
                  outContext += ' (' + hContact[:contactId] + ')' unless hContact[:contactId].nil?

                  @xml.tag!('cit:CI_Contact') do

                     # contact - phones [] {CI_Telephone} (pass all phones)
                     aPhones = hContact[:phones]
                     unless aPhones.empty?
                        @xml.tag!('cit:phone') do
                           phoneClass.writeXML(aPhones)
                        end
                     end
                     if aPhones.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('cit:phone')
                     end

                     # contact - address [] {CI_Address}
                     aAddress = hContact[:addresses]
                     aAddress.each do |hAddress|
                        @xml.tag!('cit:address') do
                           addClass.writeXML(hAddress)
                        end
                     end
                     if aAddress.nil? && @hResponseObj[:writerShowTags]
                        @xml.tag!('cit:address')
                     end

                     # contact - email address [] {CI_Address}
                     # in 19115-1 email addresses are associated with mailing addresses
                     # .. not in mdJson, so email addresses shown in separate address block
                     emailClass.writeXML(hContact[:eMailList])

                     # contact - online resource [] {CI_OnlineResource}
                     aOlResources = hContact[:onlineResources]
                     aOlResources.each do |hOnline|
                        @xml.tag!('cit:onlineResource') do
                           resourceClass.writeXML(hOnline, outContext)
                        end
                     end
                     if aOlResources.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('cit:onlineResource')
                     end

                     # contact - hours of service []
                     aHours = hContact[:hoursOfService]
                     aHours.each do |hours|
                        @xml.tag!('cit:hoursOfService') do
                           @xml.tag!('gco:CharacterString', hours)
                        end
                     end
                     if aHours.empty? && @hResponseObj[:writerShowTags]
                        @xml.tag!('cit:hoursOfService')
                     end

                     # contact - contact instructions
                     unless hContact[:contactInstructions].nil?
                        @xml.tag!('cit:contactInstructions') do
                           @xml.tag!('gco:CharacterString', hContact[:contactInstructions])
                        end
                     end
                     if hContact[:contactInstructions].nil? && @hResponseObj[:writerShowTags]
                        @xml.tag!('cit:contactInstructions')
                     end

                     # contact - contact type
                     unless hContact[:contactType].nil?
                        @xml.tag!('cit:contactType') do
                           @xml.tag!('gco:CharacterString', hContact[:contactType])
                        end
                     end
                     if hContact[:contactType].nil? && @hResponseObj[:writerShowTags]
                        @xml.tag!('cit:contactType')
                     end

                  end # CI_Contact tag
               end # write XML
            end # CI_Contact class

         end
      end
   end
end
