# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready -> 
	# watch for change in language selection
	$("#exam_definition_master_question").change ->
		$("#concept option").remove()
		$("#subconcept option").remove()
		$.getJSON "/master_question/concepts_for_question", language: $("#exam_definition_master_question").val(), (data) ->
  			if data is null
    			window.console and console.log("null :(")
    			return
  			options = $("#concept")
  			$.each data, (item) ->
    			options.append $("<option />").val(data[item].id).text(data[item].concept)
    			$("#concept").prop "selectedIndex", -1

$(document).ready -> 
	# watch for change in concept selection
	$("#concept").change ->
		$("#subconcept option").remove()
		$.getJSON "/master_question/subconcepts_for_question", {language: $("#exam_definition_master_question").val(), concept: $("#concept option:selected").text()}, (data) ->
  			if data is null
    			window.console and console.log("null :(")
    			return
  			options = $("#subconcept")
  			$.each data, (item) ->
    			options.append $("<option />").val(data[item].id).text(data[item].subconcept)
    			$("#subconcept").prop "selectedIndex", -1


 # SELECT DISTINCT(subconcept), id FROM "master_questions" WHERE "master_questions"."language" = 'python' AND "master_questions"."concept" = '5' GROUP BY subconcept

	