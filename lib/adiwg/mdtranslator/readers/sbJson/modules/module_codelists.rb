# sbJson 1.0 reader

# History:
#  Stan Smith 2017-08-03 refactored - separated forward and reverse translations
#  Stan Smith 2017-05-26 original script

require 'adiwg-mdcodes'

module ADIWG
   module Mdtranslator
      module Readers
         module SbJson

            module Codelists

               @role_sb2adiwg = [
                  {sb: 'administrator', adiwg: 'administrator'},
                  {sb: 'Associate Project Chief', adiwg: nil},
                  {sb: 'Author', adiwg: 'author'},
                  {sb: 'client', adiwg: 'client'},
                  {sb: 'Co-Investigator', adiwg: 'coPrincipalInvestigator'},
                  {sb: 'Contact', adiwg: 'pointOfContact'},
                  {sb: 'Cooperator/Partner', adiwg: 'collaborator'},
                  {sb: 'Custodian', adiwg: 'custodian'},
                  {sb: 'Data Owner', adiwg: 'owner'},
                  {sb: 'Data Provider', adiwg: nil},
                  {sb: 'Distributor', adiwg: 'distributor'},
                  {sb: 'Editor', adiwg: 'editor'},
                  {sb: 'funder', adiwg: 'funder'},
                  {sb: 'Funding Agency', adiwg: nil},
                  {sb: 'Lead Organization', adiwg: nil},
                  {sb: 'logistics', adiwg: 'logistics'},
                  {sb: 'Material Request Contact', adiwg: nil},
                  {sb: 'mediator', adiwg: 'mediator'},
                  {sb: 'Metadata Contact', adiwg: nil},
                  {sb: 'Originator', adiwg: 'originator'},
                  {sb: 'Participant', adiwg: nil},
                  {sb: 'Photographer', adiwg: nil},
                  {sb: 'Point of Contact', adiwg: 'pointOfContact'},
                  {sb: 'Principal Investigator', adiwg: 'principalInvestigator'},
                  {sb: 'Process Contact', adiwg: nil},
                  {sb: 'Processor', adiwg: 'processor'},
                  {sb: 'Project Chief', adiwg: nil},
                  {sb: 'Project Team', adiwg: nil},
                  {sb: 'publisher', adiwg: 'publisher'},
                  {sb: 'Referred By', adiwg: nil},
                  {sb: 'Report Prepared By', adiwg: nil},
                  {sb: 'Resource Provider', adiwg: 'resourceProvider'},
                  {sb: 'SoftwareEngineer', adiwg: nil},
                  {sb: 'sponsor', adiwg: 'sponsor'},
                  {sb: 'stakeholder', adiwg: 'stakeholder'},
                  {sb: 'Subtask Leader', adiwg: nil},
                  {sb: 'Supporter', adiwg: nil},
                  {sb: 'Task Leader', adiwg: nil},
                  {sb: 'Transmitted', adiwg: nil},
                  {sb: 'User', adiwg: 'use'},
                  {sb: 'USGS Mission Area', adiwg: nil},
                  {sb: 'USGS Program', adiwg: nil},
               ]

               @onlineFunction_sb2adiwg = [
                  {sb: 'arcgis', adiwg: nil},
                  {sb: 'browseImage', adiwg: 'browseGraphic'},
                  {sb: 'browsing', adiwg: 'browsing'},
                  {sb: 'citation', adiwg: nil},
                  {sb: 'configFile', adiwg: nil},
                  {sb: 'download',adiwg: 'download' },
                  {sb: 'emailService', adiwg: 'emailService'},
                  {sb: 'fileAccess', adiwg: 'fileAccess'},
                  {sb: 'kml', adiwg: nil},
                  {sb: 'mapapp', adiwg: nil},
                  {sb: 'method', adiwg: nil},
                  {sb: 'oai-pmh', adiwg: nil},
                  {sb: 'offlineAccess', adiwg: 'offlineAccess'},
                  {sb: 'order', adiwg: 'order'},
                  {sb: 'originalMetadata', adiwg: 'completeMetadata'},
                  {sb: 'pdf', adiwg: nil},
                  {sb: 'publicationReferenceSource', adiwg: nil},
                  {sb: 'repo', adiwg: nil},
                  {sb: 'search', adiwg: 'search'},
                  {sb: 'serviceCapabilitiesUrl', adiwg: nil},
                  {sb: 'serviceFeatureInfoUrl', adiwg: nil},
                  {sb: 'serviceLegendUrl', adiwg: nil},
                  {sb: 'serviceLink', adiwg: nil},
                  {sb: 'serviceMapUrl', adiwg: nil},
                  {sb: 'serviceWfsBackingUrl', adiwg: nil},
                  {sb: 'sitemap', adiwg: nil},
                  {sb: 'sourceCode', adiwg: nil},
                  {sb: 'txt', adiwg: nil},
                  {sb: 'upload', adiwg: 'upload'},
                  {sb: 'WAF', adiwg: nil},
                  {sb: 'webapp', adiwg: 'webApplication'},
                  {sb: 'webLink', adiwg: 'information'},
                  {sb: 'xls', adiwg: nil},
                  {sb: 'zip', adiwg: nil}
               ]

               @scope_sb2adiwg = [
                  {sb: 'Collection', adiwg: 'collection'},
                  {sb: 'Data', adiwg: 'dataset'},
                  {sb: 'Data Release - In Progress', adiwg: nil},
                  {sb: 'Image', adiwg: 'photographicImage'},
                  {sb: 'Map', adiwg: 'map'},
                  {sb: 'Physical Item', adiwg: 'sample'},
                  {sb: 'Project', adiwg: 'project'},
                  {sb: 'Publication', adiwg: 'publication'},
                  {sb: 'Software', adiwg: 'software'},
                  {sb: 'Web Site', adiwg: 'website'}
               ]

               @date_sb2adiwg = [
                  {sb: 'Acquisition', adiwg: 'acquisition'},
                  {sb: 'adopted', adiwg: 'adopted'},
                  {sb: 'AssessmentDate', adiwg: 'assessment'},
                  {sb: 'Award', adiwg: 'award'},
                  {sb: 'beginPosition', adiwg: nil},
                  {sb: 'Collected', adiwg: 'collected'},
                  {sb: 'creation', adiwg: 'creation'},
                  {sb: 'deprecated', adiwg: 'deprecated'},
                  {sb: 'distribution', adiwg: 'distribution'},
                  {sb: 'Due', adiwg: 'due'},
                  {sb: 'End', adiwg: 'end'},
                  {sb: 'endPosition', adiwg: nil},
                  {sb: 'firstProcessed', adiwg: nil},
                  {sb: 'info', adiwg: nil},
                  {sb: 'inForce', adiwg: 'inForce'},
                  {sb: 'lastProcessed', adiwg: nil},
                  {sb: 'lastRevision', adiwg: 'lastRevision'},
                  {sb: 'lastUpdate', adiwg: 'lastUpdate'},
                  {sb: 'nextUpdate', adiwg: 'nextUpdate'},
                  {sb: 'Publication', adiwg: 'publication'},
                  {sb: 'Received', adiwg: 'received'},
                  {sb: 'Release', adiwg: 'released'},
                  {sb: 'Reported', adiwg: 'reported'},
                  {sb: 'Repository Created', adiwg: nil},
                  {sb: 'Repository Updated', adiwg: nil},
                  {sb: 'revision', adiwg: 'revision'},
                  {sb: 'Start', adiwg: 'start'},
                  {sb: 'suspended', adiwg: 'suspended'},
                  {sb: 'Transmitted', adiwg: 'transmitted'},
                  {sb: 'unavailable', adiwg: 'unavailable'},
                  {sb: 'validityBegins', adiwg: 'validityBegins'},
                  {sb: 'validityExpires', adiwg: 'validityExpires'}
               ]

               @progress_sb2adiwg = [
                  {sb: 'Active', adiwg: 'onGoing'},
                  {sb: 'Approved', adiwg: 'accepted'},
                  {sb: 'Completed', adiwg: 'completed'},
                  {sb: 'In Progress', adiwg: 'onGoing'},
                  {sb: 'Proposed', adiwg: 'proposed'}
               ]

               @association_sb2adiwg = [
                  {sb: 'alternate', adiwg: 'crossReference', reverse: 'alternate'},
                  {sb: 'constituentOf', adiwg: 'isComposedOf', reverse: 'constituent'},
                  {sb: 'copiedFrom', adiwg: nil, reverse: 'copiedInto'},
                  {sb: 'derivativeOf', adiwg: 'derivativeProduct', reverse: 'derived'},
                  {sb: 'precededBy', adiwg: nil, reverse: 'succeededBy'},
                  {sb: 'productOf', adiwg: 'parentProject', reverse: 'produced'},
                  {sb: 'related', adiwg: nil, reverse: 'related'},
                  {sb: 'subprojectOf', adiwg: 'subProject', reverse: 'mainprojectOf'}
               ]

               # translate iso/adiwg code to sb
               def self.codelist_sb2adiwg(codelist, sbCode)
                  codeList = instance_variable_get("@#{codelist}")
                  unless sbCode.nil?
                     codeList.each do |obj|
                        if obj[:sb] == sbCode
                           return obj[:adiwg]
                        end
                     end
                  end
                  return nil
               end

               # test if provided code is a valid sb code
               def self.is_sb_code(codelist, sbCode)
                  codeList = instance_variable_get("@#{codelist}")
                  unless sbCode.nil?
                     codeList.each do |obj|
                        if obj[:sb] == sbCode
                           return true
                        end
                     end
                  end
                  return false
               end

            end

         end
      end
   end
end
