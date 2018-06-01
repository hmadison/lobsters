# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
Mime::Type.register 'application/ld+json', :ld_json
ActionDispatch::Request.parameter_parsers[:ld_json] = -> (body) { JSON.parse(body) }
