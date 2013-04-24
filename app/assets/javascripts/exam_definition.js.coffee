# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready -> 
	# watch for change in language selection
	$("#exam_definition_master_question").change ->
		$("#concept option").remove()
		$("#subconcept option").remove()
		$("#filteredMQ tr").remove()
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
		$("#filteredMQ tr").remove()
		$.getJSON "/master_question/subconcepts_for_question", {language: $("#exam_definition_master_question").val(), concept: $("#concept option:selected").text()}, (data) ->
  			if data is null
    			window.console and console.log("null :(")
    			return
  			options = $("#subconcept")
  			$.each data, (item) ->
    			options.append $("<option />").val(data[item].id).text(data[item].subconcept)
    			$("#subconcept").prop "selectedIndex", -1


 # SELECT DISTINCT(subconcept), id FROM "master_questions" WHERE "master_questions"."language" = 'python' AND "master_questions"."concept" = '5' GROUP BY subconcept
 # <%= button_tag "Cancel",:type => 'button',:class => "subBtn", :onclick => "" %>

$(document).ready ->
  $("#subconcept").change ->
    $("#filteredMQ tr").remove()
    $.getJSON "/master_question/filtered_master_questions",
      language: $("#exam_definition_master_question").val()
      concept: $("#concept option:selected").text()
      subconcept: $("#subconcept option:selected").text()
    , (data) ->
      if data is null
        window.console and console.log("null :(")
        return
      rows = $("#filteredMQ")
      $.each data, (item) ->
        rows.append $("<tr />")
        rows = $("#filteredMQ tr:last")
        rows.append $("<td />").append(data[item].inquiry)
        rows.append $("<td />").append($("<button/>",
          text: "Agregar Reactivo"
          type: "button"
          click: ->
            inquiry = $("#examInquiries")
            inquiry.append $("<tr />")
            inquiry = $("#examInquiries tr:last")
            inquiry.append $("<td />").append(data[item].inquiry)
            inquiry.append $("<td />").append("<input type=\"text\" id=\"value\" size=\"5\" placeholder=\"Valor del Reactivo\" />")
            inquiry.append $("<td />").append($("<button/>",
              text: "Eliminar Reactivo"
              type: "button"
              click: ->
                $(this).parent().parent().remove()
            ))
            inquiry = $("#examInquiries tbody")
        ))
        rows = $("#filteredMQ tbody")


$(document).ready ->
  $("#submit").click -> 