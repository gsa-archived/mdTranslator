# frozen_string_literal: true

require 'nokogiri'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require_relative 'module_legal_constraint'
require_relative 'module_common_constraint'
require_relative 'module_security_constraint'

module ADIWG
   module Mdtranslator
      module Readers
         module Iso191153
            module Constraint
               @@commonConstraintXPath = 'mco:MD_Constraints'
               @@legalConstraintXPath = 'mco:MD_LegalConstraints'
               @@securityConstraintXPath = 'mco:MD_SecurityConstraints'
               def self.unpack(xConstraint, hResponseObj)
                  xCommonConstraints = xConstraint.xpath(@@commonConstraintXPath)
                  aConstraints = xCommonConstraints.map { |c| CommonConstraint.unpack(c, hResponseObj) }

                  # legal constraints
                  xLegalConstraints = xConstraint.xpath(@@legalConstraintXPath)
                  aLegalConstraints = xLegalConstraints.map { |l| LegalConstraint.unpack(l, hResponseObj) }

                  # security constraints
                  xSecurityConstraints = xConstraint.xpath(@@securityConstraintXPath)
                  aSecurityConstraints = xSecurityConstraints.map { |s| SecurityConstraint.unpack(s, hResponseObj) }

                  aConstraints + aLegalConstraints + aSecurityConstraints
               end
            end
         end
      end
   end
end
