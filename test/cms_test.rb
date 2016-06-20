ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'

require_relative '../cms'

Minitest::Reporters.use!

class CMSTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get '/'
    assert_equal 200, last_response.status
    assert_match 'about.md', last_response.body
    assert_match 'changes.txt', last_response.body
    assert_match 'history.txt', last_response.body
  end

  def test_text_file
    get '/history.txt'
    assert_equal 200, last_response.status
    assert_equal 'text/plain', last_response['Content-Type']
    assert_match 'Lorem ipsum dolor sit amet', last_response.body
  end

  def test_document_not_found
    get '/notafile.ext'
    assert 302, last_response.status

    get last_response["Location"]

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'notafile.ext does not exist'
  end

  def test_markdown_file
    get '/about.md'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, '<h1>'
  end
end
