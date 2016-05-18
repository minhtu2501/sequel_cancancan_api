require File.expand_path("spec_helper", File.dirname(File.dirname(__FILE__)))

describe "middleware plugin" do 
  it "turns Roda app into middlware" do
    a2 = app(:bare) do
      plugin :middleware

      route do |r|
        r.is "a" do
          "a2"
        end
        r.post "b" do
          "b2"
        end
      end
    end

    a3 = app(:bare) do
      plugin :middleware

      route do |r|
        r.get "a" do
          "a3"
        end
        r.get "b" do
          "b3"
        end
      end
    end

    app(:bare) do
      use a3
      use a2

      route do |r|
        r.is "a" do
          "a1"
        end
        r.is "b" do
          "b1"
        end
      end
    end

    body('/a').must_equal 'a3'
    body('/b').must_equal 'b3'
    body('/a', 'REQUEST_METHOD'=>'POST').must_equal 'a2'
    body('/b', 'REQUEST_METHOD'=>'POST').must_equal 'b2'
    body('/a', 'REQUEST_METHOD'=>'PATCH').must_equal 'a2'
    body('/b', 'REQUEST_METHOD'=>'PATCH').must_equal 'b1'
  end

  it "makes it still possible to use the Roda app normally" do
    app(:middleware) do
      "a"
    end
    body.must_equal 'a'
  end

  it "is compatible with the multi_route plugin" do
    app(:bare) do
      plugin :multi_route
      plugin :middleware

      route("a") do |r|
        r.is "b" do
          "ab"
        end
      end

      route do |r|
        r.multi_route
      end
    end

    body('/a/b').must_equal 'ab'
  end

  it "uses the app's middleware if :include_middleware option is given" do
    mid = Struct.new(:app) do
      def call(env)
        env['foo'] = 'bar'
        app.call(env)
      end
    end
    app(:bare) do
      plugin :middleware, :include_middleware=>true
      use mid
      route{}
    end
    mid2 = app
    app(:bare) do
      use mid2
      route{env['foo']}
    end
    body.must_equal 'bar'
  end
end
