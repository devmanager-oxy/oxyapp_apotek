<%-- 
    Document   : addItemReceive
    Created on : Mar 10, 2012, 8:23:41 AM
    Author     : Ngurah Wirata
--%>

 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
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

	public String drawList(Vector objectClass ,  long vendorId)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell1");
		jsplist.setCellStyle1("tablecell");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("Code","10%");
		jsplist.addHeader("Name","45%");
		jsplist.addHeader("Address","15%");		
		
		
		//jsplist.addHeader("Unit Purchase","11%");
		//jsplist.addHeader("Unit Recipe","11%");
		//jsplist.addHeader("Unit Stock","10%");
		//jsplist.addHeader("Selling Price","15%");
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
			Vendor vendor = (Vendor)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(vendorId == vendor.getOID())
				 index = i;
			
			
			
			

			rowx.add(vendor.getCode());
			
			rowx.add(vendor.getName());
			
			rowx.add(vendor.getAddress());

			//rowx.add("<div align=\"center\">"+itemMaster.getBarcode()+"</div>");

			//rowx.add(String.valueOf(itemMaster.getUomPurchaseId()));

			//rowx.add(String.valueOf(itemMaster.getUomRecipeId()));

			

			//rowx.add("<div align=\"center\">"+uo.getUnit()+"</div>");
			
			//rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(DbPriceType.getPrice(1, "gol_1", itemMaster.getOID()), "#,###.##")+"</div>");

			//rowx.add(String.valueOf(itemMaster.getUomSalesId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(vendor.getOID()));
		}

		return jsplist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidVendor = JSPRequestValue.requestLong(request, "hidden_vendor_id");

//--------------- search ------------------------------------------------------
//long srcGroupId = JSPRequestValue.requestLong(request, "src_roup");
//long srcCategoryId = JSPRequestValue.requestLong(request, "src_category");

String srcName = JSPRequestValue.requestString(request, "src_name");
String vName = JSPRequestValue.requestString(request, "vendor_name");
//String Code = JSPRequestValue.requestString(request, "item_code");
//-----------------------------------------------------------------------------
if(vName.length()>0 && vName!=null){
    srcName=vName;
}

/*variable declaration*/
int recordToGet = 5;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
//String orderClause = "code";//DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+","+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+","+
					 //DbItemMaster.colNames[DbItemMaster.COL_CODE]+","+DbItemMaster.colNames[DbItemMaster.COL_NAME];

if(srcName.length()>0 && srcName!=null){
	whereClause = DbVendor.colNames[DbVendor.COL_NAME]+" like '%"+srcName+"%'";
}


//out.println("whereClause : "+whereClause);


CmdVendor ctrlIVendor = new CmdVendor(request);
JSPLine jspLine = new JSPLine();
Vector listVendor = new Vector(1,1);

/*switch statement */
iErrCode = ctrlIVendor.action(iJSPCommand , oidVendor);
/* end switch*/
JspVendor jspVendor = ctrlIVendor.getForm();

/*count list All ItemMaster*/
int vectSize = DbVendor.getCount(whereClause);

Vendor vendor = ctrlIVendor.getVendor();
//msgString =  ctrlItemMaster.getMessage();

if(oidVendor==0){
	oidVendor = vendor.getOID();
}

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlIVendor.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listVendor = DbVendor.list(start,recordToGet, whereClause , "");

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listVendor.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listVendor = DbVendor.list(start,recordToGet, whereClause , "");
}

//Vector categories = DbItemCategory.list(0,0, "", DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID]+","+DbItemCategory.colNames[DbItemCategory.COL_NAME]);

//out.println("categories : "+categories);

//Vector units = DbUom.list(0,0, "", "");

//if(iJSPCommand==JSPCommand.ADD){
//	itemMaster.setForSale(1);
//	itemMaster.setForBuy(1);
//	itemMaster.setIsActive(1);
//	itemMaster.setRecipeItem(1);
//}

%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=salesSt%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

function cmdSearch(){
	//document.frmitemmaster.hidden_item_master_id.value="0";
	document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
}

function cmdToProduct(){
	document.frmitemmaster.hidden_item_master_id.value="0";
	document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
}

function cmdAdd(){
	document.frmitemmaster.hidden_item_master_id.value="0";
	document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
}

function cmdAsk(oidItemMaster){
	document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
	document.frmitemmaster.command.value="<%=JSPCommand.ASK%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
}

function cmdConfirmDelete(oidItemMaster){
	document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
	document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
}
function cmdSave(){
	document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
	}

function cmdEdit(oidItemMaster){
	//self.opener.document.frmsalesproductdetail.hidden_item_master_id.value=oidItemMaster  
        self.opener.document.frmpurchase.HIDDEN_JSP_VENDOR_ID.value=oidItemMaster  
        self.opener.document.frmpurchase.submit();                
        self.close();  
	}

function cmdCancel(oidItemMaster){
	document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
	document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
}

function cmdBack(){
	document.frmitemmaster.command.value="<%=JSPCommand.BACK%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
	}

function cmdListFirst(){
	document.frmitemmaster.command.value="<%=JSPCommand.FIRST%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
}

function cmdListPrev(){
	document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
	}

function cmdListNext(){
	document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmitemmaster.action="searchSupplier.jsp";
	document.frmitemmaster.submit();
}

function cmdListLast(){
	document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmitemmaster.action="searchSupplier.jsp";
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
<body >
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmitemmaster" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_vendor_id" value="<%=oidVendor%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						 
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
						    
                            <tr> 
                              <td class="container" valign="top"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  
                                  <tr> 
                                    <td class="page"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8"  colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr align="left" valign="top"> 
                                                <td height="8" valign="middle" colspan="3"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                    <tr> 
                                                      <td colspan="5" height="5"></td>
                                                    </tr>
                                                    
                                                    
                                                    <tr> 
                                                      <td width="10%">Vendor Name&nbsp;</td>
                                                      <td width="14%"> 
                                                        <input type="text" name="src_name" onchange="javasrcipt:cmdSearch()" value="<%=srcName%>">
                                                      </td>
                                                      
                                                    </tr>
                                                    
                                                    
                                                    <tr> 
                                                      
                                                      <td width="10%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>
                                                      
                                                    </tr>
                                                    <tr> 
                                                      <td width="5%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="64%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="5" background="../images/line1.gif"><img src="../images/line1.gif" width="47" height="3"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="5">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%
							try{
								if (listVendor.size()>0){
							%>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                  <%= drawList(listVendor,oidVendor)%> </td>
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
                                              <tr align="left" valign="top"> 
                                                <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                              </tr>
                                              <%
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0)
						{
					%>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                              </tr>
                                              <%}%>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
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
                        </form>
                        <span class="level2"><br>
                        </span><!-- #EndEditable --> </td>
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
        
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>


