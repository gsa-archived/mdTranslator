# ISO <<Class>> MD_Distributor
# 19115-2 writer output in XML

# History:
#   Stan Smith 2016-12-07 refactored for mdTranslator/mdJson 2.0
#   Stan Smith 2015-09-21 added format from distributorTransferOptions
#   Stan Smith 2015-07-14 refactored to eliminate namespace globals $WriterNS and $IsoNS
#   Stan Smith 2015-07-14 refactored to make iso19110 independent of iso19115_2 classes
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (hResponseObj)
#   Stan Smith 2014-12-12 refactored to handle namespacing readers and writers
#   Stan Smith 2014-07-09 modify require statements to function in RubyGem structure
# 	Stan Smith 2013-09-25 original script

require_relative 'class_responsibleParty'
require_relative 'class_orderProcess'
require_relative 'class_format'
require_relative 'class_transferOptions'

module ADIWG
    module Mdtranslator
        module Writers
            module Iso19115_2

                class MD_Distributor

                    def initialize(xml, hResponseObj)
                        @xml = xml
                        @hResponseObj = hResponseObj
                    end

                    def writeXML(hDistributor)

                        # classes used
                        partyClass =  CI_ResponsibleParty.new(@xml, @hResponseObj)
                        orderClass =  MD_StandardOrderProcess.new(@xml, @hResponseObj)
                        formatClass =  MD_Format.new(@xml, @hResponseObj)
                        transferClass =  MD_DigitalTransferOptions.new(@xml, @hResponseObj)

                        @xml.tag!('gmd:MD_Distributor') do

                            # distributor - contact (required) {CI_ResponsibleParty}
                            role = 'distributor'
                            hParty = hDistributor[:contact][:party][0]
                            unless hParty.nil?
                                @xml.tag!('gmd:distributorContact') do
                                    partyClass.writeXML(role, hParty)
                                end
                            end
                            if hParty.nil?
                                @xml.tag!('gmd:distributorContact', {'gco:nilReason'=>'missing'})
                            end

                            # distributor - order process [{MD_StandardOrderProcess}]
                            aDistOrderProc = hDistributor[:orderProcess]
                            aDistOrderProc.each do |hOrder|
                                @xml.tag!('gmd:distributionOrderProcess') do
                                    orderClass.writeXML(hOrder)
                                end
                            end
                            if aDistOrderProc.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:distributionOrderProcess')
                            end

                            # distributor - format [{MD_Format}]
                            aOptions = hDistributor[:transferOptions]
                            aOptions.each do |hOption|
                                aFormats = hOption[:distributionFormats]
                                aFormats.each do |hFormat|
                                    @xml.tag!('gmd:distributorFormat') do
                                        formatClass.writeXML(hFormat)
                                    end
                                end
                            end
                            if aOptions.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:distributorFormat')
                            end

                            # distributor - transfer options [{MD_DigitalTransferOptions}]
                            aOptions = hDistributor[:transferOptions]
                            aOptions.each do |hOption|
                                @xml.tag!('gmd:distributorTransferOptions') do
                                    transferClass.writeXML(hOption)
                                end
                            end
                            if aOptions.empty? && @hResponseObj[:writerShowTags]
                                @xml.tag!('gmd:distributorTransferOptions')
                            end

                        end # gmd:MD_Distributor tag
                    end # writeXML
                end # MD_Distributor class

            end
        end
    end
end
