require 'jbuilder'

module ADIWG
   module Mdtranslator
      module Writers
         module Dcat_us
            module IsPartOf

               def self.build(intObj)
                  parentIdentifiers = intObj.dig(:metadata, :metadataInfo, :parentMetadata, :identifier)
                  return parentIdentifiers[0][:identifier] unless parentIdentifiers.nil? || parentIdentifiers.empty?

                  associatedResources = intObj.dig(:metadata, :associatedResources)
                
                  associatedResources.each do |resource|
                    next unless resource[:initiativeType] == "collection" && resource[:associationType] == "collectiveTitle"
                
                    onlineResources = resource.dig(:resourceCitation, :onlineResources) || []
                    uri = onlineResources.find { |onlineResource| onlineResource[:olResURI] }&.dig(:olResURI)
                    return uri if uri
                  end
                
                  nil
                end                

            end
         end
      end
   end
end
