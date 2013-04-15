module ExamsHelper

	def format_values(values)
		"{" << values.gsub("-","").gsub(/(\^\d+)/,'"\\1"').gsub("\n",",").sub(",","").gsub(/(.*),(.*)/,'\\1\\2') << "}"
	end
end
