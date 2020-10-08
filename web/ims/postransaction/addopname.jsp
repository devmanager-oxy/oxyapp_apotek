
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %> 
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->

	
<%




int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidOpname = JSPRequestValue.requestLong(request, "hidden_opname_id");
long itemGroupId = JSPRequestValue.requestLong(request, "src_item_group_id");
String[] itemGroupIds = request.getParameterValues("src_item_group_id");
long itemCategoryId = JSPRequestValue.requestLong(request, "src_item_category_id");
long location_id = JSPRequestValue.requestLong(request, "JSP_LOCATION_ID");
int typeOpname = JSPRequestValue.requestInt(request, DbOpname.colNames[DbOpname.COL_TYPE_OPNAME]);
long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");

if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
	oidOpname = 0;
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;


//SessOpnameOrder prOrder = new SessOpnameOrder();

CmdOpname cmdOpname = new CmdOpname(request);
JSPLine ctrLine = new JSPLine();
iErrCode = cmdOpname.action(iJSPCommand , oidOpname);
JspOpname jspOpname = cmdOpname.getForm();
Opname opname = cmdOpname.getOpname();
if(opname.getOID()!=0){
    try{
        opname.setTypeOpname(typeOpname);
        DbOpname.updateExc(opname);
    }catch(Exception ex){
        
    }
}

msgString =  cmdOpname.getMessage();
        
if(oidOpname==0){
    oidOpname = opname.getOID();
    if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){
        opname.setStatus(I_Project.DOC_STATUS_DRAFT);
    }else{
        opname.setStatus(I_Project.DOC_STATUS_APPROVED);
    }
	
}





%>	
	
<%
long oidOpnameItem = JSPRequestValue.requestLong(request, "hidden_opname_item_id");

/*variable declaration*/
//int recordToGet = 10;
String msgString2 = "";
int iErrCode2 = JSPMessage.NONE;







//System.out.println("oidOpname : "+oidOpname);

Vector locations = DbLocation.list(0,0, "", "code");

if(location_id!=0){
    opname.setLocationId(location_id);
}
if(opname.getLocationId()==0 && locations!=null && locations.size()>0){
	Location lxx = (Location)locations.get(0);
	opname.setLocationId(lxx.getOID());
}

Vector resultVens = new Vector();
String itemGroupResult ="" ;

if(iJSPCommand == JSPCommand.SAVE){
    for(int i=0; i<itemGroupIds.length; i++){ 
			String oids = (String)itemGroupIds[i];
			
                        if(itemGroupResult.length()>1 && oids.length()> 0  ){
                            itemGroupResult = itemGroupResult + "," + (String)itemGroupIds[i];
                        }else{
                            itemGroupResult = (String)itemGroupIds[i] ;
                        }
                        
			
    }
}

if(iErrCode==0 && iErrCode2==0 && iJSPCommand==JSPCommand.SAVE && !itemGroupResult.equalsIgnoreCase("0") ){
    DbStock.doClosingOpname(location_id, itemGroupResult, itemCategoryId,srcVendorId, opname.getOID());
     
}else if(iErrCode==0 && iErrCode2==0 && iJSPCommand==JSPCommand.SAVE && itemGroupResult.equalsIgnoreCase("0") ){
    DbStock.doClosingOpname(location_id, itemGroupId, itemCategoryId,srcVendorId, opname.getOID());
}



//System.out.println("oidOpname2 : "+oidOpname);

if((iJSPCommand==JSPCommand.DELETE && iErrCode==0 && iErrCode2==0) || iJSPCommand==JSPCommand.LOAD){
//delete item, load opname
	try{
		opname = DbOpname.fetchExc(oidOpname);
	}
	catch(Exception e){
	}
}



//Vector itemStock = DbStock.getStock(fromLocationId);
//out.println("subTotal : "+subTotal);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        
<script language="JavaScript">
<!--


<%if(!posPReqPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

function cmdLocation(){
	<%if(true){//opname.getOID()!=0 && purchItems!=null && purchItems.size()>0){%>
		if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all opname item based on vendor item master. ')){
			document.frmopname.command.value="<%=JSPCommand.LOAD%>";
			document.frmopname.action="opnameitem.jsp";
			document.frmopname.submit();
		}
	<%}else{%>
			document.frmopname.command.value="<%=JSPCommand.LOAD%>";
			document.frmopname.action="opnameitem.jsp";
			document.frmopname.submit();
		//cmdVendorChange();
	<%}%>
}

function cmdTypeOpname(){
	document.frmopname.command.value="<%=JSPCommand.NONE%>";
	document.frmopname.action="addopname.jsp";
	document.frmopname.submit();
}
function cmdToRecord(){
	document.frmopname.command.value="<%=JSPCommand.NONE%>";
	document.frmopname.action="addopname.jsp";
	document.frmopname.submit();
}



function cmdSearch(){
	document.frmopname.command.value="<%=JSPCommand.SEARCH %>";
	document.frmopname.action="opnameitem.jsp?menu_idx=<%=menuIdx%>";
	document.frmopname.submit();
}
function cmdCloseDoc(){
	document.frmopname.action="<%=approot%>/home.jsp";
	document.frmopname.submit();
}

function cmdAskDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdDeleteDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.CONFIRM%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdCancelDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdSaveDoc(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="addopname.jsp";
	document.frmopname.submit();
        
        
}
function cmdSaveClose1(){
	
        
        self.close();  
}
function cmdAdd(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.ADD%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdAsk(oidOpnameItem){
	document.frmopname.hidden_opname_item_id.value=oidOpnameItem;
	document.frmopname.command.value="<%=JSPCommand.ASK%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdAskMain(oidOpname){
	document.frmopname.hidden_opname_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.ASK%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
}

function cmdConfirmDelete(oidOpnameItem){
	document.frmopname.hidden_opname_item_id.value=oidOpnameItem;
	document.frmopname.command.value="<%=JSPCommand.DELETE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}
function cmdSaveMain(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
	}

function cmdSave(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdEdit(oidOpname){
	document.frmopname.hidden_opname_item_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdCancel(oidOpname){
	document.frmopname.hidden_opname_item_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdBack(){
	document.frmopname.command.value="<%=JSPCommand.BACK%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdListFirst(){
	document.frmopname.command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdListPrev(){
	document.frmopname.command.value="<%=JSPCommand.PREV%>";
	document.frmopname.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdListNext(){
	document.frmopname.command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdListLast(){
	document.frmopname.command.value="<%=JSPCommand.LAST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
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

function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
//-->
</script>
               
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  
				  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmopname" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="0">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=JspOpname.colNames[JspOpname.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_opname_item_id" value="<%=oidOpnameItem%>">
                          <input type="hidden" name="hidden_opname_id" value="<%=oidOpname%>">
                          <input type="hidden" name="<%=JspOpnameItem.colNames[JspOpnameItem.JSP_OPNAME_ID]%>" value="<%=oidOpname%>">
                          <input type="hidden" name="<%=JspOpnameItem.colNames[JspOpnameItem.JSP_TYPE]%>" value="<%=DbOpnameItem.TYPE_NON_CONSIGMENT%>">
                          <input type="hidden" name="<%=JspOpname.colNames[JspOpnameItem.JSP_TYPE]%>" value="<%=DbOpname.TYPE_NON_CONSIGMENT%>">
                          <%if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){%>
                            <input type="hidden" name="<%=JspOpname.colNames[JspOpname.JSP_STATUS]%>" value="<%=I_Project.DOC_STATUS_APPROVED%>">
                          <%}%>
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            
                            <tr> 
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="5"></td>
                                  </tr>
                                  
                                  <tr> 
                                    <td class="page"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                              
                                              <tr align="left"> 
                                                <td height="26" width="12%" >&nbsp;&nbsp;Number</td>
                                                <td height="26" width="27%"> 
                                                  <%
												  String number = "";
												  if(opname.getOID()==0){
													  int ctr = DbOpname.getNextCounter();
													  number = DbOpname.getNextNumber(ctr);
													  
												  }
												  else{
													  number = ""+opname.getNumber();
													  
												  }
												  %>
                                                  <%=number%> </td>
                                                <td height="26" width="9%">&nbsp;</td>
                                                <td height="26" colspan="2" width="52%" class="comment">&nbsp;</td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                  Type </td>
                                                <td width="33%" height="14"> 
                                                    <select name="<%=DbOpname.colNames[DbOpname.COL_TYPE_OPNAME]%>" onChange="javascript:cmdTypeOpname()" >
                                                         <option value="0" <%if(typeOpname==0){%>selected<%}%>>Global </option>
                                                         <option value="1" <%if(typeOpname==1){%>selected<%}%>>Partial</option>
                                                    </select>
                                                </td>
                                                <td width="9%">&nbsp;</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                </td>
                                              </tr>
						  <%if(typeOpname==1){%>	
                                              <tr align="left"> 
                                                <td width="11%" height="22" valign="top">Group<br>
                                                                    <i><font size="1" color="#006600">press 
                                                                    CTRL button 
                                                                    to have multiples 
                                                                    selection</font></i> 
                                                                  </td>
                                                <td width="33%" height="14"> 
                                                                    <%
																	Vector vitemgroup= DbItemGroup.list(0,0, "", "name");
																	%>
                                                                    <select multiple name="src_item_group_id" width="500">
                                                                      <option value="0">ALL</option>
                                                                      <%if (vitemgroup != null && vitemgroup.size() > 0){
																																			for (int i = 0; i < vitemgroup.size(); i++) {
																																				ItemGroup ig= (ItemGroup) vitemgroup.get(i);
																																																						%>
                                                                      <option value="<%=ig.getOID()%>" <%if (ig.getOID()==itemGroupId) {%>selected<%}%>><%=ig.getName().toUpperCase()%></option>
                                                                      <%}
																																		}%>
                                                                    </select>
                                                                  </td>
                                                <td width="9%">&nbsp;</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                Category </td>
                                                <td width="33%" height="14"> 
                                                                    <%
																	Vector vItemCategory = DbItemCategory.list(0,0, "", "name");
																	%>
                                                                    <select name="src_item_category_id">
                                                                      <option value="0">-- 
                                                                      All --</option>
                                                                      <%if(vItemCategory!=null && vItemCategory.size()>0){
																	  for(int i=0; i<vItemCategory.size(); i++){
																	  	ItemCategory us = (ItemCategory)vItemCategory.get(i);
																	  %>
                                                                      <option value="<%=us.getOID()%>" <%if(us.getOID()==itemCategoryId){%>selected<%}%>><%=us.getName()%></option>
                                                                      <%}}%>
                                                                    </select>
                                                                  </td>
                                                <td width="9%">&nbsp;</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                  Supplier </td>
                                                <td width="11%">
                                                          <select name="src_vendor_id">
                                                            <option value="0" <%if(srcVendorId==0){%>selected<%}%>>- 
                                                            All -</option>
                                                            <%

                                                                                                              Vector  vendors = DbVendor.list(0,0, "", "name");

                                                                                                            if(vendors!=null && vendors.size()>0){
                                                                                                                         for(int i=0; i<vendors.size(); i++){
                                                                                                                                Vendor d = (Vendor)vendors.get(i);
                                                                                                                                
                                                                                                                %>
                                                            <option value="<%=d.getOID()%>" <%if(srcVendorId==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                                            <%}}%>
                                                          </select>
                                                          
                                                          
                                                          
                                                          
                                                </td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                </td>
                                              </tr>  
                                              <%}%>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                  Location </td>
                                                <td height="21" width="27%">
												<%if(((!opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){%>
												<span class="comment"> 
                                                  <select name="<%=JspOpname.colNames[JspOpname.JSP_LOCATION_ID]%>" >
                                                    <%                                          
													
													  if(locations!=null && locations.size()>0){
														for(int i=0; i<locations.size(); i++){
															Location d = (Location)locations.get(i);
															
												    %>
                                                    <option value="<%=d.getOID()%>" <%if(opname.getLocationId()==d.getOID()){%>selected<%}%>><%=d.getCode()+" - "+d.getName()%></option>
                                                    <%}}%> 
                                                  </select> 
                                                  </span> 
												 <%}else{
														try{
															Location l = DbLocation.fetchExc(opname.getLocationId());
															out.println(l.getCode()+" - "+l.getName());
															
														}
														catch(Exception e){
														}
												 }%> 
												  </td>
                                                <td width="9%">&nbsp;</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                <td height="21" width="27%"> 
                                                  <input name="<%=JspOpname.colNames[JspOpname.JSP_DATE]%>" value="<%=JSPFormater.formatDate((opname.getDate()==null) ? new Date() : opname.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmopname.<%=JspOpname.colNames[JspOpname.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <% 
												   //prOrder.setDate(opname.getPurchDate());
												   //rptKonstan.setTanggal(opname.getDate());
												  %> 
                                                </td>
                                                <td width="9%">Status</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                  <%
                                                  if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){
											if(opname.getStatus()==null){
												//out.println("status = null, set to draft");
												opname.setStatus(I_Project.DOC_STATUS_DRAFT);
											}
                                                   }else{
                                                        opname.setStatus(I_Project.DOC_STATUS_APPROVED);
                                                   }
											%>
                                                   <% if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){%>                                     
                                                        <input type="text" class="readOnly" name="stt" value="<%=(opname.getOID()==0) ? I_Project.DOC_STATUS_DRAFT : ((opname.getStatus()==null) ? I_Project.DOC_STATUS_DRAFT : opname.getStatus())%>" size="15" readOnly>
                                                  <%}else{%>
                                                        <input type="text" class="readOnly" name="stt" value="<%=I_Project.DOC_STATUS_APPROVED%>" size="15" readOnly>
                                                  <%}%>      
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Notes</td>
                                                <td height="21" colspan="4"> 
                                                  <textarea name="<%=JspOpname.colNames[JspOpname.JSP_NOTE]%>" cols="55" rows="2"><%=opname.getNote()%></textarea>
                                                </td>
                                                
                                              </tr>
                                              <tr>
                                                <td height="21" width="12%">&nbsp;&nbsp;</td>
                                                <%if(opname.getOID()==0){%>
                                                <td width="149"><div onclick="this.style.visibility='hidden'"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></div></td>
                                                <%}%>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                             
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
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
						</td></tr></table>
                      
						
                        <span class="level2"><br>
                        </span><!-- #EndEditable -->
                      </td>
                    </tr>
                    <%if(iJSPCommand==JSPCommand.SAVE){%>
                    <script language="JavaScript">
                                                                cmdSaveClose1();
                    </script>
                    <%}%>   
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
   

</body>
<!-- #EndTemplate --></html>
