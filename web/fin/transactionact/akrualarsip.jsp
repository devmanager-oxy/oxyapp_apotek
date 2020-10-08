
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
            long srcPeriodeId = JSPRequestValue.requestLong(request, "src_periode_id");

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";

            boolean isGereja = DbSystemProperty.getModSysPropGereja();
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            String whereMd = "";
            String oidMd = "";

            if (vSeg != null && vSeg.size() > 0 && iJSPCommand != JSPCommand.NONE) {
                for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {
                    int pg = iSeg + 1;
                    long segment_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pg + "_ID");
                    oidMd = oidMd + ";" + segment_id;

                    if (whereMd.length() > 0) {
                        whereMd = whereMd + " and ";
                    }
                    if (segment_id != 0) {
                        if (iSeg == 0) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT1_ID] + " = " + segment_id;
                        } else if (iSeg == 1) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT2_ID] + " = " + segment_id;
                        } else if (iSeg == 2) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT3_ID] + " = " + segment_id;
                        } else if (iSeg == 3) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT4_ID] + " = " + segment_id;
                        } else if (iSeg == 4) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT5_ID] + " = " + segment_id;
                        } else if (iSeg == 5) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT6_ID] + " = " + segment_id;
                        } else if (iSeg == 6) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT7_ID] + " = " + segment_id;
                        } else if (iSeg == 7) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT8_ID] + " = " + segment_id;
                        } else if (iSeg == 8) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT9_ID] + " = " + segment_id;
                        } else if (iSeg == 9) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT10_ID] + " = " + segment_id;
                        } else if (iSeg == 10) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT11_ID] + " = " + segment_id;
                        } else if (iSeg == 11) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT12_ID] + " = " + segment_id;
                        } else if (iSeg == 12) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT13_ID] + " = " + segment_id;
                        } else if (iSeg == 13) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT14_ID] + " = " + segment_id;
                        } else if (iSeg == 14) {
                            whereMd = whereMd + DbAkrualProses.colNames[DbAkrualProses.COL_SEGMENT15_ID] + " = " + segment_id;
                        }
                    }
                }
            }

            whereClause = DbAkrualProses.colNames[DbAkrualProses.COL_PERIODE_ID] + " = " + srcPeriodeId;
            if (whereMd != null && whereMd.length() > 0) {
                whereClause = whereClause + " and " + whereMd;
            }

            CmdAkrualProses ctrlAkrualProses = new CmdAkrualProses(request);
            JSPLine ctrLine = new JSPLine();
            JspAkrualProses jspAkrualProses = ctrlAkrualProses.getForm();

            /*count list All AkrualSetup*/
            int vectSize = DbAkrualProses.getCount(whereClause);

            /*switch list AkrualSetup*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlAkrualProses.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            Vector akrualProcs = DbAkrualProses.list(start, recordToGet, whereClause, "");

            if (akrualProcs.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                akrualProcs = DbAkrualProses.list(start, recordToGet, whereClause, "");
            }

            //AkrualProses akrualProses = ctrlAkrualProses.getAkrualProses();
            msgString = ctrlAkrualProses.getMessage();

            /*** LANG ***/
            String[] langAT = {"Period", "Date", "Name", "Budget", "Total Accrual", "Remains", "Accrual Amount", "User", "Searching Parameter", "User", "Arsip data not found", "Click seacrh button to searching the data", "Segment"}; //0-12
            String[] langNav = {"Recurring Journal", "Archives", "Date"};

            if (lang == LANG_ID) {
                String[] langID = {"Periode", "Tanggal", "Nama", "Anggaran", "Total Akrual", "Saldo", "Jumlah Akrual", "Pengguna", "Parameter Pencarian", "Pengguna", "Data arsip tidak ditemukan", "Klik tombol search untuk mencari data", "Segmen"}; // 0 -12
                langAT = langID;

                String[] navID = {"Jurnal Berulang", "Arsip", "Tanggal"};
                langNav = navID;
            }

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
            
            function cmdEditAkrual(oidGl){                
                <%if (privUpdate) {%>
                document.frmakrualproses.hidden_ref_id.value = oidGl;
                document.frmakrualproses.command.value="<%=JSPCommand.LOAD%>";                
                document.frmakrualproses.action="akrualdetail.jsp";
                document.frmakrualproses.submit();
                
                <%}%>
            }
            
            function cmdSearch(){
                document.frmakrualproses.command.value="<%=JSPCommand.SEARCH %>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdSubmit(){
                document.frmakrualproses.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmakrualproses.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdAdd(){
                document.frmakrualproses.hidden_akrual_setup_id.value="0";
                document.frmakrualproses.command.value="<%=JSPCommand.ADD%>";
                document.frmakrualproses.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdAsk(oidAkrualSetup){
                document.frmakrualproses.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualproses.command.value="<%=JSPCommand.ASK%>";
                document.frmakrualproses.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdConfirmDelete(oidAkrualSetup){
                document.frmakrualproses.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualproses.command.value="<%=JSPCommand.DELETE%>";
                document.frmakrualproses.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdSave(){
                document.frmakrualproses.command.value="<%=JSPCommand.SAVE%>";
                document.frmakrualproses.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdEdit(oidAkrualSetup){
                <%if (privUpdate) {%>
                document.frmakrualproses.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualproses.command.value="<%=JSPCommand.EDIT%>";
                document.frmakrualproses.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
                <%}%>
            }
            
            function cmdCancel(oidAkrualSetup){
                document.frmakrualproses.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualproses.command.value="<%=JSPCommand.EDIT%>";
                document.frmakrualproses.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdBack(){
                document.frmakrualproses.command.value="<%=JSPCommand.BACK%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdListFirst(){
                document.frmakrualproses.command.value="<%=JSPCommand.FIRST%>";
                document.frmakrualproses.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdListPrev(){
                document.frmakrualproses.command.value="<%=JSPCommand.PREV%>";
                document.frmakrualproses.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdListNext(){
                document.frmakrualproses.command.value="<%=JSPCommand.NEXT%>";
                document.frmakrualproses.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            function cmdListLast(){
                document.frmakrualproses.command.value="<%=JSPCommand.LAST%>";
                document.frmakrualproses.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmakrualproses.action="akrualarsip.jsp";
                document.frmakrualproses.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidAkrualSetup){
                document.frmimage.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="akrualarsip.jsp";
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
                                                        <form name="frmakrualproses" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_akrual_setup_id" value="<%=oidAkrualSetup%>">
                                                            <input type="hidden" name="hidden_ref_id" value="<%=0%>">
                                                            <input type="hidden" name="<%=JspAkrualProses.colNames[JspAkrualProses.JSP_FIELD_USER_ID]%>" value="<%=user.getOID()%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="<%=JspAkrualProses.colNames[JspAkrualProses.JSP_FIELD_PERIODE_ID]%>" value="<%=periodeXXX.getOID()%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <table border="0" cellpadding="1" cellspacing="1" >                                                                                                                                        
                                                                                        <tr>                                                                                                                                            
                                                                                            <td class="tablecell1" >                                                                                                            
                                                                                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">  
                                                                                                    <tr height="5"> 
                                                                                                        <td width="5"></td>
                                                                                                        <td width="51"></td>
                                                                                                        <td ></td>
                                                                                                        <td width="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="5">&nbsp;</td>
                                                                                                        <td colspan="3"><b><i><%=langAT[8]%></i></b></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[0]%></td>
                                                                                                        <td >
                                                                                                            <%
            Vector pers = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            if (srcPeriodeId == 0 && pers != null && pers.size() > 0) {
                Periode p = (Periode) pers.get(0);
                srcPeriodeId = p.getOID();
            }
            Periode selectPer = new Periode();
            try {
                selectPer = DbPeriode.fetchExc(srcPeriodeId);
            } catch (Exception e) {
            }

                                                                                                            %>                                                                                                
                                                                                                            <select name="src_periode_id" onChange="javascript:cmdSrc()">
                                                                                                                <%if (pers != null && pers.size() > 0) {
                for (int i = 0; i < pers.size(); i++) {
                    Periode p = (Periode) pers.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=p.getOID()%>" <%if (p.getOID() == srcPeriodeId) {%>selected<%}%>><%=p.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if (isGereja || (vSeg != null && vSeg.size() > 0)) {%>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td height="8" valign="middle" colspan="3">
                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%
    if (vSeg != null && vSeg.size() > 0) {
        User usr = new User();
        try {
            usr = DbUser.fetch(appSessUser.getUserOID());
        } catch (Exception e) {
        }

        for (int xs = 0; xs < vSeg.size(); xs++) {
            Segment oSegment = (Segment) vSeg.get(xs);
            int pgs = xs + 1;
            long seg_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pgs + "_ID");
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td width="55"><%=oSegment.getName()%></td>
                                                                                                                    <td >
                                                                                                                        <%
                                                                                                                        String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + oSegment.getOID();
                                                                                                                        switch (xs + 1) {
                                                                                                                            case 1:
                                                                                                                                if (usr.getSegment1Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment1Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 2:
                                                                                                                                if (usr.getSegment2Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment2Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 3:
                                                                                                                                if (usr.getSegment3Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment3Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 4:
                                                                                                                                if (usr.getSegment4Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment4Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 5:
                                                                                                                                if (usr.getSegment5Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment5Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 6:
                                                                                                                                if (usr.getSegment6Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment6Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 7:
                                                                                                                                if (usr.getSegment7Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment7Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 8:
                                                                                                                                if (usr.getSegment8Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment8Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 9:
                                                                                                                                if (usr.getSegment9Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment9Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 10:
                                                                                                                                if (usr.getSegment10Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment10Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 11:
                                                                                                                                if (usr.getSegment11Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment11Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 12:
                                                                                                                                if (usr.getSegment12Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment12Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 13:
                                                                                                                                if (usr.getSegment13Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment13Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 14:
                                                                                                                                if (usr.getSegment14Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment14Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                            case 15:
                                                                                                                                if (usr.getSegment15Id() != 0) {
                                                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment15Id();
                                                                                                                                }
                                                                                                                                break;
                                                                                                                        }
                                                                                                                        Vector segDet = DbSegmentDetail.list(0, 0, wh, DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);
                                                                                                                        %>
                                                                                                                        <select name="JSP_SEGMENT<%=xs + 1%>_ID" >
                                                                                                                            <option value="0" <%if (0 == seg_id) {%>selected<%}%>>All Location</option>
                                                                                                                            <%
                                                                                                                        for (int i = 0; i < segDet.size(); i++) {
                                                                                                                            SegmentDetail ap = (SegmentDetail) segDet.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=ap.getOID()%>" <%if (ap.getOID() == seg_id) {%>selected<%}%>><%=ap.getName()%></option>
                                                                                                                            <%
                                                                                                                        }
                                                                                                                            %>
                                                                                                                        </select>                                                                                    
                                                                                                                    </td>
                                                                                                                    <td></td>
                                                                                                                    <td></td>
                                                                                                                </tr> 
                                                                                                                <%
        }
    }
                                                                                                                %> 
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td colspan="4"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                                                              
                                                                            <tr>
                                                                                <td>    
                                                                                    <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a>
                                                                                </td>    
                                                                            </tr>
                                                                            <tr>
                                                                                <td height="20">&nbsp;</td>  
                                                                            </tr>    
                                                                            <tr>
                                                                                <td>
                                                                                    <table width="1000" border="0" cellspacing="1" cellpadding="1">
                                                                                        <%if (akrualProcs != null && akrualProcs.size() > 0) {%>
                                                                                        <tr> 
                                                                                            <td width="4%" class="tablehdr">No</td>
                                                                                            <td width="9%" class="tablehdr"><%=langAT[1]%></td>
                                                                                            <td class="tablehdr"><%=langAT[2]%></td>
                                                                                            <td width="10%" class="tablehdr"><%=langAT[12]%></td>
                                                                                            <td width="14%" class="tablehdr"><%=langAT[3]%></td>
                                                                                            <td width="10%" class="tablehdr"><%=langAT[4]%></td>
                                                                                            <td width="10%" class="tablehdr"><%=langAT[5]%></td>
                                                                                            <td width="10%" class="tablehdr"><%=langAT[6]%><br>
                                                                                            ( <%=selectPer.getName()%> )</td>
                                                                                            <td width="10%" class="tablehdr"><%=langAT[7]%></td>
                                                                                        </tr>
                                                                                        <%
    for (int i = 0; i < akrualProcs.size(); i++) {
        AkrualProses ap = (AkrualProses) akrualProcs.get(i);
        AkrualSetup as = new AkrualSetup();
        try {
            as = DbAkrualSetup.fetchExc(ap.getAkrualSetupId());
        } catch (Exception e) {
        }

        User u = new User();
        try {
            u = DbUser.fetch(ap.getUserId());
        } catch (Exception e) {
        }

        double terpakai = DbAkrualProses.getTotalAkrual(as.getOID());

        if (i % 2 == 0) {
                                                                                        %>
                                                                                        <tr height="22"> 
                                                                                            <td class="tablecell1" align="center"><%=start + i + 1%></td>
                                                                                            <td class="tablecell1" align="center"><%=JSPFormater.formatDate(ap.getRegDate(), "dd MMM yyyy")%></td>
                                                                                            <td class="tablecell1"><a href="<%="javascript:cmdEditAkrual('" + ap.getOID() + "')"%>"><%=as.getNama()%></a></td>
                                                                                            <td class="tablecell1"> 
                                                                                                <%
                                                                                                String segment = "";
                                                                                                try {
                                                                                                    if (ap.getSegment1Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment1Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment2Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment2Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment3Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment3Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment4Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment4Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment5Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment5Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment6Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment6Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment7Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment7Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment8Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment8Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment9Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment9Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment10Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment10Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment11Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment11Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment12Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment12Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment13Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment13Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment14Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment14Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment15Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment15Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                } catch (Exception e) {
                                                                                                }
                                                                                                if (segment.length() > 0) {
                                                                                                    segment = segment.substring(0, segment.length() - 3);
                                                                                                }
                                                                                                %>
                                                                                                <%=segment%>
                                                                                            </td>    
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(as.getAnggaran(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(terpakai, "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(as.getAnggaran() - terpakai, "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td width="14%" bgcolor="#CCCCCC"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(ap.getJumlah(), "#,###.##")%> </div>
                                                                                            </td>
                                                                                            <td width="13%" class="tablecell1"> 
                                                                                                <div align="center"><%=u.getLoginId()%></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <tr height="22"> 
                                                                                            <td class="tablecell" align="center"><%=i + 1%></td>
                                                                                            <td class="tablecell" align="center"><%=JSPFormater.formatDate(ap.getRegDate(), "dd MMM yyyy")%></td>
                                                                                            <td class="tablecell"><a href="<%="javascript:cmdEditAkrual('" + ap.getOID() + "')"%>"><%=as.getNama()%></a></td>
                                                                                            <td class="tablecell"> 
                                                                                                <%
                                                                                                String segment = "";
                                                                                                try {
                                                                                                    if (ap.getSegment1Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment1Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment2Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment2Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment3Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment3Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment4Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment4Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment5Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment5Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment6Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment6Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment7Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment7Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment8Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment8Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment9Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment9Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment10Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment10Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment11Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment11Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment12Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment12Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment13Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment13Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment14Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment14Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (ap.getSegment15Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(ap.getSegment15Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                } catch (Exception e) {
                                                                                                }
                                                                                                if (segment.length() > 0) {
                                                                                                    segment = segment.substring(0, segment.length() - 3);
                                                                                                }
                                                                                                %>
                                                                                                <%=segment%>
                                                                                            </td>    
                                                                                            <td class="tablecell"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(as.getAnggaran(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(terpakai, "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(as.getAnggaran() - terpakai, "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td bgcolor="#CCCCCC"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(ap.getJumlah(), "#,###.##")%> </div>
                                                                                            </td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="center"><%=u.getLoginId()%></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}
    }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td colspan="9">
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
                                                                                        <%
} else {%>
                                                                                        <%if (iJSPCommand == JSPCommand.SEARCH) {%>
                                                                                        <tr> 
                                                                                            <td colspan="9"><i><%=langAT[10]%>....</i></td>
                                                                                        </tr>    
                                                                                        <%} else {%>
                                                                                        <tr> 
                                                                                            <td colspan="9"><i><%=langAT[11]%>....</i></td>
                                                                                        </tr>    
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
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
