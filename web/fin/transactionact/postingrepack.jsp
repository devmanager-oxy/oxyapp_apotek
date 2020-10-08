
<%-- 
    Document   : postingrepack
    Created on : Aug 26, 2013, 2:25:42 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.ccs.postransaction.repack.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.printman.*" %>
<%@ page import = "com.project.fms.printing.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_REPACK_POST);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_REPACK_POST, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_REPACK_POST, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_REPACK_POST, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_REPACK_POST, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            String journalNumber = JSPRequestValue.requestString(request, "journal_number");
            
            int allowPeriod = 0;
            try{
                allowPeriod = Integer.parseInt(DbSystemProperty.getValueByName("ALLOW_SELECT_PERIOD"));
            }catch(Exception e){}

            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
            }

            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }

            String whereClause = "" + DbRepack.colNames[DbRepack.COL_STATUS] + " = '" + I_Project.DOC_STATUS_APPROVED+"' ";

            if (journalNumber != null && journalNumber.length() > 0) {
                whereClause = whereClause + " and " + DbRepack.colNames[DbRepack.COL_NUMBER] + " like '%" + journalNumber + "%'";
            }

            if (srcLocationId != 0) {
                if (whereClause != null && whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbRepack.colNames[DbRepack.COL_LOCATION_ID] + "=" + srcLocationId;
            }

            if (srcIgnore == 0 && iJSPCommand != JSPCommand.NONE) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (to_days(" + DbRepack.colNames[DbRepack.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbRepack.colNames[DbRepack.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                } else {
                    whereClause = whereClause + "(to_days(" + DbRepack.colNames[DbRepack.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbRepack.colNames[DbRepack.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                }
            }

            Vector listRepack = new Vector();
            if (iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.ACTIVATE) {
                listRepack = DbRepack.list(0, 0, whereClause, DbRepack.colNames[DbRepack.COL_PREFIX_NUMBER] + "," + DbRepack.colNames[DbRepack.COL_NUMBER]);
            }

            boolean postingOk = true;
            if (iJSPCommand == JSPCommand.ACTIVATE) {
                if (listRepack != null && listRepack.size() > 0) {
                    for (int i = 0; i < listRepack.size(); i++) {
                        Repack repack = (Repack) listRepack.get(i);
                        if (JSPRequestValue.requestInt(request, "post" + repack.getOID()) == 1) {
                            long pId = JSPRequestValue.requestLong(request, "periode" + repack.getOID());
                            Vector details = DbRepackItem.list(0, 0, DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID] + " = " + repack.getOID() + " and " + DbRepackItem.colNames[DbRepackItem.COL_TYPE] + "=" + DbRepackItem.TYPE_OUTPUT, null);
                            int ok = DbRepack.postJournal(repack, details, user.getOID(), pId);
                            if (ok == 0) {
                                postingOk = false;
                            }
                        }
                    }
                }
                listRepack = DbRepack.list(0, 0, whereClause, DbRepack.colNames[DbRepack.COL_PREFIX_NUMBER] + "," + DbRepack.colNames[DbRepack.COL_NUMBER]);
            }

            String[] langRP = {"Location", "Document", "Date", "Ignored", "To", "Number", "Notes", "Period", "Item Name", "Qty", "Price", "Amount"};
            String[] langNav = {"Journal", "Repack - Post Journal", "Records", "Adjusment Stock", "Search Parameters", "Posted journal success",
                "Some journal can't be posted, please check coa configuration in group item", "Click search button to show the data", "Posting data success", "Some data can't proccess", "Data not found"
            };

            if (lang == LANG_ID) {
                String[] langID = {"Lokasi", "Dokumen", "Tanggal", "Abaikan", "Sampai", "Nomor", "Keterangan", "Periode", "Nama Barang", "Qty", "Harga", "Jumlah"};
                langRP = langID;

                String[] navID = {"Jurnal", "Repack - Post Jurnal", "Arsip", "Penyesuaian Stock", "Parameter Pencarian", "Jurnal berhasil diposting",
                    "Beberapa jurnal gagal di posting, cek setup coa di item group", "Klik tombol search untuk menampilkan data", "Posting data berhasil", "Beberapa data gagal di posting", "Data tidak ditemukan"
                };
                langNav = navID;
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
            
            function setChecked(val){
                 <%

            if (listRepack != null && listRepack.size() > 0) {
                for (int i = 0; i < listRepack.size(); i++) {
                    Repack repack = (Repack) listRepack.get(i);
                    /* Vector vRepackItem = DbRepackItem.list(0, 0, DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID] + " = " + repack.getOID(), null);
                    int tOutput = 0;
                    boolean qtyOk = true;
                    if (vRepackItem != null && vRepackItem.size() > 0) {
                        for (int t = 0; t < vRepackItem.size(); t++) {
                            RepackItem ri = (RepackItem) vRepackItem.get(t);
                            if (ri.getQty() <= 0) {
                                qtyOk = false;
                            }
                            if (ri.getType() == DbRepackItem.TYPE_OUTPUT) {
                                tOutput = tOutput + 1;
                            }
                        }
                    }*/
                    //if (qtyOk && tOutput == 1) {
                        %>
                            document.frmrepack.post<%=repack.getOID()%>.checked=val.checked;
                        <%
                    //}
                }
            }
            %>
            }
            
            function cmdSearch(){
                document.frmrepack.command.value="<%=JSPCommand.LIST%>";
                document.frmrepack.action="postingrepack.jsp";
                document.frmrepack.submit();
            }
            
            function cmdPost(){                
                document.frmrepack.command.value="<%=JSPCommand.ACTIVATE%>";                     
                document.frmrepack.action="postingrepack.jsp";
                document.frmrepack.submit();
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
                                                        <form name="frmrepack" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                                        
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="title"> 
                                                                        <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                                                        %>
                                                                        <%@ include file="../main/navigator.jsp"%>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">                                
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3" > 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                  
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3" height="15">
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td colspan="6" height="10"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="6"><i><%=langNav[4]%>:</i></td>
                                                                                                    </tr>                                                                                                                
                                                                                                    <tr height="22">
                                                                                                        <td width="90" class="tablecell1">&nbsp;&nbsp;<%=langRP[5]%></td>
                                                                                                        <td height="1" class="fontarial">:</td> 
                                                                                                        <td width="270"><input type="text" name="journal_number" class="fontarial" value="<%=journalNumber%>"></td>
                                                                                                        <td width="90" class="tablecell1">&nbsp;&nbsp;<%=langRP[2]%></td> 
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td >    
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrepack.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td class="fontarial">&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                                                                                    <td>
                                                                                                                        <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrepack.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>></td>
                                                                                                                    <td class="fontarial">Ignored</td>
                                                                                                                </tr>
                                                                                                            </table>  
                                                                                                        </td>
                                                                                                    </tr> 
                                                                                                    <tr height="22"> 
                                                                                                        <td class="tablecell1">&nbsp;&nbsp;<%=langRP[0]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <select name="src_location_id">
                                                                                                                <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>< All Location ></option>
                                                                                                                <%

            Vector vloc = DbLocation.list(0, 0, "", "name");

            if (vloc != null && vloc.size() > 0) {
                for (int i = 0; i < vloc.size(); i++) {
                    Location loc = (Location) vloc.get(i);
                    String str = "";
                                                                                                                %>
                                                                                                                <option value="<%=loc.getOID()%>" <%if (srcLocationId == loc.getOID()) {%>selected<%}%>><%=loc.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>         
                                                                                                        <td colspan="3" ></td>                                                                                                        
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
                                                                                            <td valign="middle" colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                        </tr>         
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3" height="15"></td>
                                                                                        </tr>    
                                                                                        <%if (iJSPCommand != JSPCommand.NONE) {%>
                                                                                        
                                                                                        <%if (listRepack != null && listRepack.size() > 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">
                                                                                                
                                                                                                <table width="1000" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr height="22">
                                                                                                        <td width="4%" class="tablearialhdr">No</td>
                                                                                                        <td width="10%" class="tablearialhdr"><%=langRP[5]%></td>
                                                                                                        <td width="12%" class="tablearialhdr"><%=langRP[2]%></td>
                                                                                                        <td width="22%" class="tablearialhdr"><%=langRP[0]%></td>                                                                                                        
                                                                                                        <td width="15%" class="tablearialhdr"><%=langRP[7]%></td>
                                                                                                        <td class="tablearialhdr"><%=langRP[6]%></td>                                            
                                                                                                        <td width="3%" class="tablearialhdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                                    </tr>  
                                                                                                    <%
    for (int i = 0; i < listRepack.size(); i++) {
        Repack repack = (Repack) listRepack.get(i);
        Location location = new Location();
        try {
            location = DbLocation.fetchExc(repack.getLocationId());
        } catch (Exception e) {
        }

        long pId = JSPRequestValue.requestLong(request, "periode" + repack.getOID());
        Vector vRepackItem = DbRepackItem.list(0, 0, DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID] + " = " + repack.getOID(), null);
                                                                                                    %>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablearialcell1" align="center"><%=i + 1%></td>
                                                                                                        <td class="tablearialcell1" align="center"><%=repack.getNumber()%></td>
                                                                                                        <td class="tablearialcell1" align="center"><%=JSPFormater.formatDate(repack.getDate(), "dd MMM yyyy")%></td>
                                                                                                        <td class="tablearialcell1"><%=location.getName()%></td>                                                                                                        
                                                                                                        <td class="tablearialcell1" align="center">
                                                                                                            <select name="periode<%=repack.getOID()%>">
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
                                                                                                        <td class="tablearialcell1"><%=repack.getNote()%></td>
                                                                                                        <%
                                                                                                        int tOutput = 0;
                                                                                                        boolean qtyOk = true;
                                                                                                        if (vRepackItem != null && vRepackItem.size() > 0) {
                                                                                                            for (int t = 0; t < vRepackItem.size(); t++) {
                                                                                                                RepackItem ri = (RepackItem) vRepackItem.get(t);
                                                                                                                if (ri.getQty() <= 0) {
                                                                                                                    qtyOk = false;
                                                                                                                }
                                                                                                                if (ri.getType() == DbRepackItem.TYPE_OUTPUT) {
                                                                                                                    tOutput = tOutput + 1;
                                                                                                                }
                                                                                                            }
                                                                                                        }

                                                                                                        %>
                                                                                                        <td class="tablearialcell1" align="center"><input type="checkbox" name="post<%=repack.getOID()%>" value="1"></td>
                                                                                                    </tr>  
                                                                                                    
                                                                                                    <%if (vRepackItem != null && vRepackItem.size() > 0) {%>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablearialcell">&nbsp;</td>
                                                                                                        <td class="tablearialcell1" colspan="5">
                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                                <tr height="22">
                                                                                                                    <td class="tablearialcell" align="center" width="40%"><B><%=langRP[8]%></b></td>   
                                                                                                                    <td class="tablearialcell" align="center" ><B><%=langRP[9]%></b></td>   
                                                                                                                    <td class="tablearialcell" align="center" width="14%"><B><%=langRP[10]%></b></td>  
                                                                                                                    <td class="tablearialcell" align="center" width="15%"><B><%=langRP[11]%></b></td>                                                       
                                                                                                                    <td class="tablearialcell" align="center" width="5"></td> 
                                                                                                                    <td class="tablearialcell" align="center" width="50"></td> 
                                                                                                                    <td class="tablearialcell" align="center" width="20%">&nbsp;</td>                                                     
                                                                                                                </tr>
                                                                                                                <%
    double total = 0;
    for (int t = 0; t < vRepackItem.size(); t++) {
        RepackItem ri = (RepackItem) vRepackItem.get(t);
        ItemMaster im = new ItemMaster();
        try {
            im = DbItemMaster.fetchExc(ri.getItemMasterId());
        } catch (Exception e) {
        }
        total = total + (ri.getCogs() * ri.getQty());

        String status = "";
        String color = "#E95336";
        if (ri.getType() == DbRepackItem.TYPE_INPUT) {
            status = "STOCK OUT";
            color = "#7CCB80";
        } else {
            status = "STOCK IN";
            color = "#E95336";
        }
                                                                                                                %>
                                                                                                                <tr height="22">
                                                                                                                    <td class="tablearialcell" align="left"><%=im.getName()%></td>   
                                                                                                                    <td class="tablearialcell" align="right" ><%=JSPFormater.formatNumber(ri.getQty(), "###,###.###")  %></td>   
                                                                                                                    <td class="tablearialcell" align="right" ><%=JSPFormater.formatNumber(ri.getCogs(), "###,###.##")%></td>  
                                                                                                                    <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber((ri.getQty() * ri.getCogs()), "###,###.##")%></td>                                                  
                                                                                                                    <td class="tablearialcell" align="center">&nbsp;</td> 
                                                                                                                    <td align="center" bgcolor="<%=color%>"><font face="arial"><%=status%></font></td>  
                                                                                                                    <td class="tablearialcell" align="center">&nbsp;</td> 
                                                                                                                </tr>
                                                                                                                <%}%>     
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%}%>      
                                                                                                    <%}%>  
                                                                                                </table>
                                                                                            </td>   
                                                                                        </tr>   
                                                                                        <tr height="5">
                                                                                            <td colspan="7">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <tr height="5">
                                                                                            <td colspan="7">
                                                                                                <a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a>
                                                                                            </td>                
                                                                                        </tr>
                                                                                        <tr height="30">
                                                                                            <td colspan="7">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <%}%>             
                                                                                        
                                                                                        <%if (iJSPCommand == JSPCommand.ACTIVATE) {%>
                                                                                        <tr >
                                                                                            <%if (postingOk) {%>
                                                                                            <td colspan="7"><font face="arial"><i><%=langNav[8]%> ...</i></font></td>
                                                                                            <%} else {%>
                                                                                            <td colspan="7"><font face="arial"><i><%=langNav[9]%> ...</i></font></td>
                                                                                            <%}%>
                                                                                        </tr> 
                                                                                        <tr height="30">
                                                                                            <td colspan="7">&nbsp;</td>
                                                                                        </tr> 
                                                                                        <%} else {%>
                                                                                        <%if (listRepack == null || listRepack.size() <= 0) {%>
                                                                                        <tr >
                                                                                            <td colspan="7"><font face="arial"><i><%=langNav[10]%> ...</i></font></td>
                                                                                        </tr>
                                                                                        <tr height="30">
                                                                                            <td colspan="7">&nbsp;</td>
                                                                                        </tr> 
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                        
                                                                                        <%} else {%>     
                                                                                        <tr >
                                                                                            <td colspan="7"><font face="arial"><i><%=langNav[7]%> ...</i></font></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>                                                    
                                                                                </td>
                                                                            </tr>     
                                                                        </table>                                                                        
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                        <!-- #EndEditable -->
                                                    </td>
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
