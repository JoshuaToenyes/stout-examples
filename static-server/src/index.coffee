zlib = require 'zlib'

HTTPCompress     = require '/Users/josh/work/stout/server/server/http/Compress'
HTTPServer       = require '/Users/josh/work/stout/server/server/http/HTTPServer'
StaticController = require '/Users/josh/work/stout/server/server/http/StaticController'

s = new HTTPServer
s.port = 8011

s._post new HTTPCompress

s.routes =
  '/*splat': new StaticController 'static'

s.start()
