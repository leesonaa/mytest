<?php $this->load->view('header');?>
<style>


.wrapper2{margin:0 auto;padding: 5px;width:420px;font-size:14px;}
.mod-form{margin-top:10px;}
.mod-form li label{margin-bottom:5px;float:left; width:80px;height:32px; line-height:32px;}
.mod-form li span{display:inline-block;height:32px; line-height:32px;}
.mod-form li p{padding-left:80px;}
.tip{font-size: 12px;color: #999;}
.tips{color: #eba434;border-color: #f5d193;box-shadow: 0 0 5px rgba(248,171,58,0.35);padding: 5px 30px 5px 10px;font-size: 12px;border: 1px solid #F5D4A0;border-radius: 2px;}
.tips a{margin: 0 5px;color: #eba434;font-weight: bolder;text-decoration: none;}
.ui-input {
    padding: 6px 5px;
    width: 180px;
    height: 16px;
    line-height: 16px;
    border: 1px solid #ddd;
    color: #555;
    vertical-align: middle;
    outline: none;
}
</style>  
<script type="text/javascript">
var DOMAIN = document.domain;
var WDURL = "";
var SCHEME= "<?php echo sys_skin()?>";
try{
	document.domain = '<?php echo base_url()?>';
}catch(e){
}
//ctrl+F5 增加版本号来清空iframe的缓存的
$(document).keydown(function(event) {
	/* Act on the event */
	if(event.keyCode === 116 && event.ctrlKey){
		var defaultPage = Public.getDefaultPage();
		var href = defaultPage.location.href.split('?')[0] + '?';
		var params = Public.urlParam();
		params['version'] = Date.parse((new Date()));
		for(i in params){
			if(i && typeof i != 'function'){
				href += i + '=' + params[i] + '&';
			}
		}
		defaultPage.location.href = href;
		event.preventDefault();
	}
});
</script>


<script>
function validMaxForShare(){
    $.ajax({
      url: '../right/isMaxShareUser?action=isMaxShareUser',
      dataType: 'json',
      type: 'POST',
      success: function(data){
        if(data.status === 200){
        	var json = data.data;
        	if(json.shareTotal >= json.totalUserNum)
        	{
        		parent.Public.tips({type:2, content : '共享用户已经达到上限值：'+json.totalUserNum});
        		return false;
        	}else
        	{
        		window.location.href='../settings/authority_new';
        	}	
        }
      }
  });
}
</script>
</head>
<body>
<div class="wrapper">
    <div class="mod-toolbar-top">
       <a href="javascript:validMaxForShare();" class="ui-btn ui-btn-sp mrb">新增同事</a>
       <span class="tit" id="shareInfo" style="display:none;">该账套主服务最多支持<strong id="totalUser"></strong>用户共同管理，已共享<strong id="usedTotal"></strong>人，剩余<strong id="leftTotal"></strong>。</span>
    </div>    
    <div class="grid-wrap">
      <table id="grid">
      </table>
      <div id="page"></div>
    </div>
</div>
<script>
  (function($){
    var totalUser, usedTotal, leftTotal;
    initGrid();

    $('.grid-wrap').on('click', '.delete', function(e){
      var id = $(this).parents('tr').attr('id');
      var rowData = $('#grid').getRowData(id);
      var userName = rowData.userName;
      e.preventDefault();
      $.ajax({
        url: '../right/auth2UserCancel?action=auth2UserCancel&userName=' + userName,
        type: 'POST',
        dataType: 'json',
        success: function(data){
          if (data.status == 200) {
            parent.Public.tips({content: '取消用户授权成功！'});
            usedTotal--;
            leftTotal++;
            showShareCount();
            if (rowData.isCom) {
                rowData.share = false;
                $("#grid").jqGrid('setRowData', id, rowData);
            } else {
                $("#grid").jqGrid('delRowData',id);
            }
           
          } else {
            parent.Public.tips({type: 1, content: '取消用户授权失败！' + data.msg});
          }
        },
        error: function(){
           parent.Public.tips({content:'取消用户授权失败！请重试。', type: 1});
        }
      });
    });

    $('.grid-wrap').on('click', '.authorize', function(e){
      var id = $(this).parents('tr').attr('id');
      var rowData = $('#grid').getRowData(id);
      var userName = rowData.userName;
      e.preventDefault();
       $.ajax({
        type: 'POST',
        dataType: 'json',
        url: '../right/auth2User?action=auth2User&userName=' + userName,
        success: function(data){
          if (data.status == 200) {
            parent.Public.tips({content : '授权成功！'});
            rowData.share = true;
            $("#grid").jqGrid('setRowData', id, rowData);
            usedTotal++;
            leftTotal--;
            showShareCount();
            //window.location.href = 'authority-setting.jsp?userName=' + userName + '&right=0';
          } else {
            parent.Public.tips({type:1, content : data.msg});
          }
        },
        error: function(){
          parent.Public.tips({type:1, content : '用户授权失败！请重试。'});
        }
      });
    });

   
    function initGrid(){
      $('#grid').jqGrid({
        url: '../right/queryAllUser?action=queryAllUser',
        datatype: 'json',
        height: Public.setGrid().h,
        colNames:['用户', '真实姓名', '公司','功能授权','数据授权','启用授权','重置密码'],
        colModel:[
          {name:'userName',index:'userName', width:200},
          {name:'realName', index:'realName', width:200},
          {name:'isCom', index:'isCom', hidden: true},
          {name:'setting', index:'setting', width:100, align:"center", title:false, formatter: settingFormatter},
		  //{name:'setting_data', index:'setting_data', width:100, align:"center", title:false, formatter: settingDataFormatter},
		  {name:'setting_data', index:'setting_data', width:100, align:"center", title:false, formatter: settingDataFormatter},
		  //{name:'setting_data', index:'setting_data', width:100, align:"center", title:false, formatter: settingDataFormatter, hidden:(parent.SYSTEM.siType == 1)},
		  {name:'share', index:'share', width:100, align:"center", title:false, formatter: shareFormatter},
		  {name:'reset',index:'reset',width:100,align:"center",title:false,
			hidden:<?php $s=$this->session->userdata('jxcsys');echo ($s['roleid'] != 0 ? 'true' : 'false') ?>,
			  formatter:function(a,b,c){return '<span class="set-status ui-label ui-label-success" onclick="resetPwd(' + c.userId + ')">重置</span>'}
		  }

        ],
        altRows:true,
        gridview: true,
        page: 1,
        scroll: 1,
        autowidth: true,
        cmTemplate: {sortable:false}, 
        rowNum:150,
        shrinkToFit:false,
        forceFit:false,
        pager: '#page',
        viewrecords: true,
        jsonReader: {
          root: 'data.items', 
          records: 'data.totalsize',  
          repeatitems : false,
          id: 'userId'
        },
        loadComplete: function(data){
          if (data.status == 200) {
            data = data.data;
            totalUser = data.totalUserNum;
            usedTotal = data.shareTotal;
            leftTotal = totalUser - usedTotal;
            showShareCount();
            $('#shareInfo').show();
          } else {
        	  parent.Public.tips({type: 1, content: data.msg});
          }
          
        },
        loadonce: true
      });
    }


    function showShareCount(){
        $('#totalUser').text(totalUser);
        $('#usedTotal').text(usedTotal);
        $('#leftTotal').text(leftTotal);
    }
	
	
	function shareFormatter(val, opt, row) {
        if (val || row.admin) {
          if (row.admin) {
              return '管理员';
          } else {
               return '<div class="operating" data-id="' + row.userId + '"><span class="delete ui-label ui-label-success">已启用</span></div>';
          }
        } else {
          return '<p class="operate-wrap"><span class="authorize ui-label ui-label-default">已停用</span></p>';
        } 
    };
    function settingFormatter(val, opt, row) {
		if (row.admin || row.share === false) {
			return '&nbsp;';
		} else {
			return '<div class="operating" data-id="' + row.userId + '"><a class="ui-icon ui-icon-pencil" title="详细设置授权信息" href="../settings/authority_setting?userName=' + row.userName + '"></a></div>';
		}
    };
    function settingDataFormatter(val, opt, row) {
		if (row.admin || row.share === false) {
			return '&nbsp;';
		} else {
			return '<div class="operating" data-id="' + row.userId + '"><a class="ui-icon ui-icon-pencil" title="详细设置授权信息" href="../settings/authority_setting_data?userName=' + row.userName + '"></a></div>';
		}
    };
	
  })(jQuery)
  
  $(window).resize(function(){
	  Public.resizeGrid();
  });
  
  //重置密码
  function resetPwd(userId){
		var d = ['<div class="wrapper2"><form action="" id="set-password-form">',
					'<ul class="mod-form">',
					'<li>',
						'<label for="password">密码:</label>',
						'<input type="password" class="ui-input" placeholder="设置登录密码" id="password"/>',
						'<p class="tip">长度8~20位，同时包含数字、字母（区分大小写），可使用特殊符号</p>',
					'</li>',
					'<li>',
						'<label>确认密码:</label>',
						'<input type="password" class="ui-input" placeholder="请再次输入密码" id="confirm-password" />',
					'</li>',
				'</ul>',
			'</form></div>'],
		e = 90;
		dialog = $.dialog({
			title: "强制重置密码",
			content: d.join(""),
			width: 400,
			height: e,
			max: !1,
			min: !1,
			cache: !1,
			lock: !0,
			okVal: "确定",
			ok: function() {
				var password = $.trim($("#password").val());
				var password2 = $.trim($("#confirm-password").val());
				if(password!==password2){
					parent.parent.Public.tips({
						type: 1,
						content: "两次输入的密码不一致！"
					});
					return false;
				}
				if(password.length<8){
					parent.parent.Public.tips({
						type: 1,
						content: "密码不能少于8位！"
					});
					return false;
				}
				var data = {};
				data.password = password;
				data.password2 = password2;
				data.userId = userId;
				Public.ajaxPost("../home/set_password2", data, function(a) {
					200 == a.status ? (parent.parent.Public.tips({
						content: "操作成功！"
					})) : parent.parent.Public.tips({
						type: 1,
						content: "操作失败！" + a.msg
					})
				})
				//return postData(b), !1
			},
			cancelVal: "取消",
			cancel: function() {
				return !0
			},
			init: function() {
				
			}
		})
	}
</script>
</body>
</html>


 