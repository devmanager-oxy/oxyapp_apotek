
<%-- 
    Document   : costlist
    Created on : Apr 11, 2012, 11:17:29 AM
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
<%@ page import = "com.project.ccs.postransaction.costing.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_POST);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_POST, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_POST, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_POST, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_POST, AppMenu.PRIV_DELETE);
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
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            long srcLocationExpId = JSPRequestValue.requestLong(request, "src_locationexp_id");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            String journalNumber = JSPRequestValue.requestString(request, "journal_number");

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

            String whereClause = "";
            String whereClause2 = ""; 
            String orderClause = "";

            whereClause = whereClause + " and "+ DbCosting.colNames[DbCosting.COL_STATUS] + "='" + I_Project.DOC_STATUS_APPROVED + "'";
            whereClause2 = whereClause2 + " and "+DbCosting.colNames[DbCosting.COL_STATUS] + "='" + I_Project.DOC_STATUS_APPROVED + "'";
            
            if (srcLocationId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                    whereClause2 = whereClause2 + " and ";
                }
                whereClause = whereClause + DbCosting.colNames[DbCosting.COL_LOCATION_ID] + "=" + srcLocationId;
                whereClause2 = whereClause2 + DbCosting.colNames[DbCosting.COL_LOCATION_ID] + "=" + srcLocationId;
            }


            if (srcLocationExpId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                    whereClause2 = whereClause2 + " and ";
                }
                whereClause = whereClause + DbCosting.colNames[DbCosting.COL_LOCATION_POST_ID] + "=" + srcLocationExpId;
                whereClause2 = whereClause2 + DbCosting.colNames[DbCosting.COL_LOCATION_ID] + "=" + srcLocationExpId;
            }

            if (srcIgnore == 0 && iJSPCommand != JSPCommand.NONE) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                    whereClause2 = whereClause2 + " and (to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))"; 
                } else {
                    whereClause = "(to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                    whereClause2 = "(to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                }
            }

            if (journalNumber != null && journalNumber.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                    whereClause2 = whereClause2 + " and ";
                }
                whereClause = whereClause + DbCosting.colNames[DbCosting.COL_NUMBER] + " like '%" + journalNumber + "%'";
                whereClause2 = whereClause2 + DbCosting.colNames[DbCosting.COL_NUMBER] + " like '%" + journalNumber + "%'";
            }

            Vector listCosting = new Vector(1, 1);
            orderClause = DbCosting.colNames[DbCosting.COL_DATE];
            if (iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.POST) {
                listCosting = DbCosting.listCosting(whereClause,whereClause2,orderClause);
            }

            String msg = "";
            String[] langCST = {"Location", "Document Status", "Date", "Ignored", "To", "Journal Number", "Notes", "Costing", "Posted journal success",
                "Some journal can't be posted", "Item Name", "Price", "Expense Account"
            };

            String[] langNav = {"Journal", "Costing - Post Journal", "Records", "Costing Stock", "Search Parameters", "Period", "Cost Location", "No data available", "Click search button to seraching the data"};

            if (lang == LANG_ID) {
                String[] langID = {"Lokasi", "Status Dokumen", "Tanggal", "Abaikan", "Sampai", "Nomor Jurnal", "Memo", "Jurnal berhasil diposting",
                    "Beberapa jurnal gagal di posting", "Nama Barang", "Harga", "Perkiraan Biaya"
                };
                langCST = langID;

                String[] navID = {"Jurnal", "Costing - Post Jurnal", "Arsip", "Penyesuaian Stock", "Parameter Pencarian", "Biaya", "Periode", "Lokasi Biaya", "Tidak ada data untuk di posting", "Klik tombol search untuk melakukan pencarian"};
                langNav = navID;
            }

            if (iJSPCommand == JSPCommand.POST) {

                for (int i = 0; i < listCosting.size(); i++) {
                    Costing costing = (Costing) listCosting.get(i);
                    if (JSPRequestValue.requestInt(request, "post" + costing.getOID()) == 1) {
                        if (msg.length() <= 0) {
                            msg = langCST[7];
                        }
                        long pId = JSPRequestValue.requestLong(request, "periode" + costing.getOID());
                        long postLocationId = JSPRequestValue.requestLong(request, "post_location_" + costing.getOID());
                        Vector details = new Vector();
                        details = DbCostingItem.list(0, 0, DbCostingItem.colNames[DbCostingItem.COL_COSTING_ID] + " = " + costing.getOID(), null);
                        Hashtable coaItem = new Hashtable();
                        boolean isHeader = false;
                        
                        String oidExc = "";
                        Vector detalisSelect = new Vector();
                        
                        if (details != null && details.size() > 0) {
                            for (int t = 0; t < details.size(); t++) {
                                CostingItem ci = (CostingItem) details.get(t);
                                long coaExpId = JSPRequestValue.requestLong(request, "coa_expense_" + ci.getOID());
                                
                                if (coaExpId != 0) {
                                    detalisSelect.add(ci);
                                    Coa c = new Coa();
                                    try {
                                        c = DbCoa.fetchExc(coaExpId);
                                        if (!c.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                                            isHeader = true;
                                        }
                                    } catch (Exception e) {
                                    }
                                    c.setOID(coaExpId);
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
                            x = DbCosting.postJournal(costing, detalisSelect, user.getOID(), pId, coaItem, postLocationId,oidExc);
                        }
                        if (x == 0) {
                            msg = langCST[8];
                        }
                    }
                }
                listCosting = DbCosting.listCosting(whereClause,whereClause2,orderClause);                
            }
            Vector vPeriode = new Vector();
            if(allowPeriod == 1){
                vPeriode = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "' ", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            }        
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_EXPENSE + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
            Vector locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
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
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmcosting.command.value="<%=JSPCommand.LIST%>";
                document.frmcosting.action="costlist.jsp";
                document.frmcosting.submit();
            }
            
            function setChecked(val){
                 <%
            for (int k = 0; k < listCosting.size(); k++) {
                Costing adj = (Costing) listCosting.get(k);
                 %>
                     document.frmcosting.post<%=adj.getOID()%>.checked=val.checked;
                     <% }%>
                 }
                 
                 function cmdPost(){        
                     var tanya = confirm("Apakah Lokasi Biaya & Periode  Sudah di set dg benar ?");
                     if(tanya == 1){
                         document.frmcosting.command.value="<%=JSPCommand.POST%>";
                         document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
                         document.frmcosting.action="costlist.jsp";
                         document.frmcosting.submit();
                     }
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
                                                        <form name="frmcosting" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">&nbsp;<%=langNav[0]%> 
                                                                                </font><font class="tit1">&raquo; <span class="lvl2"><%=langNav[1]%></span></font></b></td>
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
                                                                                <td height="8"  colspan="3" > 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                       
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td colspan="6" height="10"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="6"><i><%=langNav[4]%>:</i></td>
                                                                                                    </tr>                                                                                                                
                                                                                                    <tr height="22">
                                                                                                        <td width="90" class="tablecell1">&nbsp;&nbsp;<%=langCST[5]%></td>
                                                                                                        <td height="1" class="fontarial">:</td> 
                                                                                                        <td width="270"><input type="text" name="journal_number" class="fontarial" value="<%=journalNumber%>"></td>
                                                                                                        <td width="90" class="tablecell1">&nbsp;&nbsp;<%=langCST[2]%></td> 
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td >    
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcosting.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td class="fontarial">&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                                                                                    <td>
                                                                                                                        <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcosting.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>></td>
                                                                                                                    <td class="fontarial">Ignored</td>
                                                                                                                </tr>
                                                                                                            </table>  
                                                                                                        </td>
                                                                                                    </tr> 
                                                                                                    <tr height="22"> 
                                                                                                        <td class="tablecell1">&nbsp;&nbsp;<%=langCST[0]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <select name="src_location_id">
                                                                                                                <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>< All Lokasi ></option>
                                                                                                                <%



            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);                    
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>         
                                                                                                        <td colspan="3" ></td>                                                                                                        
                                                                                                    </tr>  
                                                                                                    <tr height="22"> 
                                                                                                        <td class="tablecell1">&nbsp;&nbsp;<%=langNav[7]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <select name="src_locationexp_id">
                                                                                                                <option value="0" <%if (srcLocationExpId == 0) {%>selected<%}%>>< All Location ></option>
                                                                                                                <%

            Vector vloc = DbLocation.list(0, 0, "", "name");

            if (vloc != null && vloc.size() > 0) {
                for (int i = 0; i < vloc.size(); i++) {
                    Location loc = (Location) vloc.get(i);
                    String str = "";
                                                                                                                %>
                                                                                                                <option value="<%=loc.getOID()%>" <%if (srcLocationExpId == loc.getOID()) {%>selected<%}%>><%=loc.getName()%></option>
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
                                                                                        <tr>
                                                                                            <td height="22" valign="middle" colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <%

            if (iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.POST) {
                try {
                    if (listCosting.size() > 0) {
                                                                                        %>                                                                                       
                                                                                        <%if (listCosting != null && listCosting.size() > 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                                <table border="0" cellpadding="0" cellspacing="1" width="1050">
                                                                                                    <tr height="20">
                                                                                                        <td class="tablehdr" width="5%">No</td>
                                                                                                        <td class="tablehdr" width="10%"><%=langCST[5]%></td>
                                                                                                        <td class="tablehdr" width="15%"><%=langCST[2]%></td>
                                                                                                        <td class="tablehdr" width="15%"><%=langCST[0]%></td>
                                                                                                        <td class="tablehdr" width="10%"><%=langNav[6]%></td>
                                                                                                        <td class="tablehdr" width="15%"><%=langNav[7]%></td>
                                                                                                        <td class="tablehdr"><%=langCST[6]%></td>
                                                                                                        <td class="tablehdr" width="3%"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                                    </tr>                                                                                                       
                                                                                                    <%
    for (int i = 0; i < listCosting.size(); i++) {
        Costing c = (Costing) listCosting.get(i);
        Location loc = new Location();
        String nameLoc = "-";
        try {
            loc = DbLocation.fetchExc(c.getLocationId());
            nameLoc = loc.getName();
        } catch (Exception e) {
        }

        Vector vCostD = new Vector();
        vCostD = DbCostingItem.list(0, 0, DbCostingItem.colNames[DbCostingItem.COL_COSTING_ID] + "=" + c.getOID(), null);
        long pId = JSPRequestValue.requestLong(request, "periode" + c.getOID());

                                                                                                    %>
                                                                                                    <tr height="20">
                                                                                                        <td class="tablecell1" align="center"><%=i + 1 %></td>
                                                                                                        <td class="tablecell1" align="center"><%=c.getNumber()%></td>
                                                                                                        <td class="tablecell1" align="center"><%=JSPFormater.formatDate(c.getEffectiveDate(), "dd MMM yyyy")%></td>
                                                                                                        <td class="tablecell1"><%=nameLoc%></td>                                                                                                        
                                                                                                        <td class="tablecell1" align="center">
                                                                                                            <select name="periode<%=c.getOID()%>">
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
                                                                                                        <td class="tablecell1" align="left">
                                                                                                            <select name="post_location_<%=c.getOID()%>">
                                                                                                                <option <%if (c.getLocationPostId() == 0) {%>selected<%}%> value="0">< Default Location ></option>
                                                                                                                <%if (locations != null && locations.size() > 0) {
                                                                                                            for (int ix = 0; ix < locations.size(); ix++) {
                                                                                                                Location d = (Location) locations.get(ix);
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (c.getLocationPostId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
                                                                                                        }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td class="tablecell1" align="left"><%=c.getNote()%></td>
                                                                                                        <td class="tablecell1" align="center"><input type="checkbox" name="post<%=c.getOID()%>" value="1"></td>
                                                                                                    </tr>     
                                                                                                    <%
                                                                                                        if (vCostD != null && vCostD.size() > 0) {
                                                                                                            double tTot = 0;
                                                                                                    %>
                                                                                                    <tr height="20">
                                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                                        <td class="tablecell1" colspan="5">
                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                                <tr height="20">
                                                                                                                    <td class="tablecell" align="center" width="25%"><B><%=langCST[9]%></b></td>                                                                        
                                                                                                                    <td class="tablecell" align="center" width="6%"><B>Qty</b></td>
                                                                                                                    <td class="tablecell" align="center" width="10%"><B><%=langCST[10]%></b></td>
                                                                                                                    <td class="tablecell" align="center" ><B><%=langCST[11]%></b></td>                                                                                                                    
                                                                                                                    <td class="tablecell" align="center" width="10%"><B>Amount</b></td>
                                                                                                                </tr>
                                                                                                                <%
                                                                                                        for (int x = 0; x < vCostD.size(); x++) {
                                                                                                            CostingItem ci = (CostingItem) vCostD.get(x);
                                                                                                            ItemMaster im = new ItemMaster();
                                                                                                            try {
                                                                                                                im = DbItemMaster.fetchExc(ci.getItemMasterId());
                                                                                                            } catch (Exception e) {
                                                                                                            }

                                                                                                            double total = im.getCogs() * ci.getQty();
                                                                                                            double price = im.getCogs();

                                                                                                            if (ci.getPrice() != 0) {
                                                                                                                total = ci.getPrice() * ci.getQty();
                                                                                                                price = ci.getPrice();
                                                                                                            }
                                                                                                            long coaExpId = JSPRequestValue.requestLong(request, "coa_expense_" + ci.getOID());

                                                                                                            tTot = tTot + total;
                                                                                                                %>
                                                                                                                <tr height="20">
                                                                                                                    <td class="tablecell" align="left" ><%=im.getName()%></td>                                                                        
                                                                                                                    <td class="tablecell" align="right" ><%=JSPFormater.formatNumber(ci.getQty(), "###,###.##") %></td>
                                                                                                                    <td class="tablecell" align="right" ><%=JSPFormater.formatNumber(price, "###,###.##") %></td>
                                                                                                                    <td class="tablecell" align="left" >
                                                                                                                        &nbsp;<select name="coa_expense_<%=ci.getOID()%>">
                                                                                                                            <option <%if (coaExpId == 0) {%>selected<%}%> value="0">< Default ></option>
                                                                                                                            <%if (accLinks != null && accLinks.size() > 0) {
                                                                                                                        for (int z = 0; z < accLinks.size(); z++) {
                                                                                                                            AccLink accLink = (AccLink) accLinks.get(z);
                                                                                                                            Coa coa = new Coa();
                                                                                                                            try {
                                                                                                                                coa = DbCoa.fetchExc(accLink.getCoaId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }
                                                                                                                            %>
                                                                                                                            <option <%if (coaExpId == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coa.getLevel() * -1, coa, coaExpId, isPostableOnly)%> 
                                                                                                                            <%}
} else {%>
                                                                                                                            <option><%=langNav[3]%></option>
                                                                                                                            <%}%>
                                                                                                                        </select>                                                                                                                        
                                                                                                                    </td>                                                                                                                   
                                                                                                                    <td class="tablecell" align="right" ><%=JSPFormater.formatNumber(total, "###,###.##") %></td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <tr height="20">
                                                                                                                    <td class="tablecell" align="right" colspan="4"><B>Total</B></td>            
                                                                                                                    <td class="tablecell" align="right" ><B><%=JSPFormater.formatNumber(tTot, "###,###.##") %></B></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>                                                                                                        
                                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                                    </tr>                                                                                                       
                                                                                                    <%}%>
                                                                                                    <tr height="5">
                                                                                                        <td colspan="6"></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>  
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td valign="middle" colspan="3"> 
                                                                                                <a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <% } else {%>
                                                                                        <%if (iJSPCommand != JSPCommand.POST) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="fontarial"><i><%=langNav[8]%></i></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                    }
                                                                                                }

                                                                                            } catch (Exception exc) {
                                                                                                System.out.println("excp : " + exc.toString());
                                                                                            }

                                                                                        } else {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="fontarial"><i><%=langNav[9]%></i></td>
                                                                                        </tr>
                                                                                        <%}%>
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
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
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
