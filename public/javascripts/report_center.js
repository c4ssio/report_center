/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function getChildCharts(q_name,s_name,c_name){
    //submit request to server
        $.ajax({
        data: 'query_name=' + q_name +
            '&series_name=' + s_name + '&category_name' + c_name,
        dataType:'script',
        type:'get',
        url:'/charts/',
        success: function() {}
    });


}


