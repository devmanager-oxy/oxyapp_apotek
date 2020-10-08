
<%-- 
    Document   : rptconsignedbycost
    Created on : Dec 12, 2012, 11:07:51 AM
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
<% int appObjCode = 1;%>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean masterPriv = true;
            boolean masterPrivView = true;
            boolean masterPrivUpdate = true;
%>
<!-- Jsp Block -->
<%
            
            if(session.getValue("REPORT_KONSINYASI_COST")!=null){
		session.removeValue("REPORT_KONSINYASI_COST");
            }            
            
            if(session.getValue("REPORT_KONSINYASI_COST_RESULT")!=null){
		session.removeValue("REPORT_KONSINYASI_COST_RESULT");
            }            
            
            if(session.getValue("REPORT_KONSINYASI_COST_BEGIN")!=null){
		session.removeValue("REPORT_KONSINYASI_COST_BEGIN");
            }            
            
            if(session.getValue("REPORT_KONSINYASI_COST_RECEIVE")!=null){
		session.removeValue("REPORT_KONSINYASI_COST_RECEIVE");
            }            
            
            if(session.getValue("REPORT_KONSINYASI_COST_SOLD")!=null){
		session.removeValue("REPORT_KONSINYASI_COST_SOLD");
            }

            if(session.getValue("REPORT_KONSINYASI_COST_RETUR")!=null){
		session.removeValue("REPORT_KONSINYASI_COST_RETUR");
            }
            
            if(session.getValue("REPORT_KONSINYASI_COST_TI")!=null){
		session.removeValue("REPORT_KONSINYASI_COST_TI");
            }
            
            if(session.getValue("REPORT_KONSINYASI_COST_TO")!=null){
		session.removeValue("REPORT_KONSINYASI_COST_TO");
            }
            
            if(session.getValue("REPORT_KONSINYASI_COST_ADJ")!=null){
		session.removeValue("REPORT_KONSINYASI_COST_ADJ");
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
            
            Vector result = new Vector();
            Hashtable sBegin = new Hashtable();
            Hashtable sReceive = new Hashtable();
            Hashtable sSold = new Hashtable();
            Hashtable sRetur = new Hashtable();            
            Hashtable sTransIn = new Hashtable();
            Hashtable sTransOut = new Hashtable();
            Hashtable sAdjustment = new Hashtable();
            
            if(iJSPCommand == JSPCommand.SEARCH){
                ReportParameter rp = new ReportParameter();
                rp.setLocationId(locationId);
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                rp.setIgnore(chkInvDate);                                                     
                rp.setVendorId(vendorId);
                session.putValue("REPORT_KONSINYASI_COST", rp);
                
                result = SessReportSales.reportItemConsignedByCost(vendorId);                                              
                sBegin = SessReportSales.reportConsignedByCostBegining(invStartDate, chkInvDate, vendorId,locationId);
                sReceive = SessReportSales.reportConsignedByCost(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_INCOMING_GOODS,locationId);                
                sSold = SessReportSales.reportConsignedBySellingPosSales(invStartDate, invEndDate, chkInvDate, vendorId, locationId);    
                sRetur = SessReportSales.reportConsignedByCost(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_RETUR_GOODS,locationId);                
                sTransIn = SessReportSales.reportConsignedByCost(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_TRANSFER_IN,locationId);
                sTransOut = SessReportSales.reportConsignedByCost(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_TRANSFER,locationId);
                sAdjustment = SessReportSales.reportConsignedByCost(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_ADJUSTMENT,locationId);
                
                session.putValue("REPORT_KONSINYASI_COST_RESULT", result);
                session.putValue("REPORT_KONSINYASI_COST_BEGIN", sBegin);
                session.putValue("REPORT_KONSINYASI_COST_RECEIVE",sReceive );
                session.putValue("REPORT_KONSINYASI_COST_SOLD",sSold);
                session.putValue("REPORT_KONSINYASI_COST_RETUR",sRetur);
                session.putValue("REPORT_KONSINYASI_COST_TI",sTransIn);
                session.putValue("REPORT_KONSINYASI_COST_TO",sTransOut);
                session.putValue("REPORT_KONSINYASI_COST_ADJ",sAdjustment);
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
            <%if (!masterPriv || !masterPrivView) {%>
                window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptKonsinyasiCostPDF?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdPrintJournalXls(){	                       
                window.open("<%=printroot%>.report.RptKonsinyasiCostXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                document.frmsales.action="rptconsignedbycost.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Consigned Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                <span class="lvl2">Consigned By Cost<br></span></font></b></td>
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
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" height="14">Date Between</td>
                                                                                                                                            <td colspan="3">
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
                                                                                                                                            <td width="8%" height="14" nowrap>Suplier</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                            <% 
                                                                                                                                            String whereCosg = DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = 1 and "+DbVendor.colNames[DbVendor.COL_SYSTEM]+" = "+DbVendor.TYPE_SYSTEM_HB;
                                                                                                                                            Vector vVendor = DbVendor.list(0, 0, whereCosg, DbVendor.colNames[DbVendor.COL_NAME]);
                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                                 <select name="src_vendor_id">                                                                                                                                                    
                                                                                                                                                    <%if (vVendor != null && vVendor.size() > 0) {
                for (int i = 0; i < vVendor.size(); i++) {
                    Vendor v = (Vendor) vVendor.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=v.getOID()%>" <%if (v.getOID() == vendorId) {%>selected<%}%>><%=v.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14">Location</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                                <%
            Vector vLoc = DbLocation.list(0, 0, "", "name");
                                                                                                                                                %>
                                                                                                                                                <select name="src_location_id">
                                                                                                                                                    <option value="0">--ALL--</option>
                                                                                                                                                    <%if (vLoc != null && vLoc.size() > 0){
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="33">&nbsp;</td>
                                                                                                                                            <td width="38%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                            <td width="54%" height="33">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="15">&nbsp;</td>
                                                                                                                                            <td width="38%" height="15">&nbsp; 
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
                if (result != null && result.size() >0 ){
%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablehdr" width="10%">SKU</td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" >Description</td>
                                                                                                                                            <td class="tablehdr" width="5%">Cost</td>
                                                                                                                                            <td class="tablehdr" width="5%">Begining</td>
                                                                                                                                            <td class="tablehdr" width="5%">Receiving</td>
                                                                                                                                            <td class="tablehdr" width="5%">Sold</td>
                                                                                                                                            <td class="tablehdr" width="5%">Retur</td>
                                                                                                                                            <td class="tablehdr" width="5%">Transfer In</td>
                                                                                                                                            <td class="tablehdr" width="5%">Transfer Out</td>
                                                                                                                                            <td class="tablehdr" width="5%">Adjustment</td>
                                                                                                                                            <td class="tablehdr" width="5%">Ending</td>
                                                                                                                                            <td class="tablehdr" width="7%">Selling Value</td>
                                                                                                                                            <td class="tablehdr" width="7%">Stock Value</td>
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
                                                                                                                                        for(int i = 0 ; i < result.size() ; i++){ 
                                                                                                                                            
                                                                                                                                         ReportConsigCost rsm = (ReportConsigCost)result.get(i);
                                                                                                                                         
                                                                                                                                         String wherex = DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+"="+rsm.getItemMasterId();
                                                                                                                                         String orderx = DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE]+" desc ";
                                                                                                                                         
                                                                                                                                         Vector listVItem = DbVendorItem.list(0, 1, wherex, orderx);
                                                                                                                                         
                                                                                                                                         VendorItem vI = new VendorItem();
                                                                                                                                         try{
                                                                                                                                             if(listVItem != null && listVItem.size() > 0){
                                                                                                                                                vI = (VendorItem)listVItem.get(0);
                                                                                                                                             }
                                                                                                                                         }catch(Exception e){}
                                                                                                                                         
                                                                                                                                         ReportConsigCost begin = new ReportConsigCost();                                                                                                                                         
                                                                                                                                         try{
                                                                                                                                            begin = (ReportConsigCost)sBegin.get(""+rsm.getItemMasterId());
                                                                                                                                         }catch(Exception e){
                                                                                                                                             begin = new ReportConsigCost();
                                                                                                                                         }
                                                                                                                                         ReportConsigCost receive = new ReportConsigCost();
                                                                                                                                         try{
                                                                                                                                            receive = (ReportConsigCost)sReceive.get(""+rsm.getItemMasterId());
                                                                                                                                         }catch(Exception e){
                                                                                                                                            System.out.println("exception "+e.toString());
                                                                                                                                         }
                                                                                                                                         if(receive == null){
                                                                                                                                             receive = new ReportConsigCost();
                                                                                                                                         }
                                                                                                                                         if(begin == null){
                                                                                                                                             begin = new ReportConsigCost();
                                                                                                                                         }
                                                                                                                                         ReportConsigCost sold = new ReportConsigCost();
                                                                                                                                         try{
                                                                                                                                            sold = (ReportConsigCost)sSold.get(""+rsm.getItemMasterId());
                                                                                                                                         }catch(Exception e){
                                                                                                                                            System.out.println("exception "+e.toString());
                                                                                                                                         }
                                                                                                                                         if(sold == null){
                                                                                                                                             sold = new ReportConsigCost();
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         ReportConsigCost retur = new ReportConsigCost();
                                                                                                                                         try{
                                                                                                                                            retur = (ReportConsigCost)sRetur.get(""+rsm.getItemMasterId());
                                                                                                                                         }catch(Exception e){
                                                                                                                                            System.out.println("exception "+e.toString());
                                                                                                                                         }
                                                                                                                                         if(retur == null){
                                                                                                                                             retur = new ReportConsigCost();
                                                                                                                                         }                                                                                                                                         
                                                                                                                                         ReportConsigCost transIn = new ReportConsigCost();
                                                                                                                                         try{
                                                                                                                                            transIn = (ReportConsigCost)sTransIn.get(""+rsm.getItemMasterId());
                                                                                                                                         }catch(Exception e){
                                                                                                                                            System.out.println("exception "+e.toString());
                                                                                                                                         }
                                                                                                                                         if(transIn == null){
                                                                                                                                             transIn = new ReportConsigCost();
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         ReportConsigCost transOut = new ReportConsigCost();
                                                                                                                                         try{
                                                                                                                                            transOut = (ReportConsigCost)sTransOut.get(""+rsm.getItemMasterId());
                                                                                                                                         }catch(Exception e){
                                                                                                                                            System.out.println("exception "+e.toString());
                                                                                                                                         }
                                                                                                                                         if(transOut == null){
                                                                                                                                             transOut = new ReportConsigCost();
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         ReportConsigCost adjustment = new ReportConsigCost();
                                                                                                                                         try{
                                                                                                                                            adjustment = (ReportConsigCost)sAdjustment.get(""+rsm.getItemMasterId());
                                                                                                                                         }catch(Exception e){
                                                                                                                                            System.out.println("exception "+e.toString());
                                                                                                                                         }
                                                                                                                                         if(adjustment == null){
                                                                                                                                             adjustment = new ReportConsigCost();
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         double stock = begin.getQty() + receive.getQty() + sold.getQty() + retur.getQty() +  transIn.getQty() + transOut.getQty() + adjustment.getQty();                                                                                                                                                                                                                                                                                  
                                                                                                                                         
                                                                                                                                         double cogs = 0;                                                                                                                                         
                                                                                                                                         try{
                                                                                                                                            cogs = SessReportSales.getLastCOGS(locationId,rsm.getItemMasterId(),invEndDate);
                                                                                                                                         }catch(Exception e){}
                                                                                                                                         
                                                                                                                                         if(cogs == 0){
                                                                                                                                             cogs = vI.getLastPrice();
                                                                                                                                         }                                                                                                                                          
                                                                                                                                         
                                                                                                                                         double sellingV = 0;
                                                                                                                                         if(sold.getQty() != 0){                                                                                                                                             
                                                                                                                                             sellingV = sold.getQty() * -1 * cogs ;
                                                                                                                                         }else{                                                                                                                                             
                                                                                                                                             sellingV = sold.getQty() * cogs ;
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         String strSellingV = "";                                                                                                                                         
                                                                                                                                         if(sellingV < 0){
                                                                                                                                             strSellingV = "("+JSPFormater.formatNumber(sellingV, "#,###.##")+")";
                                                                                                                                         }else{
                                                                                                                                             strSellingV = JSPFormater.formatNumber(sellingV, "#,###.##");
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         double vEnding = 0;                                                                                                                                         
                                                                                                                                         double vEnding2 = 0;       
                                                                                                                                         
                                                                                                                                         vEnding = stock * cogs ;                                                                                                                                         
                                                                                                                                         vEnding2 = stock * cogs ;
                                                                                                                                         
                                                                                                                                         String strV = "";                                                                                                                                         
                                                                                                                                         if(vEnding < 0){
                                                                                                                                             vEnding = vEnding * -1;
                                                                                                                                             strV = "("+JSPFormater.formatNumber(vEnding, "#,###.##")+")";
                                                                                                                                         }else{
                                                                                                                                             strV = JSPFormater.formatNumber(vEnding, "#,###.##");
                                                                                                                                         }
                                                                                                                                         
                                                                                                                                         tot1 = tot1 + begin.getQty();
                                                                                                                                         tot2 = tot2 + receive.getQty();   
                                                                                                                                         double tot3x = sold.getQty() != 0 ? sold.getQty()*-1 : sold.getQty();                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                         tot3 = tot3 + tot3x;
                                                                                                                                         double tot4x = retur.getQty() != 0 ? retur.getQty()*-1 : retur.getQty();
                                                                                                                                         tot4 = tot4 + tot4x;
                                                                                                                                         tot5 = tot5 + transIn.getQty();
                                                                                                                                         double tot6x =  transOut.getQty() != 0 ? transOut.getQty()*-1 : transOut.getQty();
                                                                                                                                         tot6 = tot6 + tot6x;
                                                                                                                                         tot7 = tot7 + adjustment.getQty();
                                                                                                                                         tot8 = tot8 + stock;
                                                                                                                                         tot9 = tot9 + sellingV;
                                                                                                                                         tot10 = tot10 + vEnding2;
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell" align="center"><%=rsm.getSku()%></td>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="left">&nbsp;<%=rsm.getDescription()%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(cogs, "#,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(begin.getQty(), "#,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(receive.getQty(), "#,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(sold.getQty() != 0 ? sold.getQty()*-1 : sold.getQty(), "#,###.##") %></td>
                                                                                                                                            <td class="tablecell" align="right"><%=retur.getQty() != 0 ? retur.getQty()*-1 : retur.getQty()%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=transIn.getQty()%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=transOut.getQty() != 0 ? transOut.getQty()*-1 : transOut.getQty() %></td>
                                                                                                                                            <td class="tablecell" align="right"><%=adjustment.getQty()%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=stock%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=strSellingV%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=strV%></td>
                                                                                                                                        </tr>    
                                                                                                                                        <%}%>
                                                                                                                                        <tr height="20">                                                                                                                                             
                                                                                                                                            <td class="tablecell" align="right" colspan="3"><B>GRAND TOTAL</B>&nbsp;&nbsp;</td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot1, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot2, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot3, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot4, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot5, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot6, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot7, "#,###.##")%></B></td>
                                                                                                                                            <td class="tablecell" align="right"><B><%=JSPFormater.formatNumber(tot8, "#,###.##")%></B></td>
                <%                                                                                                                            
                String strV = "";
                if (tot9 < 0) {
                    tot9 = tot9 * -1;
                    strV = "(" + JSPFormater.formatNumber(tot9, "#,###.##") + ")";
                } else {
                    strV = JSPFormater.formatNumber(tot9, "#,###.##");
                }%>
                                                                                                                                            <td class="tablecell" align="right"><B><%=strV%></B></td>
                                                                                                                                            <% 
                                                                                                                                            String strVx = "";
                if (tot10 < 0) {
                    tot10 = tot10 * -1;
                    strVx = "(" + JSPFormater.formatNumber(tot10, "#,###.##") + ")";
                } else {
                    strVx = JSPFormater.formatNumber(tot10, "#,###.##");
                }
                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                            <td class="tablecell" align="right"><B><%=strVx%></B></td>
                                                                                                                                        </tr>   
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="15">
                                                                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                                    <tr >
                                                                                                                                                        <td width="200"><B>Total Bill</B></td>
                                                                                                                                                        <td width="20" align="center">&nbsp;</td>
                                                                                                                                                        <td width="100" align="center"><B>=</B></td>
                                                                                                                                                        <td width="50" align="center"><B>Rp.</B></td>
                                                                                                                                                        <td width="100" align="right"><B><%=strV%></B></td>
                                                                                                                                                    </tr>  
                                                                                                                                                </table>
                                                                                                                                            </td>       
                                                                                                                                        </tr>             
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    &nbsp;
                                                                                                                                </td>     
                                                                                                                            </tr> 
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                                                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                                                                                                                    <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print2','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print2" height="22" border="0"></a>
                                                                                                                                </td>     
                                                                                                                            </tr>     
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

