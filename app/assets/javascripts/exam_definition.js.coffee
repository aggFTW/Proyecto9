# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
addition = 0
calculated = false
i = 1
user_id = -1
groups_ids = []

$(document).ready ->
  $("#examInquiriesHeaders").hide()


$(document).ready ->
  $("#exam_definition_master_question").change ->
    i = 1
    $("#concept option").remove()
    $("#subconcept option").remove()
    $("#filteredMQ tr").remove()
    $("#examInquiries tr").remove()
    $.getJSON "/master_question/concepts_for_question",
      language: $("#exam_definition_master_question").val()
    , (data) ->
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
      if data is null
        window.console and console.log("null :(")
        return
      options = $("#subconcept")
      $.each data, (item) ->
        options.append $("<option />").val(data[item].id).text(data[item].subconcept)
        $("#subconcept").prop "selectedIndex", -1

$(document).ready ->
  $("#subconcept").change ->
    $("#filteredMQ tr").remove()
    $.getJSON "/master_question/filtered_master_questions",
      language: $("#exam_definition_master_question").val()
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
            inquiry.append $("<td />").append(i++)
            inquiry.append $("<td />").append(data[item].id)
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
            temp = $(this).find("td:nth-child(4) input:first").val()
            if $.isNumeric(temp) is true
              if parseInt(temp) > 0
                addition += parseInt(temp)
              else
                addition += 1
                $(this).find("td:nth-child(4) input:first").val 1
            else
              addition += 1
              $(this).find("td:nth-child(4) input:first").val 1

          rows.each (index, value) ->
            temp = $(this).find("td:nth-child(4) input:first").val()
            $(this).find("td:nth-child(4) input:first").val (parseInt(temp) / parseInt(addition)) * 100  if $.isNumeric(temp) is true

        dataToSend = []
        dataIndex = 0
        cdt = new Date()
        $("#examInquiries tr").each ->
          dataToSend.push
            numQuestion: parseInt(dataIndex + 1)
            numInquiry: parseInt($(this).find("td:nth-child(2)").text())
            value: parseFloat($(this).find("td:nth-child(4) input:first").val()) / 100
            master_question_id: parseInt($("#examInquiries").find("td:nth-child(2)").text())
            
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
          startYear: $("#start_Date_1i").val()
          startMonth: $("#start_Date_2i").val()
          startDay: $("#start_Date_3i").val()
          startHour: $("#start_Time_4i").val()
          startMinute: $("#start_Time_5i").val()
          endYear: $("#end_Date_1i").val()
          endMonth: $("#end_Date_2i").val()
          endDay: $("#end_Date_3i").val()
          endHour: $("#end_Time_4i").val()
          endMinute: $("#end_Time_5i").val()

        , (data) ->
        $("#exam_definition_master_question").prop "selectedIndex", 0
        $("#filteredMQ tr").remove()
        $("#concept option").remove()
        $("#subconcept option").remove()
        $("#attempts_number").val ""
        $("#examInquiries tr").remove()
        $("#examInquiriesHeaders").hide()
        i = 1
      else
        window.console and console.log("Nombre de examen debe ser mayor a 5")
        alert "Nombre de examen debe ser mayor a 5"
    else
      window.console and console.log("No hay reactivos seleccionados")
      alert "No hay reactivos seleccionados"

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
          temp = $(this).find("td:nth-child(4) input:first").val()
          if $.isNumeric(temp) is true
            if parseInt(temp) > 0
              addition += parseInt(temp)
            else
              addition += 1
              $(this).find("td:nth-child(4) input:first").val 1
          else
            addition += 1
            $(this).find("td:nth-child(4) input:first").val 1

        rows.each (index, value) ->
          temp = $(this).find("td:nth-child(4) input:first").val()
          $(this).find("td:nth-child(4) input:first").val (parseInt(temp) / parseInt(addition)) * 100  if $.isNumeric(temp) is true

      else
        alert "Ya fue calculado. Modifique el valor de algún reactivo para poder volver a calcular."
    else
      window.console and console.log("No hay reactivos seleccionados")
      alert "No hay reactivos seleccionados"

$(document).ready ->
  $("#eraseEverything").click ->
    $("#filteredMQ tr").remove()
    $("#examInquiries tr").remove()
    $("#concept option").remove()
    $("#subconcept option").remove()
    $("#exam_definition_master_question").prop "selectedIndex", -1
    $("#attempts_number").val ""
    $("#name_exam").val ""
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
    $("#examInquiriesHeaders").hide()


# edit view
addUser = false
$(document).ready -> 
  $("#addUsers").click ->
    window.location = "/edit/"+user_id
    addUser = true

$(document).ready ->
  $(window).load ->
    $("#examName").ready ->
      $.getJSON "/user/get_current_user", (data) ->
        user_id = data
        $.getJSON "/exam/get_exams", (data) ->
          examDropDown = $("#examName")
          $.each data, (item) ->
            examDropDown.append $("<option />").val(data[item].id).text(data[item].name + " - " + data[item].dateCreation)
          $("#examName").prop "selectedIndex", -1

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
              # text: data[item].name
            ))
            $("#groups label:last").append( data[item].name )
          groups_ids = null  if groups_ids.length < 1
          $.getJSON "/user/get_users",
            groups_ids_: groups_ids
          , (data) ->
            usersCheckBox = $("#users")
            $.each data, (item) ->
              usersCheckBox.append ($("<label />")
              .append $("<input />",
                type: "checkbox"
                name: "users"
                value: data[item].id
                # text: data[item].name
              ))
              $("#users label:last").append( data[item].username + " " + data[item].fname + " " + data[item].lname )
            


# Add a "When selected exam changes get all users an groups that can take that exam"
$(document).ready->
  $("#examName").change->
    $.getJSON "/user/set_users_cantake",
      checked_groups: checkedGroups
      checked_users: checkedUsers
      exam_id: $("#examName").val()
    , (data) ->
    window.location = "/edit/" + user_id
# Also, improve queries to allow that if users are selected when we select an exam don't display them again

# Also, when I add a user, delete it from the selectable checkboxes

# Also, when I remove a user, add it to the selectable checkboxes


# When I clic on Agregar

$(document).ready ->
  $("#add").click ->
    checkedGroups = $("input[name=groups]:checked").map(->
      $(this).val()
    ).get()
    checkedUsers = $("input[name=users]:checked").map(->
      $(this).val()
    ).get()
    $.getJSON "/user/set_users_cantake",
      checked_groups: checkedGroups
      checked_users: checkedUsers
      exam_id: $("#examName").val()
    , (data) ->
    window.location = "/edit/" + user_id



# When I clic on Quitar


# When I clic on Agregar Grupos

# When I clic on Agregar Usuarios
# When I clic on Continuar 
$(document).ready ->
  $("#continueToHome").click ->
    window.location = "/users/"+user_id





# This is the converter of groups to users
# $(document).ready ->
#   $(window).load ->
#     $("#groupsToUsers").click ->
#       boxes = $("input[name=groups]:checked")
#       $.each boxes, (item) ->
#         alert boxes[item].value
#         # boxes
    

    # This is a desperate way to show the flashes made in ruby
# (($, undefined_) ->
#   $.notification = (options) ->
#     opts = $.extend({},
#       type: "notice"
#       time: 3000
#     , options)
#     o = opts
#     timeout = setTimeout("$.notification.removebar()", o.time)
#     message_span = $("<span />").addClass("jbar-content").html(o.message)
#     wrap_bar = $("<div />").addClass("jbar jbar-top").css("cursor", "pointer")
#     wrap_bar.css color: "#D8000C"  if o.type is "error"
#     wrap_bar.click ->
#       $.notification.removebar()

#     wrap_bar.append(message_span).hide().insertBefore($(".container")).fadeIn "fast"

#   timeout = undefined
#   $.notification.removebar = (txt) ->
#     if $(".jbar").length
#       clearTimeout timeout
#       $(".jbar").fadeOut "fast", ->
#         $(this).remove()

# ) jQuery