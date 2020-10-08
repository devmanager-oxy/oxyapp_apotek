<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
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
	public Vector drawList(Vector objectClass, int start, int groupBy){
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("80%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		
		cmdist.addHeader("No","1%");
		cmdist.addHeader("Sub Category","25%");
		cmdist.addHeader("Qty","4%");
		cmdist.addHeader("Total Amount","13%");
		cmdist.addHeader("Doc","11%");

		cmdist.setLinkRow(-1);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;
		
		Vector temp = new Vector();
		double totalamount = 0.0;
		double totalQty = 0.0;
		for (int i = 0; i < objectClass.size(); i++) {
			TransferReport transferReport = (TransferReport)objectClass.get(i);
			RptITSubCategoryL detail = new RptITSubCategoryL();
			Vector rowx = new Vector();

            rowx.add("<div align=\"center\">"+(start+i+1)+"</div>");
				detail.setNo((start+i+1));
			rowx.add(""+transferReport.getItemCategory());
				detail.setCategory(transferReport.getItemCategory());
			rowx.add("<div align=\"center\">"+transferReport.getTotalQty()+"</div>");
				detail.setQty(transferReport.getTotalQty());
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(transferReport.getPurchAmount(),"##,##0.00")+"</div>");
				detail.setTotalAmount(transferReport.getPurchAmount());
			rowx.add(""+transferReport.getPurchNumber());
				detail.setDoc(transferReport.getPurchNumber());
			
			totalQty = totalQty + transferReport.getTotalQty();
			totalamount = totalamount + transferReport.getPurchAmount();
			lstData.add(rowx);
			temp.add(detail);
			lstLinkData.add(String.valueOf(-1));
		}
		
		Vector rowx = new Vector();
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		lstData.add(rowx);

		rowx = new Vector();
		rowx.add("");
		rowx.add("<div align=\"right\"><b>Total Doc</b></div>");
		rowx.add("<div align=\"center\"><b>"+totalQty+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+JSPFormater.formatNumber(totalamount,"##,##0.00")+"</b></div>");
		rowx.add("");
		lstData.add(rowx);
		
		//return cmdist.draw(index);
		Vector vx = new Vector();
		vx.add(cmdist.draw(index));
		vx.add(temp);
		return vx;
	}

%>
<%
	if(session.getValue("KONSTAN")!=null){
		session.removeValue("KONSTAN");
	}
	
	if(session.getValue("DETAIL")!=null){
		session.removeValue("DETAIL");
	}

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidAdjusment = JSPRequestValue.requestLong(request, "hidden_adjusment_id");

long srcLocationToId = JSPRequestValue.requestLong(request, "src_location_to_id");
long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
String srcStatus = JSPRequestValue.requestString(request, "src_status");
String srcStart = JSPRequestValue.requestString(request, "src_start_date");
String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
int groupBy = JSPRequestValue.requestInt(request, "group_by");

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
int recordToGet = 15;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";
int vectSize = 0;

JSPLine ctrLine = new JSPLine();
Vector listReport = new Vector(1,1);

//get value for report
RptITSubCategory rptKonstan = new RptITSubCategory();

SrcTransferReport srcTransferReport = new SrcTransferReport();
srcTransferReport.setTypeReport(SrcTransferReport.GROUP_BY_SUB_CATEGORY);
srcTransferReport.setLocationId(srcLocationId);
srcTransferReport.setLocationToId(srcLocationToId);
srcTransferReport.setFromDate(srcStartDate);
srcTransferReport.setToDate(srcEndDate);
srcTransferReport.setIgnoreDate(srcIgnore); 
srcTransferReport.setGroupBy(groupBy);
srcTransferReport.setStatus(srcStatus);

listReport = SessTransferReport.getTransferReport(srcTransferReport, DbTransfer.TYPE_NON_CONSIGMENT);  
//out.println("listReport >> : "+listReport);
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=titleIS%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
function cmdPrintXLS(){	 
	window.open("<%=printroot%>.report.RptITSubCategoryXLS?idx=<%=System.currentTimeMillis()%>");
}

function cmdSearch(){
	document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
	document.frmadjusment.action="treport-subcategory.jsp";
	document.frmadjusment.submit();
}

function cmdListFirst(){
	document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmadjusment.action="treport-subcategory.jsp";
	document.frmadjusment.submit();
}

function cmdListPrev(){
	document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmadjusment.action="treport-subcategory.jsp";
	document.frmadjusment.submit();
	}

function cmdListNext(){
	document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmadjusment.action="treport-subcategory.jsp";
	document.frmadjusment.submit();
}

function cmdListLast(){
	document.frmadjusment.command.value="<%=JSPCommand.LAST%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmadjusment.action="treport-subcategory.jsp";
	document.frmadjusment.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif','../images/print2.gif')">
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
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmadjusment" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_adjusment_id" value="<%=oidAdjusment%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Report 
                                      </font><font class="tit1">&raquo; </font><font color="#990000" class="lvl1">Item 
                                      Transfer </font><font class="tit1">&raquo; 
                                      <span class="lvl2">By Sub Category</span></font></b></td>
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
                                            <div align="center">&nbsp;<a href="<%=approot%>/posreport/treport-location.jsp?menu_idx=13" class="tablink">By Location</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin" nowrap>
                                            <div align="center">&nbsp;<a href="<%=approot%>/posreport/treport-category.jsp?menu_idx=13" class="tablink">By Category</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;By Sub Category&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;<a href="<%=approot%>/posreport/treport-itemmaster.jsp?menu_idx=13" class="tablink">By Item</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;<a href="<%=approot%>/posreport/treport-bysupplier.jsp?menu_idx=13" class="tablink">By Supplier</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>

                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
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
                                                <td width="15%"><b><i>Search Parameters 
                                                  :</i></b></td>
                                                <td width="16%">&nbsp;</td>
                                                <td width="8%">&nbsp;</td>
                                                <td width="61%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="15%">from Location</td>
                                                <td width="16%"> 
                                                  <select name="src_location_id">
                                                    <%
														if(srcLocationId==0){
															rptKonstan.setLocation("- All -");
														}
													%>
                                                    <option value="0" <%if(srcLocationId==0){%>selected<%}%>>- 
                                                    All -</option>
                                                    <%
													Vector locations = DbLocation.list(0,0, "", "name");
												    if(locations!=null && locations.size()>0){
														 for(int i=0; i<locations.size(); i++){
															Location d = (Location)locations.get(i);
															String str = "";
															if(srcLocationId==d.getOID()){
																rptKonstan.setLocation(d.getName());
															}
													%>
                                                    <option value="<%=d.getOID()%>" <%if(srcLocationId==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                                <td width="8%" align="right">To 
                                                  Location</td>
                                                <td width="61%"> 
                                                  <select name="src_location_to_id">
                                                    <%
														if(srcLocationToId==0){
															rptKonstan.setToLocation("- All -");
														}
													%>
                                                    <option value="0" <%if(srcLocationToId==0){%>selected<%}%>>- 
                                                    All -</option>
                                                    <%
												    if(locations!=null && locations.size()>0){
														 for(int i=0; i<locations.size(); i++){
															Location d = (Location)locations.get(i);
															String str = "";
															if(srcLocationToId==d.getOID()){
																rptKonstan.setToLocation(d.getName());
															}
													%>
                                                    <option value="<%=d.getOID()%>" <%if(srcLocationToId==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="15%">Request Between</td>
                                                <td width="16%"> 
                                                  <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate==null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%rptKonstan.setRequestStart(srcStartDate);%>
                                                </td>
                                                <td align="right" width="8%">and</td>
                                                <td width="61%"> 
                                                  <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate==null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%rptKonstan.setRequestEnd(srcEndDate);%>
                                                  <input type="checkbox" name="src_ignore" value="1" <%if(srcIgnore==1){%>checked<%}%>>
                                                  Ignored 
                                                  <%
														if(srcIgnore==1){
															rptKonstan.setIgnored(1);
														}
												  %>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td height="5" width="15%">Document 
                                                  Status </td>
                                                <td height="5" width="16%"> 
                                                  <select name="src_status">
                                                    <%
														if(srcStatus==""){
															rptKonstan.setDocStatus("- All -");
														}
													%>
                                                    <option value="" >- All -</option>
                                                    <%
														if(srcStatus.equals(I_Project.DOC_STATUS_DRAFT)){
															rptKonstan.setDocStatus(I_Project.DOC_STATUS_DRAFT);
														}
													%>
                                                    <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if(srcStatus.equals(I_Project.DOC_STATUS_DRAFT)){%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                    <%
														if(srcStatus.equals(I_Project.DOC_STATUS_APPROVED)){
															rptKonstan.setDocStatus(I_Project.DOC_STATUS_APPROVED);
														}
													%>
                                                    <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if(srcStatus.equals(I_Project.DOC_STATUS_APPROVED)){%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                    <%
														if(srcStatus.equals(I_Project.DOC_STATUS_CHECKED)){
															rptKonstan.setDocStatus(I_Project.DOC_STATUS_CHECKED);
														}
													%>
                                                    <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if(srcStatus.equals(I_Project.DOC_STATUS_CHECKED)){%>selected<%}%>><%=I_Project.DOC_STATUS_CHECKED%></option>
                                                    <%
														if(srcStatus.equals(I_Project.DOC_STATUS_CLOSE)){
															rptKonstan.setDocStatus(I_Project.DOC_STATUS_CLOSE);
														}
													%>
                                                    <option value="<%=I_Project.DOC_STATUS_CLOSE%>" <%if(srcStatus.equals(I_Project.DOC_STATUS_CLOSE)){%>selected<%}%>><%=I_Project.DOC_STATUS_CLOSE%></option>
                                                  </select>
                                                </td>
                                                <td height="5" align="right" width="8%">Group 
                                                  By </td>
                                                <td height="5" width="61%"> 
                                                  <select name="group_by">
                                                    <%
														if(groupBy==0){
															rptKonstan.setGroupBy("Transaction");
														}
													%>
                                                    <option value="0" <%if(groupBy==0){%>selected<%}%>>Transaction</option>
                                                    <%
														if(groupBy==3){
															rptKonstan.setGroupBy("Sub Category");
														}
													%>
                                                    <option value="3" <%if(groupBy==3){%>selected<%}%>>Sub 
                                                    Category</option>
                                                  </select>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="15%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                <td colspan="3">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="15%">&nbsp;</td>
                                                <td colspan="3">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
							try{
								if (listReport.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                            <%
												Vector x = drawList(listReport,start,groupBy);
												String strTampil = (String)x.get(0);
												Vector rptObj = (Vector)x.get(1);
											%>
                                            <%=strTampil%> 
                                            <%
												session.putValue("DETAIL", rptObj);
											%>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></td>
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
                                            <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
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
						<%
							session.putValue("KONSTAN", rptKonstan);
						%>
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
