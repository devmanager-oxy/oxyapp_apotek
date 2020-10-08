<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
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

	public Vector drawList(Vector objectClass, int start)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("No","3%");
		cmdist.addHeader("Date","5%");
		cmdist.addHeader("Rec Number","5%");
		cmdist.addHeader("PO Number","5%");
                cmdist.addHeader("Vendor","20%");
                cmdist.addHeader("Item Name","40%");
                cmdist.addHeader("Unit","3%");
                cmdist.addHeader("Price","7%");
                cmdist.addHeader("Qty","5%");
                cmdist.addHeader("Total","10%");
                
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
		
		for (int i = 0; i < objectClass.size(); i++) {
                    Vector tem = (Vector)objectClass.get(i);
			Receive receive = (Receive)tem.get(0);
			Vendor vendor = (Vendor)tem.get(1);
			ItemMaster im = (ItemMaster)tem.get(2);
			ReceiveItem pi = (ReceiveItem)tem.get(3);
                        
			//ReceiveReport receiveReport = (ReceiveReport)objectClass.get(i);
			RptIRSupplierL detail = new RptIRSupplierL();
                        RptIGCategoryL ig = new RptIGCategoryL();
			Vector rowx = new Vector();
                        
                        Purchase pu = new Purchase();
                        try{
                            pu= DbPurchase.fetchExc(receive.getPurchaseId());
                        }catch(Exception e){
                            
                        }
			Uom uom = new Uom();
                        try{
                            uom = DbUom.fetchExc(im.getUomPurchaseId());
                        }catch(Exception e){
                            
                        }
                        
			Vendor vnd = new Vendor();
			try{
				vnd = DbVendor.fetchExc(vendor.getOID());
			}catch(Exception ex){
			}

                        rowx.add("<div align=\"center\">"+(start+i+1)+"</div>");  
				detail.setNo((start+i+1)); 
                                ig.setNo(start+i+1);
			rowx.add(""+ JSPFormater.formatDate(receive.getDate(),"dd-MM-yyyy"));
				detail.setDoc(receive.getNumber());
                                ig.setDate(receive.getDate());
                                        
			rowx.add(""+receive.getNumber());
                                ig.setRecNumber(receive.getNumber());
                        rowx.add(""+pu.getNumber());
                                ig.setPoNumber(pu.getNumber());
                        rowx.add(""+vnd.getName());
                                ig.setVendor(vnd.getName());
                                
                        rowx.add(""+im.getName());
                                ig.setItemName(im.getName());
                        rowx.add(""+uom.getUnit());
                                ig.setUnit(uom.getUnit());
                        
				detail.setSupplier(vnd.getName());
			rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(pi.getAmount(),"##,##0.00")+"</div>");
                                ig.setPrice(pi.getAmount());
                        rowx.add(""+pi.getQty());
                                ig.setQty(pi.getQty());
                        rowx.add("<div align=\"right\">"+JSPFormater.formatNumber((pi.getQty()* pi.getAmount()),"##,##0.00")+"</div>");
                                ig.setTotal((pi.getQty()* pi.getAmount()));
				//detail.setTotalAmount(receiveReport.getPurchAmount());
			
			totalamount = totalamount + (pi.getQty()* pi.getAmount()); //receiveReport.getPurchAmount();
			lstData.add(rowx);
			temp.add(ig);
			lstLinkData.add(String.valueOf(-1));
		}
		
		Vector rowx = new Vector();
		rowx.add("");         
		rowx.add("");
		rowx.add("");
		rowx.add("");
		lstData.add(rowx);

		rowx = new Vector();
		rowx.add("");         
		rowx.add("");
                rowx.add("");         
		rowx.add("");
                rowx.add("");         
		rowx.add("");
                rowx.add("");         
		rowx.add("");
		rowx.add("<div align=\"right\"><b>Total</b></div>");
		rowx.add("<div align=\"right\"><b>"+JSPFormater.formatNumber(totalamount,"##,##0.00")+"</b></div>");
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

String vendorNames = JSPRequestValue.requestString(request, "src_vendor_name");
String itemNames = JSPRequestValue.requestString(request, "src_item_name");
int order = JSPRequestValue.requestInt(request, "src_order");
long itemCategoryId = JSPRequestValue.requestLong(request, "src_category_id");

long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
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
RptIRSupplier rptKonstan = new RptIRSupplier();

SrcReceiveReport srcReceiveReport = new SrcReceiveReport();
srcReceiveReport.setTypeReport(SrcReceiveReport.GROUP_BY_SUPPLIER);
srcReceiveReport.setLocationId(srcLocationId);
srcReceiveReport.setVendorId(srcVendorId);
srcReceiveReport.setFromDate(srcStartDate);
srcReceiveReport.setToDate(srcEndDate);
srcReceiveReport.setIgnoreDate(srcIgnore);
srcReceiveReport.setGroupBy(groupBy);
srcReceiveReport.setStatus(srcStatus);


//listReport = SessReceiveReport.getReceiveReport(srcReceiveReport);
//listReport = DbReceive.getReceiveMainData(srcStartDate, srcEndDate, vendorNames, order, srcStatus);
//out.println("listReport >> : "+listReport);

Vector groups = DbItemGroup.list(0,0,"", "");

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
	window.open("<%=printroot%>.report.RptIGCategoryXLS?idx=<%=System.currentTimeMillis()%>");
}

function cmdSearch(){
	document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
	document.frmadjusment.action="recreport-category.jsp";
	document.frmadjusment.submit();
}

function cmdListFirst(){
	document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmadjusment.action="recreport-category.jsp";
	document.frmadjusment.submit();
}

function cmdListPrev(){
	document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmadjusment.action="recreport-category.jsp";
	document.frmadjusment.submit();
	}

function cmdListNext(){
	document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmadjusment.action="recreport-category.jsp";
	document.frmadjusment.submit();
}

function cmdListLast(){
	document.frmadjusment.command.value="<%=JSPCommand.LAST%>";
	document.frmadjusment.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmadjusment.action="recreport-category.jsp";
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
                                      </font><font class="tit1">&raquo; </font><font color="#990000" class="lvl1">Incoming 
                                      Report </font><font class="tit1">&raquo; 
                                      <span class="lvl2">By Category</span></font></b></td>
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
                                            <div align="center">&nbsp;&nbsp;<a href="<%=approot%>/posreport/recreport-supplier.jsp?menu_idx=13" class="tablink">Report 
                                              by Supplier</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;Report by Category&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <!--td class="tabin" nowrap> 
                                            <div align="center">&nbsp;<a href="<%=approot%>/posreport/recreport-subcategory.jsp?menu_idx=13" class="tablink">Report by Sub Category</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;<a href="<%=approot%>/posreport/recreport-itemmaster.jsp?menu_idx=13" class="tablink">Report by Item</a>&nbsp;&nbsp;</div>
                                          </td-->
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
                                                <td colspan="2"><b><i>Search Parameters 
                                                  :</i></b></td>
                                              </tr>
                                              <tr> 
                                                <td width="11%">Vendor/Supplier</td>
                                                <td width="89%"> 
                                                  <input type="text" name="src_vendor_name" size="30" value="<%=vendorNames%>">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="11%">Item Name</td>
                                                <td width="89%"> 
                                                  <input type="text" name="src_item_name" size="30" value="<%=itemNames%>">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="11%">Receive Date</td>
                                                <td width="89%"> 
                                                  <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate==null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%rptKonstan.setRequestStart(srcStartDate);%>
                                                  &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                  <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate==null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%rptKonstan.setRequestEnd(srcEndDate);%>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td height="5" width="11%">Document 
                                                  Status </td>
                                                <td height="5" width="89%"> 
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
                                              </tr>
                                              <tr> 
                                                <td width="11%">Order By</td>
                                                <td width="89%"> 
                                                  <select name="src_order">
                                                    <option value="0" <%if(order==0){%>selected<%}%>>Vendor 
                                                    Name</option>
                                                    <option value="1" <%if(order==1){%>selected<%}%>>Receive 
                                                    Date</option>
                                                  </select>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="11%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                <td width="89%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="11%">&nbsp;</td>
                                                <td width="89%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
                                            listReport = DbReceive.getReceiveByItemGroup(srcStartDate, srcEndDate, vendorNames, order, srcStatus,0);
                                        %>
                                        
										<%if(groups==null && groups.size()>0){
										for(int x=0; x<groups.size(); x++){
											ItemGroup ig = (ItemGroup)groups.get(x);
											
											listReport = DbReceive.getReceiveByItemGroup(srcStartDate, srcEndDate, vendorNames, order, srcStatus, ig.getOID());
											
											if (listReport!=null && listReport.size()>0){
										%>
										<tr align="left" valign="top"> 
                                          <td height="30" align="left" colspan="3" class="command" valign="middle" bgcolor="#EAEAD5">&nbsp;<b>GROUP 
                                            : <%=ig.getName().toUpperCase()%></b></td>
                                        </tr>                                        
                                        <tr align="left" valign="top"> 
                                          <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td class="tablehdr" width="4%">No</td>
                                                <td class="tablehdr" width="7%">Date</td>
                                                <td class="tablehdr" width="7%">Rec. 
                                                  Number </td>
                                                <td class="tablehdr" width="7%">PO 
                                                  Number</td>
                                                <td class="tablehdr" width="21%">Vendor</td>
                                                <td class="tablehdr" width="25%">Item 
                                                  Desc. </td>
                                                <td class="tablehdr" width="4%">Unit</td>
                                                <td class="tablehdr" width="9%">@Price</td>
                                                <td class="tablehdr" width="5%">Qty</td>
                                                <td class="tablehdr" width="11%">Total 
                                                  Amount </td>
                                              </tr>
                                              <%
											  
											  double totalAmount = 0;
											  double subTotal = 0;
											  
											  for(int i=0; i<listReport.size(); i++){
											  		Vector temp = (Vector)listReport.get(i);
													Receive receive = (Receive)temp.get(0);
													Vendor vendor = (Vendor)temp.get(1);
													ItemMaster im = (ItemMaster)temp.get(2);
													ReceiveItem pi = (ReceiveItem)temp.get(3);
													
													totalAmount = totalAmount + (pi.getAmount()*pi.getQty());//receive.getTotalAmount()-receive.getDiscountTotal()+receive.getTotalTax();
													//subTotal = subTotal + receive.getTotalAmount();
													
													Purchase purchase = new Purchase();
													try{
														vendor = DbVendor.fetchExc(receive.getVendorId());
														purchase = DbPurchase.fetchExc(receive.getPurchaseId());
													}
													catch(Exception e){
													}
													
													if(i%2==0){
											  %>
                                              <tr> 
                                                <td class="tablecell" width="4%"> 
                                                  <div align="center"><font size="1"><%=i+1%></font></div>
                                                </td>
                                                <td class="tablecell" width="7%"><font size="1"><%=JSPFormater.formatDate(receive.getDate(), "dd/MM/yyyy")%></font></td>
                                                <td class="tablecell" width="7%"><font size="1"><%=receive.getNumber()%></font></td>
                                                <td class="tablecell" width="7%"><font size="1"><%=purchase.getNumber()%></font></td>
                                                <td class="tablecell" width="21%"><font size="1"><%=vendor.getName()%></font></td>
                                                <td class="tablecell" width="25%"><font size="1"><%=im.getName()%></font></td>
                                                <td class="tablecell" width="4%"><font size="1"></font></td>
                                                <td class="tablecell" width="9%"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(pi.getAmount(), "#,###")%></font></div>
                                                </td>
                                                <td class="tablecell" width="5%"> 
                                                  <div align="right"><font size="1"><%=pi.getQty()%></font></div>
                                                </td>
                                                <td class="tablecell" width="11%"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(pi.getAmount()*pi.getQty(), "#,###")%></font></div>
                                                </td>
                                              </tr>
                                              <%}else{%>
                                              <tr> 
                                                <td class="tablecell1" width="4%"> 
                                                  <div align="center"><font size="1"><%=i+1%></font></div>
                                                </td>
                                                <td class="tablecell1" width="7%"><font size="1"><%=JSPFormater.formatDate(receive.getDate(), "dd/MM/yyyy")%></font></td>
                                                <td class="tablecell1" width="7%"><font size="1"><%=receive.getNumber()%></font></td>
                                                <td class="tablecell1" width="7%"><font size="1"><%=purchase.getNumber()%></font></td>
                                                <td class="tablecell1" width="21%"><font size="1"><%=vendor.getName()%></font></td>
                                                <td class="tablecell1" width="25%"><font size="1"><%=im.getName()%></font></td>
                                                <td class="tablecell1" width="4%"><font size="1"></font></td>
                                                <td class="tablecell1" width="9%"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(pi.getAmount(), "#,###")%></font></div>
                                                </td>
                                                <td class="tablecell1" width="5%"> 
                                                  <div align="right"><font size="1"><%=pi.getQty()%></font></div>
                                                </td>
                                                <td class="tablecell1" width="11%"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(pi.getAmount()*pi.getQty(), "#,###")%></font></div>
                                                </td>
                                              </tr>
                                              <%}}%>
                                              <tr> 
                                                <td width="4%" height="18">&nbsp;</td>
                                                <td width="7%" height="18">&nbsp;</td>
                                                <td width="7%" height="18">&nbsp;</td>
                                                <td width="7%" height="18">&nbsp;</td>
                                                <td width="21%" height="18" bgcolor="#CCCCCC"> 
                                                  <div align="center"><b>T O T 
                                                    A L :</b></div>
                                                </td>
                                                <td width="25%" height="18" bgcolor="#CCCCCC">&nbsp;</td>
                                                <td width="4%" height="18" bgcolor="#CCCCCC">&nbsp;</td>
                                                <td width="9%" height="18" bgcolor="#CCCCCC"> 
                                                  <div align="right"></div>
                                                </td>
                                                <td width="5%" height="18" bgcolor="#CCCCCC">&nbsp;</td>
                                                <td width="11%" height="18" bgcolor="#CCCCCC"> 
                                                  <div align="right"><b><%=JSPFormater.formatNumber(totalAmount, "#,###")%></b></div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%}}
										}
										
										%>
                                        <tr align="left" valign="top">
                                          <td class="boxed1" height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td class="boxed1" height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <%
							try{
								if (listReport.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                            <%
										  	Vector x = drawList(listReport,start);
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
