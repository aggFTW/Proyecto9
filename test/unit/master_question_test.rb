require 'test_helper'

class MasterQuestionTest < ActiveSupport::TestCase

   test "returns all languages" do
   	 languages = MasterQuestion.all_languages
   	 languages_strings = languages.map { |l| l.language }
   	 assert_equal(languages_strings, ["Python" , "MyString"])
   end




end
