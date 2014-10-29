require File.expand_path('../test_helper', __FILE__)

class JSONSchemaDraft1Test < Test::Unit::TestCase
  def test_types
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {}
      }
    }
    data = {
      "a" => nil
    }

    # Test integers
    schema["properties"]["a"]["type"] = "integer"
    data["a"] = 5
    assert_valid schema, data, :version => :draft1

    data["a"] = 5.2
    refute_valid schema, data, :version => :draft1

    data['a'] = 'string'
    refute_valid schema, data, :version => :draft1

    data['a'] = true
    refute_valid schema, data, :version => :draft1


    # Test numbers
    schema["properties"]["a"]["type"] = "number"
    data["a"] = 5
    assert_valid schema, data, :version => :draft1

    data["a"] = 5.2
    assert_valid schema, data, :version => :draft1

    data['a'] = 'string'
    refute_valid schema, data, :version => :draft1

    data['a'] = true
    refute_valid schema, data, :version => :draft1


    # Test strings
    schema["properties"]["a"]["type"] = "string"
    data["a"] = 5
    refute_valid schema, data, :version => :draft1

    data["a"] = 5.2
    refute_valid schema, data, :version => :draft1

    data['a'] = 'string'
    assert_valid schema, data, :version => :draft1

    data['a'] = true
    refute_valid schema, data, :version => :draft1


    # Test booleans
    schema["properties"]["a"]["type"] = "boolean"
    data["a"] = 5
    refute_valid schema, data, :version => :draft1

    data["a"] = 5.2
    refute_valid schema, data, :version => :draft1

    data['a'] = 'string'
    refute_valid schema, data, :version => :draft1

    data['a'] = true
    assert_valid schema, data, :version => :draft1

    data['a'] = false
    assert_valid schema, data, :version => :draft1


    # Test object
    schema["properties"]["a"]["type"] = "object"
    data["a"] = {}
    assert_valid schema, data, :version => :draft1

    data["a"] = 5.2
    refute_valid schema, data, :version => :draft1

    data['a'] = 'string'
    refute_valid schema, data, :version => :draft1

    data['a'] = true
    refute_valid schema, data, :version => :draft1


    # Test array
    schema["properties"]["a"]["type"] = "array"
    data["a"] = []
    assert_valid schema, data, :version => :draft1

    data["a"] = 5.2
    refute_valid schema, data, :version => :draft1

    data['a'] = 'string'
    refute_valid schema, data, :version => :draft1

    data['a'] = true
    refute_valid schema, data, :version => :draft1


    # Test null
    schema["properties"]["a"]["type"] = "null"
    data["a"] = nil
    assert_valid schema, data, :version => :draft1

    data["a"] = 5.2
    refute_valid schema, data, :version => :draft1

    data['a'] = 'string'
    refute_valid schema, data, :version => :draft1

    data['a'] = true
    refute_valid schema, data, :version => :draft1


    # Test any
    schema["properties"]["a"]["type"] = "any"
    data["a"] = 5
    assert_valid schema, data, :version => :draft1

    data["a"] = 5.2
    assert_valid schema, data, :version => :draft1

    data['a'] = 'string'
    assert_valid schema, data, :version => :draft1

    data['a'] = true
    assert_valid schema, data, :version => :draft1


    # Test a union type
    schema["properties"]["a"]["type"] = ["integer","string"]
    data["a"] = 5
    assert_valid schema, data, :version => :draft1

    data["a"] = 'boo'
    assert_valid schema, data, :version => :draft1

    data["a"] = false
    refute_valid schema, data, :version => :draft1

    # Test a union type with schemas
    schema["properties"]["a"]["type"] = [{ "type" => "string" }, {"type" => "object", "properties" => {"b" => {"type" => "integer"}}}]

    data["a"] = "test"
    assert_valid schema, data, :version => :draft1

    data["a"] = 5
    refute_valid schema, data, :version => :draft1

    data["a"] = {"b" => 5}
    assert_valid schema, data, :version => :draft1

    data["a"] = {"b" => "taco"}
    refute_valid schema, data, :version => :draft1
   end



  def test_optional
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"type" => "string"}
      }
    }
    data = {}

    refute_valid schema, data, :version => :draft1
    data['a'] = "Hello"
    assert_valid schema, data, :version => :draft1

    schema = {
      "properties" => {
        "a" => {"type" => "integer", "optional" => "true"}
      }
    }

    data = {}
    assert_valid schema, data, :version => :draft1

  end



  def test_minimum
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"minimum" => 5}
      }
    }

    data = {
      "a" => nil
    }


    # Test an integer
    data["a"] = 5
    assert_valid schema, data, :version => :draft1

    data["a"] = 4
    refute_valid schema, data, :version => :draft1

    # Test a float
    data["a"] = 5.0
    assert_valid schema, data, :version => :draft1

    data["a"] = 4.9
    refute_valid schema, data, :version => :draft1

    # Test a non-number
    data["a"] = "a string"
    assert_valid schema, data, :version => :draft1

    # Test exclusiveMinimum
    schema["properties"]["a"]["minimumCanEqual"] = false

    data["a"] = 6
    assert_valid schema, data, :version => :draft1

    data["a"] = 5
    refute_valid schema, data, :version => :draft1

    # Test with float
    data["a"] = 5.00000001
    assert_valid schema, data, :version => :draft1

    data["a"] = 5.0
    refute_valid schema, data, :version => :draft1
  end



  def test_maximum
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"maximum" => 5}
      }
    }

    data = {
      "a" => nil
    }


    # Test an integer
    data["a"] = 5
    assert_valid schema, data, :version => :draft1

    data["a"] = 6
    refute_valid schema, data, :version => :draft1

    # Test a float
    data["a"] = 5.0
    assert_valid schema, data, :version => :draft1

    data["a"] = 5.1
    refute_valid schema, data, :version => :draft1

    # Test a non-number
    data["a"] = "a string"
    assert_valid schema, data, :version => :draft1

    # Test exclusiveMinimum
    schema["properties"]["a"]["maximumCanEqual"] = false

    data["a"] = 4
    assert_valid schema, data, :version => :draft1

    data["a"] = 5
    refute_valid schema, data, :version => :draft1

    # Test with float
    data["a"] = 4.9999999
    assert_valid schema, data, :version => :draft1

    data["a"] = 5.0
    refute_valid schema, data, :version => :draft1
  end


  def test_min_items
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"minItems" => 1}
      }
    }

    data = {
      "a" => nil
    }

    # Test with an array
    data["a"] = ["boo"]
    assert_valid schema, data, :version => :draft1

    data["a"] = []
    refute_valid schema, data, :version => :draft1

    # Test with a non-array
    data["a"] = "boo"
    assert_valid schema, data, :version => :draft1
  end



  def test_max_items
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"maxItems" => 1}
      }
    }

    data = {
      "a" => nil
    }

    # Test with an array
    data["a"] = ["boo"]
    assert_valid schema, data, :version => :draft1

    data["a"] = ["boo","taco"]
    refute_valid schema, data, :version => :draft1

    # Test with a non-array
    data["a"] = "boo"
    assert_valid schema, data, :version => :draft1
  end


  def test_pattern
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"pattern" => "\\d+ taco"}
      }
    }

    data = {
      "a" => nil
    }

    # Test strings
    data["a"] = "156 taco bell"
    assert_valid schema, data, :version => :draft1

    # Test a non-string
    data["a"] = 5
    assert_valid schema, data, :version => :draft1

    data["a"] = "taco"
    refute_valid schema, data, :version => :draft1
  end


  def test_min_length
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"minLength" => 1}
      }
    }

    data = {
      "a" => nil
    }

    # Try out strings
    data["a"] = "t"
    assert_valid schema, data, :version => :draft1

    data["a"] = ""
    refute_valid schema, data, :version => :draft1

    # Try out non-string
    data["a"] = 5
    assert_valid schema, data, :version => :draft1
  end


  def test_max_length
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"maxLength" => 1}
      }
    }

    data = {
      "a" => nil
    }

    # Try out strings
    data["a"] = "t"
    assert_valid schema, data, :version => :draft1

    data["a"] = "tt"
    refute_valid schema, data, :version => :draft1

    # Try out non-string
    data["a"] = 5
    assert_valid schema, data, :version => :draft1
  end


  def test_enum
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"enum" => [1,'boo',[1,2,3],{"a" => "b"}], "optional" => true}
      }
    }

    data = {
      "a" => nil
    }

    # Make sure all of the above are valid...
    data["a"] = 1
    assert_valid schema, data, :version => :draft1

    data["a"] = 'boo'
    assert_valid schema, data, :version => :draft1

    data["a"] = [1,2,3]
    assert_valid schema, data, :version => :draft1

    data["a"] = {"a" => "b"}
    assert_valid schema, data, :version => :draft1

    # Test something that doesn't exist
    data["a"] = 'taco'
    refute_valid schema, data, :version => :draft1

    # Try it without the key
    data = {}
    assert_valid schema, data, :version => :draft1
  end


  def test_max_decimal
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"maxDecimal" => 2}
      }
    }

    data = {
      "a" => nil
    }

    data["a"] = 3.35
    assert_valid schema, data, :version => :draft1

    data["a"] = 3.455
    refute_valid schema, data, :version => :draft1


    schema["properties"]["a"]["maxDecimal"] = 0

    data["a"] = 4.0
    refute_valid schema, data, :version => :draft1

    data["a"] = 'boo'
    assert_valid schema, data, :version => :draft1

    data["a"] = 5
    assert_valid schema, data, :version => :draft1
  end



  def test_disallow
    # Set up the default datatype
    schema = {
      "properties" => {
        "a" => {"disallow" => "integer"}
      }
    }

    data = {
      "a" => nil
    }


    data["a"] = 'string'
    assert_valid schema, data, :version => :draft1

    data["a"] = 5
    refute_valid schema, data, :version => :draft1


    schema["properties"]["a"]["disallow"] = ["integer","string"]
    data["a"] = 'string'
    refute_valid schema, data, :version => :draft1

    data["a"] = 5
    refute_valid schema, data, :version => :draft1

    data["a"] = false
    assert_valid schema, data, :version => :draft1

  end



  def test_additional_properties
    # Test no additional properties allowed
    schema = {
      "properties" => {
        "a" => { "type" => "integer" }
      },
      "additionalProperties" => false
    }

    data = {
      "a" => 10
    }

    assert_valid schema, data, :version => :draft1
    data["b"] = 5
    refute_valid schema, data, :version => :draft1

    # Test additional properties match a schema
    schema["additionalProperties"] = { "type" => "string" }
    data["b"] = "taco"
    assert_valid schema, data, :version => :draft1
    data["b"] = 5
    refute_valid schema, data, :version => :draft1
  end


  def test_items
    schema = {
      "items" => { "type" => "integer" }
    }

    data = [1,2,4]
    assert_valid schema, data, :version => :draft1
    data = [1,2,"string"]
    refute_valid schema, data, :version => :draft1

    schema = {
      "items" => [
        {"type" => "integer"},
        {"type" => "string"}
      ]
    }

    data = [1,"string"]
    assert_valid schema, data, :version => :draft1
    data = [1,"string",3]
    assert_valid schema, data, :version => :draft1
    data = ["string",1]
    refute_valid schema, data, :version => :draft1

  end


  def test_format_ipv4
    schema = {
      "type" => "object",
      "properties" => { "a" => {"type" => "string", "format" => "ip-address"}}
    }

    data = {"a" => "1.1.1.1"}
    assert_valid schema, data, :version => :draft1
    data = {"a" => "1.1.1"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "1.1.1.300"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => 5}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "1.1.1"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "1.1.1.1b"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "b1.1.1.1"}
  end


  def test_format_ipv6
    schema = {
      "type" => "object",
      "properties" => { "a" => {"type" => "string", "format" => "ipv6"}}
    }

    data = {"a" => "1111:2222:8888:9999:aaaa:cccc:eeee:ffff"}
    assert_valid schema, data, :version => :draft1
    data = {"a" => "1111:0:8888:0:0:0:eeee:ffff"}
    assert_valid schema, data, :version => :draft1
    data = {"a" => "1111:2222:8888::eeee:ffff"}
    assert_valid schema, data, :version => :draft1
    data = {"a" => "1111:2222:8888:99999:aaaa:cccc:eeee:ffff"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "1111:2222:8888:9999:aaaa:cccc:eeee:gggg"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "1111:2222::9999::cccc:eeee:ffff"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "1111:2222:8888:9999:aaaa:cccc:eeee:ffff:bbbb"}
    refute_valid schema, data, :version => :draft1
    assert(JSON::Validator.validate(schema, {"a" => "::1"}, :version => :draft1), 'validate with shortcut')
    assert(!JSON::Validator.validate(schema, {"a" => "42"}, :version => :draft1), 'not validate a simple number')
  end

  def test_format_time
    schema = {
      "type" => "object",
      "properties" => { "a" => {"type" => "string", "format" => "time"}}
    }

    data = {"a" => "12:00:00"}
    assert_valid schema, data, :version => :draft1
    data = {"a" => "12:00"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "12:00:60"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "12:60:00"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "24:00:00"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "0:00:00"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "-12:00:00"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "12:00:00b"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "12:00:00"}
    assert_valid schema, data, :version => :draft1
    data = {"a" => "12:00:00\nabc"}
    refute_valid schema, data, :version => :draft1
  end


  def test_format_date
    schema = {
      "type" => "object",
      "properties" => { "a" => {"type" => "string", "format" => "date"}}
    }

    data = {"a" => "2010-01-01"}
    assert_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-32"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "n2010-01-01"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-1-01"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-1"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-01n"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-01\nabc"}
    refute_valid schema, data, :version => :draft1
  end

  def test_format_datetime
    schema = {
      "type" => "object",
      "properties" => { "a" => {"type" => "string", "format" => "date-time"}}
    }

    data = {"a" => "2010-01-01T12:00:00Z"}
    assert_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-32T12:00:00Z"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-13-01T12:00:00Z"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-01T24:00:00Z"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-01T12:60:00Z"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-01T12:00:60Z"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-01T12:00:00z"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-0112:00:00Z"}
    refute_valid schema, data, :version => :draft1
    data = {"a" => "2010-01-01T12:00:00Z\nabc"}
    refute_valid schema, data, :version => :draft1
  end

  def test_format_unknown
    schema = {
      "type" => "object",
      "properties" => { "a" => {"type" => "string", "format" => "unknown"}}
    }

    data = {"a" => "I can write what I want here"}
    assert_valid schema, data, :version => :draft1
    data = {"a" => ""}
    assert_valid schema, data, :version => :draft1
  end


  def test_format_union
    data1 = {"a" => "boo"}
    data2 = {"a" => nil}

    schema = {
      "type" => "object",
      "properties" => { "a" => {"type" => ["string","null"], "format" => "ip-address"}}
    }
    refute_valid schema, data1, :version => :draft1
    assert_valid schema, data2, :version => :draft1
  end

end

