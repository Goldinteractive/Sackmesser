# Require any additional compass plugins here.
require 'json'

# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "assets/css"
sass_dir = "assets/scss"
images_dir = "assets/img"
javascripts_dir = "assets/js"
fonts_dir = "assets/css/fonts"
shared_variables_file = "assets/shared-variables.json"

output_style = :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false

color_output = true

sass_options = {
	:custom => {'shared_variables' => shared_variables_file}
	#:debug_info => true
}

# This function allows to share variables between javascript and compass by using a simple flat json file
module Sass::Script::Functions
	def get_shared_var(variable)
		# read the json
		unless json = JSON.load(IO.read(options[:custom]['shared_variables']))
			raise Sass::SyntaxError.new("Error: File '#{options[:custom]['shared_variables']}' does not exist")
		end
		# get the json variable as string
		if json[variable.value]
			Sass::Script::String.new(json[variable.value])
		else
			raise Sass::SyntaxError.new("Error: Breakpoint '#{variable}' does not exist, choose from the following: #{json.keys.join(', ')}")
		end
	end
end
