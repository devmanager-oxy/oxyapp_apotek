<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %> 
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
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

	public String drawList(Vector objectClass, int start)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("65%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("No","5%");
                cmdist.addHeader("Date","10%");
		cmdist.addHeader("Sub Location","20%");
		cmdist.addHeader("Form Number","25%");
		cmdist.addHeader("Status","10%");
		

		cmdist.setLinkRow(1);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;
                SubLocation subloc = new SubLocation();
		for (int i = 0; i < objectClass.size(); i++) {
			OpnameSubLocation opnamesub = (OpnameSubLocation)objectClass.get(i);
			Vector rowx = new Vector();

                        rowx.add("<div align=\"center\">"+(start+i+1)+"</div>");   
                        try{
                            subloc= DbSubLocation.fetchExc(opnamesub.getSubLocationId());
                        }catch(Exception ex){
                            
                        }
                        rowx.add(JSPFormater.formatDate( opnamesub.getDate(),"dd-MM-yyyy"));
                        rowx.add(subloc.getName());
                        rowx.add(opnamesub.getFormNumber());
			rowx.add(opnamesub.getStatus());

                lstData.add(rowx);
		lstLinkData.add(String.valueOf(opnamesub.getOID()));
		}

		return cmdist.draw(index);
	}

%>
<%

if(session.getValue("DETAIL")!=null){
		session.removeValue("DETAIL");
}

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidOpname = JSPRequestValue.requestLong(request, "hidden_opname_id");
long oidOpnameSub = JSPRequestValue.requestLong(request, "hidden_opname_sub_id");


String srcStatus = JSPRequestValue.requestString(request, "src_status");
String srcStart = JSPRequestValue.requestString(request, "src_start_date");
String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
String srcformnumber = JSPRequestValue.requestString(request, "src_form_number");
String status = JSPRequestValue.requestString(request, JspOpname.colNames[JspOpname.JSP_STATUS]);


/*if(iJSPCommand==JSPCommand.LIST){
    Vector vopname = new Vector();
    vopname = DbOpname.list(0, 0, "to_days(date) > to_days('2013-01-01')", "opname_id");
    for(int i=0;i<vopname.size();i++){
        Opname op = (Opname) vopname.get(i);
        Vector vopnameitem = DbOpnameItem.list(0, 0, "opname_id="+ op.getOID(), "");
        for(int c=0;c<vopnameitem.size();c++){
            OpnameItem opi =(OpnameItem) vopnameitem.get(c);
            ClosingOpname co = new ClosingOpname();
            co.setDate(op.getDate());
            co.setItemMasterId(opi.getItemMasterId());
            co.setLocationId(op.getLocationId());
            co.setQty(opi.getQtySystem());
            co.setOpnameId(op.getOID());
            try{
                DbClosingOpname.insertExc(co);
            }catch(Exception ex){

            }
        }
        
        
    }
   // Vector vopname = new Vector();
   // vopname = DbOpname.list(0, 0, "", "location_id");
   // Vector vsub = new Vector();
   
  //  for(int i=0;i<vopname.size();i++){
   //    Opname sto = (Opname) vopname.get(i);
   //     vsub = DbOpnameSubLocation.list(0, 0, "opname_id="+sto.getOID(), "");
   //     OpnameSubLocation subop = (OpnameSubLocation)vsub.get(0);
   //     DbClosingOpname.updateOpnameItem(sto.getOID(), subop.getOID());
        
   // }
    
    
    
   
}*/

session.putValue("DETAIL", oidOpname);
Opname opname = new Opname();


try{
    opname = DbOpname.fetchExc(oidOpname);
}catch(Exception ex){
    
}
Location locOp = new Location();
try{
    locOp = DbLocation.fetchExc(opname.getLocationId());
}catch(Exception ex){
    
}


Date srcStartDate = new Date();
Date srcEndDate = new Date();
if(iJSPCommand==JSPCommand.NONE){
	srcIgnore = 1;
}
if(srcIgnore==0){
	srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
	srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
}

/*variable declaration*/
int recordToGet = 5;
String msgString = "";
//int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";


if(srcStatus!=null && srcStatus.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause + " and "+DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_STATUS]+"='"+srcStatus+"'";	
	}else{
		whereClause = DbOpname.colNames[DbOpname.COL_STATUS]+"='"+srcStatus+"'";	
	}
}
if(srcformnumber!=null && srcformnumber.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause + " and "+DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_FORM_NUMBER]+" like '%"+srcformnumber+"%'";	
	}else{
		whereClause = DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_FORM_NUMBER]+" like '%"+srcformnumber+"%'";	
	}
}

if(oidOpname!=0){
	if(whereClause.length()>0){
		whereClause = whereClause + " and "+DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_OPNAME_ID]+"="+oidOpname;	
	}else{
		whereClause = DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_OPNAME_ID]+"="+oidOpname;	
	}
}
if(oidOpnameSub!=0){
	if(whereClause.length()>0){
		whereClause = whereClause + " and "+DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_OPNAME_SUB_LOCATION_ID]+"="+oidOpnameSub;	
	}else{
		whereClause = DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_OPNAME_SUB_LOCATION_ID]+"="+oidOpnameSub;	
	}
}

if(srcIgnore==0 && iJSPCommand!=JSPCommand.NONE){
	if(whereClause.length()>0){
		whereClause = whereClause + " and (to_days("+DbOpname.colNames[DbOpname.COL_DATE]+")>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
				" and to_days("+DbOpname.colNames[DbOpname.COL_DATE]+")<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"'))";	
	}
	else{
		whereClause = "(to_days("+DbOpname.colNames[DbOpname.COL_DATE]+")>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
				" and to_days("+DbOpname.colNames[DbOpname.COL_DATE]+")<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"'))";	
	}
}

CmdOpname cmdOpname = new CmdOpname(request);
JSPLine ctrLine = new JSPLine();
 Vector listOpnamesub = new Vector(1,1);



/*count list All Opname*/
int vectSize = DbOpnameSubLocation.getCount(whereClause);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
	start = cmdOpname.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
orderClause = DbOpname.colNames[DbOpname.COL_DATE];

listOpnamesub = DbOpnameSubLocation.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listOpnamesub.size() < 1 && start > 0){
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listOpnamesub = DbOpnameSubLocation.list(start,recordToGet, whereClause , orderClause);
}

//if(iJSPCommand==JSPCommand.CONFIRM){
 //   if(oidOpname!=0){
        //DbOpnameItem.deleteAllItem(oidOpname);
        //DbOpnameSubLocation.deleteAllItem(oidOpname);
       // DbClosingOpname.deleteAllItem(oidOpname);
        //DbOpname.deleteExc(oidOpname);
     //   oidOpname=0;
      //  listOpnamesub = new Vector();
       // opname = new Opname();
   // }
    
//}

if(iJSPCommand==JSPCommand.POST){
    if(oidOpname!=0){
        DbOpnameSubLocation.updateStatusAll(oidOpname, status);
        opname.setStatus(status);
        if(status.equalsIgnoreCase("APPROVED")){
            opname.setApproval1(user.getOID());
            opname.setApproval1_date(new Date());
        }
        try{
            DbOpname.updateExc(opname);
        }catch(Exception ex){
            
        }
        listOpnamesub = DbOpnameSubLocation.list(start,recordToGet, whereClause , orderClause);
        
    }
    
}


%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=titleIS%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--
function cmdSearch(){
	document.frmopname.command.value="<%=JSPCommand.LIST%>";
	document.frmopname.action="opnamesublist.jsp";
	document.frmopname.submit();
}
function cmdPrintXLS(){	 
        
            window.open("<%=printroot%>.report.RptOpnameXLS?idx=<%=System.currentTimeMillis()%>");
        }
function cmdSaveDoc(){
             document.frmopname.command.value="<%=JSPCommand.POST%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnamesublist.jsp";
             document.frmopname.submit();
         }
 function cmdDeleteDoc(){
             
             document.frmopname.command.value="<%=JSPCommand.CONFIRM%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnamesublist.jsp";
             document.frmopname.submit();
 }
  function cmdCancelDoc(){
             
             document.frmopname.command.value="<%=JSPCommand.EDIT%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnamesublist.jsp";
             document.frmopname.submit();
         }
 
 function cmdAskDoc(){
             
             document.frmopname.command.value="<%=JSPCommand.SUBMIT%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnamesublist.jsp";
             document.frmopname.submit();
         }
function cmdEdit(oid){
	document.frmopname.hidden_opname_sub_id.value=oid;
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

 

function cmdAdd(){
     
        var oidLoc = document.frmopname.hidden_location_id.value;
        var oidOpname =document.frmopname.hidden_opname_id.value;
        
	window.open("<%=approot%>/postransaction/addopnamesub.jsp?location_id=" + oidLoc + "&opname_id=" + oidOpname , null, "height=300,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
}

function cmdListFirst(){
	document.frmopname.command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.action="opnamesublist.jsp";
	document.frmopname.submit();
}

function cmdListPrev(){
	document.frmopname.command.value="<%=JSPCommand.PREV%>";
	document.frmopname.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmopname.action="opnamesublist.jsp";
	document.frmopname.submit();
	}

function cmdListNext(){
	document.frmopname.command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.action="opnamesublist.jsp";
	document.frmopname.submit();
}

function cmdListLast(){
	document.frmopname.command.value="<%=JSPCommand.LAST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmopname.action="opnamesublist.jsp";
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
                        <form name="frmopname" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_opname_id" value="<%=oidOpname%>">
                          <input type="hidden" name="hidden_opname_sub_id" value="<%=oidOpnameSub%>">
                          <input type="hidden" name="hidden_location_id" value="<%=opname.getLocationId()%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Opname Sub Location </span></font></b></td>
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
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  
                                  
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3" class="page"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                              
                                              <tr> 
                                                <td width="12%">Number</td>
                                                <td width="12%"> 
                                                    
                                                  <input size="15" class="readOnly" type="text" readonly value="<%=opname.getNumber()%>" > 
                                                  
                                                </td>
                                                <td width="13%">Location</td>
                                                <td width="57%"> 
                                                  
                                                  <input size="40" class="readOnly" type="text" readonly value="<%=locOp.getName()%>" > 
                                                  
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="12%">Doc Status</td>
                                                <td width="12%"> 
                                                  
                                                  <input size="15" class="readOnly" type="text" readonly value="<%=opname.getStatus()%>" > 
                                                  
                                                </td>
                                                <td width="13%">Opname Type</td>
                                                <td width="57%"> 
                                                
                                                  <%if(opname.getTypeOpname()==0){%>
                                                  <input size="15" class="readOnly" type="text" readonly value="Global"> 
                                                  <%}else{%>
                                                  <input size="15" class="readOnly" type="text" readonly value="Partial"> 
                                                  <%}%>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="12%">Date</td>
                                                <td width="12%"> 
                                                <%if(opname.getOID()!=0){%>
                                                  <input size="15" class="readOnly" type="text" readonly value="<%=JSPFormater.formatDate(opname.getDate(),"dd-MM-yyyy")%>"> 
                                                 <%}%> 
                                                </td>
                                                <td width="13%"></td>
                                                <td width="57%"> 
                                                  
                                                </td>
                                              </tr>
                                               <tr > 
                                                <td colspan="5" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                              </tr>
                                              <tr> 
                                                <td width="12%">Opname Between</td>
                                                <td colspan="3"> 
                                                  <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate==null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmopname.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                  <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate==null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmopname.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <input type="checkbox" name="src_ignore" value="1" <%if(srcIgnore==1){%>checked<%}%>>
                                                  Ignored</td>
                                              </tr>
                                             
                                             <tr> 
                                                <td width="12%">Form Number</td>
                                                <td width="12%"> 
                                                  <input type="text" name="src_form_number" value="<%=srcformnumber%>">
                                                </td>
                                                <td width="13%"></td>
                                                <td width="57%"> 
                                                  
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" height="5"></td>
                                              </tr>
                                              <%if(oidOpname!=0){%>
                                              <tr> 
                                                <td width="18%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                <td colspan="3">&nbsp;</td>
                                              </tr>
                                              <%}%>
                                              <tr> 
                                                <td width="18%">&nbsp;</td>
                                                <td colspan="3">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
							try{
								if (listOpnamesub.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listOpnamesub,start)%> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <%  } 
						  }catch(Exception exc){ 
						  	System.out.println("sdsdf : "+exc.toString());
						  }%>
                                         <%if(opname.getOID()!=0)          {%>
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
                                        <%}%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <%if(opname.getStatus().equalsIgnoreCase("DRAFT")){%>
                                            <tr align="left" valign="top"> 
                                              <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a></td>
                                            </tr>
                                        <%}%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        
                                      </table>
                                    </td>
                                  </tr>
                                  
                                  <%if(opname.getStatus().equalsIgnoreCase("DRAFT") && listOpnamesub.size()>0){%>
                                                                                                                            <tr> 
                                                                                                                                <td width="12%"><b>Set Status to</b></td>
                                                                                                                                <td width="14%"> 
                                                                                                                                    <select name="<%=JspOpname.colNames[JspOpname.JSP_STATUS]%>">
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (opname.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                                        
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                                <td width="74%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="3">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                  
                                  
                                  <tr> 
                                                                                                                    <td colspan="4"> 
                                                                                                                                         
                                                                                                                            
                                                                                                                            
                                                                                                                            <%if(iJSPCommand==JSPCommand.SUBMIT){%>
                                                                                                                                <tr> 
                                                                                                                                    <td colspan="3">Are you sure to delete Opname <%=opname.getNumber()%> ? </td>
                                                                                                                                    <td width="862">&nbsp;</td>
                                                                                                                                </tr>
                                                                                                                                <tr> 
                                                                                                                                    <td width="149"><a href="javascript:cmdDeleteDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('yes21111','','../images/yes2.gif',1)"><img src="../images/yes.gif" name="yes21111" height="21" border="0"></a></td>
                                                                                                                                    <td width="102"><a href="javascript:cmdCancelDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel211111','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel211111" height="22" border="0"></a></td>
                                                                                                                                    <td width="97">&nbsp;</td>
                                                                                                                                    <td width="862">&nbsp;</td>
                                                                                                                                </tr>
                                                                                                                            <%}else{%>
                                                                                                                            <tr> 
                                                                                                                                
                                                                                                                               <%if(listOpnamesub.size()>0 && opname.getStatus().equalsIgnoreCase("DRAFT")){//jika sudah ada item dan masih draft baru bisa mengubah status%>
                                                                                                                                <td width="149"><div onclick="this.style.visibility='hidden'"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></div></td>
                                                                                                                                <%}%>
                                                                                                                                <%if(opname.getStatus().equalsIgnoreCase("DRAFT") && oidOpname !=0){%>
                                                                                                                                
                                                                                                                                <%}%>
                                                                                                                                                                                         
                                                                                                                               <%if(listOpnamesub.size()>0){%>
                                                                                                                                <td width="97"> 
                                                                                                                                    <div align="left"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="close211111" border="0"></a></div>
                                                                                                                                </td>
                                                                                                                               <%}%>
                                                                                                                                
   
                                                                                                                               
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="3">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                           
                                                                                                                       
                                                                                                                        
                                                                                                                        
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%if (opname.getOID() != 0) {%>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="32%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><b><u>Document 
                                                                                                                    History</u></b></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"><b><u>User</u></b></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><b><u>Date</u></b></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Prepared 
                                                                                                                    By</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
    User u = new User();
    try {
        u = DbUser.fetch(opname.getUserId());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i><%=JSPFormater.formatDate(opname.getDate(), "dd MMMM yy")%></i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Approved 
                                                                                                                    by</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
    u = new User();
    try {
        u = DbUser.fetch(opname.getApproval1());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%if (opname.getApproval1() != 0) {%>
                                                                                                                                <%=JSPFormater.formatDate(opname.getApproval1_date(), "dd MMMM yy")%> 
                                                                                                                                <%}%>
                                                                                                                        </i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3">&nbsp; </td>
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
