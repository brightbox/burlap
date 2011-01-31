require "rubygems"
require "bundler/setup"
require "burlap"
require "pp"

data = {
  "method" => "updateUser",
  "arguments" => [
    Burlap::Object.new(
      :type => "com.sapienter.jbilling.server.user.UserWS",
      :contents => {
        :balanceType => nil,
        :userName => "Caius",
        :languageId => 1,
        :creditCard => nil,
        :createDatetime => Time.local(2010, 9, 11, 10, 0, 0),
        :mainRoleId => 2,
        :contact => Burlap::Object.new(
          :type => "com.sapienter.jbilling.server.user.ContactWS",
          :contents => {
            :city => "Leeds",
            :createDate => Time.local(2010, 9, 11, 10, 0, 0)
          }
        )
      }
    )
  ]
}

xml = Burlap.dump(data)

pp xml
