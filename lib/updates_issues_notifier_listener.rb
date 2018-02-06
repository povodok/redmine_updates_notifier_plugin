require 'uri'
require 'net/http'
require 'json'

class UpdatesIssuesNotifierListener < Redmine::Hook::ViewListener
  CALLBACK_URL = 'https://localhost:3333'.freeze

  def controller_issues_edit_after_save(context = {})
    data = {
      'issueid'  => context[:issue].id,
      'userid'   => User.current.id,
      'datetime' => context[:issue].updated_on.strftime('%Y-%m-%d %H:%M:%S')
    }

    uri = URI(CALLBACK_URL)
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = { 'data' => data }.to_json
    Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
  end
end
