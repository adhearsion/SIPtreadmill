# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("input#scenario_receiver").change ->
    if $(this).is(':checked')
      $("#reg_scenario_form").show()
    else
      $("#reg_scenario_form").hide()

  $("input:radio[name=type]").change ->
    $("#scenario_type_form_row").show()
    if $(this).val() is "sippy_cup"
      if $("#scenario_sipp_xml").val() or $("#scenario_pcap_audio").val() or $("#scenario_csv_data").val()
        if window.confirm "You can have either Sippy Cup scenario data or SIPp XML data associated with a scenario. Continuing will erase your SIPp XML data that you entered."
          $("#sippyCupForm").show()
          $("#scenario_sipp_xml").val("")
          $("#scenario_pcap_audio").val("") 
          $("#scenario_csv_data").val("")
          $("#sippForm").hide()
        else
          $("#scenario_type_sippy_cup").prop('checked', false)
          $("#scenario_type_sipp_xml").prop('checked', true)
      else
        $("#sippyCupForm").show()
        $("#sippForm").hide()
    else
      if $("#scenario_sippy_cup_scenario").val()
        if window.confirm "You can have either Sippy Cup scenario data or SIPp XML data associated with a scenario. Continuing will erase your Sippy Cup data that you entered."
          $("#sippyCupForm").hide()
          $("#scenario_sippy_cup_scenario").val("")
          $("#sippForm").show()
        else
          $("#scenario_type_sipp_xml").prop('checked', false)
          $("#scenario_type_sippy_cup").prop('checked', true)
      else
        $("#sippyCupForm").hide()
        $("#sippForm").show()

  $("input:radio[name=type_2]").change ->
    $("#scenario_type_form_row_2").show()
    if $(this).val() is "sippy_cup"
      if $("#registration_scenario_sipp_xml").val() or $("#registration_scenario_pcap_audio").val() or $("#registration_scenario_csv_data").val()
        if window.confirm "You can have either Sippy Cup scenario data or SIPp XML data associated with a scenario. Continuing will erase your SIPp XML data that you entered for your registration scenario."
          $("#sippyCupForm_2").show()
          $("#registration_scenario_sipp_xml").val("")
          $("#registration_scenario_pcap_audio").val("") 
          $("#registration_scenario_csv_data").val("")
          $("#sippForm_2").hide()
        else
          $("#registration_type_sippy_cup").prop('checked', false)
          $("#registration_type_sipp_xml").prop('checked', true)
      else
        $("#sippyCupForm_2").show()
        $("#sippForm_2").hide()
    else
      if $("#registration_scenario_sippy_cup_scenario").val()
        if window.confirm "You can have either Sippy Cup scenario data or SIPp XML data associated with a scenario. Continuing will erase your Sippy Cup data that you entered for your registration scenario."
          $("#sippyCupForm_2").hide()
          $("#registration_scenario_sippy_cup_scenario").val("")
          $("#sippForm_2").show()
        else
          $("#registration_type_sipp_xml").prop('checked', false)
          $("#registration_type_sippy_cup").prop('checked', true)
      else
        $("#sippyCupForm_2").hide()
        $("#sippForm_2").show()

  if $('#scenario_sippy_cup_scenario').val()
    # Show sippy cup scenario form.
    $("#sippyCupForm").show();
    $("#sippForm").hide();
    $("#scenario_type_sipp_xml").prop('checked', false)
    $("#scenario_type_sippy_cup").prop('checked', true)
  else if $("#scenario_sipp_xml").val() or $("#scenario_pcap_audio").val() or $("#scenario_csv_data").val()
    # Show SIPp scenario form.
    $("#sippyCupForm").hide();
    $("#sippForm").show();
    $("#scenario_type_sipp_xml").prop('checked', true)
    $("#scenario_type_sippy_cup").prop('checked', false)

  if $('#registration_scenario_sippy_cup_scenario').val()
    # Show sippy cup scenario form.
    $("#sippyCupForm_2").show();
    $("#sippForm_2").hide();
    $("#registration_type_sipp_xml").prop('checked', false)
    $("#registration_type_sippy_cup").prop('checked', true)
  else if $("#registration_scenario_sipp_xml").val() or $("#registration_scenario_pcap_audio").val() or $("#registration_scenario_csv_data").val()
    # Show SIPp scenario form.
    $("#sippyCupForm_2").hide();
    $("#sippForm_2").show();
    $("#registration_type_sipp_xml").prop('checked', true)
    $("#registration_type_sippy_cup").prop('checked', false)

  $(".uploader").addClass("span11");
