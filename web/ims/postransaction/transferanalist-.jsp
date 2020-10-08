<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.request.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.report.*" %>
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
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("No","5%");
                cmdist.addHeader("Location","10%");
		cmdist.addHeader("Number","10%");
		cmdist.addHeader("Date","10%");
                cmdist.addHeader("Item Name","10%");
               // cmdist.addHeader("Qty","10%");
                
		cmdist.setLinkRow(1);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Transfer transfer = (Transfer)objectClass.get(i);
			 Vector rowx = new Vector();

                        rowx.add("<div align=\"center\">"+(start+i+1)+"</div>");         
                        Location location = new Location();        
                	try{
        			location = DbLocation.fetchExc(transfer.getToLocationId());
					}catch(Exception e){}
			rowx.add(""+location.getName());
                        rowx.add("" +transfer.getNumber());
                        if(transfer.getDate()==null){
                            rowx.add("");
                        }else	{
                            rowx.add("<div align=\"center\">"+JSPFormater.formatDate(transfer.getDate(),"dd-MMM-yyyy")+"</div>");
                        }        
				
				//Location location2 = new Location();        
				//try{
					//location2 = DbLocation.fetchExc(transfer.getToLocationId());
					//}catch(Exception e){}
				//rowx.add(""+location2.getName());
                        

			//rowx.add("<div align=\"center\">"+transfer.getStatus()+"</div>");
			
			//rowx.add(transfer.getNote());

                        lstData.add(rowx);
			lstLinkData.add(String.valueOf(transfer.getOID()));
		}

		return cmdist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidTransfer = JSPRequestValue.requestLong(request, "hidden_transfer_id");

long srclocFromId = JSPRequestValue.requestLong(request, "src_loc_from_id");
long srclocToId = JSPRequestValue.requestLong(request, "src_loc_to_id");

String srcStatus = JSPRequestValue.requestString(request, "src_status");
String srcTransferNumber = JSPRequestValue.requestString(request, "src_transferNumber");
String srcStart = JSPRequestValue.requestString(request, "src_start_date");
String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
Date srcStartDate = new Date();
Date srcEndDate = new Date();
Vector vListItem = new Vector();
if(iJSPCommand==JSPCommand.NONE){
	srcIgnore = 1;
}
if(srcIgnore==0){
	srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
	srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
}

/*variable declaration*/
int recordToGet = 15;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

if(srclocFromId!=0){
	whereClause = DbTransfer.colNames[DbTransfer.COL_FROM_LOCATION_ID]+"="+srclocFromId;	
}

if(srclocToId!=0){
    if(whereClause.length()>0){
        whereClause = whereClause + " and " + DbTransfer.colNames[DbTransfer.COL_TO_LOCATION_ID]+"="+srclocToId;	
    }else{
        whereClause = DbTransfer.colNames[DbTransfer.COL_TO_LOCATION_ID]+"="+srclocToId;
    }
	
}
if(srcStatus!=null && srcStatus.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause + " and "+DbTransfer.colNames[DbTransfer.COL_STATUS]+"='"+srcStatus+"'";	
	}
	else{
		whereClause = DbTransfer.colNames[DbTransfer.COL_STATUS]+"='"+srcStatus+"'";	
	}
}
if(srcTransferNumber!=null && srcTransferNumber.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause + " and "+DbTransfer.colNames[DbTransfer.COL_NUMBER]+" like '%"+srcTransferNumber+"%'";	
	}
	else{
		whereClause = DbTransfer.colNames[DbTransfer.COL_NUMBER]+" like '%"+srcTransferNumber+"%'";	
	}
}
if(srcIgnore==0 && iJSPCommand!=JSPCommand.NONE){
	if(whereClause.length()>0){
		whereClause = whereClause + " and (to_days("+DbTransfer.colNames[DbTransfer.COL_DATE]+")>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
				" and to_days("+DbTransfer.colNames[DbTransfer.COL_DATE]+")<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"'))";	
	}
	else{
		whereClause = "(to_days("+DbTransfer.colNames[DbTransfer.COL_DATE]+")>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
				" and to_days("+DbTransfer.colNames[DbTransfer.COL_DATE]+")<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"'))";	
	}
}

if(whereClause.length()>0){
    whereClause = whereClause + " and " + DbTransfer.colNames[DbTransfer.COL_TYPE] + " = " + DbTransfer.TYPE_NON_CONSIGMENT;
}else{
    whereClause = DbTransfer.colNames[DbTransfer.COL_TYPE] + " = " + DbTransfer.TYPE_NON_CONSIGMENT;    
}


CmdTransfer cmdTransfer = new CmdTransfer(request);
JSPLine ctrLine = new JSPLine();
Vector listTransfer = new Vector(1,1);

/*switch statement */
iErrCode = cmdTransfer.action(iJSPCommand , oidTransfer);
/* end switch*/
JspTransfer jspTransfer = cmdTransfer.getForm();

/*count list All Transfer*/
int vectSize = DbTransfer.getCount(whereClause);

Transfer vendor = cmdTransfer.getTransfer();
msgString =  cmdTransfer.getMessage();



if(iJSPCommand== JSPCommand.SAVE){
    //pembuatan PR
    Vector vloc = new Vector();
    vloc= DbTransfer.list(0, 0, " status='REQUEST' group by to_location_id", "");
    for(int i=0;i<vloc.size();i++){
        Transfer t = (Transfer) vloc.get(i);
        Vector vItem = new Vector();
        vItem= DbTransferItem.listRequestByLocation(t.getToLocationId());
        
        //buat main dari PR
            long oidPr = 0;
            PurchaseRequest pr = new PurchaseRequest();
            pr.setCounter(DbPurchaseRequest.getNextCounter());
            pr.setDate(new java.util.Date());
            pr.setDepartmentId(t.getToLocationId());
            pr.setNumber(DbPurchaseRequest.getNextNumber(DbPurchaseRequest.getNextCounter()));
            pr.setPrefixNumber(DbPurchaseRequest.getNumberPrefix());
            pr.setStatus("DRAFT");
            pr.setUserId(user.getOID());
            try{
                oidPr=DbPurchaseRequest.insertExc(pr);
            }catch(Exception ex){
                
            }
            boolean insertPR =false ;
        for(int a=0;a<vItem.size();a++){
            SessTransferAnalist sta = (SessTransferAnalist) vItem.get(a);
            double qtyPr = JSPRequestValue.requestDouble(request, "pr_"+sta.getTransferId());
            double qtyTransfer =JSPRequestValue.requestDouble(request, "transfer_"+sta.getTransferId());
            if(qtyPr>0){
                ItemMaster im = new ItemMaster();
                try{
                    im = DbItemMaster.fetchExc(sta.getItemMasterId());
                            
                }catch(Exception e){
                    
                }
                PurchaseRequestItem pri = new PurchaseRequestItem();
                pri.setItemMasterId(sta.getItemMasterId());
                pri.setPurchaseRequestId(oidPr);
                pri.setQty(qtyPr);
                pri.setUomId(im.getUomPurchaseId());
                
                
                try{
                    DbPurchaseRequestItem.insertExc(pri);
                    insertPR=true;
                }catch(Exception ex){
                    
                }
                
            }
            if(qtyTransfer>0){
                Transfer tt = new Transfer();
                TransferItem ti = new TransferItem();
                try{
                    tt = DbTransfer.fetchExc(sta.getTransferId());
                    tt.setUserId(user.getOID());
                    tt.setStatus("DRAFT");
                    DbTransfer.updateExc(tt);
                    
                    Vector vti = new  Vector();
                    vti= DbTransferItem.list(0, 0, "transfer_id="+ tt.getOID(), "");
                    ti=(TransferItem) vti.get(0);
                    ti.setQtyRequest(ti.getQty());
                    ti.setQty(qtyTransfer);
                    DbTransferItem.updateExc(ti);
                            
                    
                }catch(Exception e){
                    
                }
               
            }
            
        }
            if(insertPR==false){
                //delete pr karena tidak ada item detailnya
                DbPurchaseRequest.deleteExc(oidPr);
            }
        
    }
   // iJSPCommand=JSPCommand.NONE;
}
vListItem=DbTransferItem.listRequest(0);



if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
	start = cmdTransfer.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
orderClause = DbTransfer.colNames[DbTransfer.COL_DATE];
listTransfer = DbTransfer.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listTransfer.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listTransfer = DbTransfer.list(start,recordToGet, whereClause , orderClause);
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
	document.frmtransfer.command.value="<%=JSPCommand.LIST%>";
	document.frmtransfer.action="transferanalist.jsp";
	document.frmtransfer.submit();
}


function cmdEdit(oid){
	document.frmtransfer.hidden_transfer_id.value=oid;
	document.frmtransfer.command.value="<%=JSPCommand.EDIT%>";
	document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
	document.frmtransfer.action="transferitem.jsp";
	document.frmtransfer.submit();
}

function cmdProcess(){
	document.frmtransfer.hidden_transfer_id.value="0";
	document.frmtransfer.command.value="<%=JSPCommand.SAVE%>";
	document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
	document.frmtransfer.action="transferanalist.jsp";
	document.frmtransfer.submit();
}

function cmdListFirst(){
	document.frmtransfer.command.value="<%=JSPCommand.FIRST%>";
	document.frmtransfer.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmtransfer.action="transferanalist";
	document.frmtransfer.submit();
}

function cmdListPrev(){
	document.frmtransfer.command.value="<%=JSPCommand.PREV%>";
	document.frmtransfer.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmtransfer.action="transferanalist";
	document.frmtransfer.submit();
	}

function cmdListNext(){
	document.frmtransfer.command.value="<%=JSPCommand.NEXT%>";
	document.frmtransfer.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmtransfer.action="transferanalist";
	document.frmtransfer.submit();
}

function cmdListLast(){
	document.frmtransfer.command.value="<%=JSPCommand.LAST%>";
	document.frmtransfer.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmtransfer.action="transferanalist";
	document.frmtransfer.submit();
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
                        <form name="frmtransfer" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_transfer_id" value="<%=oidTransfer%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Transfer Analist </span></font></b></td>
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
                                    <td height="5"  colspan="3"></td>
                                  </tr>
                                  
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3" class="page"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"></td>
                                        </tr>
                                        
                                        <%
							try{
								if (vListItem.size()>0){
							%>
                                        <tr>
                                            <td colspan="2">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                    <tr>
                                                        <td width="5%" class="tablehdr">No</td>
                                                        <td width="10%" class="tablehdr">Location</td>
                                                        <td width="15%" class="tablehdr">Number</td>
                                                        <td width="45%" class="tablehdr">Item Name</td>
                                                        <td width="10%" class="tablehdr">Qty Request</td>
                                                        <td width="10%" class="tablehdr">Qty PR</td>
                                                        <td width="10%" class="tablehdr">Qty Transfer</td>
                                                  
                                                    </tr> 
                                                    
                                                    
                                                    <% if(vListItem.size()>0){
                                                        long item= 0;
                                                        double qty=0;
                                                        SessTransferAnalist staOld = new SessTransferAnalist();
                                                         
                                                         
                                                         
                                                            for(int i=0;i<vListItem.size();i++){
                                                        SessTransferAnalist sta = (SessTransferAnalist) vListItem.get(i);
                                                        Location loc = new Location();
                                                        
                                                        
                                                    %>
                                                        <%
                                                             if((item!=sta.getItemMasterId() && item!=0)){
                                                                 try{
                                                                    loc = DbLocation.fetchExc(staOld.getToLocationId());
                                                                 }catch(Exception ex){
                                                                 }
                                                                 double stockLocRequest = DbStock.getItemTotalStock(loc.getLocationIdRequest(), staOld.getItemMasterId());    
                                                        %>
                                                             <tr>
                                                                <td width="5%" class= "tablecell1" colspan="4" ></td>
                                                                <td width="10%" class= "tablecell1"><b><%=qty%></b></td>
                                                                <td width="10%" class= "tablecell1" colspan="=2"><b><%=stockLocRequest%></b></td>
                                                                    
                                                             </tr>
                                                                <%qty=0;%>
                                                        <%}%>
                                                    <tr>
                                                        <td width="5%" class= "tablecell1" ><%= i+1  %></td>
                                                        <td width="15%" class= "tablecell1"><%= sta.getLocationName() %></td>
                                                        <td width="10%" class= "tablecell1"><%= sta.getTransferNumber() %></td>
                                                        <td width="40%" class= "tablecell1"><%= sta.getItemName()%></td>
                                                        <td width="10%" class= "tablecell1"><%=sta.getQty()%></td>
                                                        <td width="10%" class= "tablecell1"><input type="text" name="pr_<%=sta.getTransferId()%>" value="" size="7"></td>
                                                        <td width="10%" class= "tablecell1"><input type="text" name="transfer_<%=sta.getTransferId()%>" value="" size="7"></td>
                                                    </tr>
                                                    <%
                                                    item=sta.getItemMasterId();
                                                    staOld=sta;
                                                    qty=qty+sta.getQty();
                                                    double stockFrom2 = DbStock.getItemTotalStock(srclocFromId, item);
                                                    if(i==vListItem.size()-1){
                                                                 try{
                                                                    loc = DbLocation.fetchExc(sta.getToLocationId());
                                                                 }catch(Exception ex){
                                                                 }
                                                                 double stockLocRequest = DbStock.getItemTotalStock(loc.getLocationIdRequest(), sta.getItemMasterId());    
                                                        
                                                        
                                                   %> 
                                                         <tr>
                                                                    <td width="5%" class= "tablecell1" colspan="4" ></td>
                                                                    <td width="10%" class= "tablecell1"><b><%=qty%><b></td>
                                                                    <td width="10%" class= "tablecell1" colspan="2"><b><%=stockLocRequest%></b></td>
                                                                    
                                                         </tr>
                                                    <%}%>      
                                                    <% 
                                                    
                                                            }}%>
                                                </table>
                                            </td>
                                        </tr>
                                        

                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <%  } 
						  }catch(Exception exc){ 
						  	System.out.println("sdsdf : "+exc.toString());
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
                                            <%//=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <%if(iJSPCommand==JSPCommand.SAVE){%>
                                        <tr>
                                            <td>
                                                <b>Data is Processed</b>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if(vListItem.size()>0 ){%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdProcess()">Process</a></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <%}else if(iJSPCommand!=JSPCommand.SAVE) {%>
                                        <tr>
                                            <td>
                                                <u><i>no data transfer request</i></u>
                                            </td>
                                        </tr>
                                        <%}%>
                                        
                                      </table>
                                    </td>
                                  </tr>
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
