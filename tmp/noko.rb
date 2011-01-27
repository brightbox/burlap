require 'rubygems'
require 'nokogiri'

module Burlap

  def Burlap::parse_xml io_handle
    listener = Listener.new
    parser = Nokogiri::XML::SAX::Parser.new(listener)
    parser.parse(io_handle)
    listener.result
  end

  class Listener < Nokogiri::XML::SAX::Document

    attr_accessor :result

    def initialize
      @result = nil
      @open = []
    end

    def start_element name, attrs=[]
      klass = BaseTag::mappings[name]
      raise "Missing class for #{name.inspect}" unless klass
      @open.push klass.new
    end

    def characters contents
      @open.last.text = contents if @open.last
    end

    def end_element name
      last = @open.pop
      if @open.empty?
        @result = last.to_ruby
      else
        @open.last.children.push last
      end
    end

  private
    attr_writer :data

  end

  class BaseTag
    @@mappings = {}
    def BaseTag::mappings
      @@mappings
    end

    def self.inherited klass
      key = klass.to_s.gsub(/^Burlap::/, "").gsub(/(?!^)([A-Z])/, ':\1').downcase

      @@mappings[key] = klass
    end

    attr_accessor :text, :children

    def initialize
      self.children = []
    end

    def to_ruby
      raise "Unimplemented: #{self.class}#to_ruby on #{self.inspect}"
    end

    def self.tag_name
      @tag_name
    end
  end

  class BurlapReply < BaseTag
    def to_ruby
      children.first.to_ruby if children.first
    end
  end

  class Map < BaseTag
    def to_ruby
      # Pop the first element off
      type = children.shift.to_ruby

      # And then the rest are matched pairs
      dict = {}

      children.each_slice(2) do |arr|
        key, value = arr.map(&:to_ruby)
        dict[key] = value
      end

      Struct.new(:type, :contents).new(type, dict)
    end
  end

  class Type < BaseTag
    def to_ruby
      text || ""
    end
  end

  class String < BaseTag
    def to_ruby
      text || ""
    end
  end

  class Int < BaseTag
    def to_ruby
      text.to_i
    end
  end

  class Null < BaseTag
    def to_ruby
      nil
    end
  end

  require "date"
  class Date < BaseTag
    def to_ruby
      ::Date.parse(text) if text
    end
  end

  class List < BaseTag
    def to_ruby
      "<< list >>"
    end
  end

  class Length < BaseTag
  end

end

p Burlap::parse_xml DATA

__END__
<burlap:reply><map><type>com.sapienter.jbilling.server.user.UserWS</type><string>id</string><int>20</int><string>currencyId</string><int>1</int><string>password</string><string>46f94c8de14fb36680850768ff1b7f2a</string><string>deleted</string><int>0</int><string>userName</string><string>burlap</string><string>failedAttempts</string><int>0</int><string>languageId</string><int>1</int><string>role</string><string>Super user</string><string>language</string><string>English</string><string>status</string><string>Active</string><string>mainRoleId</string><int>2</int><string>statusId</string><int>1</int><string>subscriberStatusId</string><int>6</int><string>partnerId</string><null></null><string>parentId</string><null></null><string>isParent</string><null></null><string>invoiceChild</string><null></null><string>mainOrderId</string><null></null><string>userIdBlacklisted</string><null></null><string>owingBalance</string><string>0.00</string><string>balanceType</string><null></null><string>dynamicBalance</string><null></null><string>autoRecharge</string><null></null><string>creditLimit</string><null></null><string>createDatetime</string><map><type>java.sql.Timestamp</type><string>value</string><date>20110127T120541.000Z</date></map><string>lastStatusChange</string><null></null><string>lastLogin</string><null></null><string>creditCard</string><null></null><string>ach</string><null></null><string>contact</string><map><type>com.sapienter.jbilling.server.user.ContactWS</type><string>id</string><int>300</int><string>organizationName</string><null></null><string>address1</string><null></null><string>address2</string><null></null><string>city</string><null></null><string>stateProvince</string><null></null><string>postalCode</string><null></null><string>countryCode</string><string>UK</string><string>lastName</string><null></null><string>firstName</string><null></null><string>initial</string><null></null><string>title</string><null></null><string>phoneCountryCode</string><null></null><string>phoneAreaCode</string><null></null><string>phoneNumber</string><null></null><string>faxCountryCode</string><null></null><string>faxAreaCode</string><null></null><string>faxNumber</string><null></null><string>email</string><string>caius@brightbox.co.uk</string><string>deleted</string><int>0</int><string>include</string><int>1</int><string>type</string><null></null><string>createDate</string><map><type>java.sql.Timestamp</type><string>value</string><date>20110127T120541.000Z</date></map><string>fieldNames</string><list><type>[string</type><length>0</length></list><string>fieldValues</string><list><type>[string</type><length>0</length></list></map><string>blacklistMatches</string><null></null><string>childIds</string><null></null><string>autoRechargeAsDecimal</string><null></null><string>owingBalanceAsDecimal</string><map><type>java.math.BigDecimal</type><string>value</string><string>0</string></map><string>creditLimitAsDecimal</string><null></null><string>dynamicBalanceAsDecimal</string><null></null></map></burlap:reply>