#!/usr/local/bin/ruby
#
require "zabbixapi"
require 'net/http'
require 'uri'

zbx = ZabbixApi.connect(
  :url => 'http://127.0.0.1/zabbix/api_jsonrpc.php',
  :user => 'USERNAME',
  :password => 'PASSWORD'
)

graphid = GRAPHID
width = 600
height = 150
period = 604800

result_file = "graph.png"

params  = "graphid=#{graphid}&width=#{width}&height=#{height}&period=#{period}"
session_id = "zbx_sessionid=#{zbx.client.auth}"

url = URI.parse('http://127.0.0.1/zabbix/chart2.php')

Net::HTTP.start("#{url.host}") { |http|
  resp = http.get("#{url.path}?#{params}",{'Cookie' => "#{session_id}"})
  open("#{result_file}" ,"wb") { |file|
    file.write(resp.body)
  }
}
