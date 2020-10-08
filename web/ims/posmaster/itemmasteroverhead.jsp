 
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
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long itemMasterId)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("Code","9%");
		jsplist.addHeader("Barcode","11%");
		jsplist.addHeader("Name","22%");
		jsplist.addHeader("Group","20%");
		jsplist.addHeader("Category","20%");
		//jsplist.addHeader("Unit Purchase","11%");
		//jsplist.addHeader("Unit Recipe","11%");
		jsplist.addHeader("Unit Stock","8%");
		jsplist.addHeader("Selling Price","10%");
		//jsplist.addHeader("Uom Sales Id","11%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		jsplist.setLinkPrefix("javascript:cmdEdit('");
		jsplist.setLinkSufix("')");
		jsplist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			ItemMaster itemMaster = (ItemMaster)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(itemMasterId == itemMaster.getOID())
				 index = i;

			rowx.add("<div align=\"center\">"+itemMaster.getCode()+"</div>");

			rowx.add("<div align=\"center\">"+itemMaster.getBarcode()+"</div>");

			rowx.add(itemMaster.getName());
			
			ItemGroup ig = new ItemGroup();
			try{
				ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
			}
			catch(Exception e){
			}

			rowx.add("<div align=\"center\">"+ig.getName()+"</div>");
			
			ItemCategory ic = new ItemCategory();
			try{
				ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
			}
			catch(Exception e){
			}

			rowx.add("<div align=\"center\">"+ic.getName()+"</div>");

			//rowx.add(String.valueOf(itemMaster.getUomPurchaseId()));

			//rowx.add(String.valueOf(itemMaster.getUomRecipeId()));

			Uom uo = new Uom();
			try{
				uo = DbUom.fetchExc(itemMaster.getUomStockId());
			}
			catch(Exception e){
			}

			rowx.add("<div align=\"center\">"+uo.getUnit()+"</div>");
			
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(itemMaster.getSellingPrice(), "#,###.##")+"</div>");

			//rowx.add(String.valueOf(itemMaster.getUomSalesId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(itemMaster.getOID()));
		}

		return jsplist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
JSPLine jspLine = new JSPLine();
Vector listItemMaster = new Vector(1,1);

/*switch statement */
iErrCode = ctrlItemMaster.action(iJSPCommand , oidItemMaster);
/* end switch*/
JspItemMaster jspItemMaster = ctrlItemMaster.getForm();

/*count list All ItemMaster*/
int vectSize = DbItemMaster.getCount(whereClause);

ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
msgString =  ctrlItemMaster.getMessage();

if(oidItemMaster==0){
	oidItemMaster = itemMaster.getOID();
}

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listItemMaster = DbItemMaster.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listItemMaster.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listItemMaster = DbItemMaster.list(start,recordToGet, whereClause , orderClause);
}

Vector categories = DbItemCategory.list(0,0, "", DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID]+","+DbItemCategory.colNames[DbItemCategory.COL_NAME]);

//out.println("categories : "+categories);

Vector units = DbUom.list(0,0, "", "");

if(iJSPCommand==JSPCommand.ADD){
	itemMaster.setForSale(1);
	itemMaster.setForBuy(1);
	itemMaster.setIsActive(1);
	itemMaster.setRecipeItem(1);
}

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        <script language="JavaScript">

function cmdToRecipe(){
	document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
	document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="itemmasterrecipe.jsp";
	document.frmitemmaster.submit();
}

function cmdAddVendor(){
	document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
	document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="vendoritem.jsp";
	document.frmitemmaster.submit();
}

function cmdEditVendor(oid){
	document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
	document.frmitemmaster.hidden_vendor_item_id.value=oid;
	document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="vendoritem.jsp";
	document.frmitemmaster.submit();
}


function cmdAdd(){
	document.frmitemmaster.hidden_item_master_id.value="0";
	document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
}

function cmdAsk(oidItemMaster){
	document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
	document.frmitemmaster.command.value="<%=JSPCommand.ASK%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
}

function cmdConfirmDelete(oidItemMaster){
	document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
	document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
}
function cmdSave(){
	document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
	}

function cmdEdit(oidItemMaster){
	document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
	document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
	}

function cmdCancel(oidItemMaster){
	document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
	document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
}

function cmdBack(){
	document.frmitemmaster.command.value="<%=JSPCommand.BACK%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
	}

function cmdListFirst(){
	document.frmitemmaster.command.value="<%=JSPCommand.FIRST%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
}

function cmdListPrev(){
	document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
	}

function cmdListNext(){
	document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
}

function cmdListLast(){
	document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmitemmaster.action="itemmaster.jsp";
	document.frmitemmaster.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Master 
                        Maintenance </span> &raquo; <span class="level1">POS</span> 
                        &raquo; <span class="level2">Product<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmitemmaster" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
						  <input type="hidden" name="hidden_vendor_item_id" value="">
						  
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3">&nbsp; 
                                          </td>
                                        </tr>
                                        <%
							try{
								if (listItemMaster.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listItemMaster,oidItemMaster)%> </td>
                                        </tr>
                                        <%  } 
						  }catch(Exception exc){ 
						  }%>
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
                                            <% jspLine.setLocationImg(approot+"/images/ctr_line");
							   	jspLine.initDefault();
								jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                            <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                        <%
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0)
						{
					%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                        </tr>
                                        <%}%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <%//if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspItemMaster.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                      <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE && iErrCode!=0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="12%">&nbsp;</td>
                                          <td height="21" valign="middle" width="16%">&nbsp;</td>
                                          <td height="21" valign="middle" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="62%" class="comment" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left">
                                          <td height="21" valign="middle" width="12%">&nbsp;</td>
                                          <td height="21" valign="middle" width="16%">&nbsp;</td>
                                          <td height="21" valign="middle" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="62%" class="comment" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="12%">&nbsp;&nbsp;<b>ITEM 
                                            MASTER</b> </td>
                                          <td height="21" valign="middle" width="16%">&nbsp;</td>
                                          <td height="21" valign="middle" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="62%" class="comment" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="12%">&nbsp;</td>
                                          <td height="21" valign="middle" width="16%">*)= 
                                            required</td>
                                          <td height="21" valign="middle" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="62%" class="comment" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Category</td>
                                          <td height="21" width="16%"> 
                                            <% Vector itemcategoryid_value = new Vector(1,1);
											Vector itemcategoryid_key = new Vector(1,1);
											String sel_itemcategoryid = ""+itemMaster.getItemCategoryId();
											if(categories!=null && categories.size()>0){
												for(int i=0; i<categories.size(); i++){
													ItemCategory ic = (ItemCategory)categories.get(i);
													
													ItemGroup ig = new ItemGroup();
													try{
														ig = DbItemGroup.fetchExc(ic.getItemGroupId());
													}
													catch(Exception e){
													}
													
												    itemcategoryid_key.add(""+ic.getOID());
												    itemcategoryid_value.add(""+ig.getName()+" - "+ic.getName());
												}
											}		
										   %>
                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_ITEM_CATEGORY_ID],null, sel_itemcategoryid, itemcategoryid_key, itemcategoryid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_ITEM_CATEGORY_ID) %> </td>
                                          <td height="21" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="62%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Code</td>
                                          <td height="21" width="16%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_CODE] %>"  value="<%= itemMaster.getCode() %>" class="formElemen" size="10" maxlength="5">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_CODE) %> </td>
                                          <td height="21" width="10%"> 
                                            <div align="right"></div>
                                          </td>
                                          <td height="21" colspan="2" width="62%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Barcode</td>
                                          <td height="21" width="16%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_BARCODE] %>"  value="<%= itemMaster.getBarcode() %>" class="formElemen" size="20">
                                          </td>
                                          <td height="21" width="10%"> 
                                            <div align="right">Product Name&nbsp;&nbsp;</div>
                                          </td>
                                          <td height="21" colspan="2" width="62%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NAME] %>"  value="<%= itemMaster.getName() %>" class="formElemen" size="40">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_NAME) %> 
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Selling 
                                            Price</td>
                                          <td height="21" width="16%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_SELLING_PRICE] %>"  value="<%= itemMaster.getSellingPrice() %>" class="formElemen" size="20" style="text-align:right">
                                          </td>
                                          <td height="21" width="10%"> 
                                            <div align="right">C.O.G.S.&nbsp;&nbsp;</div>
                                          </td>
                                          <td height="21" colspan="2" width="62%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS] %>"  value="<%= itemMaster.getCogs() %>" class="formElemen" size="20" style="text-align:right">
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;</td>
                                          <td height="21" width="16%">&nbsp;</td>
                                          <td height="21" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="62%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                            Purchase</td>
                                          <td height="21" width="16%"> 
                                            <% Vector uompurchaseid_value = new Vector(1,1);
						Vector uompurchaseid_key = new Vector(1,1);
					 	String sel_uompurchaseid = ""+itemMaster.getUomPurchaseId();
						if(units!=null && units.size()>0){
							for(int i=0; i<units.size(); i++){
								Uom uo = (Uom)units.get(i);
							    uompurchaseid_key.add(""+uo.getOID());
							    uompurchaseid_value.add(""+uo.getUnit());
					   		}
					    }
					   %>
                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_PURCHASE_ID],null, sel_uompurchaseid, uompurchaseid_key, uompurchaseid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_PURCHASE_ID) %> </td>
                                          <td height="21" width="10%"> 
                                            <div align="right">1 Unit Purchase 
                                              = &nbsp;&nbsp;</div>
                                          </td>
                                          <td height="21" colspan="2" width="62%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY] %>"  value="<%= itemMaster.getUomPurchaseStockQty() %>" class="formElemen" size="5" style="text-align:right">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY) %> Unit Stock 
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                            Stock</td>
                                          <td height="21" width="16%"> 
                                            <% Vector uomstockid_value = new Vector(1,1);
											Vector uomstockid_key = new Vector(1,1);
											String sel_uomstockid = ""+itemMaster.getUomStockId();
										   
										   if(units!=null && units.size()>0){
												for(int i=0; i<units.size(); i++){
													Uom uo = (Uom)units.get(i);
													uomstockid_key.add(""+uo.getOID());
													uomstockid_value.add(""+uo.getUnit());
												}
											}
										   %>
                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_ID],null, sel_uomstockid, uomstockid_key, uomstockid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_ID) %></td>
                                          <td height="21" width="10%"> 
                                            <div align="right">1 Unit Stock = 
                                              &nbsp;&nbsp; </div>
                                          </td>
                                          <td height="21" colspan="2" width="62%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES_QTY] %>"  value="<%= itemMaster.getUomStockSalesQty() %>" class="formElemen" size="5" style="text-align:right">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES_QTY) %> Unit Sales 
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                            Recipe</td>
                                          <td height="21" width="16%"> 
                                            <% Vector uomrecipeid_value = new Vector(1,1);
											Vector uomrecipeid_key = new Vector(1,1);
											String sel_uomrecipeid = ""+itemMaster.getUomRecipeId();
										    uomrecipeid_key.add("---select---");
										    uomrecipeid_value.add("");
										   
										    if(units!=null && units.size()>0){
												for(int i=0; i<units.size(); i++){
													Uom uo = (Uom)units.get(i);
													uomrecipeid_key.add(""+uo.getOID());
													uomrecipeid_value.add(""+uo.getUnit());
												}
											 }
					   
					   						%>
                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_RECIPE_ID],null, sel_uomrecipeid, uomrecipeid_key, uomrecipeid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_RECIPE_ID) %> </td>
                                          <td height="21" width="10%"> 
                                            <div align="right">1 Unit Stock = 
                                              &nbsp;&nbsp; </div>
                                          </td>
                                          <td height="21" colspan="2" width="62%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_RECIPE_QTY] %>"  value="<%= itemMaster.getUomStockRecipeQty() %>" class="formElemen" size="5" style="text-align:right">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_RECIPE_QTY) %> Unit Recipe 
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                            Sales</td>
                                          <td height="21" width="16%"> 
                                            <% Vector uomsalesid_value = new Vector(1,1);
											Vector uomsalesid_key = new Vector(1,1);
											String sel_uomsalesid = ""+itemMaster.getUomSalesId();
										    uomsalesid_key.add("---select---");
										    uomsalesid_value.add("");
											if(units!=null && units.size()>0){
												for(int i=0; i<units.size(); i++){
													Uom uo = (Uom)units.get(i);
													uomsalesid_key.add(""+uo.getOID());
													uomsalesid_value.add(""+uo.getUnit());
												}
											 }
										   %>
                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_SALES_ID],null, sel_uomsalesid, uomsalesid_key, uomsalesid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_SALES_ID) %> </td>
                                          <td height="21" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="62%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;</td>
                                          <td height="21" width="16%">&nbsp;</td>
                                          <td height="21" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="62%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" colspan="5"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="6%">&nbsp;&nbsp;For 
                                                  Sale </td>
                                                <td width="6%"> 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_FOR_SALE] %>"  value="1" <%if(itemMaster.getForSale()==1){%>checked<%}%> class="formElemen" >
                                                </td>
                                                <td width="7%">For Purchase</td>
                                                <td width="6%"> 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_FOR_BUY] %>"  value="1" <%if(itemMaster.getForBuy()==1){%>checked<%}%> class="formElemen" >
                                                </td>
                                                <td width="9%">Include In Recipe</td>
                                                <td width="6%"> 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_RECIPE_ITEM] %>"  value="1" <%if(itemMaster.getRecipeItem()==1){%>checked<%}%> class="formElemen" >
                                                </td>
                                                <td width="7%">Is Available</td>
                                                <td width="53%"> 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_ACTIVE] %>"  value="1" <%if(itemMaster.getIsActive()==1){%>checked<%}%> class="formElemen">
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="12%">&nbsp;</td>
                                          <td height="8" valign="middle" width="16%">&nbsp;</td>
                                          <td height="8" valign="middle" width="10%">&nbsp;</td>
                                          <td height="8" colspan="2" width="62%" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" class="command" valign="top"> 
                                            <%
									jspLine.setLocationImg(approot+"/images/ctr_line");
									jspLine.initDefault();
									jspLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidItemMaster+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidItemMaster+"')";
									String scancel = "javascript:cmdEdit('"+oidItemMaster+"')";
									jspLine.setBackCaption("Back to List");
									jspLine.setJSPCommandStyle("buttonlink");
										jspLine.setDeleteCaption("Delete");
										jspLine.setSaveCaption("Save");
										jspLine.setAddCaption("");
										
										jspLine.setOnMouseOut("MM_swapImgRestore()");
									jspLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									jspLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//jspLine.setOnMouseOut("MM_swapImgRestore()");
									jspLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									jspLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									jspLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									jspLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									jspLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									jspLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									
									
									jspLine.setWidthAllJSPCommand("90");
									jspLine.setErrorStyle("warning");
									jspLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									jspLine.setQuestionStyle("warning");
									jspLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									jspLine.setInfoStyle("success");
									jspLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

									if (privDelete){
										jspLine.setConfirmDelJSPCommand(sconDelCom);
										jspLine.setDeleteJSPCommand(scomDel);
										jspLine.setEditJSPCommand(scancel);
									}else{ 
										jspLine.setConfirmDelCaption("");
										jspLine.setDeleteCaption("");
										jspLine.setEditCaption("");
									}

									if(privAdd == false  && privUpdate == false){
										jspLine.setSaveCaption("");
									}

									if (privAdd == false){
										jspLine.setAddCaption("");
									}
									%>
                                            <%= jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="10%">&nbsp;</td>
                                          <td width="62%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" background="../images/line.gif"><img src="../images/line.gif" width="47" height="7"></td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="10%">&nbsp;</td>
                                          <td width="62%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                <td class="tab" nowrap> 
                                                  <div align="center">&nbsp;&nbsp;Vendor&nbsp;&nbsp;</div>
                                                </td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabin"> 
                                                  <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecipe()" class="tablink">Recipe</a>&nbsp;&nbsp;</div>
                                                </td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabin"> 
                                                  <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToOverhead()" class="tablink">Overhead</a>&nbsp;&nbsp;</div>
                                                </td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="10%">&nbsp;</td>
                                          <td width="62%">&nbsp;</td>
                                        </tr>
                                        <%
										Vector listVendorItem = DbVendorItem.list(0,0, DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+"="+itemMaster.getOID() , DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE]);
										%>
                                        <tr> 
                                          <td colspan="4" class="page"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td> 
                                                  <%if(listVendorItem!=null && listVendorItem.size()>0){%>
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="25%" class="tablehdr" height="19">Name</td>
                                                      <td width="29%" class="tablehdr" height="19">Address</td>
                                                      <td width="19%" class="tablehdr" height="19">Last 
                                                        Price</td>
                                                      <td width="14%" class="tablehdr" height="19">Last 
                                                        Discount %</td>
                                                      <td width="13%" class="tablehdr" height="19">Last 
                                                        Update</td>
                                                    </tr>
                                                    <%for(int i=0; i<listVendorItem.size(); i++){
											  		VendorItem iv = (VendorItem)listVendorItem.get(i);
													Vendor v = new Vendor();
													try{
														v = DbVendor.fetchExc(iv.getVendorId());
													}
													catch(Exception e){
													}
											  %>
                                                    <tr> 
                                                      <td width="25%" class="tablecell"><a href="javascript:cmdEditVendor('<%=iv.getOID()%>')"><%=v.getCode()+" - "+v.getName()%></a></td>
                                                      <td width="29%" class="tablecell"><%=v.getAddress()%></td>
                                                      <td width="19%" class="tablecell"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(iv.getLastPrice(), "#,###.##")%></div>
                                                      </td>
                                                      <td width="14%" class="tablecell"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(iv.getLastDiscount(), "#,###.##")%>%</div>
                                                      </td>
                                                      <td width="13%" class="tablecell"> 
                                                        <div align="center"><%=JSPFormater.formatDate(iv.getUpdateDate(), "dd MMMM yyyy")%></div>
                                                      </td>
                                                    </tr>
                                                    <%}%>
                                                    <tr> 
                                                      <td width="25%">&nbsp;</td>
                                                      <td width="29%">&nbsp;</td>
                                                      <td width="19%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="13%">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                  <%}%>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td><a href="javascript:cmdAddVendor()"><img src="../images/add2.gif" width="49" height="22" border="0"></a></td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top"> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                      </table>
                                      <%}%>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
  </tr>
</table>
                          
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
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
