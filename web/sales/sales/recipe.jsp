 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/checksl.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(int iJSPCommand,JspRecipe frmObject, Recipe objEntity, Vector objectClass,  long recipeId, long itemOID)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		//jsplist.addHeader("Item Master Id","14%");
		jsplist.addHeader("Item","14%");
		jsplist.addHeader("Qty","14%");
		jsplist.addHeader("Unit","14%");
		jsplist.addHeader("Cost","14%");
		//jsplist.addHeader("Type","14%");
		jsplist.addHeader("Last Update","14%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

		/* selected ItemRecipeId*/
		Vector recipeItems = SessItemMaster.getRecipeItems(itemOID, iJSPCommand);
		Vector itemrecipeid_value = new Vector(1,1);
		Vector itemrecipeid_key = new Vector(1,1);
		if(recipeItems!=null && recipeItems.size()>0){
			for(int i=0; i<recipeItems.size(); i++){
				ItemMaster im = (ItemMaster)recipeItems.get(i);
				itemrecipeid_value.add(""+im.getOID());
				itemrecipeid_key.add(im.getCode()+" - "+im.getName());
			}
		}

		/* selected Type*/
		Vector type_value = new Vector(1,1);
		Vector type_key = new Vector(1,1);
		type_value.add("");
		type_key.add("---select---");

		for (int i = 0; i < objectClass.size(); i++) {
			 Recipe recipe = (Recipe)objectClass.get(i);
			 rowx = new Vector();
			 if(recipeId == recipe.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				//rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_ITEM_MASTER_ID] +"\" value=\""+recipe.getItemMasterId()+"\" class=\"formElemen\">");
				rowx.add(JSPCombo.draw(frmObject.colNames[JspRecipe.JSP_ITEM_RECIPE_ID],null, ""+recipe.getItemRecipeId(), itemrecipeid_value , itemrecipeid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_QTY] +"\" value=\""+recipe.getQty()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_UOM_ID] +"\" value=\""+recipe.getUomId()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_COST] +"\" value=\""+recipe.getCost()+"\" class=\"formElemen\">");
				//rowx.add(JSPCombo.draw(frmObject.colNames[JspRecipe.JSP_TYPE],null, ""+recipe.getType(), type_value , type_key, "formElemen", ""));
				rowx.add("");//<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_LAST_UPDATE] +"\" value=\""+recipe.getLastUpdate()+"\" class=\"formElemen\">");
			}else{
				//rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(recipe.getOID())+"')\">"+String.valueOf(recipe.getItemMasterId())+"</a>");
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(recipe.getOID())+"')\">"+String.valueOf(recipe.getItemRecipeId())+"</a>");
				rowx.add(String.valueOf(recipe.getQty()));
				rowx.add(String.valueOf(recipe.getUomId()));
				rowx.add(String.valueOf(recipe.getCost()));
				//rowx.add(recipe.getType());

				String str_dt_LastUpdate = ""; 
				try{
					Date dt_LastUpdate = recipe.getLastUpdate();
					if(dt_LastUpdate==null){
						dt_LastUpdate = new Date();
					}

				str_dt_LastUpdate = JSPFormater.formatDate(dt_LastUpdate, "dd MMMM yyyy");
				}catch(Exception e){ str_dt_LastUpdate = ""; }
				rowx.add(str_dt_LastUpdate);
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				//rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_ITEM_MASTER_ID] +"\" value=\""+objEntity.getItemMasterId()+"\" class=\"formElemen\">");
				rowx.add(JSPCombo.draw(frmObject.colNames[JspRecipe.JSP_ITEM_RECIPE_ID],null, ""+objEntity.getItemRecipeId(), itemrecipeid_value , itemrecipeid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_QTY] +"\" value=\""+objEntity.getQty()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_UOM_ID] +"\" value=\""+objEntity.getUomId()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_COST] +"\" value=\""+objEntity.getCost()+"\" class=\"formElemen\">");
				//rowx.add(JSPCombo.draw(frmObject.colNames[JspRecipe.JSP_TYPE],null, ""+objEntity.getType(), type_value , type_key, "formElemen", ""));
				rowx.add("");//<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_LAST_UPDATE] +"\" value=\""+objEntity.getLastUpdate()+"\" class=\"formElemen\">");

		}
		
		lstData.add(rowx);
		
		if(objectClass!=null && objectClass.size()>0){ 
				//rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_ITEM_MASTER_ID] +"\" value=\""+objEntity.getItemMasterId()+"\" class=\"formElemen\">");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				//rowx.add(JSPCombo.draw(frmObject.colNames[JspRecipe.JSP_TYPE],null, ""+objEntity.getType(), type_value , type_key, "formElemen", ""));
				rowx.add("");//<input type=\"text\" name=\""+frmObject.colNames[JspRecipe.JSP_LAST_UPDATE] +"\" value=\""+objEntity.getLastUpdate()+"\" class=\"formElemen\">");

		}
		
		lstData.add(rowx);


		return jsplist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidRecipe = JSPRequestValue.requestLong(request, "hidden_recipe_id");
long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");

//out.println("oidItemMaster : "+oidItemMaster);

ItemMaster itemMaster = new ItemMaster();
try{
	itemMaster = DbItemMaster.fetchExc(oidItemMaster);
}
catch(Exception e){
}


/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = DbRecipe.colNames[DbRecipe.COL_ITEM_MASTER_ID]+"="+oidItemMaster;
String orderClause = "";

CmdRecipe ctrlRecipe = new CmdRecipe(request);
JSPLine ctrLine = new JSPLine();
Vector listRecipe = new Vector(1,1);

/*switch statement */
iErrCode = ctrlRecipe.action(iJSPCommand , oidRecipe);
/* end switch*/
JspRecipe jspRecipe = ctrlRecipe.getForm();

//out.println(jspRecipe.getErrors());

/*count list All Recipe*/
int vectSize = DbRecipe.getCount(whereClause);
recordToGet = vectSize;
 
/*switch list Recipe*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlRecipe.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

Recipe recipe = ctrlRecipe.getRecipe();
msgString =  ctrlRecipe.getMessage();

/* get record to display */
listRecipe = DbRecipe.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listRecipe.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listRecipe = DbRecipe.list(start,recordToGet, whereClause , orderClause);
}

Vector vRecipes = SessItemMaster.getRecipeItems(oidItemMaster, iJSPCommand);
Vector uoms = DbUom.list(0,0, "", "");

double totalRecipe = DbRecipe.getTotalRecipe(oidItemMaster);

%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

function cmdChangeItem(){
	var oid = document.frmrecipe.<%=jspRecipe.colNames[JspRecipe.JSP_ITEM_RECIPE_ID]%>.value;
	//alert(oid);
	<%if(vRecipes!=null && vRecipes.size()>0){
		for(int x=0; x<vRecipes.size();x++){
			ItemMaster imm = (ItemMaster)vRecipes.get(x);
		%>
			if(oid=='<%=imm.getOID()%>'){
				oid = '<%=imm.getUomRecipeId()%>';
			}
	<%}}%>	
	
	//alert(oid);	
													  
	<%if(uoms!=null && uoms.size()>0){
		for(int i=0; i<uoms.size(); i++){
			Uom uom = (Uom)uoms.get(i);
	%>
			if(oid=='<%=uom.getOID()%>'){
				document.frmrecipe.temp_uom.value="<%=uom.getUnit()%>";
				document.frmrecipe.<%=jspRecipe.colNames[JspRecipe.JSP_UOM_ID]%>.value="<%=uom.getOID()%>";
			}
	<%}}%>
}

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

function removeChar(number){
	
	var ix;
	var result = "";
	for(ix=0; ix<number.length; ix++){
		var xx = number.charAt(ix);
		//alert(xx);
		if(!isNaN(xx)){
			result = result + xx;
		}
		else{
			if(xx==',' || xx=='.'){
				result = result + xx;
			}
		}
	}
	
	return result;
}

function checkNumber(){
	var st = document.frmrecipe.<%=jspRecipe.colNames[jspRecipe.JSP_COST]%>.value;		
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	document.frmrecipe.<%=jspRecipe.colNames[jspRecipe.JSP_COST]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function cmdToVendor(){
	document.frmrecipe.hidden_item_master_id.value="<%=oidItemMaster%>";
	document.frmrecipe.command.value="<%=JSPCommand.LIST%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="vendoritem.jsp";
	document.frmrecipe.submit();
}

function cmdToProduct(){
	document.frmrecipe.hidden_item_master_id.value="<%=oidItemMaster%>";
	document.frmrecipe.command.value="<%=JSPCommand.EDIT%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="itemmaster.jsp";
	document.frmrecipe.submit();
}

function cmdToRecords(){
	document.frmrecipe.hidden_item_master_id.value="<%=oidItemMaster%>";
	document.frmrecipe.command.value="<%=JSPCommand.LIST%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="itemlist.jsp";
	document.frmrecipe.submit();
}

function cmdToRecipe(){
	document.frmrecipe.hidden_item_master_id.value="<%=oidItemMaster%>";
	document.frmrecipe.command.value="<%=JSPCommand.LIST%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdBackItem(oid){
	document.frmrecipe.hidden_item_master_id.value=oid;
	document.frmrecipe.command.value="<%=JSPCommand.EDIT%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="itemmasterrecipe.jsp";
	document.frmrecipe.submit();
}

function cmdAdd(){
	document.frmrecipe.hidden_recipe_id.value="0";
	document.frmrecipe.command.value="<%=JSPCommand.ADD%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdAsk(oidRecipe){
	document.frmrecipe.hidden_recipe_id.value=oidRecipe;
	document.frmrecipe.command.value="<%=JSPCommand.ASK%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdConfirmDelete(oidRecipe){
	document.frmrecipe.hidden_recipe_id.value=oidRecipe;
	document.frmrecipe.command.value="<%=JSPCommand.DELETE%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdSave(){
	document.frmrecipe.command.value="<%=JSPCommand.SAVE%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdEdit(oidRecipe){
	document.frmrecipe.hidden_recipe_id.value=oidRecipe;
	document.frmrecipe.command.value="<%=JSPCommand.EDIT%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdCancel(oidRecipe){
	document.frmrecipe.hidden_recipe_id.value=oidRecipe;
	document.frmrecipe.command.value="<%=JSPCommand.EDIT%>";
	document.frmrecipe.prev_command.value="<%=prevJSPCommand%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdBack(){
	document.frmrecipe.command.value="<%=JSPCommand.BACK%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdListFirst(){
	document.frmrecipe.command.value="<%=JSPCommand.FIRST%>";
	document.frmrecipe.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdListPrev(){
	document.frmrecipe.command.value="<%=JSPCommand.PREV%>";
	document.frmrecipe.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdListNext(){
	document.frmrecipe.command.value="<%=JSPCommand.NEXT%>";
	document.frmrecipe.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

function cmdListLast(){
	document.frmrecipe.command.value="<%=JSPCommand.LAST%>";
	document.frmrecipe.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmrecipe.action="recipe.jsp";
	document.frmrecipe.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidRecipe){
	document.frmimage.hidden_recipe_id.value=oidRecipe;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="recipe.jsp";
	document.frmimage.submit();
}

//-------------- script control line -------------------
	function MM_swapImgRestore() { //v3.0
		var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

function MM_preloadImages() { //v3.0
		var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
		if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}

function MM_findObj(n, d) { //v4.0
		var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
		if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
		for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
		if(!x && document.getElementById) x=document.getElementById(n); return x;
	}

function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)

		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmrecipe" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_recipe_id" value="<%=oidRecipe%>">
                          <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                          <input type="hidden" name="<%=jspRecipe.colNames[jspRecipe.JSP_ITEM_MASTER_ID]%>" value="<%=oidItemMaster%>">
                          <input type="hidden" name="<%=jspRecipe.colNames[jspRecipe.JSP_TYPE]%>" value="<%=DbRecipe.TYPE_RECIPE%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <%
									  String navigator = "<font class=\"lvl1\">Sales Item</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">BOM Data</span></font>";
									  %>
									  <%@ include file="../main/navigatorsl.jsp"%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecords()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToProduct()" class="tablink">Item 
                                              Data </a>&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <%if(itemMaster.getOID()!=0){
										  if(itemMaster.getForBuy()==1){
										  %>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <%}
										  if(itemMaster.getForSale()==1 && itemMaster.getNeedRecipe()==1){
										  %>
                                          <td class="tab"> 
                                            <div align="center">&nbsp;&nbsp;BOM&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <!--td class="tabin"> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToOverhead()" class="tablink">Overhead</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td-->
                                          <%
										  }
										  }%>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td class="page"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8"  colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr align="left" valign="top"> 
                                                <td height="8" valign="middle" colspan="3"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="91%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="9%"><b>Code</b></td>
                                                      <td width="91%"><%=itemMaster.getCode()%></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="9%"><b>Name</b></td>
                                                      <td width="91%"><%=itemMaster.getName()%></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="9%"><b>Barcode</b></td>
                                                      <td width="91%"><%=(itemMaster.getBarcode()==null || itemMaster.getBarcode().length()<1) ? "-" : itemMaster.getBarcode()%></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="91%">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td class="tablehdr" width="15%" height="18">Item</td>
                                                      <td class="tablehdr" width="7%" height="18">Qty</td>
                                                      <td class="tablehdr" width="9%" height="18">Unit</td>
                                                      <td class="tablehdr" width="13%" height="18">Cost</td>
                                                      <td class="tablehdr" width="41%" height="18">Description</td>
                                                      <td class="tablehdr" width="15%" height="18">Last 
                                                        Update</td>
                                                    </tr>
                                                    <%
											  
											  int index = -1;
											  
											  for (int i = 0; i < listRecipe.size(); i++) {
												  
												  Recipe recipex = (Recipe)listRecipe.get(i);
												  
												  String cls = "tablecell1";
												  if(i%2!=0){
												  	cls = "tablecell";
												  }
												  
												  if(oidRecipe == recipex.getOID())
													 index = i; 
									
												  if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
												  
											  %>
                                                    <tr> 
                                                      <td width="15%" class="<%=cls%>"> 
                                                        <div align="center"> 
                                                          <select name="<%=jspRecipe.colNames[JspRecipe.JSP_ITEM_RECIPE_ID]%>" onChange="javascript:cmdChangeItem()">
                                                            <%if(vRecipes!=null && vRecipes.size()>0){
													  for(int x=0; x<vRecipes.size();x++){
													  	ItemMaster im = (ItemMaster)vRecipes.get(x);
													  %>
                                                            <option value="<%=im.getOID()%>" <%if(recipe.getItemRecipeId()==im.getOID()){%>selected<%}%>><%=im.getCode()+" - "+im.getName()%></option>
                                                            <%}}%>
                                                          </select>
                                                        </div>
                                                      </td>
                                                      <td width="7%" class="<%=cls%>"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspRecipe.colNames[JspRecipe.JSP_QTY]%>" size="5" value="<%=recipe.getQty()%>" style="text-align:right" onClick="this.select()">
                                                        </div>
                                                      </td>
                                                      <td width="9%" class="<%=cls%>"> 
                                                        <div align="center"> 
                                                          <input type="text" name="temp_uom" size="10" readOnly style="text-align:center">
                                                          <input type="hidden" name="<%=jspRecipe.colNames[JspRecipe.JSP_UOM_ID]%>" value="<%=recipe.getUomId()%>" size="10" readOnly>
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="<%=cls%>"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspRecipe.colNames[JspRecipe.JSP_COST]%>" value="<%=JSPFormater.formatNumber(recipe.getCost(), "#,###.##")%>" style="text-align:right" onClick="this.select()" onBlur="javascript:checkNumber()">
                                                        </div>
                                                      </td>
                                                      <td width="41%" class="<%=cls%>"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspRecipe.colNames[JspRecipe.JSP_DESCRIPTION]%>" size="60" value="<%=(recipe.getDescription()==null) ? "" : recipe.getDescription()%>">
                                                        </div>
                                                      </td>
                                                      <td width="15%" class="<%=cls%>"> 
                                                        <div align="center"><%=JSPFormater.formatDate(recipe.getLastUpdate(), "dd MMMM yyyy hh:mm")%></div>
                                                      </td>
                                                    </tr>
                                                    <%}else{
											  
											  		ItemMaster imabc = new ItemMaster();
													try{
														imabc = DbItemMaster.fetchExc(recipex.getItemRecipeId());
													}
													catch(Exception e){
													}
													
													Uom om = new Uom();													
													try{
														om = DbUom.fetchExc(recipex.getUomId());
													}
													catch(Exception e){
													}
											  
											  %>
                                                    <tr> 
                                                      <td width="15%" class="<%=cls%>"><%=imabc.getCode()+" - "+imabc.getName()%></td>
                                                      <td width="7%" class="<%=cls%>"> 
                                                        <div align="center"><%=recipex.getQty()%></div>
                                                      </td>
                                                      <td width="9%" class="<%=cls%>"> 
                                                        <div align="center"><%=om.getUnit()%></div>
                                                      </td>
                                                      <td width="13%" class="<%=cls%>"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(recipex.getCost(), "#,###.##")%></div>
                                                      </td>
                                                      <td width="41%" class="<%=cls%>"><%=recipex.getDescription()%></td>
                                                      <td width="15%" class="<%=cls%>"> 
                                                        <div align="center"><%=JSPFormater.formatDate(recipex.getLastUpdate(), "dd MMMM yyyy hh:mm")%></div>
                                                      </td>
                                                    </tr>
                                                    <%}}
											  
											  if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && jspRecipe.errorSize() > 0)){ 
											  
											  %>
                                                    <tr> 
                                                      <td width="15%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <select name="<%=jspRecipe.colNames[JspRecipe.JSP_ITEM_RECIPE_ID]%>" onChange="javascript:cmdChangeItem()">
                                                            <%if(vRecipes!=null && vRecipes.size()>0){
													  for(int x=0; x<vRecipes.size();x++){
													  	ItemMaster im = (ItemMaster)vRecipes.get(x);
													  %>
                                                            <option value="<%=im.getOID()%>" <%if(recipe.getItemRecipeId()==im.getOID()){%>selected<%}%>><%=im.getCode()+" - "+im.getName()%></option>
                                                            <%}}%>
                                                          </select>
                                                        </div>
                                                      </td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspRecipe.colNames[JspRecipe.JSP_QTY]%>" size="5" value="<%=recipe.getQty()%>" style="text-align:right" onClick="this.select()">
                                                        </div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="temp_uom" size="10" readOnly style="text-align:center">
                                                          <input type="hidden" name="<%=jspRecipe.colNames[JspRecipe.JSP_UOM_ID]%>" size="10" value="<%=recipe.getUomId()%>" readOnly>
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspRecipe.colNames[JspRecipe.JSP_COST]%>" value="<%=JSPFormater.formatNumber(recipe.getCost(), "#,###.##")%>" style="text-align:right" onClick="this.select()" onBlur="javascript:checkNumber()">
                                                        </div>
                                                      </td>
                                                      <td width="41%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=jspRecipe.colNames[JspRecipe.JSP_DESCRIPTION]%>" size="60" value="<%=(recipe.getDescription()==null) ? "" : recipe.getDescription()%>">
                                                        </div>
                                                      </td>
                                                      <td width="15%" class="tablecell1">&nbsp;</td>
                                                    </tr>
                                                    <%
													}
													
													if(vRecipes!=null && vRecipes.size()>0){
													%>
                                                    <tr> 
                                                      <td colspan="6" height="1" bgcolor="#999999"> 
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="15%" height="20">&nbsp;</td>
                                                      <td width="7%" height="20">&nbsp;</td>
                                                      <td width="9%" class="tablecell" height="20"> 
                                                        <div align="center"><b><u>Total 
                                                          :</u></b></div>
                                                      </td>
                                                      <td width="13%" class="tablecell" height="20"> 
                                                        <div align="right"><b><u><%=JSPFormater.formatNumber(totalRecipe, "#,###.##")%></u></b></div>
                                                      </td>
                                                      <td width="41%" height="20">&nbsp;</td>
                                                      <td width="15%" height="20">&nbsp;</td>
                                                    </tr>
                                                    <%}%>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="8" align="left" colspan="3" class="command"> 
                                                  <span class="command"> 
                                                  <% 
								   int cmd = 0;
									   if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| 
										(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
											cmd =iJSPCommand; 
								   else{
									  if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)
										cmd = JSPCommand.FIRST;
									  else 
									  	cmd =prevJSPCommand; 
								   } 
							    %>
                                                  <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								
								ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                                  <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                              </tr>
                                              <%
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0)
						{
					%>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <%
											if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0)
											{
										%>
                                                    <tr> 
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                      <td width="81%">&nbsp;</td>
                                                      <td width="1%">&nbsp;</td>
                                                      <td width="2%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                      <td width="81%">&nbsp;</td>
                                                      <td width="1%">&nbsp;</td>
                                                      <td width="2%">&nbsp;</td>
                                                    </tr>
                                                    <%}%>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}%>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" width="17%">&nbsp;</td>
                                          <td height="8" colspan="2" width="83%">&nbsp; 
                                          </td>
                                        </tr>
                                        <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspRecipe.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                        <tr align="left" valign="top" > 
                                          <td colspan="3" class="command"> 
                                            <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidRecipe+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidRecipe+"')";
									String scancel = "javascript:cmdEdit('"+oidRecipe+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");
									
									ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									
									
									ctrLine.setWidthAllJSPCommand("90");
									ctrLine.setErrorStyle("warning");
									ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setQuestionStyle("warning");
									ctrLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setInfoStyle("success");
									ctrLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

									if (privDelete){
										ctrLine.setConfirmDelJSPCommand(sconDelCom);
										ctrLine.setDeleteJSPCommand(scomDel);
										ctrLine.setEditJSPCommand(scancel);
									}else{ 
										ctrLine.setConfirmDelCaption("");
										ctrLine.setDeleteCaption("");
										ctrLine.setEditCaption("");
									}

									if(privAdd == false  && privUpdate == false){
										ctrLine.setSaveCaption("");
									}

									if (privAdd == false){
										ctrLine.setAddCaption("");
									}
									%>
                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                        </tr>
                                        <tr align="left" valign="top" > 
                                          <td colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
						  <%if(iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT || iErrCode!=0){%>
						 cmdChangeItem();
						 <%}%>
						 </script>
                        </form>
                        <!-- #EndEditable --> </td>
                    </tr>
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footersl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

