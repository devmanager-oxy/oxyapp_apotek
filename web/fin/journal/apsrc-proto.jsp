<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long apId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Date","14%");
		ctrlist.addHeader("Due Date","14%");
		ctrlist.addHeader("Number Counter","14%");
		ctrlist.addHeader("Amount","14%");
		ctrlist.addHeader("Invoice Number","14%");
		ctrlist.addHeader("Status","14%");
		ctrlist.addHeader("Total Payment","14%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Ap ap = (Ap)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(apId == ap.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = ap.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = JSPFormater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			String str_dt_DueDate = ""; 
			try{
				Date dt_DueDate = ap.getDueDate();
				if(dt_DueDate==null){
					dt_DueDate = new Date();
				}

				str_dt_DueDate = JSPFormater.formatDate(dt_DueDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_DueDate = ""; }

			rowx.add(str_dt_DueDate);

			rowx.add(String.valueOf(ap.getNumberCounter()));

			rowx.add(String.valueOf(ap.getAmount()));

			rowx.add(ap.getInvoiceNumber());

			rowx.add(ap.getStatus());

			rowx.add(String.valueOf(ap.getTotalPayment()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(ap.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidAp = JSPRequestValue.requestLong(request, "hidden_ap_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdAp ctrlAp = new CmdAp(request);
JSPLine ctrLine = new JSPLine();
Vector listAp = new Vector(1,1);

/*switch statement */
iErrCode = ctrlAp.action(iJSPCommand , oidAp);
/* end switch*/
JspAp jspAp = ctrlAp.getForm();

/*count list All Ap*/
int vectSize = DbAp.getCount(whereClause);

Ap ap = ctrlAp.getAp();
msgString =  ctrlAp.getMessage();



if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlAp.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listAp = DbAp.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listAp.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listAp = DbAp.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">


function cmdAdd(){
	document.frmap.hidden_ap_id.value="0";
	document.frmap.command.value="<%=JSPCommand.ADD%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}

function cmdAsk(oidAp){
	document.frmap.hidden_ap_id.value=oidAp;
	document.frmap.command.value="<%=JSPCommand.ASK%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}

function cmdConfirmDelete(oidAp){
	document.frmap.hidden_ap_id.value=oidAp;
	document.frmap.command.value="<%=JSPCommand.DELETE%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}
function cmdSave(){
	document.frmap.command.value="<%=JSPCommand.SAVE%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
	}

function cmdEdit(oidAp){
	document.frmap.hidden_ap_id.value=oidAp;
	document.frmap.command.value="<%=JSPCommand.EDIT%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
	}

function cmdCancel(oidAp){
	document.frmap.hidden_ap_id.value=oidAp;
	document.frmap.command.value="<%=JSPCommand.EDIT%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}

function cmdBack(){
	document.frmap.command.value="<%=JSPCommand.BACK%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
	}

function cmdListFirst(){
	document.frmap.command.value="<%=JSPCommand.FIRST%>";
	document.frmap.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}

function cmdListPrev(){
	document.frmap.command.value="<%=JSPCommand.PREV%>";
	document.frmap.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
	}

function cmdListNext(){
	document.frmap.command.value="<%=JSPCommand.NEXT%>";
	document.frmap.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}

function cmdListLast(){
	document.frmap.command.value="<%=JSPCommand.LAST%>";
	document.frmap.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
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
<script language="JavaScript">
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
              <%@ include file="../main/menu.jsp"%>
			  <%@ include file="../calendar/calendarframe.jsp"%>
              <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Cash </span> &raquo; 
                        <span class="level1">Petty Cash</span> &raquo; <span class="level2">Payment<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
              <form name="frmap" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                <input type="hidden" name="hidden_ap_id" value="<%=oidAp%>">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="left" valign="top"> 
                    <td height="8"  colspan="3"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top"> 
                          <td height="8" valign="middle" colspan="3"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr align="left" valign="top"> 
                                <td height="8" valign="middle" colspan="3"></td>
                              </tr>
                              <tr align="left" valign="top"> 
                                <td height="14" valign="middle" colspan="3" class="comment"><b><u>Purchases 
                                  &gt; Search Data</u></b></td>
                              </tr>
                              <tr align="left" valign="top"> 
                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp; 
                                </td>
                              </tr>
                              <tr align="left" valign="top"> 
                                <td height="14" valign="middle" colspan="3" class="comment">
                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                    <tr> 
                                      <td width="9%">Date From</td>
                                      <td colspan="3"> 
                                        <input name="a" value="<%=JSPFormater.formatDate((new Date()==null) ? new Date() : ap.getDate(), "dd/MM/yyyy")%>" size="11">
                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.a);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                        to 
                                        <input name="a2" value="<%=JSPFormater.formatDate((new Date()==null) ? new Date() : ap.getDate(), "dd/MM/yyyy")%>" size="11">
                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.a2);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                        <input type="checkbox" name="checkbox" value="checkbox" checked>
                                        ignore</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">Vendor</td>
                                      <td width="14%"> 
                                        <select name="select">
                                          <option selected>All</option>
                                          <option>PT. Laksmana</option>
                                          <option>CV. Bangun Jaya</option>
                                        </select>
                                      </td>
                                      <td width="5%">Status</td>
                                      <td width="72%"> 
                                        <select name="select2">
                                          <option selected>Draft</option>
                                          <option>Approved</option>
                                        </select>
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td colspan="4" height="5"></td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="14%"> 
                                        <input type="button" name="Button" value="Search">
                                      </td>
                                      <td width="5%">&nbsp;</td>
                                      <td width="72%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="14%">&nbsp; </td>
                                      <td width="5%">&nbsp;</td>
                                      <td width="72%">&nbsp;</td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                              <tr id="listit"> 
                                <td height="14" valign="middle" colspan="3" class="comment">
                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                    <tr> 
                                      <td class="tablehdr" width="13%">Trans. 
                                        Date</td>
                                      <td class="tablehdr" width="16%">Vendor</td>
                                      <td class="tablehdr" width="19%">Amount</td>
                                      <td class="tablehdr" width="21%">Payment</td>
                                      <td  class="tablehdr" width="15%">Due Date</td>
                                      <td  class="tablehdr" width="16%">Status</td>
                                    </tr>
                                    <tr> 
                                      <td class="tablecell" width="13%">10-11-2007</td>
                                      <td class="tablecell" width="16%"><a href="ap-proto.jsp">PT. 
                                        Maju Jaya</a></td>
                                      <td class="tablecell" width="19%"> 
                                        <div align="right">Rp. 20,000,000.-</div>
                                      </td>
                                      <td class="tablecell" width="21%"> 
                                        <div align="right">Rp. 10,000,000.-</div>
                                      </td>
                                      <td class="tablecell" width="15%">30-11-2007</td>
                                      <td class="tablecell" width="16%"> 
                                        <div align="center">Posted</div>
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td class="tablecell" width="13%">20-10-2007</td>
                                      <td class="tablecell" width="16%"><a href="ap-proto.jsp">CV. 
                                        Ramayana</a></td>
                                      <td class="tablecell" width="19%"> 
                                        <div align="right">Rp. 5,000,000.-</div>
                                      </td>
                                      <td class="tablecell" width="21%"> 
                                        <div align="right">Rp. 4,000,000.-</div>
                                      </td>
                                      <td class="tablecell" width="15%">25-11-2007</td>
                                      <td class="tablecell" width="16%"> 
                                        <div align="center">Posted</div>
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td class="tablecell" width="13%">01-11-2007</td>
                                      <td class="tablecell" width="16%"><a href="ap-proto.jsp">PT. 
                                        Ratu Manja </a></td>
                                      <td class="tablecell" width="19%"> 
                                        <div align="right">Rp. 20,000,000.-</div>
                                      </td>
                                      <td class="tablecell" width="21%"> 
                                        <div align="right">Rp. 0.-</div>
                                      </td>
                                      <td class="tablecell" width="15%">&nbsp;</td>
                                      <td class="tablecell" width="16%"> 
                                        <div align="center">Draft</div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                              <tr align="left" valign="top"> 
                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                              </tr>
                              <tr align="left" valign="top"> 
                                <td height="14" valign="middle" colspan="3" class="comment">List 
                                  1-3 of 3</td>
                              </tr>
                              <tr align="left" valign="top">
                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <%
							try{
								if (listAp.size()>0){
							%>
                        <%  } 
						  }catch(Exception exc){ 
						  }%>
                      </table>
                    </td>
                  </tr>
                  <tr align="left" valign="top"> 
                    <td height="8" valign="middle" colspan="3">&nbsp; </td>
                  </tr>
                </table>
              </form>
              <title></title>
              <!-- #EndEditable -->
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
