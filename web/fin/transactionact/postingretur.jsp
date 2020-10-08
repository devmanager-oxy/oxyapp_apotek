
<%-- 
    Document   : postingretur
    Created on : Jan 1, 2013, 6:49:30 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_RETUR_POST);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_RETUR_POST, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_RETUR_POST, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_RETUR_POST, AppMenu.PRIV_ADD);
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidRetur = JSPRequestValue.requestLong(request, "hidden_retur_id");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");            
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            String number = JSPRequestValue.requestString(request, "textnumber");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();
            
            int allowPeriod = 0;
            try{
                allowPeriod = Integer.parseInt(DbSystemProperty.getValueByName("ALLOW_SELECT_PERIOD"));
            }catch(Exception e){}

            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
            }
            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int iErrCode = JSPMessage.NONE;
            String orderClause = DbRetur.colNames[DbRetur.COL_PREFIX_NUMBER] + "," + DbRetur.colNames[DbRetur.COL_NUMBER];
            String whereClause = " lower("+DbRetur.colNames[DbRetur.COL_STATUS] + ") = '" + I_Project.STATUS_DOC_APPROVED.toLowerCase() + "' ";

            if (srcLocationId != 0) {
                if (whereClause != null && whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbRetur.colNames[DbRetur.COL_LOCATION_ID] + "=" + srcLocationId;
            }

            if (number != null && number.length() > 0) {
                if (whereClause != null && whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbRetur.colNames[DbRetur.COL_NUMBER] + " like '%" + number + "%'";
            }

            if (srcIgnore == 0 && iJSPCommand != JSPCommand.NONE) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (to_days(" + DbRetur.colNames[DbRetur.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbRetur.colNames[DbRetur.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                } else {
                    whereClause = whereClause + "(to_days(" + DbRetur.colNames[DbRetur.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbRetur.colNames[DbRetur.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                }
            }

            CmdRetur cmdRetur = new CmdRetur(request);
            JSPLine ctrLine = new JSPLine();
            Vector listRetur = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdRetur.action(iJSPCommand, oidRetur);
            /* end switch*/
            listRetur = DbRetur.list(0, 0, whereClause, orderClause);

            String[] langAR = {"Location", "Period", "Date", "Ignored", "To", "Number", "Notes", "Vendor"};
            String[] langNav = {"Journal", "Retur - Post Journal", "Records", "Retur Stock", "Search Parameters", "Posted journal success",
                "Some journal can't be posted", "Vendor", "Data not found"
            };

            if (lang == LANG_ID) {
                String[] langID = {"Lokasi", "Periode", "Tanggal", "Abaikan", "Sampai", "Nomor", "Memo", "Suplier"};
                langAR = langID;

                String[] navID = {"Jurnal", "Retur - Post Jurnal", "Arsip", "Penyesuaian Stock", "Parameter Pencarian", "Jurnal berhasil diposting",
                    "Beberapa jurnal gagal di posting", "Suplier", "Data tidak ditemukan"
                };
                langNav = navID;
            }

            String msg = "";

            if (iJSPCommand == JSPCommand.ACTIVATE) { // jika posted

                for (int i = 0; i < listRetur.size(); i++) {
                    Retur retur = (Retur) listRetur.get(i);
                    if (JSPRequestValue.requestInt(request, "post" + retur.getOID()) == 1) {
                        if (msg.length() <= 0) {
                            msg = langNav[5];
                        }
                        Vector details = new Vector();
                        details = DbReturItem.list(0, 0, DbReturItem.colNames[DbReturItem.COL_RETUR_ID] + " = " + retur.getOID(), null);
                        long pId = JSPRequestValue.requestLong(request, "periode" + retur.getOID());
                        int x = DbRetur.postJournal(retur, details, user.getOID(), pId);
                        if (x == 0) {
                            msg = langNav[6];
                        }
                    }
                }
                listRetur = DbRetur.list(0, 0, whereClause, orderClause);
            }
            Vector vPeriode = new Vector();
            try{
                if(allowPeriod == 1){
                    vPeriode = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "' ", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
                }
            }catch(Exception e){}    
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script language="JavaScript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmaretur.command.value="<%=JSPCommand.LIST%>";
                document.frmaretur.action="postingretur.jsp";
                document.frmaretur.submit();
            }
            
            function setChecked(val){
                 <%
            for (int k = 0; k < listRetur.size(); k++) {
                Retur adj = (Retur) listRetur.get(k);
                 %>
                     document.frmaretur.post<%=adj.getOID()%>.checked=val.checked;
                     <% }%>
                 }
                 
                 function cmdPost(){                
                     document.all.closecmd.style.display="none";
                     document.all.closemsg.style.display="";
                     document.frmaretur.command.value="<%=JSPCommand.ACTIVATE%>";
                     document.frmaretur.prev_command.value="<%=prevJSPCommand%>";
                     document.frmaretur.action="postingretur.jsp";
                     document.frmaretur.submit();
                 }
                 
                 function cmdEdit(oid){
                     document.frmaretur.hidden_retur_id.value=oid;
                     document.frmaretur.command.value="<%=JSPCommand.EDIT%>";
                     document.frmaretur.prev_command.value="<%=prevJSPCommand%>";
                     document.frmaretur.action="adjusmentitem.jsp";
                     document.frmaretur.submit();
                 }
                 
                 function cmdAdd(){
                     document.frmaretur.hidden_retur_id.value="0";
                     document.frmaretur.command.value="<%=JSPCommand.ADD%>";
                     document.frmaretur.prev_command.value="<%=prevJSPCommand%>";
                     document.frmaretur.action="adjusmentitem.jsp";
                     document.frmaretur.submit();
                 }
                 
                 function cmdListFirst(){
                     document.frmaretur.command.value="<%=JSPCommand.FIRST%>";
                     document.frmaretur.prev_command.value="<%=JSPCommand.FIRST%>";
                     document.frmaretur.action="postingretur.jsp";
                     document.frmaretur.submit();
                 }
                 
                 function cmdListPrev(){
                     document.frmaretur.command.value="<%=JSPCommand.PREV%>";
                     document.frmaretur.prev_command.value="<%=JSPCommand.PREV%>";
                     document.frmaretur.action="postingretur.jsp";
                     document.frmaretur.submit();
                 }
                 
                 function cmdListNext(){
                     document.frmaretur.command.value="<%=JSPCommand.NEXT%>";
                     document.frmaretur.prev_command.value="<%=JSPCommand.NEXT%>";
                     document.frmaretur.action="postingretur.jsp";
                     document.frmaretur.submit();
                 }
                 
                 function cmdListLast(){
                     document.frmaretur.command.value="<%=JSPCommand.LAST%>";
                     document.frmaretur.prev_command.value="<%=JSPCommand.LAST%>";
                     document.frmaretur.action="postingretur.jsp";
                     document.frmaretur.submit();
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
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmaretur" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_retur_id" value="<%=oidRetur%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr> 
                                                                                <td class="title"> 
                                                                                    <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                                                                    %>
                                                                                    <%@ include file="../main/navigator.jsp"%>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                                                                                    
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3" > 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                       
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                
                                                                                                <table border="0" cellpadding="1" cellspacing="1" >                        
                                                                                                    <tr>
                                                                                                        <td colspan="6" class="fontarial"><i><%=langNav[4]%>:</i></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="6" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width="80" class="tablecell1">&nbsp;&nbsp;<%=langAR[0]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td width="300"> 
                                                                                                            <select name="src_location_id" class="fontarial">
                                                                                                                <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>> < All Location > </option>
                                                                                                                <%

            Vector locations = DbLocation.list(0, 0, "", "name");
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td class="tablecell1" width="80">&nbsp;&nbsp;<%=langAR[2]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >    
                                                                                                            <table border = "0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td><input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmaretur.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> </td>    
                                                                                                                    <td class="fontarial">&nbsp;&nbsp;<%=langAR[4]%>&nbsp;&nbsp;</td>    
                                                                                                                    <td><input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly></td>    
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmaretur.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> </td>     
                                                                                                                    <td><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>></td>    
                                                                                                                    <td class="fontarial"><%=langAR[3]%></td>    
                                                                                                                </tr>   
                                                                                                            </table>   
                                                                                                        </td>
                                                                                                    </tr>   
                                                                                                    <tr>
                                                                                                        <td class="tablecell1">&nbsp;&nbsp;<%=langAR[5]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td ><input type="text" name="textnumber" value="<%=number%>" size="25" class="fontarila"></td>
                                                                                                        <td colspan="3"></td>
                                                                                                    </tr>                                                                                                                                                                                                                                                                                                                                             
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td height="7" valign="middle" colspan="3">
                                                                                                <table width="85%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>     
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                        </tr>    
                                                                                        <tr align="left" valign="top" height="26"> 
                                                                                            <td colspan="3">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <%
            try {
                if (listRetur != null && listRetur.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="3%"  class="tablearialhdr">No</td>
                                                                                                        <td width="7%"  class="tablearialhdr"><%=langAR[5]%></td>
                                                                                                        <td width="7%"  class="tablearialhdr"><%=langAR[2]%></td>
                                                                                                        <td width="16%" class="tablearialhdr"><%=langAR[7]%></td>
                                                                                                        <td width="17%" class="tablearialhdr"><%=langAR[0]%></td>
                                                                                                        <td width="10%" class="tablearialhdr"><%=langAR[1]%></td>
                                                                                                        <td width="20%" class="tablearialhdr"><%=langAR[6]%></td>                                                                                                        
                                                                                                        <td width="3%"  class="tablearialhdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                                    </tr>
                                                                                                    <%for (int i = 0; i < listRetur.size(); i++) {
                                                                                                    Retur retur = (Retur) listRetur.get(i);

                                                                                                    String dtx = "";
                                                                                                    if (retur.getDate() != null) {
                                                                                                        try {
                                                                                                            dtx = JSPFormater.formatDate(retur.getDate(), "dd-MMM-yyyy");
                                                                                                        } catch (Exception e) {
                                                                                                            dtx = "";
                                                                                                        }
                                                                                                    }

                                                                                                    Location location = new Location();
                                                                                                    try {
                                                                                                        location = DbLocation.fetchExc(retur.getLocationId());
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                    Vendor vendorx = new Vendor();
                                                                                                    try {
                                                                                                        vendorx = DbVendor.fetchExc(retur.getVendorId());
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                    Vector vRetDet = new Vector();
                                                                                                    vRetDet = DbReturItem.list(0, 0, DbReturItem.colNames[DbReturItem.COL_RETUR_ID] + " = " + retur.getOID(), null);
                                                                                                    long pId = JSPRequestValue.requestLong(request, "periode" + retur.getOID());
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="tablearialcell1" align="center"><%=i + 1%></td>
                                                                                                        <td class="tablearialcell1" align="center"><%=retur.getNumber()%></td>                                                                                                        
                                                                                                        <td class="tablearialcell1" align="center"><%=dtx%></td>
                                                                                                        <td class="tablearialcell1" align="left">&nbsp;<%=vendorx.getName().toUpperCase()%></td>
                                                                                                        <td class="tablearialcell1" align="left">&nbsp;<%=location.getName().toUpperCase() %></td>
                                                                                                        <td class="tablearialcell1" align="center">
                                                                                                            <select name="periode<%=retur.getOID()%>">
                                                                                                                <option value="0" <%if (pId == 0) {%> selected <%}%>> < Default > </option>
                                                                                                                <%
    if (vPeriode != null && vPeriode.size() > 0) {
        for (int ix = 0; ix < vPeriode.size(); ix++) {
            Periode p = (Periode) vPeriode.get(ix);
                                                                                                                %>
                                                                                                                <option value="<%=p.getOID()%>" <%if (p.getOID() == pId) {%> selected <%}%>><%=p.getName()%></option>
                                                                                                                <%
        }
    }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1" align="left">&nbsp;<%=retur.getNote()%></td>
                                                                                                        <td class="tablearialcell1" align="center"><input type="checkbox" name="post<%=retur.getOID()%>" value="1"></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%if (vRetDet != null && vRetDet.size() > 0) {%>
                                                                                                    <tr>
                                                                                                        <td class="tablearialcell" align="center">&nbsp</td>
                                                                                                        <td class="tablearialcell1" align="left" colspan="6">
                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                                <tr>
                                                                                                                    <td class="tablearialcell" align="center" width="30%"><B>Name</b></td>                                                                        
                                                                                                                    <td class="tablearialcell" align="center" width="15%"><B>Qty</b></td>
                                                                                                                    <td class="tablearialcell" align="center" width="15%"><B>Price</b></td>
                                                                                                                    <td class="tablearialcell" align="center" width="35%"><B>Total</b></td>
                                                                                                                </tr>
                                                                                                                <%
    double totSum = 0;
    for (int t = 0; t < vRetDet.size(); t++) {
        ReturItem ri = (ReturItem) vRetDet.get(t);
        ItemMaster im = new ItemMaster();
        try {
            im = DbItemMaster.fetchExc(ri.getItemMasterId());
        } catch (Exception e) {
        }
        double sum = ri.getQty() * ri.getAmount();
        totSum = totSum + sum;

                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td class="tablearialcell" align="left" >&nbsp;<%=im.getName()%></td>                                                                        
                                                                                                                    <td class="tablearialcell" align="right" ><%=JSPFormater.formatNumber(ri.getQty(), "###,###.##")%>&nbsp;&nbsp;</td>
                                                                                                                    <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(ri.getAmount(), "###,###.##")%>&nbsp;&nbsp;</td>
                                                                                                                    <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(sum, "###,###.##")%>&nbsp;&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <tr>
                                                                                                                    <td class="tablearialcell" align="left" >&nbsp;</td>                                                                        
                                                                                                                    <td class="tablearialcell" align="right" colspan="2"><B>Discount</B></td>
                                                                                                                    <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(retur.getDiscountTotal(), "###,###.##")%>&nbsp;&nbsp;</B></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td class="tablearialcell" align="left" >&nbsp;</td>                                                                        
                                                                                                                    <td class="tablearialcell" align="right" colspan="2"><B>Vat</B></td>
                                                                                                                    <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(retur.getTotalTax(), "###,###.##")%>&nbsp;&nbsp;</B></td>
                                                                                                                </tr>
                                                                                                                <%
    double grandTotal = totSum + retur.getTotalTax() - retur.getDiscountTotal();
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td class="tablearialcell" align="left" >&nbsp;</td>                                                                        
                                                                                                                    <td class="tablearialcell" align="right" colspan="2"><B>Grand Total</B></td>
                                                                                                                    <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(grandTotal, "###,###.##")%>&nbsp;&nbsp;</B></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>                                                                                                        
                                                                                                        <td class="tablearialcell" align="center">&nbsp;</td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr>
                                                                                                        <td align="center" colspan="8" height="5"></td>                                                                        
                                                                                                    </tr> 
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td> 
                                                                                        </tr>                                                                                           
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td valign="middle" colspan="3" height="10"></td>
                                                                                        </tr>       
                                                                                        <%if (privUpdate || privAdd) {%>
                                                                                        <tr align="left" valign="top" id="closecmd"> 
                                                                                            <td valign="middle" colspan="3"> 
                                                                                                <a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr id="closemsg" align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td> <font color="#006600">Posting retur in progress, please wait .... </font> </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td height="1">&nbsp; </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td> <img src="../images/progress_bar.gif" border="0"> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <% } else {%>
                                                                                        <%if (iJSPCommand != JSPCommand.ACTIVATE) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="fontarial"><i><%=langNav[8]%>...</i></td>
                                                                                        </tr>
                                                                                        <%
                    }
                }
            } catch (Exception exc) {
                System.out.println("exc : " + exc.toString());
            }%>
                                                                                        <%if (msg.length() > 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td valign="middle" colspan="3">
                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                    <tr> 
                                                                                                        <td width="20"><img src="<%=approot%>/images/success.gif"></td>
                                                                                                        <td width="200" nowrap><%=msg%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>    
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>                                                                                       
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3">&nbsp;</td>
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
