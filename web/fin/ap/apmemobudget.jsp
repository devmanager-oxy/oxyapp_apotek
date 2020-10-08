
<%-- 
    Document   : apmemobudget
    Created on : Mar 23, 2016, 11:05:32 AM
    Author     : Roy
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
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_DELETE);
%>
<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int ignore = JSPRequestValue.requestInt(request, "ignore");
            String[] a = request.getParameterValues("segment1_id");
            String number = JSPRequestValue.requestString(request, "number");
            Date startDate = new Date();
            Date endDate = new Date();

            if (JSPRequestValue.requestString(request, "start_date").length() > 0) {
                startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "start_date"), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, "end_date").length() > 0) {
                endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "end_date"), "dd/MM/yyyy");
            }

            /*** LANG ***/
            String[] langBudget = {"Journal Number", "Date Transaction", "Location", "To", "Period", "Ignore", "Budget Total", "Data not found"};
            String[] langBudgetItem = {"Number", "Account Name", "Description", "Request By", "Used", "Total Used", "Budget YTD", "Balance","Approved By"};
            String[] langNav = {"Account Payble", "Budget Payment"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Lokasi", "Sampai", "Periode", "Abaikan", "Total Budget", "Data tidak ditemukan"};
                langBudget = langID;
                String[] langBudgetItemID = {"No.", "Nama Akun", "Keterangan", "Diajukan Oleh", "Sudah Terpakai", "Total Terpakai", "Budget YTD", "Selisih","Disetujui Oleh"};
                langBudgetItem = langBudgetItemID;
                String[] navID = {"Hutang", "Pembayaran Budget"};
                langNav = navID;
            }

            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = DbBudgetRequest.colNames[DbBudgetRequest.COL_STATUS]+" = "+DbBudgetRequest.DOC_STATUS_CHECKED;
            String orderClause = DbBudgetRequest.colNames[DbBudgetRequest.COL_TRANS_DATE];

            Vector segments = DbSegmentUser.userSegments(user.getOID(), 0);
            CmdBudgetRequest cmdBudgetRequest = new CmdBudgetRequest(request);
            JSPLine ctrLine = new JSPLine();
            Vector listBudgetRequest = new Vector(1, 1);

            if (iJSPCommand == JSPCommand.NONE) {
                ignore = 1;
                if (segments != null && segments.size() > 0) {
                    String str = "";
                    for (int x = 0; x < segments.size(); x++) {
                        if (str != null && str.length() > 0) {
                            str = str + ",";
                        }
                        SegmentDetail sd = (SegmentDetail) segments.get(x);
                        str = str + sd.getOID();
                    }
                    if (whereClause != null && whereClause.length() > 0) {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT1_ID] + " in (" + str + ") ";

                } else {
                    if (whereClause != null && whereClause.length() > 0) {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT1_ID] + " = 0 ";
                }
            } else {
                if (a != null && a.length > 0) {
                    String str = "";
                    for (int x = 0; x < a.length; x++) {
                        if (str != null && str.length() > 0) {
                            str = str + ",";
                        }
                        str = str + Long.parseLong(a[x].trim());
                    }
                    if (whereClause != null && whereClause.length() > 0) {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT1_ID] + " in (" + str + ") ";
                } else {
                    if (whereClause != null && whereClause.length() > 0) {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT1_ID] + " = 0 ";
                }

            }

            if (ignore == 0) {
                if (whereClause != null && whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbBudgetRequest.colNames[DbBudgetRequest.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59' ";

            }

            if (number != null && number.length() > 0) {
                if (whereClause != null && whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbBudgetRequest.colNames[DbBudgetRequest.COL_JOURNAL_NUMBER] + " like '%" + number.trim() + "%'";
            }



            int vectSize = DbBudgetRequest.getCount(whereClause);

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdBudgetRequest.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            listBudgetRequest = DbBudgetRequest.list(start, recordToGet, whereClause, orderClause);

            if (listBudgetRequest.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listBudgetRequest = DbBudgetRequest.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />        
        <script type="text/javascript" src="<%=approot%>/js/jquery.min.js"></script>
        <link href="<%=approot%>/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<%=approot%>/js/bootstrap.min.js"></script>
        <link href="<%=approot%>/js/bootstrap-multiselect.css" rel="stylesheet" type="text/css" />
        <script src="<%=approot%>/js/bootstrap-multiselect.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(function () {
                $('#lstSegment').multiselect({
                    includeSelectAllOption: true
                });
                $('#btnSelected').click(function () {
                    var selected = $("#lstSegment option:selected");
                    var message = "";
                    selected.each(function () {
                        message += $(this).text() + " " + $(this).val() + "\n";
                    });
                    alert(message);
                });
            });
        </script>
        <script type="text/javascript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){  
                document.frmbudgetarchive.command.value="<%=JSPCommand.SEARCH%>";
                document.frmbudgetarchive.action="apmemobudget.jsp";
                document.frmbudgetarchive.submit();
            }
            
            function cmdEdit(oidBudgetRequest,keyUniqId){
                <%if (privUpdate) {%>
                document.frmbudgetarchive.hidden_budget_request_id.value=oidBudgetRequest;
                document.frmbudgetarchive.hidden_uniq_key_id.value=keyUniqId;
                document.frmbudgetarchive.select_idx.value=<%=-1%>;
                document.frmbudgetarchive.command.value="<%=JSPCommand.NONE%>";
                document.frmbudgetarchive.prev_command.value="<%=prevJSPCommand%>";
                document.frmbudgetarchive.action="apmemobudgetproses.jsp";
                document.frmbudgetarchive.submit();
                <%}%>
            }
            
            
            function cmdListFirst(){
                document.frmbudgetarchive.command.value="<%=JSPCommand.FIRST%>";
                document.frmbudgetarchive.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmbudgetarchive.action="apmemobudgetbudget.jsp";
                document.frmbudgetarchive.submit();
            }
            
            function cmdListPrev(){
                document.frmbudgetarchive.command.value="<%=JSPCommand.PREV%>";
                document.frmbudgetarchive.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmbudgetarchive.action="apmemobudgetbudget.jsp";
                document.frmbudgetarchive.submit();
            }
            
            function cmdListNext(){
                document.frmbudgetarchive.command.value="<%=JSPCommand.NEXT%>";
                document.frmbudgetarchive.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmbudgetarchive.action="apmemobudgetbudget.jsp";
                document.frmbudgetarchive.submit();
            }
            
            function cmdListLast(){
                document.frmbudgetarchive.command.value="<%=JSPCommand.LAST%>";
                document.frmbudgetarchive.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmbudgetarchive.action="apmemobudgetbudget.jsp";
                document.frmbudgetarchive.submit();
            }
            
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            
            function MM_findObj(n, d) { //v4.01
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && d.getElementById) x=d.getElementById(n); return x;
            }
            
            function MM_swapImage() { //v3.0
                var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }
            //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                            <!-- #EndEditable --> </td>
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
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
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
                                                                                        <td> 
                                                                                            <form id="form1" name="frmbudgetarchive" method="post" action="">
                                                                                                <input type="hidden" name="command">
                                                                                                <input type="hidden" name="menu_idx" value="<%=menuIdx%>"> 
                                                                                                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                                <input type="hidden" name="start" value="<%=start%>">
                                                                                                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                <input type="hidden" name="hidden_budget_request_id" value="<%=0%>">
                                                                                                <input type="hidden" name="hidden_uniq_key_id" value="<%=0%>">
                                                                                                <input type="hidden" name="select_idx" value="<%=-1%>">                                                                                                
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td class="container"> 
                                                                                                            <table>
                                                                                                                <tr>
                                                                                                                    <td width="80" class="fontarial" style="padding:3px;"><i><%=langBudget[0]%></i></td>
                                                                                                                    <td width="2" class="fontarial">:</td>                                                                                                                    
                                                                                                                    <td width="250"><input type="text" name="number" size="25" value="<%=number%>" style="-webkit-border-radius: 3px;-moz-border-radius: 3px; border-radius: 3px; border: 1px solid #ccc; outline:0; height:22px; width: 100px; background-color:#FFFFFF;padding-left:3px;"></td>
                                                                                                                    <td width="100" class="<i>" style="padding:3px;"><i><%=langBudget[1]%></i></td>
                                                                                                                    <td width="2" class="fontarial">:</td>
                                                                                                                    <td>
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input name="start_date" style="-webkit-border-radius: 3px;-moz-border-radius: 3px; border-radius: 3px; border: 1px solid #ccc; outline:0; height:22px; width: 100px; background-color:#FFFFFF;padding-left:3px;" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" readonly></td>                                                                                                                                    
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbudgetarchive.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                <td class="fontarial">&nbsp;&nbsp;<i><%=langBudget[3]%></i>&nbsp;&nbsp;</td>
                                                                                                                                <td><input name="end_date" style="-webkit-border-radius: 3px;-moz-border-radius: 3px; border-radius: 3px; border: 1px solid #ccc; outline:0; height:22px; width: 100px; background-color:#FFFFFF;padding-left:3px;" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbudgetarchive.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                <td class="fontarial">&nbsp;&nbsp;<input type="checkbox" name="ignore" value="1" <%if (ignore == 1) {%> checked <%}%> ></td>
                                                                                                                                <td class="fontarial"><i><%=langBudget[5]%></i></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr> 
                                                                                                                
                                                                                                                <tr>
                                                                                                                    <td class="fontarial" style="padding:3px;"><i><%=langBudget[2]%></i></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td class="fontarial">                                                                                                                                                                                                                                          
                                                                                                                        <select name="segment1_id" id="lstSegment" multiple="multiple"  >
                                                                                                                            <%
            if (segments != null && segments.size() > 0) {
                for (int i = 0; i < segments.size(); i++) {
                    SegmentDetail sd = (SegmentDetail) segments.get(i);
                    boolean selected = false;
                    if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.BACK) {
                        selected = true;
                    } else {
                        if (a != null) {
                            for (int x = 0; x < a.length; x++) {
                                if (sd.getOID() == Long.parseLong(a[x].trim())) {
                                    selected = true;
                                    break;
                                }
                            }
                        }
                    }
                                                                                                                            %>
                                                                                                                            
                                                                                                                            <option value="<%=sd.getOID()%>" <%if (selected) {%> selected<%}%> ><%=sd.getName()%></option>
                                                                                                                            <% }
            }%>                                                                                                    
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr>    
                                                                                                                <tr> 
                                                                                                                    <td colspan="6">
                                                                                                                        <table width="800" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr>
                                                                                                                                <td background="../images/line.gif"><img src="../images/line.gif"></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td colspan="6"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                </tr>
                                                                                                            </table>    
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td>&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td class="container">
                                                                                                            <table cellpadding="0" cellspacing="1" border="0">
                                                                                                                <tr height="26">
                                                                                                                    <td class="tablearialhdr" width="25"><%=langBudgetItem[0]%></td>
                                                                                                                    <td class="tablearialhdr" width="100"><%=langBudget[0]%></td>
                                                                                                                    <td class="tablearialhdr" width="100"><%=langBudget[1]%></td>
                                                                                                                    <td class="tablearialhdr" width="160"><%=langBudget[2]%></td>                                                                                                                    
                                                                                                                    <td class="tablearialhdr" width="180"><%=langBudgetItem[3]%></td>      
                                                                                                                    <td class="tablearialhdr" width="180"><%=langBudgetItem[8]%></td>      
                                                                                                                    <td class="tablearialhdr" width="130"><%=langBudget[6]%></td>                                                                                                                                                                                                                                        
                                                                                                                </tr> 
                                                                                                                <%if (listBudgetRequest != null && listBudgetRequest.size() > 0) {
                for (int i = 0; i < listBudgetRequest.size(); i++) {

                    BudgetRequest br = (BudgetRequest) listBudgetRequest.get(i);

                    String style = "";
                    if (i % 2 == 0) {
                        style = "tablecell";
                    } else {
                        style = "tablecell1";
                    }

                    SegmentDetail sdx = new SegmentDetail();
                    try {
                        sdx = DbSegmentDetail.fetchExc(br.getSegment1Id());
                    } catch (Exception e) {
                    }

                    User u = new User();
                    try {
                        u = DbUser.fetch(br.getUserId());
                    } catch (Exception e) {
                    }
                    
                    String checkedBy = "";
                    if(br.getApproval2Id() != 0){
                        User uCheck = DbUser.fetch(br.getApproval2Id());
                        checkedBy = uCheck.getFullName();
                    }

                    double totalRequest = 0;
                    try {
                        totalRequest = DbBudgetRequestDetail.getSum(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_ID] + "=" + br.getOID()+ " and " + DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_STATUS] + "='1'");
                    } catch (Exception e) {
                    }
                                                                                                                %>     
                                                                                                                <tr height="24">
                                                                                                                    <td class="<%=style%>" align="center"><%=(start + i + 1)%></td>
                                                                                                                    <td class="<%=style%>" align="center" style="padding:3px;"><a href="javascript:cmdEdit('<%=String.valueOf(br.getOID())%>','<%=String.valueOf(br.getUniqKeyId())%>')"><%=br.getJournalNumber()%></a></td>                                                                                                                    
                                                                                                                    <td class="<%=style%>" align="center" style="padding:3px;"><%=JSPFormater.formatDate(br.getTransDate(), "dd-MMM-yyyy")%></td>
                                                                                                                    <td class="<%=style%>" align="left" style="padding:3px;"><%=sdx.getName()%></td>
                                                                                                                    <td class="<%=style%>" align="left" style="padding:3px;"><%=u.getFullName()%></td>
                                                                                                                    <td class="<%=style%>" align="left" style="padding:3px;"><%=checkedBy%></td>
                                                                                                                    <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(totalRequest, "###,###.##")%></td>
                                                                                                                   
                                                                                                                </tr>
                                                                                                                <%
    }%>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td height="7" valign="middle" colspan="3">&nbsp;</td>
                                                                                                                </tr>
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
                                                                                                                            %>
                                                                                                                    <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                                                </tr>
                                                                                                                
                                                                                                                
                                                                                                                
                                                                                                                <%} else {%>
                                                                                                                <tr height="24">
                                                                                                                    <td class="fontarial" colspan="8" align="left" style="padding:3px;"><b><i><%=langBudget[7]%></i></b></td>
                                                                                                                </tr>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </table>    
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
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
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>
