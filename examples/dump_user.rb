require "rubygems"
require "bundler/setup"
require "burlap"
require "pp"

data = Burlap::Call.new(
  :method => "updateUser",
  :arguments => [
    :balanceType => nil,
    :userName => "Caius",
    :languageId => 1,
    :creditCard => nil,
    :createDatetime => Time.local(2010, 9, 11, 10, 0, 0),
    :mainRoleId => 2,
    :contact => Burlap::Hash[
      {
        :city => "Leeds",
        :createDate => Time.local(2010, 9, 11, 10, 0, 0)
      },
      "com.sapienter.jbilling.server.user.ContactWS"
    ]
  ]
)

xml = data.to_burlap

pp xml
