
<%-- 
    Document   : journalmemberpoint
    Created on : Sep 14, 2015, 10:55:04 AM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.postransaction.memberpoint.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.fms.transaction.DbGl" %>
<%@ page import = "com.project.fms.transaction.Gl" %>
<%@ page import = "com.project.fms.transaction.DbGlDetail" %>
<%@ page import = "com.project.fms.transaction.GlDetail" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_JOURNAL_CASH_BACK);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_JOURNAL_CASH_BACK, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_JOURNAL_CASH_BACK, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_JOURNAL_CASH_BACK, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_JOURNAL_CASH_BACK, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_JOURNAL_CASH_BACK, AppMenu.PRIV_PRINT);
%>


<!-- Jsp Block -->
<%

            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            if (session.getValue("REPORT_CASH_BACK_LANGSUNG") != null) {
                session.removeValue("REPORT_CASH_BACK_LANGSUNG");
            }

            Vector locations = DbSegmentDetail.listLocation(user.getOID());
            String where = DbMemberPoint.colNames[DbMemberPoint.COL_TYPE] + " = " + DbMemberPoint.TYPE_CASH_BACK_LANGSUNG + " and " +
                    DbMemberPoint.colNames[DbMemberPoint.COL_DATE] + " between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd ") + " 00:00:00' and '" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd ") + " 23:59:59' ";

            if (locationId == 0) {
                if (locations != null && locations.size() > 0) {
                    if (totLocationxAll != locations.size()) {
                        Location locSelect = new Location();
                        try {
                            locSelect = (Location) locations.get(0);
                            locationId = locSelect.getOID();
                            where = where + " and " + DbMemberPoint.colNames[DbMemberPoint.COL_LOCATION_ID] + " = " + locationId;
                        } catch (Exception e) {
                        }
                    }
                } else {
                    where = where + " and " + DbMemberPoint.colNames[DbMemberPoint.COL_LOCATION_ID] + " = -1";
                }
            } else {
                where = where + " and " + DbMemberPoint.colNames[DbMemberPoint.COL_LOCATION_ID] + " = " + locationId;
            }

            Vector listMember = DbMemberPoint.list(0, 0, where, DbMemberPoint.colNames[DbMemberPoint.COL_DATE]);

            if (iJSPCommand == JSPCommand.POST) {
                Vector accDebet = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_CASH_BACK_DEBET+ "'", "");
                Vector accCredit = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_CASH_BACK_CREDIT+ "'", "");
                
                long coaDebet = 0;
                long coaCredit = 0;
                if(accDebet != null && accDebet.size() > 0){
                    try{
                        AccLink acc = (AccLink)accDebet.get(0);
                        coaDebet = acc.getCoaId();
                    }catch(Exception e){}
                }
                
                if(accCredit != null && accCredit.size() > 0){
                    try{
                        AccLink acc = (AccLink)accCredit.get(0);
                        coaCredit = acc.getCoaId();
                    }catch(Exception e){}
                }
                
                if (listMember != null && listMember.size() > 0 && coaDebet != 0 && coaCredit != 0 ) {
                    for (int i = 0; i < listMember.size(); i++) {
                        MemberPoint mp = (MemberPoint) listMember.get(i);
                        int cek = JSPRequestValue.requestInt(request, "check" + mp.getOID());
                        if (cek == 1 && mp.getPostedStatus() == 0) {
                            DbMemberPoint.postJournal(mp,user.getOID(), coaDebet,coaCredit, sysCompany);
                        }
                    }
                }
                listMember = DbMemberPoint.list(0, 0, where, DbMemberPoint.colNames[DbMemberPoint.COL_DATE]);
            }
            
            ReportParameter rp = new ReportParameter();
            rp.setLocationId(locationId);            
            rp.setDateFrom(tanggal);
            rp.setDateTo(tanggalEnd);
            session.putValue("REPORT_CASH_BACK_LANGSUNG",rp);
            
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
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmsales.action="journalmemberpoint.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
            }
            
            function cmdPostJournal(){
                document.frmsales.command.value="<%=JSPCommand.POST%>";
                document.frmsales.action="journalmemberpoint.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
            }
            
            function cmdPrintJournalXls(){	                       
                window.open("<%=printroot%>.report.ReportCashBackLangsungXLS?user_id=<%=appSessUser.getUserOID()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
            
            
            function setChecked(val){
                 <%
            for (int k = 0; k < listMember.size(); k++) {
                MemberPoint osl = (MemberPoint) listMember.get(k);
                if (osl.getPostedStatus() == 0) {
                %>
                    document.frmsales.check<%=osl.getOID()%>.checked=val.checked;
                <%
                }
            }
                %>
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
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Accounting 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Process Journal Cash Back<br>
                                                                                                                                </span></font></b></td>
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
                                                                                                                                            <td colspan="2">
                                                                                                                                                <table border="0" cellpadding="1" cellspacing="1">                                                                                                                                        
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="5" height="10"></td>
                                                                                                                                                    </tr>   
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td width="80" bgcolor="#D3EDF5" class="fontarial" style="color:#63605C">&nbsp;Date</td>
                                                                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                                                                        <td width="300">
                                                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td><input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                                                                                                    <td>&nbsp;&nbsp;To&nbsp;&nbsp;</td>
                                                                                                                                                                    <td><input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table>    
                                                                                                                                                        </td>
                                                                                                                                                        <td width="7" colspan="4"></td>                                                                                                                                                        
                                                                                                                                                    </tr> 
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td bgcolor="#D3EDF5" class="fontarial" style="color:#63605C">&nbsp;Location</td>
                                                                                                                                                        <td class="fontarial">:</td>
                                                                                                                                                        <td colspan="4">
                                                                                                                                                            <%

                                                                                                                                                            %>
                                                                                                                                                            <select name="src_location_id" class="fontarial">  
                                                                                                                                                                <%if (totLocationxAll == locations.size()) {%>
                                                                                                                                                                <option onClick="javascript:cmdchange()" value="0" <%if (0 == locationId) {%>selected<%}%>>- All Location - </option>
                                                                                                                                                                <%}%>
                                                                                                                                                                <%if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location us = (Location) locations.get(i);
                                                                                                                                                                %>
                                                                                                                                                                <option onClick="javascript:cmdchange()" value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName()%></option>
                                                                                                                                                                <%}
            }%>
                                                                                                                                                            </select>           
                                                                                                                                                        </td>
                                                                                                                                                    </tr>                                                                                                                                                    
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td valign="middle" colspan="4"> 
                                                                                                                                                <table width="80%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" height="10">&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                            <td colspan="3">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4" height="15">&nbsp;</td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4" height="15">
                                                                                                                                                <table border="0" cellspacing="1" cellpadding="0" width="1100">
                                                                                                                                                    <tr height="24">
                                                                                                                                                        <td width="25" class="tablearialhdr">No</td>
                                                                                                                                                        <td width="80" class="tablearialhdr">Date</td>
                                                                                                                                                        <td width="200" class="tablearialhdr">Location</td>
                                                                                                                                                        <td class="tablearialhdr">Member</td>                                                                                                                                                        
                                                                                                                                                        <td width="80" class="tablearialhdr">Amount</td>
                                                                                                                                                        <td width="80" class="tablearialhdr">Status</td>
                                                                                                                                                        <td width="130" class="tablearialhdr">Posted By</td>
                                                                                                                                                        <td width="35" class="tablearialhdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
            if (listMember != null && listMember.size() > 0) {
                double total = 0;
                boolean readyPosted = false;
                for (int i = 0; i < listMember.size(); i++) {
                    MemberPoint mp = (MemberPoint) listMember.get(i);

                    String style = "";
                    if (i % 2 == 0) {
                        style = "tablearialcell1";
                    } else {
                        style = "tablearialcell1";
                    //style = "tablearialcell1";
                    }

                    String strLoc = "";
                    if (mp.getLocationId() != 0) {
                        try {
                            Location loc = DbLocation.fetchExc(mp.getLocationId());
                            strLoc = loc.getName();
                        } catch (Exception e) {
                        }
                    }

                    String strCust = "";
                    if (mp.getCustomerId() != 0) {
                        try {
                            Customer cus = DbCustomer.fetchExc(mp.getCustomerId());
                            strCust = cus.getName();
                        } catch (Exception e) {
                        }
                    }

                    total = total + mp.getPoint();

                                                                                                                                                    %>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td align="center" class="<%=style%>"><%=(i + 1)%></td>
                                                                                                                                                        <td align="center" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatDate(mp.getDate(), "yyyy-MM-dd")%></td>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px;"><%=strLoc%></td>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px;"><%=strCust%></td>   
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(mp.getPoint(), "###,###.##") %></td>                                                                                                                                                         
                                                                                                                                                        <%
                                                                                                                                                            if (false ){//|| mp.getPostedStatus() == 1 ) {
                                                                                                                                                                String postedBy = "";
                                                                                                                                                                if (mp.getPostedById() != 0) {
                                                                                                                                                                    try {
                                                                                                                                                                        User usx = DbUser.fetch(mp.getPostedById());
                                                                                                                                                                        postedBy = usx.getFullName();
                                                                                                                                                                    } catch (Exception e) {
                                                                                                                                                                    }
                                                                                                                                                                }
                                                                                                                                                        %>
                                                                                                                                                        <td bgcolor="#E6AD49" class="fontarial" >       
                                                                                                                                                            <div align="center"><font size="1">POSTED</font></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px;"><%=postedBy%></td>                                                                                                                                                        
                                                                                                                                                        <td align="left" class="<%=style%>" >&nbsp;</td>                              
                                                                                                                                                        <%
                                                                                                                                                        } else {
                                                                                                                                                            readyPosted = true;

                                                                                                                                                        %>
                                                                                                                                                        <td bgcolor="#D5645B" class="fontarial" >                                                                                                                                                        
                                                                                                                                                            <div align="center"><font size="1">NOT POSTED</font></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px;">&nbsp;</td>    
                                                                                                                                                        <td align="center" class="<%=style%>"><input type="checkbox" name="check<%=mp.getOID()%>" value="1"></td>
                                                                                                                                                        <%}%>                                                                                                                                                        
                                                                                                                                                    </tr>    
                                                                                                                                                    
                                                                                                                                                    <%
                                                                                                                                                        }%>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td align="center" bgcolor="#cccccc" colspan="4" classs="fontarial">Grand Total</td>                                                                                                                                                        
                                                                                                                                                        <td align="right" bgcolor="#cccccc" style="padding:3px;" classs="fontarial"><%=JSPFormater.formatNumber(total, "###,###.##") %></td>
                                                                                                                                                        <td align="center" bgcolor="#cccccc" colspan="3"></td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="8" height="25"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%if (privPrint || privUpdate || privAdd || privDelete) {%>
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="8" height="25">
                                                                                                                                                            <table>
                                                                                                                                                                <tr>                     
                                                                                                                                                                    <%if (readyPosted && (privUpdate || privAdd || privDelete)) {%>
                                                                                                                                                                    <td><a href="javascript:cmdPostJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" border="0"></a></td>
                                                                                                                                                                    <%}%>
                                                                                                                                                                    <%if (privPrint) {%>
                                                                                                                                                                    <td width="35">&nbsp</td>
                                                                                                                                                                    <td><a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a></td>
                                                                                                                                                                    <%}%>
                                                                                                                                                                    <td>&nbsp</td>
                                                                                                                                                                </tr>    
                                                                                                                                                            </table>    
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%}%>
                                                                                                                                                    <%



            }
                                                                                                                                                    %>
                                                                                                                                                    
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
                                                                                                            <script language="JavaScript">
                                                                                                                document.all.closecmd.style.display="";
                                                                                                                document.all.closemsg.style.display="none";
                                                                                                            </script>    
                                                                                                        </form>
                                                                                                    </td>
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
