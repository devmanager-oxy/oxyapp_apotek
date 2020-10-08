
<%-- 
    Document   : rptbeliputus
    Created on : Mar 10, 2013, 2:54:21 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %> 
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BELI_PUTUS);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BELI_PUTUS, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BELI_PUTUS, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%
            
            if(session.getValue("REPORT_BELI_PUTUS")!=null){
		session.removeValue("REPORT_BELI_PUTUS");
            }            
            
            if(session.getValue("REPORT_BP_RESULT")!=null){
		session.removeValue("REPORT_BP_RESULT");
            }            
            
            if(session.getValue("REPORT_BP_BEGIN")!=null){
		session.removeValue("REPORT_BP_BEGIN");
            }            
            
            if(session.getValue("REPORT_BP_RECEIVE")!=null){
		session.removeValue("REPORT_BP_RECEIVE");
            }            
            
            if(session.getValue("REPORT_BP_SOLD")!=null){
		session.removeValue("REPORT_BP_SOLD");
            }            
            
            if(session.getValue("REPORT_BP_RETUR")!=null){
		session.removeValue("REPORT_BP_RETUR");
            }   

            if(session.getValue("REPORT_BP_TRANSFER_IN")!=null){
		session.removeValue("REPORT_BP_TRANSFER_IN");
            }   
            
            if(session.getValue("REPORT_BP_TRANS_IN")!=null){
		session.removeValue("REPORT_BP_TRANS_IN");
            }            
            
            if(session.getValue("REPORT_BP_TRANS_OUT")!=null){
		session.removeValue("REPORT_BP_TRANS_OUT");
            }            
            
            if(session.getValue("REPORT_BP_ADJ")!=null){
		session.removeValue("REPORT_BP_ADJ");
            }            
            
            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");                           
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            int chkInvDate = 0;            
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long vendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long groupId = JSPRequestValue.requestLong(request, "src_category_id");
            
            Vector result = new Vector();
            Hashtable sBegin = new Hashtable();
            Hashtable sReceive = new Hashtable();            
            Hashtable sSold = new Hashtable();
            Hashtable sRetur = new Hashtable();            
            Hashtable sTransIn = new Hashtable();
            Hashtable sTransOut = new Hashtable();
            Hashtable sAdjustment = new Hashtable();
            Hashtable sCogs = new Hashtable() ;
            
            if(iJSPCommand == JSPCommand.SEARCH){
                ReportParameter rp = new ReportParameter();
                rp.setLocationId(locationId);
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                rp.setIgnore(chkInvDate);                                                     
                rp.setVendorId(vendorId);
                rp.setCategoryId(groupId);
                session.putValue("REPORT_BELI_PUTUS", rp);
                
                result = SessReportSales.reportItemBeliPutus(vendorId,groupId);
                sBegin = SessReportSales.reportBeliPutusBeginingSelling(invStartDate, chkInvDate, vendorId,locationId,groupId);
                sReceive = SessReportSales.reportBeliPutusBySelling(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_INCOMING_GOODS,locationId,groupId);                
                
                sSold = SessReportSales.reportBeliPutusBySellingPosSales(invStartDate, invEndDate, chkInvDate, vendorId, locationId,groupId);                                                                
                sRetur = SessReportSales.reportBeliPutusBySelling(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_RETUR_GOODS,locationId,groupId);                                
                sTransIn = SessReportSales.reportBeliPutusBySelling(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_TRANSFER_IN,locationId,groupId);
                
                sTransOut = SessReportSales.reportBeliPutusBySelling(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_TRANSFER,locationId,groupId);
                sAdjustment = SessReportSales.reportBeliPutusBySelling(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_ADJUSTMENT,locationId,groupId);
                sCogs = SessReportSales.getVLastCOGS(invEndDate, vendorId,locationId,groupId);
                
                session.putValue("REPORT_BP_RESULT", result);
                session.putValue("REPORT_BP_BEGIN", sBegin);
                session.putValue("REPORT_BP_RECEIVE", sReceive);
                session.putValue("REPORT_BP_SOLD", sSold);                
                session.putValue("REPORT_BP_RETUR", sRetur);
                session.putValue("REPORT_BP_TRANS_IN", sTransIn);
                session.putValue("REPORT_BP_TRANS_OUT", sTransOut);
                session.putValue("REPORT_BP_ADJ", sAdjustment);
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
                window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintXLS(){	                       
                window.open("<%=printroot%>.report.RptBeliPutusXls?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                document.frmsales.action="rptbeliputus.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                                                        <tr> 
                                                                            <td valign="top"> 
                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                                                    <!--DWLayoutTable-->
                                                                                    <tr> 
                                                                                        <td width="100%" valign="top"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td> 
                                                                                                        <form name="frmsales" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                            
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                                                                                                                                                                                        
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                <span class="lvl2">Report Beli Putus<br></span></font></b></td>
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
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="100" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td >&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td height="14">Date Between</td>
                                                                                                                                            <td >
                                                                                                                                                <table cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td > 
                                                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                        <td>    
                                                                                                                                                            &nbsp;&nbsp;and&nbsp;&nbsp;
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>   
                                                                                                                                         <tr> 
                                                                                                                                            <td height="14">Category</td>
                                                                                                                                            <td height="14"> 
                                                                                                                                                <%
            Vector vCategory = DbItemGroup.list(0, 0, "", ""+DbItemGroup.colNames[DbItemGroup.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_category_id">    
                                                                                                                                                    <option value="0">--All --</option>
                                                                                                                                                    <%if (vCategory != null && vCategory.size() > 0) {
                for (int i = 0; i < vCategory.size(); i++) {
                    ItemGroup ic = (ItemGroup) vCategory.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=ic.getOID()%>" <%if (ic.getOID() == groupId) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td height="14" nowrap>Suplier</td>
                                                                                                                                            <td height="14"> 
                                                                                                                                            <% 
                                                                                                                                            Vector vVendor = DbVendor.list(0, 0, "", DbVendor.colNames[DbVendor.COL_NAME]);                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                                 <select name="src_vendor_id">   
                                                                                                                                                    <option value="0">--All --</option>
                                                                                                                                                    <%if (vVendor != null && vVendor.size() > 0) {
                for (int i = 0; i < vVendor.size(); i++) {
                    Vendor v = (Vendor) vVendor.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=v.getOID()%>" <%if (v.getOID() == vendorId) {%>selected<%}%>><%=v.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td height="14">Location</td>
                                                                                                                                            <td height="14"> 
                                                                                                                                                <%
            Vector vLoc = userLocations;
                                                                                                                                                %>
                                                                                                                                                <select name="src_location_id">                                                                                                                                                    
                                                                                                                                                    <%if (vLoc != null && vLoc.size() > 0){
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>                                                                                                                                            
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td height="33">&nbsp;</td>
                                                                                                                                            <td height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                            Vector rptVector = new Vector();
                if (result != null && result.size() >0 ){
%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="1600" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablehdr" rowspan="2" width="4%"><font face="arial">SKU</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" rowspan="2"><font face="arial">NAMA BARANG</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" colspan="3" ><font face="arial">STOCK AWAL</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" colspan="3" ><font face="arial">PEMBELIAN</td>
                                                                                                                                            <td class="tablehdr" colspan="3" ><font face="arial">PENJUALAN</td>
                                                                                                                                            <td class="tablehdr" rowspan="2" width="4%"><font face="arial">COGS</td>
                                                                                                                                            <td class="tablehdr" rowspan="2" width="4%"><font face="arial">PROFIT MARGIN</td>
                                                                                                                                            <td class="tablehdr" rowspan="2" width="4%"><font face="arial">% PROFIT</td>
                                                                                                                                            <td class="tablehdr" colspan="3" ><font face="arial">RETUR BELI</td>
                                                                                                                                            <td class="tablehdr" colspan="3" ><font face="arial">SALDO AKHIR</td>
                                                                                                                                            <td class="tablehdr" rowspan="2" width="4%"><font face="arial">KOREKSI QTY</td>
                                                                                                                                            <td class="tablehdr" rowspan="2" width="4%"><font face="arial">S. AKHIR REAL</td>                                                                                                                                                                                                                                                                                       
                                                                                                                                        </tr>   
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablehdr" width="3%"><font face="arial">QTY</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="4%"><font face="arial">PRICE</font></td>
                                                                                                                                            <td class="tablehdr" width="5%"><font face="arial">NILAI</font></td>
                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="3%"><font face="arial">QTY</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="4%"><font face="arial">PRICE</font></td>
                                                                                                                                            <td class="tablehdr" width="5%"><font face="arial">NILAI</font></td>
                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="3%"><font face="arial">QTY</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="4%"><font face="arial">PRICE</font></td>
                                                                                                                                            <td class="tablehdr" width="5%"><font face="arial">NILAI</font></td>
                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="3%"><font face="arial">QTY</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="4%"><font face="arial">PRICE</font></td>
                                                                                                                                            <td class="tablehdr" width="5%"><font face="arial">NILAI</font></td>
                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="3%"><font face="arial">QTY</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="4%"><font face="arial">PRICE</font></td>
                                                                                                                                            <td class="tablehdr" width="5%"><font face="arial">NILAI</font></td>
                                                                                                                                        </tr>
                                                                                                                                        <%  
                                                                                                                                        double tot1 = 0;
                                                                                                                                        double tot2 = 0;
                                                                                                                                        double tot3 = 0;
                                                                                                                                        double tot4 = 0;
                                                                                                                                        double tot5 = 0;
                                                                                                                                        double tot6 = 0;
                                                                                                                                        double tot7 = 0;
                                                                                                                                        double tot8 = 0;
                                                                                                                                        double tot9 = 0;
                                                                                                                                        double tot10 = 0;                                                                                                                                        
                                                                                                                                        
                                                                                                                                        double tot11 = 0;  
                                                                                                                                        double tot12 = 0;  
                                                                                                                                        double tot13 = 0;  
                                                                                                                                        double tot14 = 0;  
                                                                                                                                        double tot15 = 0;  
                                                                                                                                        double tot16 = 0;  
                                                                                                                                        double tot17 = 0;  
                                                                                                                                        double tot18 = 0;  
                                                                                                                                        double tot19 = 0;                                                                                                                                          
                                                                                                                                        
                                                                                                                                        for(int i = 0 ; i < result.size() ; i++){ 
                                                                                                                                            
                                                                                                                                         ReportBeliPutus rsm = (ReportBeliPutus)result.get(i);
                                                                                                                                         //RptBeliPutus rptBeli = new RptBeliPutus();
                                                                                                                                         
                                                                                                                                         double price = 0;
                                                                                                                                         double lastCogs = 0;
                                                                                                                                         try{
                                                                                                                                            //lastCogs = SessReportSales.getLastCOGS(locationId,rsm.getItemMasterId(),invEndDate);  
                                                                                                                                            //lastCogs =Double.parseDouble(""+sCogs.get(""+rsm.getItemMasterId()));
                                                                                                                                             try {                        
                                                                                                                                                    lastCogs = SessReportSales.getLastPrice(rsm.getItemMasterId(), invEndDate); 
                                                                                                                                                    if(lastCogs == 0){
                                                                                                                                                        lastCogs = SessReportSales.getLastHargaBeli(rsm.getItemMasterId(), invEndDate,vendorId);     
                                                                                                                                                    }
                                                                                                                                                    if(lastCogs == 0){
                                                                                                                                                        lastCogs = SessReportSales.getLastHargaBeli(rsm.getItemMasterId());     
                                                                                                                                                    }
                                                                                                                                                    
                                                                                                                                             } catch (Exception e) {}
                                                                                                                                            
                                                                                                                                         }catch(Exception e){}
                                                                                                                                         
                                                                                                                                         ReportBeliPutus begin = new ReportBeliPutus();                                                                                                                                         
                                                                                                                                         try{
                                                                                                                                            if(sBegin != null && sBegin.size() > 0){
                                                                                                                                                begin = (ReportBeliPutus)sBegin.get(""+rsm.getItemMasterId());
                                                                                                                                            }
                                                                                                                                         }catch(Exception e){}
                                                                                                                                         
                                                                                                                                         if(begin == null){
                                                                                                                                             begin = new ReportBeliPutus();
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         ReportBeliPutus receive = new ReportBeliPutus();
                                                                                                                                         try{
                                                                                                                                             if(sReceive != null && sReceive.size() > 0){
                                                                                                                                                receive = (ReportBeliPutus)sReceive.get(""+rsm.getItemMasterId());
                                                                                                                                             }   
                                                                                                                                         }catch(Exception e){}
                                                                                                                                         
                                                                                                                                         if(receive == null){
                                                                                                                                             receive = new ReportBeliPutus();
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         ReportBeliPutus sold = new ReportBeliPutus();
                                                                                                                                         try{
                                                                                                                                             if(sSold != null && sSold.size() > 0){
                                                                                                                                                sold = (ReportBeliPutus)sSold.get(""+rsm.getItemMasterId());
                                                                                                                                                price = sold.getCost();
                                                                                                                                              }  
                                                                                                                                         }catch(Exception e){}
                                                                                                                                         
                                                                                                                                         if(sold == null){
                                                                                                                                             sold = new ReportBeliPutus();
                                                                                                                                         }           
                                                                                                                                                                                                                                                                      
                                                                                                                                         ReportBeliPutus retur = new ReportBeliPutus();
                                                                                                                                         try{
                                                                                                                                             if(sRetur != null && sRetur.size() > 0){
                                                                                                                                                retur = (ReportBeliPutus)sRetur.get(""+rsm.getItemMasterId());
                                                                                                                                            }
                                                                                                                                         }catch(Exception e){}
                                                                                                                                         
                                                                                                                                         if(retur == null){
                                                                                                                                             retur = new ReportBeliPutus();
                                                                                                                                         }  
                                                                                                                                                                                                                                                                               
                                                                                                                                         ReportBeliPutus transIn = new ReportBeliPutus();
                                                                                                                                         try{
                                                                                                                                            if(sTransIn != null && sTransIn.size() > 0){
                                                                                                                                                transIn = (ReportBeliPutus)sTransIn.get(""+rsm.getItemMasterId());
                                                                                                                                            }
                                                                                                                                         }catch(Exception e){}
                                                                                                                                         
                                                                                                                                         if(transIn == null){
                                                                                                                                             transIn = new ReportBeliPutus();
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         double hargaCost = 0;
                                                                                                                                         double incoming = transIn.getQty() + receive.getQty();
                                                                                                                                         if(receive.getQty() == 0){
                                                                                                                                             hargaCost = transIn.getCost();                                                                                                                                             
                                                                                                                                         }else{
                                                                                                                                             hargaCost = receive.getCost();
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         double tOut = 0;
                                                                                                                                         double priceTOut = 0;
                                                                                                                                                 
                                                                                                                                         ReportBeliPutus transOut = new ReportBeliPutus();
                                                                                                                                         try{
                                                                                                                                            if(sTransOut != null && sTransOut.size() > 0){
                                                                                                                                                transOut = (ReportBeliPutus)sTransOut.get(""+rsm.getItemMasterId());
                                                                                                                                                tOut = transOut.getQty();
                                                                                                                                                priceTOut = transOut.getCost();
                                                                                                                                            }
                                                                                                                                         }catch(Exception e){}
                                                                                                                                         
                                                                                                                                         if(transOut == null){
                                                                                                                                             transOut = new ReportBeliPutus();
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         ReportBeliPutus adjustment = new ReportBeliPutus();
                                                                                                                                         try{
                                                                                                                                             if(sAdjustment != null && sAdjustment.size() > 0){
                                                                                                                                                adjustment = (ReportBeliPutus)sAdjustment.get(""+rsm.getItemMasterId());
                                                                                                                                              }  
                                                                                                                                         }catch(Exception e){}
                                                                                                                                         
                                                                                                                                         if(adjustment == null){
                                                                                                                                             adjustment = new ReportBeliPutus();
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         String strTmpSA = JSPFormater.formatNumber(0.00, "#,###.##");
                                                                                                                                         double tmpSA = 0;
                                                                                                                                         if(begin.getQty() == 0 ||  lastCogs == 0){
                                                                                                                                            tmpSA = 0;
                                                                                                                                         }else{
                                                                                                                                             tmpSA = begin.getQty() * lastCogs;
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         if(tmpSA != 0){                                                                                                                                                                                                                                                                                   
                                                                                                                                            if(tmpSA < 0){                                                                                                                                                
                                                                                                                                                strTmpSA = "("+JSPFormater.formatNumber(tmpSA * -1, "#,###.##")+")";
                                                                                                                                            }else{
                                                                                                                                                strTmpSA = JSPFormater.formatNumber(tmpSA, "#,###.##");
                                                                                                                                            }
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         String strTmpReceive = JSPFormater.formatNumber(0.00, "#,###.##");
                                                                                                                                         
                                                                                                                                         double tmpReceive = 0;
                                                                                                                                         if(incoming == 0 || hargaCost == 0){
                                                                                                                                             tmpReceive = 0;
                                                                                                                                         }else{
                                                                                                                                             tmpReceive = incoming * hargaCost;
                                                                                                                                         }     
                                                                                                                                         
                                                                                                                                         if(tmpReceive != 0){
                                                                                                                                            if(tmpReceive < 0){                                                                                                                                                
                                                                                                                                                strTmpReceive = "("+JSPFormater.formatNumber(tmpReceive * -1, "#,###.##")+")";
                                                                                                                                            }else{
                                                                                                                                                strTmpReceive = JSPFormater.formatNumber(tmpReceive, "#,###.##");
                                                                                                                                            }
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         double tmpPrice = 0;
                                                                                                                                         String strTmpPrice = JSPFormater.formatNumber(0.0, "#,###.##");
                                                                                                                                         
                                                                                                                                         double soldx = sold.getQty() != 0 ? sold.getQty()*-1 : sold.getQty(); 
                                                                                                                                         
                                                                                                                                         if(soldx == 0 || price == 0){
                                                                                                                                            tmpPrice = 0;
                                                                                                                                         }else{
                                                                                                                                            tmpPrice = soldx * price;
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         if(tmpPrice < 0){                                                                                                                                                
                                                                                                                                            strTmpPrice = "("+JSPFormater.formatNumber(tmpPrice * -1, "#,###.##")+")";
                                                                                                                                         }else{
                                                                                                                                            strTmpPrice = JSPFormater.formatNumber(tmpPrice, "#,###.##");
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         String strCogs = JSPFormater.formatNumber(0.0, "#,###.##");
                                                                                                                                         double cogs = 0;
                                                                                                                                         if(lastCogs == 0 || sold.getQty() == 0){
                                                                                                                                             cogs = 0;
                                                                                                                                         }else{
                                                                                                                                             cogs = lastCogs * sold.getQty() *-1;
                                                                                                                                         } 
                                                                                                                                         
                                                                                                                                         if(cogs < 0){                                                                                                                                                
                                                                                                                                            strCogs = "("+JSPFormater.formatNumber(cogs * -1, "#,###.##")+")";
                                                                                                                                         }else{
                                                                                                                                            strCogs = JSPFormater.formatNumber(cogs, "#,###.##");
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         //prpfit margin                                                                                                                                         
                                                                                                                                         String strProfit = JSPFormater.formatNumber(0.0, "#,###.##");
                                                                                                                                         double profit = tmpPrice - cogs;
                                                                                                                                         if(profit < 0){                                                                                                                                                
                                                                                                                                            strProfit = "("+JSPFormater.formatNumber(profit * -1, "#,###.##")+")";
                                                                                                                                         }else{
                                                                                                                                            strProfit = JSPFormater.formatNumber(profit, "#,###.##");
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         //profit %
                                                                                                                                         String strPersenProfit = JSPFormater.formatNumber(0.0, "#,###.##");
                                                                                                                                         double persenProfit = 0;
                                                                                                                                         if(profit != 0 || tmpPrice != 0){
                                                                                                                                            persenProfit = (profit/tmpPrice)*100;
                                                                                                                                         }             
                                                                                                                                                                                                                                                                    
                                                                                                                                         if(persenProfit < 0){                                                                                                                                                
                                                                                                                                            strPersenProfit = "("+JSPFormater.formatNumber(persenProfit * -1, "#,###.##")+")";
                                                                                                                                         }else{
                                                                                                                                            strPersenProfit = JSPFormater.formatNumber(persenProfit, "#,###.##");
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         //=========Retur
                                                                                                                                         String strAmountRetur = JSPFormater.formatNumber(0.0, "#,###.##");
                                                                                                                                         double amountRetur = 0;
                                                                                                                                         
                                                                                                                                         double aRetur = retur.getQty() != 0 ? retur.getQty()*-1 : retur.getQty();
                                                                                                                                         double aTOut = tOut != 0 ? tOut*-1 : tOut ;

                                                                                                                                         aRetur = aRetur + aTOut;                                                                                                                                         
                                                                                                                                         double priceRetur = retur.getCost() == 0  ? priceTOut : retur.getCost();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                         
                                                                                                                                         if(aRetur != 0 && priceRetur != 0){
                                                                                                                                            amountRetur = aRetur*priceRetur;
                                                                                                                                         }   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                         if(amountRetur < 0){                                                                                                                                                
                                                                                                                                            strAmountRetur = "("+JSPFormater.formatNumber(amountRetur * -1, "#,###.##")+")";
                                                                                                                                         }else{
                                                                                                                                            strAmountRetur = JSPFormater.formatNumber(amountRetur, "#,###.##");
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         //==saldo akhir
                                                                                                                                         double saldoAkhir = begin.getQty() + incoming + sold.getQty() - aRetur;
                                                                                                                                         //double saldoAkhir = aRetur;
                                                                                                                                         
                                                                                                                                         String strAmountSaldoAkhir = JSPFormater.formatNumber(0.0, "#,###.##");
                                                                                                                                         double amountSaldoAkhir = 0;
                                                                                                                                         if(saldoAkhir != 0 && lastCogs != 0 ){
                                                                                                                                             amountSaldoAkhir = lastCogs * saldoAkhir;
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         if(amountSaldoAkhir < 0){                                                                                                                                                
                                                                                                                                            strAmountSaldoAkhir = "("+JSPFormater.formatNumber(amountSaldoAkhir * -1, "#,###.##")+")";
                                                                                                                                         }else{
                                                                                                                                            strAmountSaldoAkhir = JSPFormater.formatNumber(amountSaldoAkhir, "#,###.##");
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         tot1 = tot1 + begin.getQty();
                                                                                                                                         tot2 = tot2 + lastCogs;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
                                                                                                                                         tot3 = tot3 + tmpSA;
                                                                                                                                         
                                                                                                                                         tot4 = tot4 + incoming;
                                                                                                                                         tot5 = tot5 + hargaCost;                                                                                                                                         
                                                                                                                                         tot6 = tot6 + tmpReceive;
                                                                                                                                         
                                                                                                                                         tot7 = tot7 + soldx;
                                                                                                                                         tot8 = tot8 + price;
                                                                                                                                         tot9 = tot9 + tmpPrice;
                                                                                                                                         
                                                                                                                                         tot10 = tot10 + cogs;
                                                                                                                                         tot11 = tot11 + profit;
                                                                                                                                         tot12 = tot12 + persenProfit;                                                                                                                                                                                                                                                                                 
                                                                                                                                         tot13 = tot13 + aRetur;
                                                                                                                                         tot14 = tot14 + retur.getCost();                                                                                                                                         
                                                                                                                                         tot15 = tot15 + amountRetur;
                                                                                                                                         tot16 = tot16 + saldoAkhir;
                                                                                                                                         tot17 = tot17 + lastCogs;
                                                                                                                                         tot18 = tot18 + amountSaldoAkhir;
                                                                                                                                         tot19 = tot19 + saldoAkhir;
                                                                                                                                         
                                                                                                                                         
                                                                                                                                         /*rptBeli.setItemMasterId(rsm.getItemMasterId());
                                                                                                                                         rptBeli.setSku(rsm.getSku());
                                                                                                                                         rptBeli.setStockAwalQty(begin.getQty());
                                                                                                                                         rptBeli.setStockAwalPrice(lastCogs);
                                                                                                                                         rptBeli.setPembelianQty(incoming);
                                                                                                                                         rptBeli.setPembelianPrice(hargaCost);
                                                                                                                                         
                                                                                                                                         rptBeli.setPenjualanQty(sold.getQty());
                                                                                                                                         rptBeli.setPenjualanPrice(price);
                                                                                                                                         rptBeli.setCogs(cogs);
                                                                                                                                         
                                                                                                                                         rptBeli.setReturQty(aRetur);
                                                                                                                                         rptBeli.setReturPrice*/
                                                                                                                                         
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell" align="center"><%=rsm.getSku()%></td>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="left">&nbsp;<%=rsm.getDescription()%></td>
                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(begin.getQty(), "#,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(lastCogs, "#,###.##")%></td>                                                                                                                                             
                                                                                                                                            <td class="tablecell" align="right"><%=strTmpSA%></td> 
                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(incoming, "#,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(hargaCost, "#,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=strTmpReceive%></td>
                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(sold.getQty() != 0 ? sold.getQty()*-1 : sold.getQty(), "#,###.##") %></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(price, "#,###.##") %></td>
                                                                                                                                            <td class="tablecell" align="right"><%=strTmpPrice%></td> 
                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><%=strCogs%></td>                                                                                                                                                
                                                                                                                                            <td class="tablecell" align="right"><%=strProfit%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=strPersenProfit%></td>
                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(aRetur, "#,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(priceRetur, "#,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=strAmountRetur%></td>
                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(saldoAkhir, "#,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(lastCogs, "#,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=strAmountSaldoAkhir%></td>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right">&nbsp;</td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(saldoAkhir, "#,###.##")%></td>
                                                                                                                                            
                                                                                                                                        </tr>    
                                                                                                                                        <%}%>                                                                                                                                        
                                                                                                                                        <tr height="20">                                                                                                                                             
                                                                                                                                            <td class="tablecell" align="right" colspan="2"><B>GRAND TOTAL</B>&nbsp;&nbsp;</td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot1, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot2, "#,###.##")%></B></td>
                                                                                                                                            <% 
                                                                                                                                            String strTot3 = "";
                                                                                                                                            if(tot3 < 0){                                                                                                                                                
                                                                                                                                                strTot3 = "("+JSPFormater.formatNumber(tot3 * -1, "#,###.##")+")";
                                                                                                                                            }else{
                                                                                                                                                strTot3 = JSPFormater.formatNumber(tot3, "#,###.##");
                                                                                                                                            }
                                                                                                                                            %>
                                                                                                                                            <td class="tablecell" align="right"><B><%=strTot3%></B></td>                                                                                                                                            
                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot4, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot5, "#,###.##")%></B></td>
                                                                                                                                            <% 
                                                                                                                                            String strTot6 = "";
                                                                                                                                            if(tot6 < 0){                                                                                                                                                
                                                                                                                                                strTot6 = "("+JSPFormater.formatNumber(tot6 * -1, "#,###.##")+")";
                                                                                                                                            }else{
                                                                                                                                                strTot6 = JSPFormater.formatNumber(tot6, "#,###.##");
                                                                                                                                            }
                                                                                                                                            %>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><B><%=strTot6%></B></td>
                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot7, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot8, "#,###.##")%></B></td>                                                                                                                                            
                <%                                                                                                                            
                String strTot9 = "";
                if (tot9 < 0) {                    
                    strTot9 = "(" + JSPFormater.formatNumber(tot9, "#,###.##") + ")";
                } else {
                    strTot9 = JSPFormater.formatNumber(tot9, "#,###.##");
                }%>
                                                                                                                                            <td class="tablecell" align="right"><B><%=strTot9%></B></td>
                                                                                                                                            <% 
                                                                                                                                            String strTot10 = "";
                if (tot10 < 0) {                    
                    strTot10 = "(" + JSPFormater.formatNumber(tot10, "#,###.##") + ")";
                } else {
                    strTot10 = JSPFormater.formatNumber(tot10, "#,###.##");
                }
                                                                                                                                            
                                                                                                                                            %>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><B><%=strTot10%></B></td>
                                                                                                                                            <% 
                                                                                                                                            String strTot11 = "";
                if (tot11 < 0) {                    
                    strTot11 = "(" + JSPFormater.formatNumber(tot11, "#,###.##") + ")";
                } else {
                    strTot11 = JSPFormater.formatNumber(tot11, "#,###.##");
                }
                                                                                                                                            
                                                                                                                                            %>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><B><%=strTot11%></B></td>
                                                                                                                                            <% 
                                                                                                                                            String strTot12 = "";
                if (tot12 < 0) {                    
                    strTot12 = "(" + JSPFormater.formatNumber(tot12, "#,###.##") + ")";
                } else {
                    strTot12 = JSPFormater.formatNumber(tot12, "#,###.##");
                }
                                                                                                                                            
                                                                                                                                            %>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><B><%=strTot12%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot13, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot14, "#,###.##")%></B></td>
                                                                                                                                            <% 
                                                                                                                                            String strTot15 = "";
                if (tot15 < 0) {                    
                    strTot15 = "(" + JSPFormater.formatNumber(tot15, "#,###.##") + ")";
                } else {
                    strTot15 = JSPFormater.formatNumber(tot15, "#,###.##");
                }
                                                                                                                                            
                                                                                                                                            %>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><B><%=strTot15%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot16, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot17, "#,###.##")%></B></td>
                                                                                                                                            <% 
                                                                                                                                            String strTot18 = "";
                if (tot18 < 0){                    
                    strTot18 = "(" + JSPFormater.formatNumber(tot18, "#,###.##") + ")";
                } else {
                    strTot18 = JSPFormater.formatNumber(tot18, "#,###.##");
                }
                                                                                                                                            
                                                                                                                                            %>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><B><%=strTot18%></B></td>
                                                                                                                                            <td class="tablecell" align="right">&nbsp;</td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot19, "#,###.##")%></B></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="15" height="25"></td>
                                                                                                                                        </tr>                                                                                                                                       
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;</td>     
                                                                                                                            </tr> 
                                                                                                                            <%if(privPrint){%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" height="22" border="0"></a>
                                                                                                                                </td>     
                                                                                                                            </tr>     
                                                                                                                            <%}%>
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </form>
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
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    <!-- #EndEditable --> </td>
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
                            <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

