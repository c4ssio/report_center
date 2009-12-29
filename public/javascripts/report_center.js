/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function getChildren(id,parent_name,new_s_name,new_c_name){
    //submit request to server
    $.ajax({
        data: 'series_name=' + new_s_name +
        '&category_name=' + new_c_name,
        dataType:'script',
        type:'get',
        url:'/charts/' + id + '/get_children'
    })

    //replace series and category names in title panel
    var child_title_panel = $("#" + parent_name +"_child_title_panel")
    var query_name = child_title_panel.find(".chart_name").attr('query_name');
    var series_panel=child_title_panel.find(".series_name")
    var curr_s_name=series_panel.attr('name');
    series_panel.text(new_s_name.toProperCase());
    series_panel.attr('name',new_s_name)
    var category_panel=child_title_panel.find(".category_name")
    var curr_c_name=category_panel.attr('name');
    category_panel.text(new_c_name.toProperCase()); //amend display
    category_panel.attr('name',new_c_name)

    var i = 1;
    //use parent name to cycle through child embeds
    $("embed:[id^=" +parent_name + "_child]").each(function(){
        //replace chart data URL with itself modified for new series and category names
        //this.setDataURL('/data/' + chart_name + '_' + new_s_name + '_' + new_c_name + '_' + i + '.xml');
        //setDataURL has a bug for FC Free so I decided to directly replace the flashvars field
        var fv=$(this).attr('flashvars');
        var file_prefix = '/data/' +query_name +'/'+ query_name +'_';
        var curr_data_url='dataURL='+ file_prefix + curr_s_name.replace(' ','_')
        + '_' + curr_c_name.replace(' ','_');
        var new_data_url ='dataURL='+ file_prefix +
        new_s_name.replace(' ','_') +'_' + new_c_name.replace(' ','_');
        var new_fv=fv.replace(curr_data_url,new_data_url);
        $(this).attr('flashvars',new_fv);

        //refresh the src to toggle chart refresh
        var chObj= getChartFromId(this.id);
        var src = chObj.src;

        var file_url = curr_data_url.replace('dataURL=','') + '_' + i +'.xml'

        //wait while file is not available
        $.ajax({
            url:file_url,
            type:'HEAD',
            timeout:20000,
            tryCount: 0,
            retryLimit: 3,
            complete:function(xhr){
                if (xhr.status==200) {
                    chObj.src=src;
                    i+=1;
                } else {
                    var ajx = this;
                    setTimeout(function(){
                        $.ajax(ajx)
                        },2000)
                }
            }
        });
        
        

    }
    )

    ;

    function setChartDataURL(chart_id,new_URL){
        alert(chart_id + '-' + new_URL);
    }


}


