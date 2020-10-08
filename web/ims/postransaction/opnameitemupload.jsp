
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>  
<%@ page import = "com.project.*" %> 
<%@ page import = "com.project.util.*" %> 
<%@ page import = "com.project.util.jsp.*" %>  
<%@ page import = "com.project.payroll.*" %> 
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %>
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
<%!

	public String drawList(Vector objectClass, int start, OpnameSubLocation opnameSub)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("75%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("No","5%");
		cmdist.addHeader("SKU","10%");
		cmdist.addHeader("Barcode","10%");
		cmdist.addHeader("Name","40%");
                cmdist.addHeader("qty","10%");
                if(opnameSub.getStatus().equalsIgnoreCase("DRAFT")){
                    cmdist.setLinkRow(1);
                }
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;
                ItemMaster im = new ItemMaster();
		for (int i = 0; i < objectClass.size(); i++) {
			OpnameItem opnameItem = (OpnameItem)objectClass.get(i);
			Vector rowx = new Vector();
                        try{
                            im = DbItemMaster.fetchExc(opnameItem.getItemMasterId());
                        }catch(Exception ex){
                            
                        }
                        rowx.add("<div align=\"center\">"+(start+i+1)+"</div>");         
			rowx.add(im.getCode());
			rowx.add(im.getBarcode());
                        rowx.add(im.getName());
			rowx.add("<div align=\"right\">"+opnameItem.getQtyReal()+"</div>");
                        lstData.add(rowx);
                        if(opnameSub.getStatus().equalsIgnoreCase("DRAFT")){
                            lstLinkData.add(String.valueOf(opnameItem.getOID()));
                        }
			
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
    long oidOpnameItem = JSPRequestValue.requestLong(request, "hidden_opname_item_id");
    long oidOpnameSub = JSPRequestValue.requestLong(request, "hidden_opname_sub_id");
    long oidOpnameSub1 = JSPRequestValue.requestLong(request, "hidden_opname_sub_id1");
    String status = JSPRequestValue.requestString(request, JspOpnameSubLocation.colNames[JspOpnameSubLocation.JSP_STATUS]);


if(oidOpnameSub==0){
    oidOpnameSub=oidOpnameSub1;

}
session.putValue("DETAIL", oidOpnameSub);


int iErrCode = JSPMessage.NONE;
int recordToGet = 25;
String msgString = "";
String whereClause = "";
String orderClause = "";

Opname op = new Opname();
try{
    op= DbOpname.fetchExc(oidOpname);
}catch(Exception ex){
    
}

OpnameSubLocation opnameSub = new OpnameSubLocation();
try{
    opnameSub = DbOpnameSubLocation.fetchExc(oidOpnameSub);
}catch(Exception ex){
    
}

Location loc = new Location();
try{
    loc= DbLocation.fetchExc(op.getLocationId());
}catch(Exception ex){
    
}

SubLocation subloc = new SubLocation();
try{
    subloc= DbSubLocation.fetchExc(opnameSub.getSubLocationId());
}catch(Exception ex){
    
}

Hashtable tempOids = new Hashtable();
tempOids.put("opname", ""+oidOpname);
tempOids.put("opnamesubloc", ""+oidOpnameSub);
tempOids.put("subloc", ""+opnameSub.getSubLocationId());

session.putValue("UPLOAD_PARAM", tempOids);


CmdOpname cmdOpname = new CmdOpname(request);
JSPLine ctrLine = new JSPLine();
Vector listOpnameItem = new Vector(1,1);

/*switch statement */
//iErrCode = cmdOpname.action(iJSPCommand , oidOpname);
/* end switch*/
//JspOpname jspOpname = cmdOpname.getForm();

/*count list All Opname*/
whereClause= DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_OPNAME_SUB_LOCATION_ID]+ "=" + oidOpnameSub ;
int vectSize = DbOpnameItem.getCount(whereClause);



if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
	start = cmdOpname.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
orderClause = DbOpnameItem.colNames[DbOpname.COL_DATE];
listOpnameItem = DbOpnameItem.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listOpnameItem.size() < 1 && start > 0){
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listOpnameItem = DbOpnameItem.list(start,recordToGet, whereClause , orderClause);
         
}


if(iJSPCommand==JSPCommand.CONFIRM){
    if(oidOpnameSub!=0){
        try{
            DbOpnameSubLocation.deleteExc(oidOpnameSub);
           // DbOpnameItem.deleteItem(oidOpnameSub);
           // iJSPCommand=JSPCommand.NONE;
           // oidOpnameSub=0;
           // listOpnameItem = new Vector();
            
        }catch(Exception ex){
            
        }
        
    }
    
}

if(iJSPCommand==JSPCommand.POST){
    try{
        opnameSub.setStatus(status);
        DbOpnameSubLocation.updateExc(opnameSub);
    }catch(Exception ex){
        
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
function cmdPrintXLS(){	 
        
            window.open("<%=printroot%>.report.RptSubOpnameXLS?idx=<%=System.currentTimeMillis()%>");
        }    

function cmdSearch(){
	document.frmopname.command.value="<%=JSPCommand.LIST%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}
function cmdOpnameSub(oid){
	document.frmopname.hidden_opname_id.value="<%=oidOpname%>";
        
        document.frmopname.src_ignore.value="1"; 
        document.frmopname.command.value="<%=JSPCommand.SEARCH%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnamesublist.jsp";
	document.frmopname.submit();
}

 function cmdAskDoc(){
             
             document.frmopname.command.value="<%=JSPCommand.SUBMIT%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnameitem.jsp";
             document.frmopname.submit();
         }
         
function cmdDeleteDoc(){
             document.frmopname.command.value="<%=JSPCommand.CONFIRM%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnameitem.jsp";
             document.frmopname.submit();
}
         
function cmdCancelDoc(){
          document.frmopname.command.value="<%=JSPCommand.EDIT%>";
         document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnameitem.jsp";
             document.frmopname.submit();
 }
function cmdSaveDoc(){
             document.frmopname.command.value="<%=JSPCommand.POST%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnameitem.jsp";
             document.frmopname.submit();
         }
function cmdEdit(oid){
        var oidOpname = document.frmopname.hidden_opname_id.value;
        var oidOpnameSub =document.frmopname.hidden_opname_sub_id1.value;
	window.open("<%=approot%>/postransaction/addopnameitem.jsp?opname_id=" + oidOpname + "&opname_sub_location_id=" + oidOpnameSub + "&hidden_opname_item_id=" + oid , null, "height=300,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
	
}

function cmdAdd(){
        var oidOpname = document.frmopname.hidden_opname_id.value;
        var oidOpnameSub =document.frmopname.hidden_opname_sub_id1.value;
        window.open("<%=approot%>/postransaction/addopnameitem.jsp?opname_id=" + oidOpname + "&opname_sub_location_id=" + oidOpnameSub , null, "height=300,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                        <form name="frmopname" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_opname_id" value="<%=oidOpname%>">
                          <input type="hidden" name="hidden_opname_sub_id1" value="<%=oidOpnameSub%>">
                          <input type="hidden" name="hidden_opname_item_id" value="<%=oidOpnameItem%>">
                          <input type="hidden" name="src_ignore" value="1">
                          
                          
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Opname Item</span></font></b></td>
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
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;<a href="javascript:cmdOpnameSub()" class="tablink">Sub 
                                              Location</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;&nbsp;Opname 
                                              Item&nbsp;&nbsp;</div>
                                          </td>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="4"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr align="left"> 
                                          <td height="26" width="12%" >&nbsp;&nbsp;Number</td>
                                          <td height="26" width="14%"> 
                                            <input size="15" class="readOnly" type="text" readonly value="<%=op.getNumber()%>" >
                                          </td>
                                          <td height="26" width="9%">Location</td>
                                          <td height="26" colspan="2" width="52%" class="comment"> 
                                            <input size="40" class="readOnly" type="text" readonly value="<%=loc.getName()%>" >
                                          </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp; Type 
                                            Opname</td>
                                          <td width="14%" height="14"> 
                                            <%if(op.getTypeOpname()==0){%>
                                            <input size="15" class="readOnly" type="text" readonly value="Global" >
                                            <%}else{%>
                                            <input size="15" class="readOnly" type="text" readonly value="Partial" >
                                            <%}%>
                                          </td>
                                          <td width="9%">Status</td>
                                          <td colspan="2" class="comment" width="52%"> 
                                            <input size="15" class="readOnly" type="text" readonly value="<%=opnameSub.getStatus()%>">
                                          </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp; Sub 
                                            Location </td>
                                          <td height="21" width="27%"> 
                                            <input size="15" class="readOnly" type="text" readonly value="<%=subloc.getName()%>" >
                                          </td>
                                          <td width="9%">Form Number</td>
                                          <td colspan="2" class="comment" width="52%"> 
                                            <input size="15" class="readOnly" type="text" readonly value="<%=opnameSub.getFormNumber()%>" >
                                          </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                          <td height="21" width="27%"> 
                                            <input size="15" class="readOnly" type="text" readonly value="<%=JSPFormater.formatDate(opnameSub.getDate(),"dd-MM-yyyy") %>" >
                                          </td>
                                          <td width="9%"></td>
                                          <%if(oidOpnameSub!=0){%>
                                          <td width="18%">&nbsp;</td>
                                          <%}%>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
								  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="5" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3">&nbsp; </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </form>
						<table width="100%"><tr><td class="container">
						<form name="frmimage" method="post" enctype="multipart/form-data" action="opnameupload_save.jsp">
                                            <input type="hidden" name="command" value ="<%=iJSPCommand%>">
                                            <input type="hidden" name="del_command" value="">
                                            
                                <table width="100%" cellpadding="1" cellspacing="1">
                                  <tr> 
                                    <td width="81%"><b>Browse file</b></td>
                                  </tr>
                                  <tr> 
                                    <td width="81%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="81%" valign="top"><b> 
                                      <input type="file" name="opnamedetail" size="50">
                                      </b> <b> </b></td>
                                  </tr>
                                  <tr>
                                    <td width="81%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="81%"><b>
                                      <input type="submit" name="Submit" value="Upload File">
                                      </b> </td>
                                  </tr>
                                  <tr> 
                                    <td width="81%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="81%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="81%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="81%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="81%">&nbsp;</td>
                                  </tr>
                                </table>
                                          </form>
										  </td></tr></table>
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

