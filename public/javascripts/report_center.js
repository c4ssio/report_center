/* 
this makes sure ajax calls to check for files don't go off their caches */
$.ajaxSettings.cache = false; 
function getChildren(id,parent_name,new_s_name,new_c_name){
    //submit request to server

    //replace series and category names in title panel
    var child_title_panel = $("#" + parent_name +"_child_title_panel")
    var query_name = child_title_panel.find(".chart_name").attr('query_name');
    var series_panel=child_title_panel.find(".series_name")
    var curr_s_name=series_panel.attr('name');
    //add comma delimiter to series_panel
    series_panel.text(new_s_name.toProperCase()+',');
    series_panel.attr('name',new_s_name)
    var category_panel=child_title_panel.find(".category_name")
    var curr_c_name=category_panel.attr('name');
    category_panel.text(new_c_name.toProperCase()); //amend display
    category_panel.attr('name',new_c_name)

    var rank = 0;
    //use parent name to cycle through child embeds
    var children = $("embed:[id^=" +parent_name + "_child]")
    //hide all charts while we get their data
    children.each(function(){
        var chObj= getChartFromId(this.id);
        $(chObj).parent().hide();
        //show spinner
        $(chObj).parent().parent().find('div.spinner').show();
    })
    children.each(function(){
        rank+=1;
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
        
        //get src to toggle chart refresh once request is completed
        var chObj= getChartFromId(this.id);
        var src = chObj.src;
        //check if file is already generated

        var file_url = new_data_url.replace('dataURL=','') + '_' + rank +'.xml'
        $.ajax({
            url:file_url,
            query_string: 'series_name=' + new_s_name +
            '&category_name=' + new_c_name +
            '&rank=' + rank,
            new_fv:new_fv,
            src:src,
            chObj: chObj,
            type:'get',
            success: function(){
                $(this.chObj).attr('flashvars',new_fv);
                this.chObj.src=src;
                $(this.chObj).parent().parent().find('div.spinner').hide();
                $(this.chObj).parent().show();
            },
            error: function(){
                $.ajax({
                    data: this.query_string,
                    dataType:'script',
                    type:'get',
                    url:'/charts/' + id + '/get_child',
                    chObj:this.chObj,
                    src: this.src,
                    success:function(){
                        $(this.chObj).attr('flashvars',new_fv);
                        this.chObj.src=this.src;
                        $(this.chObj).parent().parent().find('div.spinner').hide();
                        $(this.chObj).parent().show();
                        },
                    error:function(){
                        alert('Ajax error - Please check your internet connection.')
                    }
                })
            }
        })
    }
    );

    function setChartDataURL(chart_id,new_URL){
        alert(chart_id + '-' + new_URL);
    }


}


