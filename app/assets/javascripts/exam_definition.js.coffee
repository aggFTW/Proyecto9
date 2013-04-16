# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready -> 
	# watch for change in language selection
	$("#exam_definition_master_question").change ->
		$.getJSON "/master_questions/languages_for_question", {language: $("#exam_definition_master_question").val()}, (data) ->
  			if data is null
    			window.console and console.log($("#exam_definition_master_question").val())
    			return
  			options = $("#concept")
  			$.each data, (item) ->
    			options.append $("<option />").val(item).text(item)



