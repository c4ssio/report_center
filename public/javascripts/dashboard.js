
$(document).ready(function(){

  $('table.metrics_and_filters').click(
    function(e){
      //determine whether user clicked on inactive tab
      var inactive_tab=$(e.target).parents("td.inactive_tab")
      if (inactive_tab.length==1) {
        toggle_metrics_tab(inactive_tab[0])
      };
    })
}
);

  function toggle_metrics_tab(me){
    var prev_active_tab = $(me).parent().find(".active_tab")
    var prev_active_metrics_list = $(me).parent().parent().find(".active_metrics_list")
    var curr_active_tab = $(me)
    var curr_active_metrics_list = $(me).parent().parent().find(
    ".inactive_metrics_list").filter(function(){
    if ($(this).attr("name")==$(curr_active_tab).attr("name")) {return true}  
    })
    //set styling for new active/inactive tabs, hide/show appropiriate metrics lists'
    prev_active_tab.attr("class","inactive_tab")
    prev_active_metrics_list.attr("class","inactive_metrics_list")
    curr_active_metrics_list.attr("class","active_metrics_list")
    curr_active_tab.attr("class","active_tab")
  }
