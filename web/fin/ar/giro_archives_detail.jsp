
<%-- 
    Document   : giro_archives_detail
    Created on : Apr 23, 2014, 3:02:41 PM
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
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privUpdate = true;
            boolean privAdd = true;
            boolean privDelete = true;
%>
<%!
    public String getStrLevel(int level) {
        String str = "";
        switch (level) {
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
        return str;
    }
%>
<%!    public Vector addNewDetail(Vector listGlDetail, GlDetail glDetail) {
        boolean found = false;
        if (listGlDetail != null && listGlDetail.size() > 0) {
            for (int i = 0; i < listGlDetail.size(); i++) {
                GlDetail cr = (GlDetail) listGlDetail.get(i);
                if (cr.getCoaId() == glDetail.getCoaId() && cr.getForeignCurrencyId() == glDetail.getForeignCurrencyId()) {
                    cr.setForeignCurrencyAmount(cr.getForeignCurrencyAmount() + glDetail.getForeignCurrencyAmount());
                    if (cr.getDebet() > 0 && glDetail.getDebet() > 0) {
                        cr.setDebet(cr.getDebet() + glDetail.getDebet());
                        found = true;
                    } else {
                        if (cr.getCredit() > 0 && glDetail.getCredit() > 0) {
                            cr.setCredit(cr.getCredit() + glDetail.getCredit());
                            found = true;
                        }
                    }
                }
            }
        }
        if (!found) {
            listGlDetail.add(glDetail);
        }
        return listGlDetail;
    }

    public double getTotalDetail(Vector listx, int typex) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                GlDetail crd = (GlDetail) listx.get(i);
                //debet
                if (typex == 0) {
                    result = result + crd.getDebet();
                } //credit
                else {
                    result = result + crd.getCredit();
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
            long oidGl = JSPRequestValue.requestLong(request, "hidden_gl_id");
            long oidGlDetail = JSPRequestValue.requestLong(request, "hidden_gl_detail_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("GL_DETAIL");
                oidGl = 0;
                recIdx = -1;
            }
            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;

            boolean isLoad = false;
            if (iJSPCommand == JSPCommand.LOAD) {
                session.removeValue("GL_DETAIL");
                oidGl = JSPRequestValue.requestLong(request, "gl_id");
                recIdx = -1;
                isLoad = true;
            }

            CmdGl ctrlGl = new CmdGl(request);
            JSPLine ctrLine = new JSPLine();

            int iErrCodeMain = ctrlGl.action(iJSPCommand, oidGl);
            JspGl jspGl = ctrlGl.getForm();            
            Gl gl = ctrlGl.getGl();
            String msgStringMain = ctrlGl.getMessage();
            if (oidGl == 0) {
                oidGl = gl.getOID();
            }
            if (iJSPCommand == JSPCommand.LOAD) {
                try {
                    gl = DbGl.fetchExc(oidGl);
                } catch (Exception e) {
                }
            }
%>
<%
            boolean load = false;
            if (iJSPCommand == JSPCommand.LOAD) {
                load = true;
            }
            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.LOAD) {
                iJSPCommand = JSPCommand.ADD;
            }
            CmdGlDetail ctrlGlDetail = new CmdGlDetail(request);
            Vector listGlDetail = new Vector(1, 1);
            if (load) {
                listGlDetail = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), null);
            }
            /*switch statement */
            iErrCode = ctrlGlDetail.action(iJSPCommand, DbPeriode.getOpenPeriod(), oidGlDetail);
            /* end switch*/
            JspGlDetail jspGlDetail = ctrlGlDetail.getForm();

            
            GlDetail glDetail = ctrlGlDetail.getGlDetail();
            msgString = ctrlGlDetail.getMessage();

            if (session.getValue("GL_DETAIL") != null) {
                listGlDetail = (Vector) session.getValue("GL_DETAIL");
            }

            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST) {
                if (iErrCode == 0 && iErrCodeMain == 0) {
                    if (recIdx == -1) {
                        listGlDetail.add(glDetail);
                    } else {
                        GlDetail gld = (GlDetail) listGlDetail.get(recIdx);
                        glDetail.setOID(gld.getOID());
                        listGlDetail.set(recIdx, glDetail);
                    }
                }
            }
            if (iJSPCommand == JSPCommand.DELETE) {
                listGlDetail.remove(recIdx);
            }

            

            session.putValue("GL_DETAIL", listGlDetail);            
            ExchangeRate eRate = DbExchangeRate.getStandardRate();
            double totalDebet = getTotalDetail(listGlDetail, 0);
            double totalCredit = getTotalDetail(listGlDetail, 1);

           

            if (iJSPCommand == JSPCommand.RESET && iErrCodeMain == 0) {
                totalDebet = 0;
                totalCredit = 0;
                gl = new Gl();
                listGlDetail = new Vector();
                session.removeValue("GL_DETAIL");
            }
            if (iJSPCommand == JSPCommand.SUBMIT && iErrCode == 0 && iErrCodeMain == 0) {
                iJSPCommand = JSPCommand.ADD;
                glDetail = new GlDetail();
                recIdx = -1;
            }

            boolean diffCoaClass = false;

            /*** LANG ***/
            String[] langGL = {"Journal Number", "Transaction Date", "Reference Number", "Journal Detail", //0-3
                "Account - Description", "Department", "Currency", "Code", "Amount", "Booked Rate", "Debet", "Credit", "Description", //4-12
                "Error, can't posting journal when details mixed between SP and NSP", "Journal has been saved successfully.", "Searching", "Journal is ready to be saved", "Memo", "Period", "Activity"};//13-19
            String[] langNav = {"BG Archive", "Journal Detail", "Date", "SEARCHING", "EDITOR JOURNAL"};
            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};
            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Nomor Referensi", "Detail Jurnal", //0-3
                    "Perkiraan", "Departemen", "Mata Uang", "Kode", "Jumlah", "Kurs", "Debet", "Credit", "Keterangan", //4-12
                    "Error, tidak bisa posting journal dengan detail gabungan SP dan NSP.", "Jurnal sukses disimpan.", "Pencarian", "Jurnal siap untuk disimpan", "Memo", "Periode", "Kegiatan"}; //13-19

                langGL = langID;

                String[] navID = {"Arsip BG", "Jurnal Detail", "Tanggal", "PENCARIAN", "EDITOR JURNAL"};
                langNav = navID;
                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }
            Vector segments = DbSegment.list(0, 0, "", "count");            
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';        
            
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>   
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function cmdEditGl(oidGl){                
                <%if (privUpdate) {%>
                document.frmgl.gl_id.value = oidGl;
                document.frmgl.command.value="<%=JSPCommand.LOAD%>";                
                document.frmgl.action="giro_archives_detaill.jsp";
                document.frmgl.submit();                
                <%}%>
            }
            
            function removeChar(number){
                var ix;
                var result = "";
                for(ix=0; ix<number.length; ix++){
                    var xx = number.charAt(ix);                    
                    if(!isNaN(xx)){
                        result = result + xx;
                    }
                    else{
                        if(xx==',' || xx=='.'){
                            result = result + xx;
                        }
                    }
                }                
                return result;
            }
            
            function cmdBack(){
                document.frmgl.command.value="<%=JSPCommand.NONE%>";
                document.frmgl.action="giro_archives.jsp";
                document.frmgl.submit();
            }
            
            function cmdDelPict(oidGlDetail){
                document.frmimage.hidden_gl_detail_id.value=oidGlDetail;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="gldetail.jsp";
                document.frmimage.submit();
            }
            
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmgl" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_gl_detail_id" value="<%=oidGlDetail%>">
                                                            <input type="hidden" name="hidden_gl_id" value="<%=oidGl%>">
                                                            <input type="hidden" name="gl_id" value="<%=oidGl%>">
                                                            <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="select_idx" value="<%=recIdx%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_TYPE]%>" value="<%=I_Project.JOURNAL_TYPE_GENERAL_LEDGER%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3">
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0"> 
                                                                                        <tr> 
                                                                                            <td colspan = "5" height="10" align="right"></td>
                                                                                        </tr>           
                                                                                        <tr> 
                                                                                            <td colspan="5" >
                                                                                                <table width="600" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td class="tablecell1" > 
                                                                                                            <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td height="6" width="5"></td>
                                                                                                                    <td colspan="5" height="6"></td>
                                                                                                                </tr>                                                                                                                            
                                                                                                                <tr> 
                                                                                                                    <td width="5"></td>
                                                                                                                    <td width="16%" class="fontarial"><%=langGL[0]%></td>
                                                                                                                    <td width="3%">&nbsp;</td>
                                                                                                                    <td width="40%" class="fontarial">:&nbsp;<%=gl.getJournalNumber()%> 
                                                                                                                        <%
            Periode open = new Periode();

            if (gl.getPeriodId() != 0) {
                try {
                    open = DbPeriode.fetchExc(gl.getPeriodId());
                } catch (Exception e) {
                }
            }
                                                                                                                        %>                                                                                                                                    
                                                                                                                    </td>
                                                                                                                    <td width="17%" class="fontarial"><%=langGL[18]%></td>
                                                                                                                    <td class="fontarial">:&nbsp;<%=open.getName()%></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5"></td>
                                                                                                                    <td class="fontarial"><%=langGL[2]%></td>
                                                                                                                    <td >&nbsp;</td>
                                                                                                                    <td class="fontarial">:&nbsp;<%=gl.getRefNumber()%></td>
                                                                                                                    <td class="fontarial"><%=langGL[1]%></td>
                                                                                                                    <td >:&nbsp;<%=JSPFormater.formatDate((gl.getTransDate() == null) ? new Date() : gl.getTransDate(), "dd/MM/yyyy")%></td>
                                                                                                                </tr>   
                                                                                                                <tr> 
                                                                                                                    <td width="5"></td>
                                                                                                                    <td valign="top" class="fontarial"><%=langGL[17]%></td>
                                                                                                                    <td >&nbsp;</td>
                                                                                                                    <td valign="top" class="fontarial" colspan="3">:&nbsp;<%=gl.getMemo()%></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td colspan="6" height="10"></td>
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                                                                                                          
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="100%" class="page"> 
                                                                                                            <table width="1070" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr>
                                                                                                                    <td rowspan="2" class="tablehdr" nowrap width="16%"></td>
                                                                                                                    <td rowspan="2" class="tablehdr" nowrap width="21%"><%=langGL[4]%></td>                                                                                                                    
                                                                                                                    <td colspan="2" class="tablehdr"><%=langGL[6]%></td>
                                                                                                                    <td rowspan="2" class="tablehdr" width="5%"><%=langGL[9]%></td>
                                                                                                                    <td rowspan="2" class="tablehdr" width="10%"><%=langGL[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                    <td rowspan="2" class="tablehdr" width="10%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                                                                                    <td rowspan="2" class="tablehdr"><%=langGL[12]%></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="3%" class="tablehdr"><%=langGL[7]%></td>
                                                                                                                    <td width="10%" class="tablehdr"><%=langGL[8]%></td>
                                                                                                                </tr>
                                                                                                                <%
            if (listGlDetail != null && listGlDetail.size() > 0) {
                int ct = 0;
                for (int i = 0; i < listGlDetail.size(); i++) {
                    GlDetail crd = (GlDetail) listGlDetail.get(i);

                    if (crd.getDebet() > 0) {
                        crd.setIsDebet(0);
                    } else {
                        crd.setIsDebet(1);
                    }

                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(crd.getCoaId());
                        if (i == 0) {
                            ct = c.getAccountClass();
                        } else {
                            if (!diffCoaClass && ct != c.getAccountClass()) {
                                if (ct == 2) {
                                    if (c.getAccountClass() != 2) {
                                        diffCoaClass = true;
                                    }
                                } else {
                                    if (c.getAccountClass() == 2) {
                                        diffCoaClass = true;
                                    }
                                }
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                                                                                                                %>
                                                                                                                <tr height = "25"> 
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <%

                                                                                                                        String outStr = "";

                                                                                                                        if (crd.getModuleId() != 0) {
                                                                                                                            Module module = new Module();
                                                                                                                            try {
                                                                                                                                module = DbModule.fetchExc(crd.getModuleId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }

                                                                                                                            StringTokenizer strTok = new StringTokenizer(module.getDescription(), ";");

                                                                                                                            int countOut = 0;

                                                                                                                            while (strTok.hasMoreTokens()) {

                                                                                                                                if (countOut != 0) {
                                                                                                                                    outStr = "(" + (countOut + 1) + ") " + outStr + " ";
                                                                                                                                }

                                                                                                                                outStr = outStr + strTok.nextToken();
                                                                                                                                countOut++;
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                        %>
                                                                                                                        <table border="0" cellpadding="1" cellspacing="1" >
                                                                                                                            <%
                                                                                                                                                                                                                                                    for (int is = 0; is < segments.size(); is++) {
                                                                                                                                                                                                                                                        Segment objSeg = (Segment) segments.get(is);

                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td >&nbsp;<%=objSeg.getName()%></td>
                                                                                                                                <%
                                                                                                                                String nameSeg = "";
                                                                                                                                switch (is + 1) {
                                                                                                                                    case 1:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment1Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }
                                                                                                                                    case 2:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment2Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 3:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment3Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 4:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment4Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 5:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment5Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 6:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment6Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 7:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment7Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 8:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment8Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 9:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment9Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 10:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment10Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 11:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment11Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 12:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment12Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 13:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment13Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 14:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment14Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 15:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment15Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                }
                                                                                                                                %>
                                                                                                                                <td >&nbsp;:&nbsp;&nbsp;<%=nameSeg%></td>
                                                                                                                            </tr>                                                                                                                                                
                                                                                                                            <%
                                                                                                                                                                                                                                                    }
                                                                                                                            %>    
                                                                                                                        </table>
                                                                                                                        <%
                                                                                                                        }

                                                                                                                        out.println(outStr);
                                                                                                                        %>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell" nowrap><%=c.getCode() + " - " + c.getName()%> </td>                                                                                                                    
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <%
                                                                                                                        Currency xc = new Currency();
                                                                                                                        try {
                                                                                                                            xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                                                                                                                        } catch (Exception e) {
                                                                                                                        }
                                                                                                                            %>
                                                                                                                        <%=xc.getCurrencyCode()%> </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                    <div align="right"> <%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%> </div>                                                      </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                    <div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div>                                                      </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></div>                                                      </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></div>                                                      </td>
                                                                                                                    <td class="tablecell">&nbsp;<%=crd.getMemo()%></td>
                                                                                                                </tr>
                                                                                                                
                                                                                                                <%}
            }%>                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell" colspan="8" height="1">&nbsp</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" class="fontarial"> 
                                                                                                                    <div align="right"><b>TOTAL : </b></div></td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"> 
                                                                                                                            <b><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%></b>
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"> 
                                                                                                                            <b><%=JSPFormater.formatNumber(totalCredit, "#,###.##")%></b>
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablecell">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr align="right" valign="top"> 
                                                                                                                    <td valign="middle" colspan="8"> 
                                                                                                                        <div align="right" class="msgnextaction"> 
                                                                                                                            <table border="0" cellpadding="5" cellspacing="0" align="right">
                                                                                                                                <tr> 
                                                                                                                                    <td width="5"><img src="../images/success.gif" height="20"></td>
                                                                                                                                    <%if (gl.getOID() != 0 && gl.getPostedStatus() == 1) {%>
                                                                                                                                    <td width="70" class="fontarial"><b><i>Posted</i></b></td>
                                                                                                                                    <%} else {%>
                                                                                                                                    <td width="70" class="fontarial"><b><i>Draft</i></b></td>
                                                                                                                                    <%}%>                                                                                                
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="right" valign="top"> 
                                                                                                                    <td valign="middle" colspan="8" height="30"> 
                                                                                                                        
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
                                                                            <tr>
                                                                                <td colspan="3">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/back2.gif',1)"><img src="../images/back.gif" name="post" height="22" border="0"></a>
                                                                                    
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="3" height="5">&nbsp;</td>
                                                                            </tr>   
                                                                             <%if (gl.getOID() != 0) {
                                                                                String name = "-";
                                                                                String date = "";
                                                                                try{
                                                                                    User u = DbUser.fetch(gl.getOperatorId());
                                                                                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                                                                                    name = e.getName();
                                                                                }catch(Exception e){}
                                                                                try{
                                                                                    date = JSPFormater.formatDate(gl.getDate(),"dd MMM yyyy");
                                                                                }catch(Exception e){}
                                                                                
                                                                                
                                                                                String postedName = "";
                                                                                String postedDate = "";
                                                                                try{
                                                                                    User u = DbUser.fetch(gl.getPostedById());
                                                                                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                                                                                    postedName = e.getName();
                                                                                }catch(Exception e){}
                                                                                try{
                                                                                    if(gl.getPostedDate() != null){
                                                                                        postedDate = JSPFormater.formatDate(gl.getPostedDate(),"dd MMM yyyy");
                                                                                    }
                                                                                }catch(Exception e){postedDate= "";}
                                                                            %>
                                                                            <tr>
                                                                                <td height="10">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="8"> 
                                                                                    <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="3" height="20"><b><i><%=langApp[0]%></i></b> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="100" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[5]%></font></b></td>                                                                                              
                                                                                            <td height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[3]%></font></b></td>
                                                                                            <td width="100" height="20" bgcolor="#F3F3F3" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="20" ><font size="1">Create By</font></td>                                                                                              
                                                                                            <td height="20" ><font size="1"><%=name%></font></td>
                                                                                            <td height="20" nowrap><font size="1"><%=date%></font></td>
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="20" ><font size="1">Posted By</font></td>                                                                                              
                                                                                            <td height="20" ><font size="1"><%=postedName%></font></td>
                                                                                            <td height="20" nowrap><font size="1"><%=postedDate%></font></td>
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr>
                                                                                <td colspan="3" height="25">&nbsp;</td>
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
