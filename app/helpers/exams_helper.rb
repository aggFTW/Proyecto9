module ExamsHelper

	def format_values(values)
		JSON.parse("{" << values.gsub("-","").gsub(/(\^\d+)/,'"\\1"').gsub("\n",",").sub(",","").gsub(/(.*),(.*)/,'\\1\\2') << "}")
	end

	def format_answers(answers)
		answers.gsub("-","").gsub("\n",",").sub(",","").gsub(/(.*),(.*)/,'\\1\\2').split(/,/)
	end

end