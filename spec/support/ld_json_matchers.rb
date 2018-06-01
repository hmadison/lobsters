RSpec::Matchers.define :define_ld_property do |key, value|
  match do |actual|
    parsed = JSON.parse(actual)

    parsed[key.to_s] == value
  end
end
