 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.fms.master.*" %>
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

	public String drawList(Vector objectClass ,  long itemMasterId, int start, long locationId, Date srcStartDate, Date  srcEndDate)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell1");
		jsplist.setCellStyle1("tablecell");
		jsplist.setHeaderStyle("tablehdr");
		
                jsplist.addHeader("No","3%");
		jsplist.addHeader("Barcode","12%");
		jsplist.addHeader("SKU","8%");
		jsplist.addHeader("Name","30%");
                jsplist.addHeader("Category","12%");
		jsplist.addHeader("Sub Category","14%");
		jsplist.addHeader("Unit Stock","5%");
                jsplist.addHeader("Qty Sold","5%");
                jsplist.addHeader("Standart Stock","10%");
                jsplist.addHeader("Delivery Unit","5%");
                jsplist.addHeader("Show History","5%");
		

		jsplist.setLinkRow(10);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		jsplist.setLinkPrefix("javascript:cmdEdit('");
		jsplist.setLinkSufix("')");
		jsplist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
                                        
			ItemMaster itemMaster = (ItemMaster)objectClass.get(i);
                        try{
                            itemMaster = DbItemMaster.fetchExc(itemMaster.getOID());
                        }catch(Exception ex){
                            
                        }
			 Vector rowx = new Vector();
			 if(itemMasterId == itemMaster.getOID())
				 index = i;
			
			ItemGroup ig = new ItemGroup();
			try{
				ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
			}
			catch(Exception e){
			}
                         Vector vstockmin = new Vector();
                        
                        StockMinItem smin = new StockMinItem();
                        try{
                            vstockmin= DbStockMin.list(0, 0, "location_id="+ locationId + " and item_master_id=" + itemMaster.getOID(), "");
                            smin = (StockMinItem) vstockmin.get(0);
                        }catch(Exception ex){
                            
                        }
                        
                            
                       
                        rowx.add("<div align=\"center\">"+""+(start + i + 1)+"</div>");
                        
                        rowx.add(itemMaster.getBarcode());
                        rowx.add(itemMaster.getCode());
                        rowx.add(itemMaster.getName());
			rowx.add(ig.getName());
			
			ItemCategory ic = new ItemCategory();
			try{
				ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
			}
			catch(Exception e){
			}

			rowx.add(ic.getName());
                                       
			

			Uom uo = new Uom();
			try{
				uo = DbUom.fetchExc(itemMaster.getUomStockId());
			}
			catch(Exception e){
			}
                        
                       
			rowx.add("<div align=\"center\">"+uo.getUnit()+"</div>");
                        rowx.add("<div align=\"center\">"+DbStockMin.getTotalTerjual(" to_days(s.date)>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"') and to_days(s.date)<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"') and s.location_id=" + locationId + " and sd.product_master_id="+itemMaster.getOID())+"</div>");
			rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"5\" name=\"s_"+itemMaster.getOID() +"\" value=\""+smin.getMinStock()+"\" class=\"formElemen\">"+"<input type=\"hidden\" size=\"5\" name=\"hpp_"+itemMaster.getOID() +"\" value=\""+itemMaster.getCogs()+"\" class=\"formElemen\">"+"</div>");
                        rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"5\" name=\"du_"+itemMaster.getOID() +"\" value=\""+itemMaster.getDeliveryUnit()+"\" ReadOnly class=\"ReadOnly\">"+"</div>");
                        rowx.add("<div align=\"center\">History</div>");
                       
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(smin.getOID()));
                      
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
String srcStart = JSPRequestValue.requestString(request, "src_start_date");
String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
String srcName = JSPRequestValue.requestString(request, "src_name");
int orderBy = JSPRequestValue.requestInt(request, "order_by");
long srcMerkId = JSPRequestValue.requestLong(request, "src_merk");
long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
int qtyJual = JSPRequestValue.requestInt(request, "qty_jual");
//-----------------------------------------------------------------------------
Vector vLocations = userLocations;//DbLocation.list(0, 0, "", "name");

Date srcStartDate = new Date();
Date srcEndDate = new Date();

srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
	srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");

/*variable declaration*/
int recordToGet = 20;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "type<>"+I_Ccs.TYPE_CATEGORY_FINISH_GOODS+" and type<>"+I_Ccs.TYPE_CATEGORY_CIVIL_WORK;
String orderClause = "";//DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+","+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+","+
					 //DbItemMaster.colNames[DbItemMaster.COL_CODE]+","+DbItemMaster.colNames[DbItemMaster.COL_NAME];
if(orderBy==0){
    orderClause="item_group_id";
}else if(orderBy==1){
    orderClause="item_category_id";
}else if(orderBy==2){
    orderClause="code";
}else if(orderBy==3){
    orderClause="name";
}else if(orderBy==4){
    orderClause="merk_id";
}


if(srcGroupId!=0){
        whereClause = DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+srcGroupId;
}
if(srcCategoryId!=0){
	if(whereClause.length()>0){
		whereClause = whereClause +" and ";
	}
	whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+srcCategoryId;
}
if(srcCode!=null && srcCode.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause +" and ";
	}
	whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+srcCode+"%'";
}
if(srcName!=null && srcName.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause +" and ";
	}
	whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+srcName+"%'";
}
if(srcBarCode!=null && srcBarCode.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause +" and ";
	}
	whereClause = whereClause + "(" + DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" like '%"+srcBarCode+"%' or " +  DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2]+" like '%"+srcBarCode+"%' or " + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3]+" like '%"+srcBarCode+"%')" ;
}
if(srcVendorId!=0){
    if(whereClause.length()>0){
        whereClause = whereClause +" and ";
    }
    whereClause= whereClause + " pos_vendor_item.vendor_id=" + srcVendorId;
}

if(whereClause.length()>0){
        whereClause = whereClause +" and ";
    }
    whereClause= whereClause + " is_active=1";

	
//out.println("whereClause : "+whereClause);


CmdStockMin ctrlItemMaster = new CmdStockMin(request);
JSPLine jspLine = new JSPLine();
Vector listItemMaster = new Vector(1,1);

/*switch statement */
//iErrCode = ctrlItemMaster.action(iJSPCommand , oidItemMaster);
/* end switch*/
//JspItemMaster jspItemMaster = ctrlItemMaster.getForm();

/*count list All ItemMaster*/
int vectSize =0;
if(srcVendorId!=0){
    vectSize = DbItemMaster.getCountBySupplier(whereClause);
}else{
    vectSize = DbItemMaster.getCount(whereClause);
}
    

//ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
msgString =  ctrlItemMaster.getMessage();



if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
} 
/* end switch list*/

/* get record to display */
if(srcVendorId!=0){
    listItemMaster = DbItemMaster.listByVendor(start,recordToGet, whereClause , orderClause);
}else{
    listItemMaster = DbItemMaster.list(start,recordToGet, whereClause , orderClause);
}
  //Vector vItem = new Vector();


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

//Vector categories = DbItemCategory.list(0,0, "", DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID]+","+DbItemCategory.colNames[DbItemCategory.COL_NAME]);

//out.println("categories : "+categories);

//Vector units = DbUom.list(0,0, "", "");



if(iJSPCommand==JSPCommand.SAVE){
    if(listItemMaster.size()>0){
        Vector vloc = new Vector();
        vloc = DbLocation.list(0, 0, "type='warehouse'", "");
        Location loc = new Location();
        
        if(vloc.size()>0){
            loc = (Location)vloc.get(0);
        }
        for(int i =0;i<listItemMaster.size();i++){
            ItemMaster im = (ItemMaster)listItemMaster.get(i);
            
            try{
                im = DbItemMaster.fetchExc(im.getOID());
            }catch(Exception ex){
                
            }
            
            StockMinItem sm = new StockMinItem();
           
            
            Vector vstockmin = new Vector();
            vstockmin= DbStockMin.list(0, 0, "location_id="+ srcLocationId + " and item_master_id=" + im.getOID(), "");
            if(vstockmin.size()>0){
                sm =(StockMinItem) vstockmin.get(0);
            }
            sm.setBarcode(im.getBarcode());
            sm.setCode(im.getCode());
            sm.setDeliveryUnit(im.getDeliveryUnit());
            sm.setItemMasterId(im.getOID());
            sm.setItemName(im.getName());
            sm.setLocationId(srcLocationId);
            sm.setMinStock(JSPRequestValue.requestDouble(request, "s_"+im.getOID()));
            
            LogStockStandar logS = new LogStockStandar();//untuk  history stock standar
            if(sm.getOID()==0){//insert
                
                if(sm.getMinStock()!=0){
                    if(sm.getLocationId()==loc.getOID()){
                        if(im.getLocationOrder() == 0 || im.getLocationOrder()==loc.getOID()){
                            DbStockMin.insertExc(sm);
                        }
                                
                    }else{
                        DbStockMin.insertExc(sm);
                        
                    }
                    logS.setLogDesc("insert stock standar ="+sm.getMinStock()+" by " + user.getFullName() );
                    if(im.getLocationOrder()==loc.getOID() || im.getLocationOrder()==0){
                        //DbStockMin.updateStockStandarByLocation(loc.getOID(),sm);
                    }
                    logS.setDate(new Date());
                    logS.setQtyStandar(sm.getMinStock());
                    logS.setStockMinId(sm.getOID());
                    logS.setUserId(user.getOID());
                    logS.setUserName(user.getFullName());
                    DbLogStockStandar.insertExc(logS);
            
                }
                
                
            }else{
                DbStockMin.updateExc(sm);//update
                logS.setLogDesc("update stock standar ="+sm.getMinStock()+" by " + user.getFullName() );
                if(im.getLocationOrder()==loc.getOID() || im.getLocationOrder()==0){
                    //DbStockMin.updateStockStandarByLocation(loc.getOID(),sm);
                }
                
                logS.setDate(new Date());
                logS.setQtyStandar(sm.getMinStock());
                logS.setStockMinId(sm.getOID());
                logS.setUserId(user.getOID());
                logS.setUserName(user.getFullName());
                DbLogStockStandar.insertExc(logS);
            
                
            }
           
            
        }
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
    
    
   

function cmdSearch(){
	document.frmitemmaster.start.value="0";
         
	document.frmitemmaster.command.value="<%=JSPCommand.SEARCH%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="stockstandarlist.jsp";
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
	document.frmitemmaster.action="stockstandarlist.jsp";
	document.frmitemmaster.submit();
}

function cmdConfirmDelete(oidItemMaster){
	document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
	document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="stockstandarlist.jsp";
	document.frmitemmaster.submit();
}
function cmdSave(){
	document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="stockstandarlist.jsp";
	document.frmitemmaster.submit();
	}

function cmdEdit(oidStockMin){
	document.frmitemmaster.stockMinId.value=oidStockMin;
	document.frmitemmaster.command.value="<%=JSPCommand.BACK%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	window.open("<%=approot%>/posmaster/detailLogStockStandar.jsp?stockMinId=" + oidStockMin, null, "height=1000,width=1000, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
	
	}

function cmdCancel(oidItemMaster){
	document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
	document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
	document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
	document.frmitemmaster.action="stockstandarlist.jsp";
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
	document.frmitemmaster.action="stockstandarlist.jsp";
	document.frmitemmaster.submit();
}

function cmdListPrev(){
	document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmitemmaster.action="stockstandarlist.jsp";
	document.frmitemmaster.submit();
	}

function cmdListNext(){
	document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmitemmaster.action="stockstandarlist.jsp";
	document.frmitemmaster.submit();
}

function cmdListLast(){
	document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmitemmaster.action="stockstandarlist.jsp";
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
                   <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmitemmaster" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          
                          <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                          <input type="hidden" name="stockMinId" value="<%=oidItemMaster%>">
			<input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container" valign="top"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                        <tr valign="bottom"> 
                                          <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                            Maintenance </font><font class="tit1">&raquo; 
                                            </font><font class="tit1"><span class="lvl2">POS 
                                            </span>&raquo; <span class="lvl2">Item 
                                            List </span></font></b></td>
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
                                    <td height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td height="25"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="23"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;&nbsp;Stock Standar&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
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
                                                      <td width="6%">Barcode</td>
                                                      <td width="15%">
                                                         <input type="text" name="src_barcode" size="15" value="<%=srcBarCode%>" onchange="javascript:cmdSearch()">
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
                                                      <td width="6%">Order By</td>
                                                      <td width="15%"> 
                                                        <select name="order_by">
                                                            <option value="0" <%if(orderBy==0){%>selected<%}%>>GROUP</option>
                                                            <option value="1" <%if(orderBy==1){%>selected<%}%>>CATEGORY</option>
                                                            <option value="2" <%if(orderBy==2){%>selected<%}%>>CODE</option>
                                                            <option value="3" <%if(orderBy==3){%>selected<%}%>>NAME</option>
                                                            <option value="4" <%if(orderBy==4){%>selected<%}%>>MERK</option>
                                                        </select>
                                                       
                                                      </td>
                                                      <td width="5%"> 
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
                                                      <td width="6%">&nbsp;Location</td>
                                                      
                                                      <td height="26" colspan="1" width="10%" class="comment"> 
                                                      
                                                                                                           
                                                                                                            <select name="src_location_id">
                                                                                                             <%if (vLocations != null && vLocations.size() > 0) {
                                                                                                                        long lokId = 0;
                                                                                                                        if(user.getSegment1Id() != 0){
                                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(user.getSegment1Id());
                                                                                                                                lokId = sd.getLocationId();
                                                                                                                            }
                                                                                                                        if(lokId==0){
                                                                                                                            
                                                                                                                        for (int i = 0; i < vLocations.size(); i++) {
                                                                                                                            Location d = (Location) vLocations.get(i);
                                                                                                                        %> 
                                                                                                                        <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>

                                                                                                                        <%}
                                                                                                                        }else{
                                                                                                                            Location loc = new Location();
                                                                                                                            try{
                                                                                                                                loc= DbLocation.fetchExc(lokId);
                                                                                                                                
                                                                                                                            }catch(Exception ec){

                                                                                                                            }
                                                                                                                            %>

                                                                                                                        <option value="<%=loc.getOID()%>" selected><%=loc.getName()%></option>

                                                                                                                    <%}%>
                                                                                                                    <%}%>
                                                                                                            </select>
                                                                                                           
                                                                                                        </td>
                                                                                                       
                                                            <td width="10%">Date Between</td>
                                                <td width="50%"> 
                                                  <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate==null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmitemmaster.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                  <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate==null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmitemmaster.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  
                                                  </td>   
                                                             
                                                             
                                                            <td width="14%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>                                            
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
								if (listItemMaster.size()>0){
							%>
                                              <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                  <%= drawList(listItemMaster,oidItemMaster, start, srcLocationId, srcStartDate, srcEndDate)%> </td>
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
                                              
                                               <tr align="left" valign="top"> 
                                                <td>
                                                    <table width="20%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            
                                                            <td><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save21','','../images/save2.gif',1)"><img src="../images/save.gif" name="save21" height="22" border="0"></a></td>
                                                            
                                                           
                                                        </tr>
                                                    </table>
                                                </td>    
                                                
                                              </tr>
                                              
                                              
                                             
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
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
