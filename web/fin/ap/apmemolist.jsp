

<%-- 
    Document   : apmemolist
    Created on : Nov 23, 2012, 3:55:13 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidReceive = JSPRequestValue.requestLong(request, "hidden_arap_id");
            long vendorId = JSPRequestValue.requestLong(request, "vendor_id");
            long locationId = JSPRequestValue.requestLong(request, "location_id");
            String txtNumber = JSPRequestValue.requestString(request, "txt_number");
            String dateStart = JSPRequestValue.requestString(request, "date_start");
            String dateEnd = JSPRequestValue.requestString(request, "date_end");
            int ignore = JSPRequestValue.requestInt(request, "ignore");
            String status = JSPRequestValue.requestString(request, "status");

            if (iJSPCommand == JSPCommand.NONE) {
                vendorId = 0;
                ignore = 1;
                txtNumber = "";
                status = "ALL";
            }

            Date dtStart = new Date();
            Date dtEnd = new Date();

            if (ignore == 0) {
                dtStart = JSPFormater.formatDate(dateStart, "dd/MM/yyyy");
                dtEnd = JSPFormater.formatDate(dateEnd, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 30;
            String orderClause = "";
            CmdReceiveMemo cmdReceiveMemo = new CmdReceiveMemo(request);
            JSPLine ctrLine = new JSPLine();
            Vector listAp = new Vector();
            String where = "";

            where = where + DbReceive.colNames[DbReceive.COL_TYPE_AP] + " = " + DbReceive.TYPE_AP_YES;
            
            if (status.compareTo("ALL") != 0) {
                where = where + " and " + DbReceive.colNames[DbReceive.COL_STATUS] + " = '" + status + "' ";
            }

            if (txtNumber.length() > 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + DbReceive.colNames[DbReceive.COL_NUMBER] + " like '%" + txtNumber + "%'";
            }

            if (vendorId > 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + " = " + vendorId;
            }
            
            if (locationId > 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + DbReceive.colNames[DbReceive.COL_LOCATION_ID] + " = " + locationId;
            }

            if (ignore == 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + DbReceive.colNames[DbReceive.COL_DATE] + " between '" + JSPFormater.formatDate(dtStart, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(dtEnd, "yyyy-MM-dd") + "'";
            }

            orderClause = " year(" + DbReceive.colNames[DbReceive.COL_DATE] + ") desc,month(" + DbReceive.colNames[DbReceive.COL_DATE] + ") desc," + DbReceive.colNames[DbReceive.COL_NUMBER] + " desc";

            int vectSize = 0;
            vectSize = DbReceive.getCount(where);
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {

                start = cmdReceiveMemo.actionList(iJSPCommand, start, vectSize, recordToGet);

            }
            /* end switch list*/

            /* get record to display */
            listAp = new Vector();
            listAp = DbReceive.list(start, recordToGet, where, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listAp.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listAp = DbReceive.list(start, recordToGet, where, orderClause);
            }

            String[] langAP = {"Date", "Vendor", "Document Number", "Period", "Date", "Vendor", "Invoice", "Amount", "Memo", "Amount", "Document Number", "Date", "Vendor", "Status", "Click search button to searching the data", "Data not found", "Location", "Memo"};
            String[] langNav = {"Account Payble", "AP Memo", "Records", "Memorial"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal", "Suplier", "Nomor Dokumen", "Periode", "Tanggal", "Suplier", "Faktur", "Jumlah", "Memo", "Jumlah", "Nomor Dokumen", "Tanggal", "Suplier", "Status", "Klik tombol search untuk mencari data", "Data tidak ditemukan", "Lokasi", "Keterangan"};
                langAP = langID;

                String[] navID = {"Hutang", "AP Memo", "Records", "Memorial"};
                langNav = navID;
            }

            Vector listVendor = DbVendor.list(0, 0, "", DbVendor.colNames[DbVendor.COL_NAME]);
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<%=approot%>/main/jquery.min.js"></script>
        <script type="text/javascript" src="<%=approot%>/main/jquery.searchabledropdown.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                $("select").searchable();
            });
            
            $(document).ready(function() {
                $("#value").html($("#searchabledropdown :selected").text() + " (VALUE: " + $("#searchabledropdown").val() + ")");
                $("select").change(function(){
                    $("#value").html(this.options[this.selectedIndex].text + " (VALUE: " + this.value + ")");
                });
            });
        </script>
        <script language="JavaScript">
            
            function cmdSearch(){ 
                document.frmarapmemo.command.value="<%=JSPCommand.SEARCH%>";            
                document.frmarapmemo.action="apmemolist.jsp";
                document.frmarapmemo.submit();
            }   
            
            function cmdNewJournal(){
                document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";            
                document.frmarapmemo.action="apmemo.jsp";
                document.frmarapmemo.submit();
            }    
            
            function removeChar(number){                        
                var ix; var result = "";
                for(ix=0; ix<number.length; ix++){
                    var xx = number.charAt(ix);                                
                    if(!isNaN(xx)){
                        result = result + xx;
                    }else{
                    if(xx==',' || xx=='.'){
                        result = result + xx;
                    }
                }
            }                        
            return result;
        }
        
        
        
        function cmdToRecord(){
            document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";            
            document.frmarapmemo.action="apmemo.jsp";
            document.frmarapmemo.submit();
        }    
        
        
        function cmdEdit(oidReceive){
            document.frmarapmemo.hidden_receive_id.value=oidReceive;
            document.frmarapmemo.command.value="<%=JSPCommand.ASSIGN%>";
            document.frmarapmemo.select_idx.value="<%=-1%>";
            document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
            document.frmarapmemo.action="apmemo.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdListFirst(){
            document.frmarapmemo.command.value="<%=JSPCommand.FIRST%>";
            document.frmarapmemo.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmarapmemo.action="apmemolist.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdListPrev(){
            document.frmarapmemo.command.value="<%=JSPCommand.PREV%>";
            document.frmarapmemo.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmarapmemo.action="apmemolist.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdListNext(){
            document.frmarapmemo.command.value="<%=JSPCommand.NEXT%>";
            document.frmarapmemo.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmarapmemo.action="apmemolist.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdListLast(){
            document.frmarapmemo.command.value="<%=JSPCommand.LAST%>";
            document.frmarapmemo.prev_command.value="<%=JSPCommand.LAST%>";
            document.frmarapmemo.action="apmemolist.jsp";
            document.frmarapmemo.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
        <tr> 
        <td valign="top"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
            <tr> 
                <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file = "../main/hmenu.jsp" %>
                <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                        <!--DWLayoutTable-->
                        <tr> 
                            <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp" %>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                            <!-- #EndEditable --> </td>
                            <td width="100%" valign="top"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                        <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">&nbsp;" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                        <!-- #EndEditable --></td>
                                    </tr>
                                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                    </tr-->
                                    <tr> 
                                        <td><!-- #BeginEditable "content" --> 
                                            <form name="frmarapmemo" method ="post" action="">
                                                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                <input type="hidden" name="start" value="<%=start%>">                            
                                                <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
                                                <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TYPE]%>" value="<%=DbReceive.TYPE_AP_YES%>">
                                                <input type="hidden" name="select_idx" value="<%=-1%>">
                                                <input type="hidden" name="JSP_REF_ID" value="0">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr align="left" valign="top"> 
                                                        <td height="8"  colspan="3" class="container"> 
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="22" valign="middle" colspan="3"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td height="8"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="100%" > 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td colspan="6"> 
                                                                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">                                                                                                                            
                                                                                                                <tr > 
                                                                                                                    <td width="100%" nowrap>
                                                                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr > 
                                                                                                                                <td class="tab" nowrap> 
                                                                                                                                    <div align="center">&nbsp;&nbsp;<font face="arial"><%=langNav[2]%></font>&nbsp;&nbsp;</div>
                                                                                                                                </td>
                                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                                <td class="tabin" nowrap> 
                                                                                                                                    <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink"><font face="arial"><%=langNav[3]%></font></a>&nbsp;&nbsp;</div>
                                                                                                                                </td>
                                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>                                                                                                                                
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="10">&nbsp;</td>
                                                                                                    </tr>                                                                               
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <table width="850" border="0" cellspacing="1" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top" colspan="8" height="8"></td>
                                                                                                                </tr>                                                                                                                
                                                                                                                <tr height="22">                                                                                                                     
                                                                                                                    <td width="100" class="tablecell1">&nbsp;&nbsp;<%=langAP[2]%></td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td width="300">
                                                                                                                        <input name="txt_number" value="<%=txtNumber%>" size="20" class="fontarial">
                                                                                                                    </td>
                                                                                                                    <td width="100" class="tablecell1">&nbsp;&nbsp;<%=langAP[4]%></td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td >                                                                                                                                    
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <input name="date_start" value="<%=JSPFormater.formatDate((dtStart == null) ? new Date() : dtStart, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                </td>
                                                                                                                                <td>        
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarapmemo.date_start);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                </td> 
                                                                                                                                <td class="fontarial">
                                                                                                                                    &nbsp;To&nbsp;
                                                                                                                                </td> 
                                                                                                                                <td>
                                                                                                                                    <input name="date_end" value="<%=JSPFormater.formatDate((dtEnd == null) ? new Date() : dtEnd, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                </td>
                                                                                                                                <td>    
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarapmemo.date_end);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                </td> 
                                                                                                                                <td><input type="checkbox" name="ignore" value="1" <%if (ignore == 1) {%>checked<%}%>></td>
                                                                                                                                <td class="fontarial">&nbsp;Ignore</td>
                                                                                                                            </tr>
                                                                                                                        </table> 
                                                                                                                    </td>
                                                                                                                    <td width="5"></td>
                                                                                                                </tr>
                                                                                                                <tr height="22">                                                                                                                     
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;<%=langAP[16]%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td >
                                                                                                                        <select name="location_id" class="fontarial">
                                                                                                                            <option value="0" <%if (locationId == 0) {%>selected<%}%>>- all location -</option>
                                                                                                                            <%
            Vector locations;
            locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=d.getOID()%>" <%if (locationId == d.getOID()) {%>selected<%}%>><%=d.getName().toUpperCase()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;Status</td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td>
                                                                                                                        <select name="status">
                                                                                                                            <option value="ALL" <%if (status.equals("ALL")) {%>selected<%}%> >- all status -</option>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (status.equals(I_Project.DOC_STATUS_DRAFT)) {%> selected <%}%> >DRAFT</option>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (status.equals(I_Project.DOC_STATUS_APPROVED)) {%> selected <%}%> >APPROVE</option>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if (status.equals(I_Project.DOC_STATUS_CHECKED)) {%> selected <%}%> >POSTED</option>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="5"></td>
                                                                                                                </tr> 
                                                                                                                <tr height="22">                                                                                                                     
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;<%=langAP[5]%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td colspan="5">
                                                                                                                        <select name="vendor_id">
                                                                                                                            <option value="0">- all suplier -</option>
                                                                                                                            <%if (listVendor != null && listVendor.size() > 0) {
                for (int i = 0; i < listVendor.size(); i++) {
                    Vendor v = (Vendor) listVendor.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=v.getOID()%>" <%if (vendorId == v.getOID()) {%> selected<%}%> ><%=v.getName()%></option>
                                                                                                                            <%
                }
            }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                    </td>                                                                                                                    
                                                                                                                </tr> 
                                                                                                                <tr> 
                                                                                                                    <td valign="top" colspan="8"></td>
                                                                                                                </tr>                                                                                                                 
                                                                                                                <tr> 
                                                                                                                    <td colspan="7" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>    
                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td ><a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search" border="0"></a></td>
                                                                                                    </tr>    
                                                                                                    <tr> 
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <%if (iJSPCommand == JSPCommand.SEARCH && listAp.size() <= 0) {%>
                                                                                                    <tr> 
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <tr> 
                                                                                                        <td height="22" valign="middle" class="page">
                                                                                                            <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell1" ><%=langAP[15]%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>    
                                                                                                    <%}%> 
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <table width="1100" border="0" cellpadding="0" cellspacing="1">                                                                                               
                                                                                                                <%
            int number = start + 1;
            if (listAp != null && listAp.size() > 0) {
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td colspan="4">&nbsp;</td>
                                                                                                                </tr> 
                                                                                                                <tr height="28">
                                                                                                                    <td class="tablehdr" width="25">No</td>
                                                                                                                    <td class="tablehdr" width="100"><%=langAP[10]%></td>
                                                                                                                    <td class="tablehdr" width="100"><%=langAP[11]%></td>
                                                                                                                    <td class="tablehdr"><%=langAP[16]%></td>
                                                                                                                    <td class="tablehdr"><%=langAP[12]%></td>
                                                                                                                    <td class="tablehdr" width="100"><%=langAP[7]%></td>
                                                                                                                    <td class="tablehdr" width="190"><%=langAP[17]%></td>
                                                                                                                    <td class="tablehdr" width="60"><%=langAP[13]%></td>
                                                                                                                </tr> 
                                                                                                                <%
                                                                                                                    for (int i = 0; i < listAp.size(); i++) {
                                                                                                                        Receive objReceive = (Receive) listAp.get(i);
                                                                                                                        Vendor vnd = new Vendor();
                                                                                                                        try {
                                                                                                                            vnd = DbVendor.fetchExc(objReceive.getVendorId());
                                                                                                                        } catch (Exception e) {
                                                                                                                        }

                                                                                                                        Location loc = new Location();
                                                                                                                        try {
                                                                                                                            loc = DbLocation.fetchExc(objReceive.getLocationId());
                                                                                                                        } catch (Exception e) {
                                                                                                                        }

                                                                                                                        double amount = DbReceiveItem.getTotalAmount(objReceive.getOID());
                                                                                                                        if (amount != 0) {
                                                                                                                            amount = amount * -1;
                                                                                                                        }
                                                                                                                        String style = "tablecell";
                                                                                                                        if (number % 2 == 0) {
                                                                                                                            style = "tablecell1";
                                                                                                                        }


                                                                                                                %>
                                                                                                                <tr height="23">
                                                                                                                    <td class="<%=style%>" align="center"><%=number%></td>
                                                                                                                    <td class="<%=style%>" align="center"><a href="javascript:cmdEdit('<%=objReceive.getOID()%>')"><%=objReceive.getNumber()%></a></td>
                                                                                                                    <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(objReceive.getDate(), "yyyy-MM-dd")%></td>
                                                                                                                    <td class="<%=style%>" ><%=loc.getName()%></td>
                                                                                                                    <td class="<%=style%>" ><%=vnd.getName()%></td>
                                                                                                                    <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(amount, "#,###.##")%>&nbsp;&nbsp;</td>
                                                                                                                    <td class="<%=style%>" align="left"><%=objReceive.getNote()%></td>
                                                                                                                    <%if (objReceive.getStatus().compareTo(I_Project.DOC_STATUS_DRAFT) == 0) {%>
                                                                                                                    <td class="<%=style%>" align="center"><font size="1">DRAFT</font></td>
                                                                                                                    <%} else if (objReceive.getStatus().compareTo(I_Project.DOC_STATUS_APPROVED) == 0) {%>
                                                                                                                    <td bgcolor="72D5BF" align="center" class="fontarial"><font size="1">APPROVED</font></td>
                                                                                                                    <%} else if (objReceive.getStatus().compareTo(I_Project.DOC_STATUS_CHECKED) == 0) {%>
                                                                                                                    <td bgcolor="D4543A" align="center" class="fontarial"><font size="1">POSTED</font></td>
                                                                                                                    <%}%>
                                                                                                                </tr> 
                                                                                                                <%
                                                                                                                        number++;
                                                                                                                    }%>
                                                                                                                <%}%>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" align="left" colspan="6" class="command"> 
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
                                                                                                                            %>
                                                                                                                        <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span>
                                                                                                                    </td>
                                                                                                                </tr> 
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="15" align="left" colspan="6" ></td> 
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="15" align="left" colspan="6" class="command">
                                                                                                                        <a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newdox','','../images/new2.gif',1)"><img src="../images/new.gif" name="newdox" height="22" border="0"></a>
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
                                                                    </td>
                                                                </tr>                                                                
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </form>
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
            <%@ include file = "../main/footer.jsp" %>
                <!-- #EndEditable --> </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
