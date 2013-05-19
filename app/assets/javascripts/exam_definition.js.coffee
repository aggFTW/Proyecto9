# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
addition = 0
calculated = false
i = 1
user_id = -1
groups_ids = []

$(document).ready ->
  $(window).load ->
    $("#examInquiriesHeaders").hide()
    languages = $("#language")
    $.getJSON "/master_question/get_languages"
      , (data) ->
        $.each data, (item) ->
          languages.append $("<option />").val(data[item].language).text(data[item].language)

$(document).ready ->
  $("#language").change ->
    i = 1
    $("#concept option").remove()
    $("#subconcept option").remove()
    $("#filteredMQ tr").remove()
    $("#examInquiries tr").remove()
    $.getJSON "/master_question/concepts_for_question",
      language: $("#language").val()
    , (data) ->
      if data is null
        window.console and console.log("null :(")
        return
      options = $("#concept")
      options.append $("<option />").val(-1).text("Selecciona un Concepto")
      $.each data, (item) ->
        options.append $("<option />").val(data[item].id).text(data[item].concept)
      $("#concept").prop "selectedIndex", 0
      $("#subconcept").append $("<option />").val(-1).text("Selecciona un Subconcepto")
      $("#subconcept").prop "selectedIndex", 0


$(document).ready ->
  $("#concept").change ->
    $("#subconcept option").remove()
    $("#filteredMQ tr").remove()
    $.getJSON "/master_question/subconcepts_for_question",
      language: $("#language").val()
      concept: $("#concept option:selected").text()
    , (data) ->
      if data is null
        window.console and console.log("null :(")
        return
      options = $("#subconcept")
      options.append $("<option />").val(-1).text("Selecciona un Subconcepto")
      $.each data, (item) ->
        options.append $("<option />").val(data[item].id).text(data[item].subconcept)
        $("#subconcept").prop "selectedIndex", 0

$(document).ready ->
  $("#subconcept").change ->
    $("#filteredMQ tr").remove()
    $.getJSON "/master_question/filtered_master_questions",
      language: $("#language").val()
      concept: $("#concept option:selected").text()
      subconcept: $("#subconcept option:selected").text()
    , (data) ->
      if data is null
        alert "No se encontró nada en la base de datos con las características anteriores."
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
          class: "btn"
          click: ->
            calculated = false
            $("#examInquiriesHeaders").show()

            inquiry = $("#examInquiries")
            inquiry.append $("<tr />")
            inquiry = $("#examInquiries tr:last")
            inquiry.append $("<td />").append(data[item].id).hide()
            inquiry.append $("<td />").append(data[item].inquiry)
            input1 = $("<input type=\"text\" id=\"value\" size=\"5\" placeholder=\"Valor del Reactivo\" />").change(->
              calculated = false
            )
            inquiry.append $("<td />").append(input1)
            inquiry.append $("<td />").append($("<button/>",
              text: "Eliminar Reactivo"
              type: "button"
              class: "btn btn-danger"
              click: ->
                $(this).parent().parent().remove()
                calculated = false;
                if $("#examInquiries").prop("rows").length < 1
                  $("#examInquiriesHeaders").hide()

            ))
            inquiry = $("#examInquiries tbody")
        ))
        rows = $("#filteredMQ tbody")

$(document).ready ->
  $("#submit").click ->
    numInquiries = $("#examInquiries").prop("rows").length
    examNameLength = $("#name_exam").val().length
    checkedGroups = $("input[name=groups]:checked").map(->
      $(this).val()
    ).get()
    numberOfSelectedGroups = checkedGroups.length
    if numInquiries > 0
      if examNameLength > 5
        if numberOfSelectedGroups > 0
          if $.isNumeric($("#attempts_number").val()) is true
            $("#attempts_number").val "1"  if parseInt($("#attempts_number").val()) < 1
          else
            $("#attempts_number").val "1"
          addition = 0
          rows = $("#examInquiries tr")
          unless calculated
            calculated = true
            rows.each (index, value) ->
              temp = $(this).find("td:nth-child(3) input:first").val()
              if $.isNumeric(temp) is true
                if parseInt(temp) > 0
                  addition += parseInt(temp)
                else
                  addition += 1
                  $(this).find("td:nth-child(3) input:first").val 1
              else
                addition += 1
                $(this).find("td:nth-child(3) input:first").val 1

            rows.each (index, value) ->
              temp = $(this).find("td:nth-child(3) input:first").val()
              $(this).find("td:nth-child(3) input:first").val (parseInt(temp) / parseInt(addition)) * 100  if $.isNumeric(temp) is true

          dataToSend = []
          dataIndex = 0
          cdt = new Date()
          $("#examInquiries tr").each ->
            dataToSend.push
              numInquiry: parseInt($(this).find("td:nth-child(1)").text())
              value: parseFloat($(this).find("td:nth-child(3) input:first").val()) / 100
              master_question_id: parseInt($(this).find("td:nth-child(1)").text())

            dataIndex++

          $.getJSON "/exam_definition/exam_def",
            hash: dataToSend
            exam_name: $("#name_exam").val()
            number_of_attempts: $("#attempts_number").val()
            creationYear: cdt.getFullYear()
            creationMonth: cdt.getMonth() + 1
            creationDay: cdt.getDate()
            creationHour: cdt.getHours()
            creationMinute: cdt.getMinutes()
            startYear: $("#datestart").datepicker("getDate").getFullYear()
            startMonth: $("#datestart").datepicker("getDate").getMonth() + 1
            startDay: $("#datestart").datepicker("getDate").getDate()
            startHour: $("#start_Time_4i").val()
            startMinute: $("#start_Time_5i").val()
            endYear: $("#dateend").datepicker("getDate").getFullYear()
            endMonth: $("#dateend").datepicker("getDate").getMonth() + 1
            endDay: $("#dateend").datepicker("getDate").getDate()
            endHour: $("#end_Time_4i").val()
            endMinute: $("#end_Time_5i").val()
          , (data) ->

          $.getJSON "/user/set_users_cantake",
            checked_groups: checkedGroups
            exam_name: $("#name_exam").val()
          , (data) ->

          $("#language").prop "selectedIndex", 0
          $("#filteredMQ tr").remove()
          $("#concept option").remove()
          $("#concept").append $("<option />").val(-1).text("Selecciona un Concepto").prop "selectedIndex", 0
          $("#subconcept option").remove()
          $("#subconcept").append $("<option />").val(-1).text("Selecciona un Suboncepto").prop "selectedIndex", 0
          $("#attempts_number").prop "selectedIndex", 0
          $("#examInquiries tr").remove()
          $("#examInquiriesHeaders").hide()
          $("#name_exam").val ""
          checkedGroups = $("input[name=groups]:checked").map(->
            $(this).attr('checked', false);
          )

          i = 1

          alert "Examen creado exitosamente."

          window.location = "/exams"
        else
          window.console and console.log("Debe seleccionar por lo menos un grupo")
          alert "No hay grupos seleccionados"
      else
        window.console and console.log("Nombre de examen debe ser mayor a 5")
        alert "Nombre de examen debe ser mayor a 5"
    else
      window.console and console.log("No hay reactivos seleccionados")
      alert "No hay reactivos seleccionados"


$(document).ready ->
  $("#submit_exercise").click ->
    numInquiries = $("#examInquiries").prop("rows").length
    examNameLength = $("#name_exam").val().length

    if numInquiries > 0
      if examNameLength > 5
          if $.isNumeric($("#attempts_number").val()) is true
            $("#attempts_number").val "1"  if parseInt($("#attempts_number").val()) < 1
          else
            $("#attempts_number").val "1"
          addition = 0
          rows = $("#examInquiries tr")
          unless calculated
            calculated = true
            rows.each (index, value) ->
              temp = $(this).find("td:nth-child(3) input:first").val()
              if $.isNumeric(temp) is true
                if parseInt(temp) > 0
                  addition += parseInt(temp)
                else
                  addition += 1
                  $(this).find("td:nth-child(3) input:first").val 1
              else
                addition += 1
                $(this).find("td:nth-child(3) input:first").val 1

            rows.each (index, value) ->
              temp = $(this).find("td:nth-child(3) input:first").val()
              $(this).find("td:nth-child(3) input:first").val (parseInt(temp) / parseInt(addition)) * 100  if $.isNumeric(temp) is true

          dataToSend = []
          dataIndex = 0
          cdt = new Date()
          $("#examInquiries tr").each ->
            dataToSend.push
              numInquiry: parseInt($(this).find("td:nth-child(1)").text())
              value: parseFloat($(this).find("td:nth-child(3) input:first").val()) / 100
              master_question_id: parseInt($(this).find("td:nth-child(1)").text())

            dataIndex++

          $.getJSON "/exam_definition/exam_def",
            hash: dataToSend
            exam_name: $("#name_exam").val()
            number_of_attempts: $("#attempts_number").val()
            creationYear: cdt.getFullYear()
            creationMonth: cdt.getMonth() + 1
            creationDay: cdt.getDate()
            creationHour: cdt.getHours()
            creationMinute: cdt.getMinutes()
            startYear: cdt.getFullYear()
            startMonth: cdt.getMonth() + 1
            startDay: cdt.getDate() - 1
            startHour: cdt.getHours()
            startMinute: cdt.getMinutes()
            endYear: cdt.getFullYear() + 10
            endMonth: cdt.getMonth() + 1
            endDay: cdt.getDate()
            endHour: cdt.getHours()
            endMinute: cdt.getMinutes()
          , (data) ->

          $.getJSON "/user/set_user_cantake_own",
            exam_name: $("#name_exam").val()
          , (data) ->

          $("#language").prop "selectedIndex", 0
          $("#filteredMQ tr").remove()
          $("#concept option").remove()
          $("#concept").append $("<option />").val(-1).text("Selecciona un Concepto").prop "selectedIndex", 0
          $("#subconcept option").remove()
          $("#subconcept").append $("<option />").val(-1).text("Selecciona un Subconcepto").prop "selectedIndex", 0
          $("#examInquiries tr").remove()
          $("#examInquiriesHeaders").hide()
          $("#name_exam").val ""

          i = 1
          window.location = "/pending"
      else
        window.console and console.log("Nombre de ejercicio debe ser mayor a 5")
        alert "Nombre de ejercicio debe ser mayor a 5"
    else
      window.console and console.log("No hay reactivos seleccionados para ejercicio")
      alert "No hay reactivos seleccionados para ejercicio"

$(document).ready ->
  $("#calculateValues").click ->
    numInquiries = $("#examInquiries").prop("rows").length
    if numInquiries > 0
      if $.isNumeric($("#attempts_number").val()) is true
        $("#attempts_number").val "1"  if parseInt($("#attempts_number").val()) < 1
      else
        $("#attempts_number").val "1"
      addition = 0
      rows = $("#examInquiries tr")
      unless calculated
        calculated = true
        rows.each (index, value) ->
          temp = $(this).find("td:nth-child(3) input:first").val()
          if $.isNumeric(temp) is true
            if parseInt(temp) > 0
              addition += parseInt(temp)
            else
              addition += 1
              $(this).find("td:nth-child(3) input:first").val 1
          else
            addition += 1
            $(this).find("td:nth-child(3) input:first").val 1

        rows.each (index, value) ->
          temp = $(this).find("td:nth-child(3) input:first").val()
          $(this).find("td:nth-child(3) input:first").val (parseInt(temp) / parseInt(addition)) * 100  if $.isNumeric(temp) is true

      else
        alert "Ya fue calculado. Modifique el valor de algún reactivo para poder volver a calcular."
    else
      window.console and console.log("No hay reactivos seleccionados")
      alert "No hay reactivos seleccionados"

$(document).ready ->
  $(window).load ->
    if $("#get_groups_SPECIALHIDDENTAG").length > 0
      $.getJSON "/user/get_current_user", (data) ->
        user_id = data

      $.getJSON "/group/get_groups", (data) ->
        groupsCheckBox = $("#groups")
        groups_ids = []
        $.each data, (item) ->
          groups_ids.push id: data[item].id
          groupsCheckBox.append ($("<label />")
          .append $("<input />",
            type: "checkbox"
            name: "groups"
            value: data[item].id
          ))
          $("#groups label:last").append( data[item].name )

