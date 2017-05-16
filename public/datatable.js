$(document).ready(function() {
  $(".datatable").DataTable({
    serverSide: true,
    ordering: false,
    ajax: $(".datatable").data("source"),
    // retrieve: true,
    // destroy: true,
    stateSave: true
  });
  var searchable = $(".searchable").attr("value");
  $(".input-sm").attr("placeholder", searchable);
})
