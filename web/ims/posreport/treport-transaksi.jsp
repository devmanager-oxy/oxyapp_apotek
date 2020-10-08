
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>  
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(Vector objectClass, int start, int groupBy) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader("No", "2%");
        cmdist.addHeader("Number", "8%");
        cmdist.addHeader("Date", "8%");
        cmdist.addHeader("User", "8%");
        cmdist.addHeader("From", "12%");
        cmdist.addHeader("To", "12%");
        cmdist.addHeader("Tot<br>Qty", "3%");
        cmdist.addHeader("Amount", "9%");
        cmdist.addHeader("Status", "7%");
        cmdist.addHeader("Notes", "31%");

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
            TransferReport transferReport = (TransferReport) objectClass.get(i);

            Transfer transfer = new Transfer();
            User ux = new User();
            try {
                transfer = DbTransfer.fetchExc(transferReport.getOID());
                ux = DbUser.fetch(transfer.getUserId());
            } catch (Exception e) {
            }

            RptITSubCategoryL detail = new RptITSubCategoryL();
            Vector rowx = new Vector();

            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
            detail.setNo((start + i + 1));
            rowx.add("<div align=\"center\"><a href=\"javascript:cmdOpenIt('" + transferReport.getOID() + "')\">" + transferReport.getPurchNumber() + "</a></div>");
            detail.setDoc(transferReport.getPurchNumber());
            rowx.add("" + JSPFormater.formatDate(transferReport.getDate(), "dd-MM-yyyy"));
            detail.setDoc(transferReport.getLocationName());
            rowx.add("" + ux.getLoginId());
            rowx.add("" + transferReport.getLocationName());
            detail.setCategory(transferReport.getItemCategory());
            rowx.add("" + transferReport.getLocationToName());
            detail.setCategory(transferReport.getItemCategory());
            rowx.add("<div align=\"right\">" + transferReport.getTotalQty() + "</div>");
            detail.setQty(transferReport.getTotalQty());
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(transferReport.getPurchAmount(), "##,###.##") + "</div>");
            detail.setTotalAmount(transferReport.getPurchAmount());
            rowx.add("<div align=\"center\">" + transfer.getStatus() + "</div>");
            rowx.add("<font size=\"1\">" + transfer.getNote().toLowerCase() + "</font>");


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
        rowx.add("");
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
        rowx.add("<div align=\"right\"><b>Total Doc</b></div>");
        rowx.add("<div align=\"center\"><b>" + totalQty + "</b></div>");
        rowx.add("<div align=\"right\"><b>" + JSPFormater.formatNumber(totalamount, "##,###.##") + "</b></div>");
        rowx.add("");
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
            if (session.getValue("KONSTAN") != null) {
                session.removeValue("KONSTAN");
            }

            if (session.getValue("DETAIL") != null) {
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
            String srcNumber = JSPRequestValue.requestString(request, "src_number");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            int groupBy = JSPRequestValue.requestInt(request, "group_by");
            long transferId = JSPRequestValue.requestLong(request, "src_transfer_id");
            int slc = JSPRequestValue.requestInt(request, "src_select");
            String srcParam = "";

            Date srcStartDate = new Date();
            Date srcEndDate = new Date();
            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
            }
            if (srcIgnore == 0) {
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
            Vector listReport = new Vector(1, 1);

//get value for report
            RptITSubCategory rptKonstan = new RptITSubCategory();

            SrcTransferReport srcTransferReport = new SrcTransferReport();
            srcTransferReport.setTypeReport(SrcTransferReport.GROUP_BY_TRANSAKSI);
            srcTransferReport.setLocationId(srcLocationId);
            srcTransferReport.setLocationToId(srcLocationToId);
            srcTransferReport.setFromDate(srcStartDate);
            srcTransferReport.setToDate(srcEndDate);
            srcTransferReport.setIgnoreDate(srcIgnore);
            srcTransferReport.setGroupBy(groupBy);
            srcTransferReport.setStatus(srcStatus);            
            srcTransferReport.setNumber(srcNumber);

            if (iJSPCommand != JSPCommand.NONE) {

                if (srcLocationId == 0) {
                    srcParam = "From : All";
                } else {
                    try {
                        Location loc = DbLocation.fetchExc(srcLocationId);
                        srcParam = "From : " + loc.getName();
                    } catch (Exception e) {
                    }
                }

                if (srcLocationToId == 0) {
                    srcParam = srcParam + ", To : All";
                } else {
                    try {
                        Location loc = DbLocation.fetchExc(srcLocationToId);
                        srcParam = srcParam + ", to : " + loc.getName();
                    } catch (Exception e) {
                    }
                }

                if (srcIgnore == 0) {
                    srcParam = srcParam + ", Period : " + JSPFormater.formatDate(srcStartDate, "dd/MM/yyyy") + " - " + JSPFormater.formatDate(srcEndDate, "dd/MM/yyyy");
                } else {
                    srcParam = srcParam + ", All Dates";
                }

                if (srcStatus != "") {
                    srcParam = srcParam + ", Status : " + srcStatus;
                } else {
                    srcParam = srcParam + ", All Status";
                }

                if (srcNumber != "") {
                    srcParam = srcParam + ", Number : " + srcNumber;
                } else {
                    srcParam = srcParam + ", All Number";
                }

                //out.println("whereClause : "+whereClause);
                //out.println("orderClause : "+orderClause);

                //out.println("start : "+start);	

                CmdTransfer ctrlStock = new CmdTransfer(request);
                vectSize = SessTransferReport.getTransferCount(srcTransferReport);
                if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                        (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                    start = ctrlStock.actionList(iJSPCommand, start, vectSize, recordToGet);
                }

                //out.println("start 1 : "+start);	


                listReport = SessTransferReport.getTransferReport(srcTransferReport, DbTransfer.TYPE_NON_CONSIGMENT, start, recordToGet);
                //out.println("listReport >> : "+listReport);

                //out.println("srcParam : "+srcParam);


                session.putValue("KONSTAN", srcTransferReport);
                session.putValue("USER_NAME", user.getLoginId());
                session.putValue("SRC_PARAM", srcParam);


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
            function cmdPrintXLSTransfer(){	 
                window.open("<%=printroot%>.report.RptTranferXLSx?transfer_id=<%=transferId%>&idx=<%=System.currentTimeMillis()%>");
                }  
                
                function cmdOpenIt(oid){  
                    window.open("opentransferitem.jsp?hidden_transfer_id="+oid+"&command=3","opentransfer", "width=800,height=500,location=0,resizable,scrollbars,status=1");
                }
                
                function cmdPrintXLS(){	   
                    window.open("<%=printroot%>.report.RptITLocationXLS?idx=<%=System.currentTimeMillis()%>");
                    }
                    
                    function cmdGetDetail(oid, slc){
                        document.frmadjusment.src_transfer_id.value=oid;
                        document.frmadjusment.src_select.value=slc;
                        document.frmadjusment.command.value="<%=JSPCommand.LIST%>";  	
                        document.frmadjusment.action="treport-transaksi.jsp";
                        document.frmadjusment.submit();
                    }
                    
                    function cmdSearch(){
                        document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
                        document.frmadjusment.action="treport-transaksi.jsp";
                        document.frmadjusment.submit();
                    }
                    
                    function cmdListFirst(){
                        document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
                        document.frmadjusment.prev_command.value="<%=JSPCommand.FIRST%>";
                        document.frmadjusment.action="treport-transaksi.jsp";
                        document.frmadjusment.submit();
                    }
                    
                    function cmdListPrev(){
                        document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
                        document.frmadjusment.prev_command.value="<%=JSPCommand.PREV%>";
                        document.frmadjusment.action="treport-transaksi.jsp";
                        document.frmadjusment.submit();
                    }
                    
                    function cmdListNext(){
                        document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
                        document.frmadjusment.prev_command.value="<%=JSPCommand.NEXT%>";
                        document.frmadjusment.action="treport-transaksi.jsp";
                        document.frmadjusment.submit();
                    }
                    
                    function cmdListLast(){
                        document.frmadjusment.command.value="<%=JSPCommand.LAST%>";
                        document.frmadjusment.prev_command.value="<%=JSPCommand.LAST%>";
                        document.frmadjusment.action="treport-transaksi.jsp";
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
                                                            <input type="hidden" name="src_transfer_id" value="0">
                                                            <input type="hidden" name="src_select" value="<%=slc%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23">&nbsp;<b><font color="#990000" class="lvl1">Report 
                                                                                        </font><font class="tit1">&raquo; </font><font class="tit1"><span class="lvl2">Item 
                                                                                Transfer Report</span></font></b></td>
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
                                                                            <!--tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;By Location&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;<a href="<%=approot%>/posreport/treport-category.jsp?menu_idx=13" class="tablink">By 
                                              Category</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;<a href="<%=approot%>/posreport/treport-subcategory.jsp?menu_idx=13" class="tablink">By 
                                              Sub Category</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;<a href="<%=approot%>/posreport/treport-itemmaster.jsp?menu_idx=13" class="tablink">By 
                                              Item</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;<a href="<%=approot%>/posreport/treport-bysupplier.jsp?menu_idx=13" class="tablink">By 
                                              Supplier</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                                                            </tr-->
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
                                                                                                        <td width="15%">Transfer from 
                                                                                                        </td>
                                                                                                        <td width="16%"> 
                                                                                                            <select name="src_location_id">
                                                                                                                <%
            if (srcLocationId == 0) {
                rptKonstan.setLocation("- All -");
            }
                                                                                                                %>
                                                                                                                <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>- 
                                                                                                                        All -</option>
                                                                                                                <%
            Vector locations = DbLocation.list(0, 0, "", "name");
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                    String str = "";
                    if (srcLocationId == d.getOID()) {
                        rptKonstan.setLocation(d.getName());
                    }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td width="8%" align="right">To 
                                                                                                        </td>
                                                                                                        <td width="61%"> 
                                                                                                            <select name="src_location_to_id">
                                                                                                                <%
            if (srcLocationToId == 0) {
                rptKonstan.setToLocation("- All -");
            }
                                                                                                                %>
                                                                                                                <option value="0" <%if (srcLocationToId == 0) {%>selected<%}%>>- 
                                                                                                                        All -</option>
                                                                                                                <%
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                    String str = "";
                    if (srcLocationToId == d.getOID()) {
                        rptKonstan.setToLocation(d.getName());
                    }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcLocationToId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="15%">Date Between</td>
                                                                                                        <td width="16%"> 
                                                                                                            <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%rptKonstan.setRequestStart(srcStartDate);%>
                                                                                                        </td>
                                                                                                        <td align="right" width="8%">and</td>
                                                                                                        <td width="61%"> 
                                                                                                        <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        <%rptKonstan.setRequestEnd(srcEndDate);%>
                                                                                                        <input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>>
                                                                                                               Ignored 
                                                                                                               <%
            if (srcIgnore == 1) {
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
            if (srcStatus == "") {
                rptKonstan.setDocStatus("- All -");
            }
                                                                                                                %>
                                                                                                                <option value="" >- All -</option>
                                                                                                                <%
            if (srcStatus.equals(I_Project.DOC_STATUS_DRAFT)) {
                rptKonstan.setDocStatus(I_Project.DOC_STATUS_DRAFT);
            }
                                                                                                                %>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                <%
            if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {
                rptKonstan.setDocStatus(I_Project.DOC_STATUS_APPROVED);
            }
                                                                                                                %>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                <%
            if (srcStatus.equals(I_Project.DOC_STATUS_CHECKED)) {
                rptKonstan.setDocStatus(I_Project.DOC_STATUS_CHECKED);
            }
                                                                                                                %>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_CHECKED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_CHECKED%></option>
                                                                                                                <%
            if (srcStatus.equals(I_Project.DOC_STATUS_CLOSE)) {
                rptKonstan.setDocStatus(I_Project.DOC_STATUS_CLOSE);
            }
                                                                                                                %>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_CLOSE%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_CLOSE)) {%>selected<%}%>><%=I_Project.DOC_STATUS_CLOSE%></option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td height="5" align="right" width="8%">Number</td>
                                                                                                        <td height="5" width="61%"> 
                                                                                                            <!--select name="group_by">
                                                    <%
            if (groupBy == 0) {
                rptKonstan.setGroupBy("Transaction");
            }
                                                                                                         %>
                                                    <option value="0" <%if (groupBy == 0) {%>selected<%}%>>Transaction</option>
                                                    <%
            if (groupBy == 3) {
                rptKonstan.setGroupBy("Sub Category");
            }
                                                                                                         %>
                                                    <option value="3" <%if (groupBy == 3) {%>selected<%}%>>Sub 
                                                    Category</option>
                                                                                                            </select-->
                                                                                                            <input type="text" name="src_number" value="<%=srcNumber%>">
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
            try {
                if (listReport.size() > 0) {
                                                                                        %>
                                                                                        <!--tr align="left" valign="top">   
                                                                                        <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                            <%
                                                                                                    Vector x = drawList(listReport, start, groupBy);
                                                                                                    String strTampil = (String) x.get(0);
                                                                                                    Vector rptObj = (Vector) x.get(1);
                                                                                         %>
                                            <%//=strTampil%> 
                                            <%
                                                                                                    //session.putValue("DETAIL", rptObj);
%>
                                          </td>  
                                        </tr-->
                                                                                 <%if (listReport != null && listReport.size() > 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">   
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td class="tablehdr" width="3%">No</td>
                                                                                                        <td class="tablehdr" width="8%">Number</td>
                                                                                                        <td class="tablehdr" width="9%">Date</td>
                                                                                                        <td class="tablehdr" width="10%">User</td>
                                                                                                        <td class="tablehdr" width="12%">From</td>
                                                                                                        <td class="tablehdr" width="12%">To</td>
                                                                                                        <td class="tablehdr" width="6%">Tot 
                                                                                                        Qty</td>
                                                                                                        <td class="tablehdr" width="8%">Amount</td>
                                                                                                        <td class="tablehdr" width="9%">Status</td>
                                                                                                        <td class="tablehdr" width="23%">Notes</td>
                                                                                                    </tr>
                                                                                                    <%
    for (int i = 0; i < listReport.size(); i++) {

        TransferReport transferReport = (TransferReport) listReport.get(i);

        Transfer transfer = new Transfer();
        User ux = new User();
        try {
            transfer = DbTransfer.fetchExc(transferReport.getOID());
            ux = DbUser.fetch(transfer.getUserId());
        } catch (Exception e) {
        }

        if (i % 2 == 0) {

                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%"> 
                                                                                                            <div align="center"><%=start + i + 1%></div> 
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="8%">   
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td width="87%"><%=transferReport.getPurchNumber()%></td>
                                                                                                                    <td width="13%"> 
                                                                                                                        <%if (transferId == transferReport.getOID()) {
                                                                                                                          if (slc == 0) {
                                                                                                                        %>
                                                                                                                        <a href="javascript:cmdGetDetail('<%=transfer.getOID()%>','1')"><img src="../images/plus.gif" border="0"></a> 
                                                                                                                        <%} else {%>
                                                                                                                        <a href="javascript:cmdGetDetail('<%=transfer.getOID()%>','0')"><img src="../images/minus.gif" border="0"></a> 
                                                                                                                        <%}
} else {%>
                                                                                                                        <a href="javascript:cmdGetDetail('<%=transfer.getOID()%>','1')"><img src="../images/plus.gif" border="0"></a> 
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="9%"> 
                                                                                                            <div align="center"><%=JSPFormater.formatDate(transferReport.getDate(), "dd-MM-yyyy")%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="10%"><%=ux.getLoginId()%></td>
                                                                                                        <td class="tablecell" width="12%"><%=transferReport.getLocationName()%></td>
                                                                                                        <td class="tablecell" width="12%"><%=transferReport.getLocationToName()%></td>
                                                                                                        <td class="tablecell" width="6%"> 
                                                                                                            <div align="right"><%=transferReport.getTotalQty()%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="8%"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(transferReport.getPurchAmount(), "##,###.##")%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="9%"> 
                                                                                                            <div align="center"><%=transfer.getStatus()%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="23%"><%=transfer.getNote().toLowerCase()%></td>
                                                                                                    </tr> 
                                                                                                    <%
                                                                                                                      if (transferId == transferReport.getOID() && slc == 1) {

                                                                                                                          Vector tempx = DbTransferItem.list(0, 0, "transfer_id=" + transferId, "");

                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="8%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="9%"><b>SKU</b></td>
                                                                                                        <td class="tablecell" width="10%"><b>Barcode</b></td>
                                                                                                        <td class="tablecell" colspan="2"><b>Name</b></td>
                                                                                                        <td class="tablecell" width="6%"> 
                                                                                                            <div align="right"><b>Qty</b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="8%"> 
                                                                                                            <div align="right"><b>Amount</b></div> 
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="9%"> 
                                                                                                            <div align="right"><b>Total</b></div> 
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="23%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%" height="1"></td>
                                                                                                        <td class="tablecell" width="8%" height="1"></td>
                                                                                                        <td width="9%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="10%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="12%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="12%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="6%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="8%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="9%" height="1" bgcolor="#000000"></td>
                                                                                                        <td class="tablecell" width="23%" height="1"></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        double totalx = 0;
                                                                                                        double totalQtyx = 0;

                                                                                                        if (tempx != null && tempx.size() > 0) {

                                                                                                            for (int xx = 0; xx < tempx.size(); xx++) {
                                                                                                                TransferItem ti = (TransferItem) tempx.get(xx);

                                                                                                                ItemMaster imx = new ItemMaster();
                                                                                                                ItemGroup igx = new ItemGroup();
                                                                                                                try {
                                                                                                                    imx = DbItemMaster.fetchExc(ti.getItemMasterId());
                                                                                                                //igx = DbItemGroup.fetchExc(imx.getItemGroupId());
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                                totalx = totalx + (ti.getQty() * ti.getPrice());
                                                                                                                totalQtyx = totalQtyx + ti.getQty();
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="8%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="9%" valign="top"><%=imx.getCode()%></td>
                                                                                                        <td class="tablecell" width="10%" valign="top"><%=imx.getBarcode()%></td>
                                                                                                        <td class="tablecell" colspan="2" valign="top"><%=imx.getName()%></td>
                                                                                                        <td class="tablecell" width="6%" valign="top"> 
                                                                                                            <div align="right"><%=ti.getQty()%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="8%" valign="top"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(ti.getPrice(), "##,###.##")%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="9%" valign="top"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(ti.getQty() * ti.getPrice(), "##,###.##")%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="23%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%" height="1"></td>
                                                                                                        <td class="tablecell" width="8%" height="1"></td>
                                                                                                        <td width="9%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="10%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="12%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="12%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="6%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="8%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="9%" height="1" bgcolor="#000000"></td>
                                                                                                        <td class="tablecell" width="23%" height="1"></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="8%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="9%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="10%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="12%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="12%"> 
                                                                                                            <div align="right"><b>Total</b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="6%"> 
                                                                                                            <div align="right"><b><%=totalQtyx%></b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="8%"> 
                                                                                                            <div align="right"></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="9%"> 
                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(totalx, "##,###.##")%></b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="23%"><a href="javascript:cmdPrintXLSTransfer()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close2111111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close2111111" border="0"></a></td>
                                                                                                    </tr>
                                                                                                    <%}//end slc
                                                                                                                  } else {%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell1" width="3%"> 
                                                                                                            <div align="center"><%=start + i + 1%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell1" width="8%"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td width="87%"><%=transferReport.getPurchNumber()%></td>
                                                                                                                    <td width="13%"> 
                                                                                                                        <%if (transferId == transferReport.getOID()) {
                                                                                                                          if (slc == 0) {
                                                                                                                        %>
                                                                                                                        <a href="javascript:cmdGetDetail('<%=transfer.getOID()%>','1')"><img src="../images/plus.gif" border="0"></a> 
                                                                                                                        <%} else {%>
                                                                                                                        <a href="javascript:cmdGetDetail('<%=transfer.getOID()%>','0')"><img src="../images/minus.gif" border="0"></a> 
                                                                                                                        <%}
} else {%>
                                                                                                                        <a href="javascript:cmdGetDetail('<%=transfer.getOID()%>','1')"><img src="../images/plus.gif" border="0"></a> 
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td class="tablecell1" width="9%"> 
                                                                                                            <div align="center"><%=JSPFormater.formatDate(transferReport.getDate(), "dd-MM-yyyy")%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell1" width="10%"><%=ux.getLoginId()%></td>
                                                                                                        <td class="tablecell1" width="12%"><%=transferReport.getLocationName()%></td>
                                                                                                        <td class="tablecell1" width="12%"><%=transferReport.getLocationToName()%></td>
                                                                                                        <td class="tablecell1" width="6%"> 
                                                                                                            <div align="right"><%=transferReport.getTotalQty()%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell1" width="8%"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(transferReport.getPurchAmount(), "##,###.##")%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell1" width="9%"> 
                                                                                                            <div align="center"><%=transfer.getStatus()%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell1" width="23%"><%=transfer.getNote().toLowerCase()%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                                      if (transferId == transferReport.getOID() && slc == 1) {

                                                                                                                          Vector tempx = DbTransferItem.list(0, 0, "transfer_id=" + transferId, "");

                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="8%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="9%"><b>SKU</b></td>
                                                                                                        <td class="tablecell" width="10%"><b>Barcode</b></td>
                                                                                                        <td class="tablecell" colspan="2"><b>Name</b></td>
                                                                                                        <td class="tablecell" width="6%"> 
                                                                                                            <div align="right"><b>Qty</b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="8%"> 
                                                                                                            <div align="right"><b>Amount</b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="9%"> 
                                                                                                            <div align="right"><b>Total</b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="23%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%" height="1"></td>
                                                                                                        <td class="tablecell" width="8%" height="1"></td>
                                                                                                        <td width="9%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="10%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="12%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="12%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="6%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="8%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="9%" height="1" bgcolor="#000000"></td>
                                                                                                        <td class="tablecell" width="23%" height="1"></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        double totalx = 0;
                                                                                                        double totalQtyx = 0;

                                                                                                        if (tempx != null && tempx.size() > 0) {

                                                                                                            for (int xx = 0; xx < tempx.size(); xx++) {
                                                                                                                TransferItem ti = (TransferItem) tempx.get(xx);

                                                                                                                ItemMaster imx = new ItemMaster();
                                                                                                                ItemGroup igx = new ItemGroup();
                                                                                                                try {
                                                                                                                    imx = DbItemMaster.fetchExc(ti.getItemMasterId());
                                                                                                                //igx = DbItemGroup.fetchExc(imx.getItemGroupId());
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                                totalx = totalx + (ti.getQty() * ti.getPrice());
                                                                                                                totalQtyx = totalQtyx + ti.getQty();
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="8%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="9%" valign="top"><%=imx.getCode()%></td>
                                                                                                        <td class="tablecell" width="10%" valign="top"><%=imx.getBarcode()%></td>
                                                                                                        <td class="tablecell" colspan="2" valign="top"><%=imx.getName()%></td>
                                                                                                        <td class="tablecell" width="6%" valign="top"> 
                                                                                                            <div align="right"><%=ti.getQty()%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="8%" valign="top"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(ti.getPrice(), "##,###.##")%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="9%" valign="top"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(ti.getQty() * ti.getPrice(), "##,###.##")%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="23%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%" height="1"></td>
                                                                                                        <td class="tablecell" width="8%" height="1"></td>
                                                                                                        <td width="9%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="10%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="12%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="12%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="6%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="8%" height="1" bgcolor="#000000"></td>
                                                                                                        <td width="9%" height="1" bgcolor="#000000"></td>
                                                                                                        <td class="tablecell" width="23%" height="1"></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" width="3%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="8%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="9%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="10%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="12%">&nbsp;</td>
                                                                                                        <td class="tablecell" width="12%">
                                                                                                            <div align="right"><b>Total</b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="6%">
                                                                                                            <div align="right"><b><%=totalQtyx%></b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="8%"> 
                                                                                                            <div align="right"></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="9%"> 
                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(totalx, "##,###.##")%></b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" width="23%"><a href="javascript:cmdPrintXLSTransfer()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close2111112','','../images/print2.gif',1)"><img src="../images/print.gif" name="close2111112" border="0"></a></td>
                                                                                                    </tr>
                                                                                                    <%}//end slc

        }
    }%>
                                                                                                    <tr> 
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td width="8%">&nbsp;</td>
                                                                                                        <td width="9%">&nbsp;</td>
                                                                                                        <td width="10%">&nbsp;</td>
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="6%">&nbsp;</td>
                                                                                                        <td width="8%">&nbsp;</td>
                                                                                                        <td width="9%">&nbsp;</td>
                                                                                                        <td width="23%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%  }
            } catch (Exception exc) {
                System.out.println("sdsdf : " + exc.toString());
            }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"> 
                                                                                                <span class="command"> 
                                                                                                    <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevJSPCommand;
                }
            }
                                                                                                    %>
                                                                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();

            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="13" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if (listReport != null && listReport.size() > 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></td>
                                                                                        </tr>
                                                                                        <%}%>
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
