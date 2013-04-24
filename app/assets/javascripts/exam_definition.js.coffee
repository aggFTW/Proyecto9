# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#exam_definition_master_question").change ->
    $("#concept option").remove()
    $("#subconcept option").remove()
    $("#filteredMQ tr").remove()
    $("#examInquiries tr").remove()
    $.getJSON "/master_question/concepts_for_question",
      language: $("#exam_definition_master_question").val()
    , (data) ->
      options = undefined
      if data is null
        window.console and console.log("null :(")
        return
      options = $("#concept")
      $.each data, (item) ->
        options.append $("<option />").val(data[item].id).text(data[item].concept)
        $("#concept").prop "selectedIndex", -1

$(document).ready ->
  $("#concept").change ->
    $("#subconcept option").remove()
    $("#filteredMQ tr").remove()
    $.getJSON "/master_question/subconcepts_for_question",
      language: $("#exam_definition_master_question").val()
      concept: $("#concept option:selected").text()
    , (data) ->
      options = undefined
      if data is null
        window.console and console.log("null :(")
        return
      options = $("#subconcept")
      $.each data, (item) ->
        options.append $("<option />").val(data[item].id).text(data[item].subconcept)
        $("#subconcept").prop "selectedIndex", -1


 # SELECT DISTINCT(subconcept), id FROM "master_questions" WHERE "master_questions"."language" = 'python' AND "master_questions"."concept" = '5' GROUP BY subconcept
 # <%= button_tag "Cancel",:type => 'button',:class => "subBtn", :onclick => "" %>

i = 1
$(document).ready ->
  $("#subconcept").change ->
    $("#filteredMQ tr").remove()
    $.getJSON "/master_question/filtered_master_questions",
      language: $("#exam_definition_master_question").val()
      concept: $("#concept option:selected").text()
      subconcept: $("#subconcept option:selected").text()
    , (data) ->
      rows = undefined
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
            inquiry = undefined
            inquiry = $("#examInquiries")
            inquiry.append $("<tr />")
            inquiry = $("#examInquiries tr:last")
            inquiry.append $("<td />").append(i++)
            inquiry.append $("<td />").append(data[item].id)
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


addition = 0
$(document).ready ->
  $("#submit").click ->
    numInquiries = $("#examInquiries").prop("rows").length
    if numInquiries > 0
      rows = $("#examInquiries tr")
      rows.each (index, value) ->
        temp = $(this).find("td:nth-child(4) input:first").val()
        if $.isNumeric(temp) is true
          addition += parseInt(temp)
        else
          addition = 0
          alert "Un valor de un reactivo no es numérico: " + temp
          window.console and console.log("Un valor de un reactivo no es numérico: " + temp)
          return

      rows.each (index, value) ->
        temp = $(this).find("td:nth-child(4) input:first").val()
        if $.isNumeric(temp) is true
          $(this).find("td:nth-child(4) input:first").val (parseInt(temp) / parseInt(addition)) * 100
        else
          return

      $("#filteredMQ tr").remove()
      $("#concept option").remove()
      $("#subconcept option").remove()
      $("#exam_definition_master_question").prop "selectedIndex", 0
      $("#attempts_number").val ""
    else
      window.console and console.log("No hay reactivos seleccionados")
      alert "No hay reactivos seleccionados"


$(document).ready ->
  $("#ereaseEverything").click ->
    $("#filteredMQ tr").remove()
    $("#concept option").remove()
    $("#subconcept option").remove()
    $("#exam_definition_master_question").prop "selectedIndex", -1
    $("#attempts_number").val ""
    $("#start_Date_3i").prop "selectedIndex", -1
    $("#start_Date_2i").prop "selectedIndex", -1
    $("#start_Date_1i").prop "selectedIndex", -1
    $("#start_Time_5i").prop "selectedIndex", -1
    $("#start_Time_4i").prop "selectedIndex", -1
    $("#end_Date_3i").prop "selectedIndex", -1
    $("#end_Date_2i").prop "selectedIndex", -1
    $("#end_Date_1i").prop "selectedIndex", -1
    $("#end_Time_5i").prop "selectedIndex", -1
    $("#end_Time_4i").prop "selectedIndex", -1

$(document).ready ->
  $("#setDefaults").click ->
    $("#filteredMQ tr").remove()
    $("#examInquiries tr").remove()
    $("#concept option").remove()
    $("#subconcept option").remove()
    $("#exam_definition_master_question").prop "selectedIndex", 0
    $("#attempts_number").val ""
    $("#start_Date_3i").prop "selectedIndex", 0
    $("#start_Date_2i").prop "selectedIndex", 0
    $("#start_Date_1i").prop "selectedIndex", 0
    $("#start_Time_5i").prop "selectedIndex", 0
    $("#start_Time_4i").prop "selectedIndex", 0
    $("#end_Date_3i").prop "selectedIndex", 0
    $("#end_Date_2i").prop "selectedIndex", 0
    $("#end_Date_1i").prop "selectedIndex", 0
    $("#end_Time_5i").prop "selectedIndex", 0
    $("#end_Time_4i").prop "selectedIndex", 0 