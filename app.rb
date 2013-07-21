require 'open-uri'
require 'json'
require 'sinatra'
require 'capybara'

class FakeYouTube < Sinatra::Base
  def self.boot
    instance = new
    Capybara::Server.new(instance).tap { |server| server.boot }
  end

  get '/youtube' do
    puts 'I am here'
    File.read('youtube.json')
  end

  puts "Fake = #{Thread.current}"
end

@@server = FakeYouTube.boot

class CapyTest
  def self.call(env)
    fake_youtube = "http://#{@@server.host}:#{@@server.port}/youtube"

    [ 200,
      { "Access-Control-Allow-Origin" => "*", "Content-Type" => "text/html" },
      [%Q|<html>
        <head>
          <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
        </head>
        <body>
          <script type="text/javascript">
            $(document).ready(function() {
              $.getJSON('https://gdata.youtube.com/feeds/api/videos?alt=json&max-results=2&q=The%20Buggles', function(data) {
                $('.youtube_client').append(data.feed.title.$t);
              });
              $.getJSON('#{fake_youtube}', function(data) {
                $('.fake_youtube_client').append(data.feed.title.$t);
              });
            });
          </script>

        <div class="youtube_client"></div>
        <div class="fake_youtube_client"></div>
        <div class="youtube_server">#{JSON.parse(open('https://gdata.youtube.com/feeds/api/videos?alt=json&max-results=2&q=The%20Buggles').read)['feed']['title']['$t']}</div>
        </body>
      </html>|],
    ]
  end
end
