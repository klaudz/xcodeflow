
require_relative '../provision'
require 'xcodeproj'

module Xcodeflow
    class Project < Xcodeproj::Project

        class Signing

            attr_reader :target, :build_configuration
            
            def initialize(target, build_configuration_name)
                @target = target
                @build_configuration = target.build_configurations.select { |build_configuration|
                    build_configuration.name == build_configuration_name
                }.first
            end

            attr_accessor :team_id
            def team_id
                @build_configuration.resolve_build_setting("DEVELOPMENT_TEAM")
            end
            def team_id=(value)
                @build_configuration.build_settings["DEVELOPMENT_TEAM"] = value
            end

            attr_accessor :bundle_identifier
            def bundle_identifier
                @build_configuration.resolve_build_setting("PRODUCT_BUNDLE_IDENTIFIER")
            end
            def bundle_identifier=(value)
                @build_configuration.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = value
            end

            attr_accessor :provision_profile_specifier
            def provision_profile_specifier
                @build_configuration.resolve_build_setting("PROVISIONING_PROFILE_SPECIFIER")
            end
            def provision_profile_specifier=(value)
                @build_configuration.build_settings["PROVISIONING_PROFILE_SPECIFIER"] = value
            end

            attr_accessor :signing_certificate_identity
            def signing_certificate_identity
                @build_configuration.resolve_build_setting("CODE_SIGN_IDENTITY")
            end
            def signing_certificate_identity=(value)
                @build_configuration.build_settings["CODE_SIGN_IDENTITY"] = value
            end

            attr_accessor :auto_manage_signing
            def auto_manage_signing
                auto_manage_signing_string = @build_configuration.resolve_build_setting("CODE_SIGN_STYLE")
                if auto_manage_signing_string.nil? or auto_manage_signing_string == "Automatic"
                    return true
                else
                    return false
                end
            end
            def auto_manage_signing=(value)
                @build_configuration.build_settings["CODE_SIGN_STYLE"] = value ? "Automatic" : "Manual"
            end

            def update_from_provision(provision)
                self.team_id = provision.team_id
                self.bundle_identifier = provision.bundle_identifier
                self.provision_profile_specifier = provision.name ? provision.name : provision.uuid
                self.signing_certificate_identity = provision.certificates[0].name
                self.auto_manage_signing = provision.is_xcode_managed
            end

        end
    end
end
