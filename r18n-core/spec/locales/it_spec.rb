require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require File.join(File.dirname(__FILE__), '..', '..', 'locales', 'it')

describe R18n::Locales::It do
  it "should format Italian date" do
    italian = R18n::I18n.new('it')
    italian.l(Date.parse('2009-07-01'), :full).should ==  "1\u00ba Luglio 2009"
    italian.l(Date.parse('2009-07-02'), :full).should ==  ' 2 Luglio 2009'
    italian.l(Date.parse('2009-07-12'), :full).should ==  '12 Luglio 2009'
  end
end
