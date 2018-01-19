<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<!--pageContext.request.contextPath相對路徑  -->
<%-- ${pageContext.request.contextPath}等价于<%=request.getContextPath()%> 或者可以说是 --%>
<%-- <%=request.getContextPath()%>的EL版 意思就是取出部署的应用程序名或者是当前的项目名称 --%>
<!-- 比如我的项目名称是ajax01  在浏览器中输入为http://localhost:8080/ajax01/login.jsp  -->
 <%-- ${pageContext.request.contextPath}或 <%=request.getContextPath()%> --%>
<!--  取出来的就是/ajax01,而"/"代表的含义就是http://localhost:8080 -->
<!--  所以我们项目中应该这样写${pageContext.request.contextPath}/login.jsp  -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">
    //全局变量
    var url;

	function searchUser(){
		$("#dg").datagrid('load',{

			//就是一个对话框
			//val() 方法返回或设置被选元素的值
			"name":$("#name").val()
		});
	}
	
function openUserAddDialog(){
	       //dialog显示信息有用的默认对话框
	$("#dlg").dialog("open").dialog("setTitle","添加用户信息");
	url="${pageContext.request.contextPath}/user/save";
}

function deleteUser(){
	var selectedRows=$("#dg").datagrid('getSelections');
	if(selectedRows.length==0){
		$.messager.alert("系统提示","请选择要删除的数据！");
		return;
	}
	var strIds=[];
	for(var i=0;i<selectedRows.length;i++){
		strIds.push(selectedRows[i].id);
	}
	var ids=strIds.join(",");
	$.messager.confirm("系统提示","您确认要删除这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
		if(r){
			$.post("${pageContext.request.contextPath}/user/delete",{ids:ids},function(result){
				if(result.success){
					$.messager.alert("系统提示","数据已成功删除！");
					$("#dg").datagrid("reload");
				}else{
					$.messager.alert("系统提示","数据删除失败！");
				}
			},"json");
		}
	});
	
}


function openUserModifyDialog(){
	var selectedRows=$("#dg").datagrid('getSelections');
	if(selectedRows.length!=1){
		$.messager.alert("系统提示","请选择一条要编辑的数据！");
		return;
	}
	var row=selectedRows[0];
	$("#dlg").dialog("open").dialog("setTitle","编辑用户信息");
	$('#fm').form('load',row);
	url="${pageContext.request.contextPath}/user/save?id="+row.id;
}

function saveUser(){
	$("#fm").form("submit",{
		url:url,
		onSubmit:function(){
			return $(this).form("validate");
		},
		success:function(result){
			var result=eval('('+result+')');
			if(result.success){
				$.messager.alert("系统提示","保存成功");
				resetValue();
				$("#dlg").dialog("close");
				$("#dg").datagrid("reload");
			}else{
				$.messager.alert("系统提示","保存失败");
				return;
			}
		}
	});
}
function resetValue(){
	$("#name").val("");
	$("#telNum").val("");
}
function closeUserDialog(){
	$("#dlg").dialog("close");
	resetValue();
}
</script>
<style type="text/css">
#divdao{
     width: auto;
     height:400px;
}
#alldiv{
height:400px;
margin-top:0px;
     float: left;

}
.nav{width:auto; border: 1px solid #CCC; border-bottom: none; margin-left:1px; }
.nav ul li{ background: #eee; list-style:none; text-align:center;  line-height: 26px; border-bottom: 1px solid #CCC; position:relative;}
.nav ul li a{ color:#333; margin-left:0px;  }
.nav ul li a{ color:#333;}
.nav ul li a:hover{ color:#f00;}
</style>
</head>
<body style="margin:1px;">
</div>
<!--pagination 为true 默认传递两个参数过去  -->
<!--fitColumns为true时自动扩展或收缩列的大小以适应网格宽度和防止水平滚动条  -->
<!--设置该属性为 True 并不会使行号立即显示。在查询表下一次刷新时行号将显示，而且在查询表每次刷新时将重新配置这些行号  -->
<!--通過url獲取列表信息的方法  -->
<div id="alldiv">
	<table id="dg" title="用户管理" class="easyui-datagrid"
	 fitColumns="true" pagination="true" rownumbers="true"
	 url="${pageContext.request.contextPath}/user/listall" fit="true" toolbar="#tb">
	 <thead>
	 	<tr>
	 		<th field="id" width="50" align="center">编号</th>
	 		<th field="name" width="100" align="center">用户名</th>
	 		<th field="telNum" width="100" align="center">联系电话</th>
	 	</tr>
	 </thead>
	</table>
	
	<div id="tb">
		<div>
			<a href="javascript:openUserAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a>
			<a href="javascript:openUserMo	difyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
			<a href="javascript:deleteUser()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
		</div>
		<div>
			&nbsp;用户名：&nbsp;<input type="text" id="name" size="20" onkeydown="if(event.keyCode==13) searchUser()"/>
			<a href="javascript:searchUser()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
		</div>
	</div>
	
	<div id="dlg" class="easyui-dialog" style="width: 620px;height:150px;padding: 10px 20px"
	  closed="true" buttons="#dlg-buttons">
	 	<form id="fm" method="post">
	 		<table cellspacing="8px">
	 			<tr>
	 				<td>用户名：</td>
	 				<td><input type="text" id="name" name="name" class="easyui-validatebox" required="true"/>&nbsp;<font color="red">*</font></td>
	 				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	 				<td>联系电话：</td>
	 				<td><input type="text" id="telNum" name="telNum" class="easyui-validatebox"  required="true"/>&nbsp;<font color="red">*</font></td>
	 			</tr>
	 			
	 		</table>
	 	</form>
	</div>
		<div id="dlg-buttons">
		<a href="javascript:saveUser()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeUserDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
	</div>
</body>
</html>