 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.postransaction.order.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
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

	public String drawList(Vector objectClass)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell1");
		jsplist.setCellStyle1("tablecell");
		jsplist.setHeaderStyle("tablehdr");
		
                jsplist.addHeader("No","5%");
                jsplist.addHeader("Date","8%");
		jsplist.addHeader("Location","15%");
		jsplist.addHeader("Order Number","8%");
		jsplist.addHeader("Code","10%");
                jsplist.addHeader("Item name","35%");	
		jsplist.addHeader("Qty order","7%");
                jsplist.addHeader("Qty Trans","7%");
		jsplist.addHeader("Select","5%");
		//jsplist.addHeader("Uom Sales Id","11%");

		//jsplist.setLinkRow(0);
		//jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		
		//jsplist.setLinkSufix("')");
		jsplist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Order order = (Order)objectClass.get(i);
			Vector rowx = new Vector();
			Location loc = new Location();
                        ItemMaster im = new ItemMaster();
                        
                        try{
                            loc = DbLocation.fetchExc(order.getLocationId());
                        }catch(Exception ex){
                            
                        }
                        
                        try{
                            im = DbItemMaster.fetchExc(order.getItemMasterId());
                        }catch(Exception ex){
                            
                        }
                        
                        rowx.add("<div align=\"center\">"+""+(i + 1)+"</div>");
                        rowx.add(JSPFormater.formatDate(order.getDate(),"dd-MM-yyyy"));
                        rowx.add("" + loc.getName());
                        rowx.add("" + order.getNumber());
                        rowx.add("" + im.getCode());
                        rowx.add("" + im.getName());
                        rowx.add("" + order.getQtyOrder());
                        rowx.add("<div align=\"center\">" + "<input type=\"textbox\" size=\"5\" name=\"qty_"+order.getOID()+ "\" value=\"0\" >" + "</div>");
                        rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" size=\"20\" readonly name=\"item_"+order.getOID()+ "\" value=\"1\" >" + "</div>");
			
                       	lstData.add(rowx);
			lstLinkData.add(String.valueOf(order.getOID()));
		}

		return jsplist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");

//--------------- search ------------------------------------------------------
long srcGroupId = JSPRequestValue.requestLong(request, "src_group");
long srcCategoryId = JSPRequestValue.requestLong(request, "src_category");
String srcCode = JSPRequestValue.requestString(request, "src_code");
String srcBarCode = JSPRequestValue.requestString(request, "src_barcode");
String srcName = JSPRequestValue.requestString(request, "src_name");
int orderBy = JSPRequestValue.requestInt(request, "order_by");
long srcMerkId = JSPRequestValue.requestLong(request, "src_merk");
long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
//-----------------------------------------------------------------------------

/*variable declaration*/
int recordToGet = 0;
String whereClause = "type<>"+I_Ccs.TYPE_CATEGORY_FINISH_GOODS+" and type<>"+I_Ccs.TYPE_CATEGORY_CIVIL_WORK;
String orderClause = "";//DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+","+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+","+
					 //DbItemMaster.colNames[DbItemMaster.COL_CODE]+","+DbItemMaster.colNames[DbItemMaster.COL_NAME];


if(srcGroupId!=0){
        whereClause = "im."+ DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+srcGroupId;
}
if(srcCategoryId!=0){
	if(whereClause.length()>0){
		whereClause = whereClause + " and ";
	}
	whereClause = whereClause + "im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+srcCategoryId;
}
if(srcCode!=null && srcCode.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause +" and ";
	}
	whereClause = whereClause + "im." + DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+srcCode+"%'";
}
if(srcName!=null && srcName.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause +" and ";
	}
	whereClause = whereClause + "im." + DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+srcName+"%'";
}
if(srcBarCode!=null && srcBarCode.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause +" and ";
	}
	whereClause = whereClause + "(" + "im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" like '%"+srcBarCode+"%' or " + "im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2]+" like '%"+srcBarCode+"%' or " + "im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3]+" like '%"+srcBarCode+"%')" ;
}
if(srcVendorId!=0){
    if(whereClause.length()>0){
        whereClause = whereClause +" and ";
    }
    whereClause= whereClause + " vi.vendor_id=" + srcVendorId;
}

if(srcLocationId!=0){
    if(whereClause.length()>0){
        whereClause = whereClause +" and ";
    }
    whereClause= whereClause + " ao.location_id=" + srcLocationId;
}

if(whereClause.length()>0){
        whereClause = whereClause +" and ";
    }
    whereClause= whereClause + " ao.status='DRAFT'"; 


//out.println("whereClause : "+whereClause);




CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
JSPLine jspLine = new JSPLine();
Vector listOrder = new Vector(1,1);

/*switch statement */
//iErrCode = ctrlItemMaster.action(iJSPCommand , oidItemMaster);
/* end switch*/
JspItemMaster jspItemMaster = ctrlItemMaster.getForm();

/*count list All ItemMaster*/
int vectSize =0;
if(srcVendorId!=0){
   // vectSize = DbItemMaster.getCountBySupplier(whereClause);
}else{
    //vectSize = DbItemMaster.getCount(whereClause);
}
    

ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
//msgString =  ctrlItemMaster.getMessage();

if(oidItemMaster==0){
	oidItemMaster = itemMaster.getOID();
}

/*if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
} */
/* end switch list*/

/* get record to display */

long oidPurchase=0;
boolean purchaseok=false;

if(iJSPCommand==JSPCommand.SEARCH){
    if(srcVendorId!=0){
        listOrder = DbOrder.listByVendor(start,recordToGet, whereClause, orderClause);
    }else{
        listOrder = DbOrder.list(start,recordToGet, whereClause , orderClause);
    }
    
}
//Transfer tr = new Transfer();
Purchase po = new Purchase();

            if (iJSPCommand == JSPCommand.SAVE && srcVendorId!=0){
                
                if(srcVendorId!=0){
                    listOrder = DbOrder.listByVendor(start,recordToGet, whereClause, orderClause);
                }else{
                    listOrder = DbOrder.list(start,recordToGet, whereClause , orderClause);
                }
                
                
                Vector temp = new Vector();
                if (listOrder != null && listOrder.size() > 0){
                    for (int i = 0; i < listOrder.size(); i++){
                        Order ti = (Order) listOrder.get(i);
                        int xxx = JSPRequestValue.requestInt(request, "item_" + ti.getOID());
                        double yy = JSPRequestValue.requestInt(request, "qty_" + ti.getOID());
                        
                        if (xxx == 1){
                            if(yy>0){
                                ti.setQtyProces(yy);
                                temp.add(ti);
                            }
                           
                        }
                    }
                   
                }
                
                
                //create transfer
                if(temp.size()>0){
                   
                    Location locOrder = new Location();
                                        
                    Order od = (Order)temp.get(0);//hanya untk mengetahui lokasi id nya
                    
                    try{
                        locOrder= DbLocation.fetchExc(od.getLocationId());
                    }catch(Exception ex){
                        
                    }
                                     
                    int ctr = DbPurchase.getNextCounter();
                    po.setLocationId(od.getLocationId());
                    po.setVendorId(srcVendorId);
                    
                    po.setCounter(ctr);
                    po.setPrefixNumber(DbPurchase.getNumberPrefix());
                    po.setNumber(DbPurchase.getNextNumber(ctr));
                    po.setPurchDate(new Date());
                    po.setStatus("DRAFT");
                    po.setUserId(user.getOID());
                    po.setExpiredDate(new Date());
                    
                    oidPurchase = DbPurchase.insertExc(po);
                                                         
                    for(int i =0;i<temp.size();i++){
                        Order odr = (Order) temp.get(i);
                        ItemMaster im = new ItemMaster();
                        try{
                            im= DbItemMaster.fetchExc(odr.getItemMasterId());
                        }catch(Exception ex){
                            
                        }
                        
                        Vector vItem = new Vector();
                        vItem= DbVendorItem.list(0, 0, "vendor_id=" + srcVendorId + " and item_master_id="+ im.getOID(), "");
                        VendorItem vendorItem = new VendorItem();
                        if(vItem.size()>0){
                            vendorItem = (VendorItem)vItem.get(0);
                        }
                                                                       
                        
                        PurchaseItem purcItem = new PurchaseItem();
                        
                        purcItem.setItemMasterId(im.getOID());
                        purcItem.setQty(odr.getQtyProces());
                        purcItem.setAmount(vendorItem.getLastPrice());
                        purcItem.setPurchaseId(oidPurchase);
                        purcItem.setTotalAmount((odr.getQtyProces())* (vendorItem.getLastPrice()));
                                               
                        long purchaseItemId = DbPurchaseItem.insertExc(purcItem);
                        
                        
                        odr.setStatus("APPROVED");
                        odr.setPurchaseId(oidPurchase);
                        odr.setPurchaseItemId(purchaseItemId);
                        DbOrder.updateExc(odr);///update status
                        
                    }
                    purchaseok=true;
                    
                    
                }
                
                
                
            }
            




%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">
    
    
function cmdPrintXLS(){	 
            window.open("<%=printroot%>.report.RptItemMasterXLS?idx=<%=System.currentTimeMillis()%>");
        }    

function cmdSearch(){
	//document.frmitemmaster.hidden_item_master_id.value="0";
	document.frmorder.command.value="<%=JSPCommand.SEARCH%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="poanalisis.jsp";
	document.frmorder.submit();
}


function cmdAsk(oidItemMaster){
	document.frmorder.hidden_item_master_id.value=oidItemMaster;
	document.frmorder.command.value="<%=JSPCommand.ASK%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="itemlist.jsp";
	document.frmorder.submit();
}


function cmdSave(){
	document.frmorder.command.value="<%=JSPCommand.SAVE%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="poanalisis.jsp";
	document.frmorder.submit();
	}

function cmdPurchase(oidPurchase){
    alert(oidPurchase);
       	document.frmorder.hidden_purchase_id.value=oidPurchase;
	document.frmorder.command.value="<%=JSPCommand.EDIT%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="purchaseitem.jsp";
	document.frmorder.submit();
}

function cmdCancel(oidItemMaster){
	document.frmorder.hidden_item_master_id.value=oidItemMaster;
	document.frmorder.command.value="<%=JSPCommand.EDIT%>";
	document.frmorder.prev_command.value="<%=prevJSPCommand%>";
	document.frmorder.action="itemlist.jsp";
	document.frmorder.submit();
}

function cmdBack(){
	document.frmorder.command.value="<%=JSPCommand.BACK%>";
	document.frmorder.action="itemmaster.jsp";
	document.frmorder.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmorder" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                   <input type="hidden" name="hidden_purchase_id" value="<%=oidPurchase%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container" valign="top"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                        <tr valign="bottom"> 
                                          <td width="60%" height="23"><b><font color="#990000" class="lvl1">Purchasing 
                                            </font><font class="tit1">&raquo; 
                                            </font><font class="tit1"><span class="lvl2">PO Analisis
                                            </span></font></b></td>
                                          <td width="40%" height="23"> 
                                            <%@ include file = "../main/userpreview.jsp" %>
                                          </td>
                                        </tr>
                                        <tr > 
                                          <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
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
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                    <tr> 
                                                      <td width="5%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="15%">&nbsp;</td>
                                                      <td width="42%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="7" nowrap><b><u>Search 
                                                        Option</u></b></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="5%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="15%">&nbsp;</td>
                                                      <td width="42%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="5%">Group</td>
                                                      <td width="11%"> 
                                                        <%
													  Vector groupsx = DbItemGroup.list(0,0, "", "name");
													  %>
                                                        <select name="src_group">
                                                          <option value="0" <%if(srcGroupId==0){%>selected<%}%>>All 
                                                          ..</option>
                                                          <%if(groupsx!=null && groupsx.size()>0){
														  		for(int i=0; i<groupsx.size(); i++){
																	ItemGroup ig = (ItemGroup)groupsx.get(i);
																%>
                                                          <option value="<%=ig.getOID()%>" <%if(srcGroupId==ig.getOID()){%>selected<%}%>><%=ig.getName()%></option>
                                                          <%}}%>
                                                        </select>
                                                      </td>
                                                      <td width="6%">SKU</td>
                                                      <td width="14%"> 
                                                        <input type="text" name="src_code" size="15" value="<%=srcCode%>" onchange="javascript:cmdSearch()">
                                                      </td>
                                                      <td width="6%">Location</td>
                                                      <td width="15%">
                                                       
                                                  <select name="src_location_id">
                                                    
                                                    <%
													
													Vector vloc = DbLocation.list(0,0, "", "name");
													
												    if(vloc!=null && vloc.size()>0){
														 for(int i=0; i<vloc.size(); i++){
															Location loc = (Location)vloc.get(i);
															
													%>
                                                    <option value="<%=loc.getOID()%>" <%if(srcLocationId==loc.getOID()){%>selected<%}%>><%=loc.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>  
                                                      </td>
                                                      <td width="42%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="5%">Category</td>
                                                      <td width="11%"> 
                                                        <%
													  Vector categoryx = DbItemCategory.list(0,0, "", "name");
													  %>
                                                        <select name="src_category">
                                                          <option value="0" <%if(srcCategoryId==0){%>selected<%}%>>All 
                                                          ..</option>
                                                          <%if(categoryx!=null && categoryx.size()>0){
														  		for(int i=0; i<categoryx.size(); i++){
																	ItemCategory ic = (ItemCategory)categoryx.get(i);
																%>
                                                          <option value="<%=ic.getOID()%>" <%if(srcCategoryId==ic.getOID()){%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                          <%}}%>
                                                        </select>
                                                      </td>
                                                      <td width="6%">Name</td>
                                                      <td width="14%"> 
                                                        <input type="text" name="src_name" value="<%=srcName%>" onchange="javascript:cmdSearch()">
                                                      </td>
                                                      
                                                      <td width="15%"> 
                                                       
                                                      </td>
                                                      <td width="42%"> 
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="5%">Vendor</td>
                                                      <td width="11%">
                                                          <select name="src_vendor_id">
                                                            <option value="0" <%if(srcVendorId==0){%>selected<%}%>>- 
                                                            All -</option>
                                                            <%

                                                                                                                Vector vendors = DbVendor.list(0,0, "", "name");

                                                                                                            if(vendors!=null && vendors.size()>0){
                                                                                                                         for(int i=0; i<vendors.size(); i++){
                                                                                                                                Vendor d = (Vendor)vendors.get(i);
                                                                                                                                String str = "";
                                                                                                                %>
                                                            <option value="<%=d.getOID()%>" <%if(srcVendorId==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                                            <%}}%>
                                                          </select>
                                                          
                                                          
                                                          
                                                          
                                                      </td>
                                                      <td width="6%">Barcode</td>
                                                      <td width="15%">
                                                         <input type="text" name="src_barcode" size="15" value="<%=srcBarCode%>" onchange="javascript:cmdSearch()">
                                                      </td>
                                                      
                                                      <td width="14%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>
                                                      <td width="15%">&nbsp;</td>
                                                      <td width="42%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="7" background="../images/line1.gif"><img src="../images/line1.gif" width="47" height="3"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="7">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%
							try{
								if (listOrder.size()>0){
							%>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                  <%= drawList(listOrder)%> </td>
                                              </tr>
                                              <%  }else{%>
                                                    <tr align="left" valign="top"> 
                                                    <td height="22" valign="middle" colspan="3"> 
                                                      No Request
                                                    </tr>                
                                              <%} 
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
                                              
                                             
                                            </table>
                                          </td>
                                        </tr>
                                        <%if(iJSPCommand==JSPCommand.SAVE && purchaseok){%>
                                         <script language="JavaScript">
                                            cmdPurchase('<%=oidPurchase%>')
                                         </script>
                                        <%}else if(iJSPCommand==JSPCommand.SAVE){%>
                                        
                                        <tr><td bgcolor="yellow">Doc PO gagal dibuat</td></tr>
                                        <%}%>
                                        <%if(listOrder.size()>0){%>
                                         <tr> 
                                            <td>
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <a href="javascript:cmdSave()">Create PO</a>
                                                        </td>
                                                        
                                                        
                                                    </tr>    
                                                </table>
                                                
                                            </td>
                                          </tr>
                                         <%}%> 
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
                       
                        <span class="level2"><br>
                        </span><!-- #EndEditable -->
                      </td>
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
          <td height="25"> 
            <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    
  

</body>
<!-- #EndTemplate --></html>
