# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::SecurePassword do
  include RbsActiverecord::Utils

  describe "#generate" do
    subject { format described_class.new(model).generate }

    let(:model) { RbsActiverecord::Model.new(klass) }

    context "When the model does not have secure password" do
      let(:klass) { Class.new(::ActiveRecord::Base) }

      it { is_expected.to eq "module GeneratedSecurePasswordMethods\nend\n" }
    end

    context "When the model has secure password" do
      context "When the column of secure password is password_digest" do
        let(:klass) do
          Class.new(::ActiveRecord::Base) do
            has_secure_password
          end
        end

        it "generates RBS" do
          expect(subject).to eq(<<~RBS)
            module GeneratedSecurePasswordMethods
              attr_reader password: ::String?

              attr_accessor password_confirmation: ::String

              attr_accessor password_challenge: ::String

              def password=: (::String) -> ::String

              def password_salt: () -> ::String

              def authenticate_password: (::String) -> (instance | false)

              alias authenticate authenticate_password
            end
          RBS
        end
      end

      context "When the column of secure password is not password_digest" do
        let(:klass) do
          Class.new(::ActiveRecord::Base) do
            has_secure_password :recovery_password
          end
        end

        it "generates RBS" do
          expect(subject).to eq(<<~RBS)
            module GeneratedSecurePasswordMethods
              attr_reader recovery_password: ::String?

              attr_accessor recovery_password_confirmation: ::String

              attr_accessor recovery_password_challenge: ::String

              def recovery_password=: (::String) -> ::String

              def recovery_password_salt: () -> ::String

              def authenticate_recovery_password: (::String) -> (instance | false)
            end
          RBS
        end
      end

      context "When the model has multiple secure passwords" do
        let(:klass) do
          Class.new(::ActiveRecord::Base) do
            has_secure_password
            has_secure_password :recovery_password, validations: false
          end
        end

        it "generates RBS" do
          expect(subject).to eq(<<~RBS)
            module GeneratedSecurePasswordMethods
              attr_reader recovery_password: ::String?

              attr_accessor recovery_password_confirmation: ::String

              attr_accessor recovery_password_challenge: ::String

              def recovery_password=: (::String) -> ::String

              def recovery_password_salt: () -> ::String

              def authenticate_recovery_password: (::String) -> (instance | false)

              attr_reader password: ::String?

              attr_accessor password_confirmation: ::String

              attr_accessor password_challenge: ::String

              def password=: (::String) -> ::String

              def password_salt: () -> ::String

              def authenticate_password: (::String) -> (instance | false)

              alias authenticate authenticate_password
            end
          RBS
        end
      end
    end
  end
end
