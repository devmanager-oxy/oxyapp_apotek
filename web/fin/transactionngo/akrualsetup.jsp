
<%@ page language="java"%>
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
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidAkrualSetup = JSPRequestValue.requestLong(request, "hidden_akrual_setup_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdAkrualSetup ctrlAkrualSetup = new CmdAkrualSetup(request);
            JSPLine ctrLine = new JSPLine();
            Vector listAkrualSetup = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlAkrualSetup.action(iJSPCommand, oidAkrualSetup);
            /* end switch*/
            JspAkrualSetup jspAkrualSetup = ctrlAkrualSetup.getForm();

            /*count list All AkrualSetup*/
            int vectSize = DbAkrualSetup.getCount(whereClause);

            /*switch list AkrualSetup*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlAkrualSetup.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            AkrualSetup akrualSet = ctrlAkrualSetup.getAkrualSetup();

            msgString = ctrlAkrualSetup.getMessage();

            /* get record to display */
            listAkrualSetup = DbAkrualSetup.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listAkrualSetup.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listAkrualSetup = DbAkrualSetup.list(start, recordToGet, whereClause, orderClause);
            }

            /*** LANG ***/
            String[] langAT = {"Reg. Date", "Akrual Name", "Budget", "Period", "Debet", "Credit", "Last Update", "Created By", "Active", "Segment"};

            String[] langNav = {"Recurring Journal", "Jurnal Setup", "Date"};

            if (lang == LANG_ID) {
                String[] langID = {"Tang. Reg.", "Nama Akrual", "Anggaran", "Periode", "Debet", "Credit", "Update Terakhir", "Dibuat Oleh", "Aktif", "Segmen"};
                langAT = langID;

                String[] navID = {"Jurnal Berulang", "Setup Jurnal", "Tanggal"};
                langNav = navID;
            }
            Vector segments = DbSegment.list(0, 0, "", "");
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />        
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
                
                function cmdAdd(){
                    document.frmakrualsetup.hidden_akrual_setup_id.value="0";
                    document.frmakrualsetup.command.value="<%=JSPCommand.ADD%>";
                    document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                }              
                
                function cmdEdit(oidAkrualSetup){
                    <%if (privUpdate) {%>
                    document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                    document.frmakrualsetup.command.value="<%=JSPCommand.EDIT%>";
                    document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                    <%}%>
                }
                
                function cmdCancel(oidAkrualSetup){
                    document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                    document.frmakrualsetup.command.value="<%=JSPCommand.EDIT%>";
                    document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                    document.frmakrualsetup.action="akrualsetup.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdBack(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.BACK%>";
                    document.frmakrualsetup.action="akrualsetup.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdListFirst(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.FIRST%>";
                    document.frmakrualsetup.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmakrualsetup.action="akrualsetup.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdListPrev(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.PREV%>";
                    document.frmakrualsetup.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmakrualsetup.action="akrualsetup.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdListNext(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.NEXT%>";
                    document.frmakrualsetup.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmakrualsetup.action="akrualsetup.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdListLast(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.LAST%>";
                    document.frmakrualsetup.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmakrualsetup.action="akrualsetup.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdDelPict(oidAkrualSetup){
                    document.frmimage.hidden_akrual_setup_id.value=oidAkrualSetup;
                    document.frmimage.command.value="<%=JSPCommand.POST%>";
                    document.frmimage.action="akrualsetup.jsp";
                    document.frmimage.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                                                        <form name="frmakrualsetup" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_akrual_setup_id" value="<%=oidAkrualSetup%>">
                                                            <input type="hidden" name="<%=JspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_USER_ID]%>" value="<%=user.getOID()%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">
                                                                                    <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%></div> 
                                                                                </td>
                                                                            </tr>
                                                                            <%
            try {
                                                                            %>                                                                              
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <table width="1000" border="0" cellpadding="0" cellspacing="1">
                                                                                        <tr height="22">
                                                                                            <td class="tablehdr" rowspan="2" width="5%">No.</td>
                                                                                            <td class="tablehdr" rowspan="2" width="10%"><%=langAT[0]%></td>
                                                                                            <td class="tablehdr" rowspan="2"><%=langAT[1]%></td> 
                                                                                            <td class="tablehdr" rowspan="2" width="10%"><%=langAT[9]%></td> 
                                                                                            <td class="tablehdr" rowspan="2" width="10%"><%=langAT[3]%></td>
                                                                                            <td class="tablehdr" colspan="2" >Perkiraan</td>                                                                                             
                                                                                            <td class="tablehdr" rowspan="2" width="10%"><%=langAT[2]%></td>                                                                                            
                                                                                            <td class="tablehdr" rowspan="2" width="7%"><%=langAT[8]%></td>
                                                                                        </tr> 
                                                                                        <tr height="22">
                                                                                            <td class="tablehdr" width="15%"><%=langAT[4]%></td>
                                                                                            <td class="tablehdr" width="15%"><%=langAT[5]%></td>
                                                                                        </tr>   
                                                                                        <%
                                                                                String wherex = "";
                                                                                if (isPostableOnly) {
                                                                                    wherex = "status='" + I_Project.ACCOUNT_LEVEL_POSTABLE + "'";
                                                                                }

                                                                                Vector coas = DbCoa.list(0, 0, wherex, "code");

                                                                                Vector creditcoaid_value = new Vector(1, 1);
                                                                                Vector creditcoaid_key = new Vector(1, 1);
                                                                                if (coas != null && coas.size() > 0) {
                                                                                    for (int x = 0; x < coas.size(); x++) {
                                                                                        Coa coa = (Coa) coas.get(x);
                                                                                        String str = "";
                                                                                        if (!isPostableOnly) {
                                                                                            switch (coa.getLevel()) {
                                                                                                case 1:
                                                                                                    break;
                                                                                                case 2:
                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                    break;
                                                                                                case 3:
                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                    break;
                                                                                                case 4:
                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                    break;
                                                                                                case 5:
                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                    break;
                                                                                            }
                                                                                        }
                                                                                        creditcoaid_value.add("" + coa.getOID());
                                                                                        creditcoaid_key.add(str + coa.getCode() + "-" + coa.getName());
                                                                                    }
                                                                                }

                                                                                /* selected DebetCoaId*/
                                                                                Vector debetcoaid_value = new Vector(1, 1);
                                                                                Vector debetcoaid_key = new Vector(1, 1);

                                                                                if (coas != null && coas.size() > 0) {
                                                                                    for (int x = 0; x < coas.size(); x++) {
                                                                                        Coa coa = (Coa) coas.get(x);
                                                                                        String str = "";
                                                                                        if (!isPostableOnly) {
                                                                                            switch (coa.getLevel()) {
                                                                                                case 1:
                                                                                                    break;
                                                                                                case 2:
                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                    break;
                                                                                                case 3:
                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                    break;
                                                                                                case 4:
                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                    break;
                                                                                                case 5:
                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                    break;
                                                                                            }
                                                                                        }
                                                                                        debetcoaid_value.add("" + coa.getOID());
                                                                                        debetcoaid_key.add(str + coa.getCode() + "-" + coa.getName());
                                                                                    }
                                                                                }
                                                                                
                                                                                int pages = 0;

                                                                                for (int i = 0; i < listAkrualSetup.size(); i++) {
                                                                                    pages = pages + 1;

                                                                                    AkrualSetup akrualSetup = (AkrualSetup) listAkrualSetup.get(i);

                                                                                    String str_dt_RegDate = "";
                                                                                    try {
                                                                                        Date dt_RegDate = akrualSetup.getRegDate();
                                                                                        if (dt_RegDate == null) {
                                                                                            dt_RegDate = new Date();
                                                                                        }
                                                                                        str_dt_RegDate = JSPFormater.formatDate(dt_RegDate, "dd MMM yyyy");
                                                                                    } catch (Exception e) {
                                                                                        str_dt_RegDate = "";
                                                                                    }

                                                                                    Coa cD = new Coa();
                                                                                    Coa cK = new Coa();
                                                                                    try {
                                                                                        cD = DbCoa.fetchExc(akrualSetup.getDebetCoaId());
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                    try {
                                                                                        cK = DbCoa.fetchExc(akrualSetup.getCreditCoaId());
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                    String str_dt_LastUpdate = "";
                                                                                    try {
                                                                                        Date dt_LastUpdate = akrualSetup.getLastUpdate();
                                                                                        if (dt_LastUpdate == null) {
                                                                                            dt_LastUpdate = new Date();
                                                                                        }

                                                                                        str_dt_LastUpdate = JSPFormater.formatDate(dt_LastUpdate, "dd MMM yyyy");
                                                                                    } catch (Exception e) {
                                                                                        str_dt_LastUpdate = "";
                                                                                    }

                                                                                    User u = new User();
                                                                                    try {
                                                                                        u = DbUser.fetch(akrualSetup.getUserId());
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                        %>
                                                                                        <tr height="30">
                                                                                            <td class="tablecell1" align="center"><%=i + 1%></td>
                                                                                            <td class="tablecell1" align="center"><a href="javascript:cmdEdit('<%=String.valueOf(akrualSetup.getOID())%>')"><%=str_dt_RegDate%></a></td>
                                                                                            <td class="tablecell1"><%=akrualSetup.getNama()%></td>  
                                                                                            <td class="tablecell1">
                                                                                             <div align="left"> 
                                                                                                                <%
                                                                                            String segment = "";
                                                                                            try {
                                                                                                if (akrualSetup.getSegment1Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment1Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment2Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment2Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment3Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment3Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment4Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment4Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment5Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment5Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment6Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment6Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment7Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment7Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment8Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment8Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment9Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment9Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment10Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment10Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment11Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment11Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment12Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment12Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment13Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment13Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment14Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment14Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                                if (akrualSetup.getSegment15Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(akrualSetup.getSegment15Id());
                                                                                                    segment = segment + sd.getName() + " | ";
                                                                                                }
                                                                                            } catch (Exception e) {
                                                                                            }

                                                                                            if (segment.length() > 0) {
                                                                                                segment = segment.substring(0, segment.length() - 3);
                                                                                            }
                                                                                                                %>
                                                                                                            <%=segment%></div>      
                                                                                            
                                                                                            </td>
                                                                                            <td class="tablecell1" align="center"><%=String.valueOf(akrualSetup.getPembagi()) %></td>  
                                                                                            <td class="tablecell1" align="center"><%=cD.getCode() + "-" + cD.getName()%></td>  
                                                                                            <td class="tablecell1" align="center"><%=cK.getCode() + "-" + cK.getName()%></td>  
                                                                                            <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(akrualSetup.getAnggaran(), "#,###.##")%></td>                                                                                            
                                                                                            <td class="tablecell1" align="center"><%=(akrualSetup.getStatus() == 1) ? "Aktif" : "-"%></td>
                                                                                        </tr>                                                                                            
                                                                                        <%
                                                                                }%>
                                                                                                
                                                                                                
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                                                              
                                                                            <%
            } catch (Exception exc) {
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
                                                                            <%if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK) && iErrCode == 0) {%>
                                                                             <tr align="left" valign="top">
                                                                                <td height="7" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">&nbsp;<%if (privAdd) {%><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a><%}%></td>
                                                                            </tr>                                                                            
                                                                            <%} else {%>
                                                                            <tr align="left" valign="top">
                                                                                <td height="7" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("40%");
    String scomDel = "javascript:cmdAsk('" + oidAkrualSetup + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidAkrualSetup + "')";
    String scancel = "javascript:cmdEdit('" + oidAkrualSetup + "')";
    ctrLine.setBackCaption("Back");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setSaveCaption("Save");
    ctrLine.setDeleteCaption("Delete");
    ctrLine.setConfirmDelCaption("Yes Delete");

    if (privDelete) {
        ctrLine.setConfirmDelJSPCommand(sconDelCom);
        ctrLine.setDeleteJSPCommand(scomDel);
        ctrLine.setEditJSPCommand(scancel);
    } else {
        ctrLine.setConfirmDelCaption("");
        ctrLine.setDeleteCaption("");
        ctrLine.setEditCaption("");
    }

    if (privAdd == false && privUpdate == false) {
        ctrLine.setSaveCaption("");
    }

    if (privAdd == false) {
        ctrLine.setAddCaption("");
    }
                                                                                    %>
                                                                                <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
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
