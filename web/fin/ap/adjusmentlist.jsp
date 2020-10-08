
<%-- 
    Document   : adjusmentlist
    Created on : Apr 5, 2012, 12:49:13 PM
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
<%@ page import = "com.project.ccs.postransaction.adjusment.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_POST);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_POST, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_POST, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_POST, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_POST, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->

<%!
    public static String getAccountRecursif(int minus, Coa coa, long oid, boolean isPostableOnly) {

        int level = 0;
        String result = "";
        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
            Vector coas = DbCoa.list(0, 0, "acc_ref_id=" + coa.getOID(), "code");
            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {
                    Coa coax = (Coa) coas.get(i);
                    String str = "";
                    if (!isPostableOnly) {
                        level = coax.getLevel() + minus;
                        switch (level) {
                            case 0:
                                break;
                            case 1:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 2:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 3:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 4:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 5:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                        }
                    }
                    result = result + "<option value=\"" + coax.getOID() + "\"" + ((oid == coax.getOID()) ? "selected" : "") + ">" + str + coax.getCode() + " - " + coax.getName() + "</option>";
                    if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        result = result + getAccountRecursif(minus, coax, oid, isPostableOnly);
                    }
                }
            }
        }
        return result;
    }

%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidAdjusment = JSPRequestValue.requestLong(request, "hidden_adjusment_id");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            String journalNumber = JSPRequestValue.requestString(request, "journal_number");
            String keterangan = JSPRequestValue.requestString(request, "txtketerangan");

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
            
            int allowPeriod = 0;
            try{
                allowPeriod = Integer.parseInt(DbSystemProperty.getValueByName("ALLOW_SELECT_PERIOD"));
            }catch(Exception e){}

            /*variable declaration*/
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = DbAdjusment.colNames[DbAdjusment.COL_STATUS] + "='" + I_Project.STATUS_DOC_APPROVED + "'";
            String orderClause = "";

            if (srcLocationId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbAdjusment.colNames[DbAdjusment.COL_LOCATION_ID] + "=" + srcLocationId;
            }

            if (srcIgnore == 0 && iJSPCommand != JSPCommand.NONE) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (to_days(" + DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_1_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_1_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                } else {
                    whereClause = whereClause + " (to_days(" + DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_1_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_1_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                }
            }

            if (journalNumber != null && journalNumber.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbAdjusment.colNames[DbAdjusment.COL_NUMBER] + " like '%" + journalNumber + "%'";
            }

            if (keterangan != null && keterangan.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbAdjusment.colNames[DbAdjusment.COL_NOTE] + " like '%" + keterangan + "%'";
            }

            Vector listAdjusment = new Vector(1, 1);

            orderClause = " year(" + DbAdjusment.colNames[DbAdjusment.COL_DATE] + "),month(" + DbAdjusment.colNames[DbAdjusment.COL_DATE] + ")," + DbAdjusment.colNames[DbAdjusment.COL_NUMBER];
            if (iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.ACTIVATE) {
                listAdjusment = DbAdjusment.list(0, 0, whereClause, orderClause);
            }

            String[] langAR = {"Location", "Document", "Approve Date", "Ignored", "To", "Transaction Number", "Notes", "Period", "Item Name", "Qty", "Price", "Amount"};
            String[] langNav = {"Journal", "Adjusment - Post Journal", "Records", "Adjusment Stock", "Search Parameters", "Posted journal success",
                "Some journal can't be posted, please check coa configuration in group item", "Data not found"
            };

            if (lang == LANG_ID) {
                String[] langID = {"Lokasi", "Dokumen", "Tanggal Approve", "Abaikan", "Sampai", "Nomor Transaksi", "Keterangan", "Periode", "Nama Barang", "Qty", "Harga", "Jumlah"};
                langAR = langID;

                String[] navID = {"Jurnal", "Adjusment - Post Jurnal", "Arsip", "Penyesuaian Stock", "Parameter Pencarian", "Jurnal berhasil diposting",
                    "Beberapa jurnal gagal di posting, cek setup coa di item group", "Data tidak ditemukan"
                };
                langNav = navID;
            }

            String msg = "";
            Vector vPeriode = new Vector();
            if(allowPeriod == 1){
                vPeriode = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "' ", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            }       

            if (iJSPCommand == JSPCommand.ACTIVATE) { // jika posted

                for (int i = 0; i < listAdjusment.size(); i++) {

                    Adjusment adjusment = (Adjusment) listAdjusment.get(i);
                    if (JSPRequestValue.requestInt(request, "post" + adjusment.getOID()) == 1) {
                        if (msg.length() <= 0) {
                            msg = langNav[5];
                        }
                        long pId = JSPRequestValue.requestLong(request, "periode" + adjusment.getOID());
                        Vector details = new Vector();
                        details = DbAdjusmentItem.list(0, 0, DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ID] + " = " + adjusment.getOID(), null);
                        Hashtable coaItem = new Hashtable();

                        boolean isHeader = false;
                        String oidExc = "";
                        Vector detalisSelect = new Vector();
                        
                        if (details != null && details.size() > 0) {
                            for (int t = 0; t < details.size(); t++) {
                                AdjusmentItem ci = (AdjusmentItem) details.get(t);
                                long coaCogsId = JSPRequestValue.requestLong(request, "coa_cogs_" + ci.getOID());
                                
                                if (coaCogsId != 0) {
                                    detalisSelect.add(ci);
                                    Coa c = new Coa();
                                    try {
                                        c = DbCoa.fetchExc(coaCogsId);
                                        if (!c.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                                            isHeader = true;
                                        }
                                    } catch (Exception e) {
                                    }
                                    c.setOID(coaCogsId);
                                    coaItem.put("" + ci.getOID(), c);

                                    if (oidExc.length() > 0) {
                                        oidExc = oidExc + ",";
                                    }
                                    oidExc = oidExc + ci.getOID();
                                }
                            }
                        }

                        int x = 0;
                        if (isHeader == false) {
                            x = DbAdjusment.postJournal(adjusment, detalisSelect, coaItem, user.getOID(), pId,oidExc);
                        }
                        if (x == 0) {
                            msg = langNav[6];
                        }

                    }
                }
                listAdjusment = DbAdjusment.list(0, 0, whereClause, orderClause);
            }
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_EXPENSE + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
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
                document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
                document.frmadjusment.action="adjusmentlist.jsp";
                document.frmadjusment.submit();
            }
            
            function setChecked(val){
                 <%
            for (int k = 0; k < listAdjusment.size(); k++) {
                Adjusment adj = (Adjusment) listAdjusment.get(k);
                 %>
                     document.frmadjusment.post<%=adj.getOID()%>.checked=val.checked;
                     <% }%>
                 }
                 
                 function cmdPost(){                
                     document.all.closecmd.style.display="none";
                     document.all.closemsg.style.display="";
                     document.frmadjusment.command.value="<%=JSPCommand.ACTIVATE%>";
                     document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
                     document.frmadjusment.action="adjusmentlist.jsp";
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
                                                        <form name="frmadjusment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_adjusment_id" value="<%=oidAdjusment%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr valign="bottom"> 
                                                                                <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                                                                %>
                                                                                <%@ include file="../main/navigator.jsp"%>
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
                                                                                            <td colspan="3">
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td colspan="5" class="fontarial"><i><%=langNav[4]%>:</i></td>
                                                                                                    </tr>                                                           
                                                                                                    <tr> 
                                                                                                        <td width="100" class="tablearialcell1" >&nbsp;&nbsp;<%=langAR[5]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td width="240"><input type="text" size="20" name="journal_number" value="<%=journalNumber%>" class="fontarial" ></td>
                                                                                                        <td width="100" class="tablearialcell1" >&nbsp;&nbsp;<%=langAR[2]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                            <table border = "0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td><input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>    
                                                                                                                    <td class="fontarial">&nbsp;&nbsp;<%=langAR[4]%>&nbsp;&nbsp;</td>    
                                                                                                                    <td><input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly></td>    
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>     
                                                                                                                    <td><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>></td>    
                                                                                                                    <td class="fontarial"><%=langAR[3]%></td>    
                                                                                                                </tr>   
                                                                                                            </table>   
                                                                                                        </td>
                                                                                                    </tr>                                                            
                                                                                                    <tr>
                                                                                                        <td class="tablearialcell1" >&nbsp;&nbsp;<%=langAR[0]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td > 
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
                                                                                                        <td class="tablearialcell1" >&nbsp;&nbsp;<%=langAR[6]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td ><input type="text" name="txtketerangan" value = "<%=keterangan%>" class="fontarial"></td>
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
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                            <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a> </td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listAdjusment != null && listAdjusment.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td valign="middle" colspan="3" height="35">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td valign="middle" colspan="3">
                                                                                                <table width="1100" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr height="22">
                                                                                                        <td width="4%" class="tablearialhdr">No</td>
                                                                                                        <td width="10%" class="tablearialhdr"><%=langAR[5]%></td>
                                                                                                        <td width="12%" class="tablearialhdr"><%=langAR[2]%></td>
                                                                                                        <td width="22%" class="tablearialhdr"><%=langAR[0]%></td>                                                                                                        
                                                                                                        <td width="15%" class="tablearialhdr"><%=langAR[7]%></td>
                                                                                                        <td class="tablearialhdr"><%=langAR[6]%></td>
                                                                                                        <td width="3%" class="tablearialhdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                                    </tr>  
                                                                                                    <%
                                                                                                for (int i = 0; i < listAdjusment.size(); i++) {
                                                                                                    Adjusment adjusment = (Adjusment) listAdjusment.get(i);

                                                                                                    Location location = new Location();
                                                                                                    try {
                                                                                                        location = DbLocation.fetchExc(adjusment.getLocationId());
                                                                                                    } catch (Exception e) {
                                                                                                    }
                                                                                                    long pId = JSPRequestValue.requestLong(request, "periode" + adjusment.getOID());

                                                                                                    Vector vAdjItem = DbAdjusmentItem.list(0, 0, DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ID] + " = " + adjusment.getOID(), null);
                                                                                                    %>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablearialcell1" align="center"><%=i + 1%></td>
                                                                                                        <td class="tablearialcell1" align="center"><%=adjusment.getNumber()%></td>
                                                                                                        <td class="tablearialcell1" align="center"><%=JSPFormater.formatDate(adjusment.getApproval1_date(), "dd MMM yyyy")%></td>
                                                                                                        <td class="tablearialcell1"><%=location.getName()%></td>                                                                                                        
                                                                                                        <td class="tablearialcell1" align="center">
                                                                                                            <select name="periode<%=adjusment.getOID()%>">
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
                                                                                                        <td class="tablearialcell1"><%=adjusment.getNote()%></td>
                                                                                                        <td class="tablearialcell1" align="center"><input type="checkbox" name="post<%=adjusment.getOID()%>" value="1"></td>
                                                                                                    </tr>  
                                                                                                    <%
                                                                                                        if (vAdjItem != null && vAdjItem.size() > 0) {
                                                                                                            double qty = 0;
                                                                                                            double tot = 0;
                                                                                                    %>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablearialcell">&nbsp;</td>
                                                                                                        <td class="tablearialcell1" colspan="5">
                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                                <tr height="22">
                                                                                                                    <td class="tablearialcell" align="center" ><B><%=langAR[8]%></b></td>   
                                                                                                                    <td class="tablearialcell" align="center" width="10%"><B>Type</b></td>  
                                                                                                                    <td class="tablearialcell" align="center" width="23%"><B>Pekiraan Inventory</b></td>
                                                                                                                    <td class="tablearialcell" align="center" width="23%"><B>Pekiraan COGS</b></td>
                                                                                                                    <td class="tablearialcell" align="center" width="4%"><B><%=langAR[9]%></b></td>   
                                                                                                                    <td class="tablearialcell" align="center" width="10%"><B><%=langAR[10]%></b></td>  
                                                                                                                    <td class="tablearialcell" align="center" width="10%"><B><%=langAR[11]%></b></td>  
                                                                                                                    
                                                                                                                </tr>
                                                                                                                <%
                                                                                                        double total = 0;
                                                                                                        for (int t = 0; t < vAdjItem.size(); t++) {
                                                                                                            AdjusmentItem ai = (AdjusmentItem) vAdjItem.get(t);
                                                                                                            ItemMaster im = new ItemMaster();
                                                                                                            try {
                                                                                                                im = DbItemMaster.fetchExc(ai.getItemMasterId());
                                                                                                            } catch (Exception e) {
                                                                                                            }
                                                                                                            total = total + ai.getAmount();
                                                                                                            qty = qty + ai.getQtyBalance();
                                                                                                            tot = tot + ai.getAmount();

                                                                                                            String coaInv = "";
                                                                                                            String coaCogs = "";

                                                                                                            try {
                                                                                                                ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                                                                                                try {
                                                                                                                    if (ig.getAccountInv().length() > 0) {
                                                                                                                        Coa c = DbCoa.getCoaByCode(ig.getAccountInv());
                                                                                                                        coaInv = c.getName();
                                                                                                                    }
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                                try {
                                                                                                                    if (ig.getAccountAjustment().length() > 0) {
                                                                                                                        Coa c = DbCoa.getCoaByCode(ig.getAccountAjustment());
                                                                                                                        coaCogs = c.getName();
                                                                                                                    }
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                            } catch (Exception e) {
                                                                                                            }

                                                                                                            long coaCogsId = JSPRequestValue.requestLong(request, "coa_cogs_" + ai.getOID());

                                                                                                                %>
                                                                                                                <tr height="22">
                                                                                                                    <td class="tablearialcell" align="left"><%=im.getName()%></td> 
                                                                                                                    <%if (im.getNeedRecipe() == 1) {%>
                                                                                                                    <td class="tablearialcell" align="center">NON</td> 
                                                                                                                    <%} else {%>
                                                                                                                    <td class="tablearialcell" align="center">STOCKABLE</td> 
                                                                                                                    <%}%>
                                                                                                                    <td class="tablearialcell" align="left"><%=coaInv%></td> 
                                                                                                                    <td class="tablearialcell" align="left">
                                                                                                                        <select name="coa_cogs_<%=ai.getOID()%>">
                                                                                                                            <option <%if (coaCogsId == 0) {%>selected<%}%> value="0">- Default Perkiraan -</option>
                                                                                                                            <%if (accLinks != null && accLinks.size() > 0) {
                                                                                                                        for (int z = 0; z < accLinks.size(); z++) {
                                                                                                                            AccLink accLink = (AccLink) accLinks.get(z);
                                                                                                                            Coa coa = new Coa();
                                                                                                                            try {
                                                                                                                                coa = DbCoa.fetchExc(accLink.getCoaId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }
                                                                                                                            %>
                                                                                                                            <option <%if (coaCogsId == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coa.getLevel() * -1, coa, coaCogsId, isPostableOnly)%> 
                                                                                                                            <%}
} else {%>
                                                                                                                            <option><%=langNav[3]%></option>
                                                                                                                            <%}%>
                                                                                                                        </select>  
                                                                                                                    </td> 
                                                                                                                    <td class="tablearialcell" align="right" ><%=JSPFormater.formatNumber(ai.getQtyBalance(), "###,###") %></td>   
                                                                                                                    <td class="tablearialcell" align="right" ><%=JSPFormater.formatNumber(ai.getPrice(), "###,###.##")%></td>  
                                                                                                                    <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(ai.getAmount(), "###,###.##")%></td>  
                                                                                                                </tr>
                                                                                                                <%}%> 
                                                                                                                <tr height="22">
                                                                                                                    <td class="tablearialcell1" align="center" colspan="4"><b>Total</b></td>                                                 
                                                                                                                    <td class="tablearialcell1" align="right" ><b><%=JSPFormater.formatNumber(qty, "###,###")%></b></td>   
                                                                                                                    <td class="tablearialcell1" align="right" >&nbsp;</td>  
                                                                                                                    <td class="tablearialcell1" align="right"><b><%=JSPFormater.formatNumber(total, "###,###.##")%></b></td>  
                                                                                                                    
                                                                                                                </tr>                                                                                                               
                                                                                                            </table>
                                                                                                        </td>   
                                                                                                        <td class="tablearialcell">&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <%}%>                                                                                                    
                                                                                                    <tr height="5">
                                                                                                        <td colspan="7"></td>
                                                                                                    </tr>    
                                                                                                    <%
                                                                                                }
                                                                                                    %>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <tr align="left" valign="top" id="closecmd"> 
                                                                                            <td valign="middle" colspan="3"> 
                                                                                                <a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr id="closemsg" align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td> <font color="#006600">Posting Adjusment in progress, please wait .... </font> </td>
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
                                                                                        
                                                                                        
                                                                                        <%} else {%>
                                                                                        <%if (iJSPCommand == JSPCommand.LIST) {%>  
                                                                                        <tr align="left" valign="top" height="30"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>                      
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="fontarial"><i><%=langNav[7]%>...</i></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%if (iJSPCommand == JSPCommand.NONE) {%>  
                                                                                        <tr align="left" valign="top" height="30"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>                      
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="fontarial"><i>Klik Tombol search untuk melakukan pencarian ..</i></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            } catch (Exception exc) {
                System.out.println("exception : " + exc.toString());
            }%>
                                                                                        <%if (msg.length() > 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td valign="middle" colspan="3">
                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                    <tr> 
                                                                                                        <td width="20"><img src="<%=approot%>/images/success.gif" width="20"></td>
                                                                                                        <td width="300" nowrap><i><%=msg%></i></td>
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

