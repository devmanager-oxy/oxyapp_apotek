
<%-- 
    Document   : glarchivedetail
    Created on : Oct 11, 2013, 4:49:50 PM
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
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_DELETE);
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
            long oidGl = JSPRequestValue.requestLong(request, "gl_id");

            Gl gl = new Gl();
            try {
                gl = DbGl.fetchExc(oidGl);
            } catch (Exception e) {
            }

            Vector listGlDetail = new Vector(1, 1);
            listGlDetail = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), null);

            /*** LANG ***/
            String[] langGL = {"Journal Number", "Transaction Date", "Reference Number", "Journal Detail", //0-3
                "Account - Description", "Jemaat", "Currency", "Code", "Amount", "Booked Rate", "Debet", "Credit", "Description", //4-12
                "Error, can't posting journal when details mixed between SP and NSP", "Journal has been saved successfully.", "Searching", "Journal is ready to be saved", "Memo", "Period", "Activity"};//13-19
            String[] langNav = {"General Journal", "New Journal", "Date", "SEARCHING", "EDITOR JOURNAL"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Nomor Referensi", "Detail Jurnal", //0-3
                    "Perkiraan", "Jemaat", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Debet", "Credit", "Keterangan", //4-12
                    "Error, tidak bisa posting journal dengan detail gabungan SP dan NSP.", "Jurnal sukses disimpan.", "Pencarian", "Jurnal siap untuk disimpan", "Memo", "Periode", "Kegiatan"}; //13-19

                langGL = langID;

                String[] navID = {"Jurnal Umum", "Jurnal Baru", "Tanggal", "PENCARIAN", "EDITOR JURNAL"};
                langNav = navID;
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
            
            function cmdBack(){
                document.frmgl.command.value="<%=JSPCommand.BACK%>";
                document.frmgl.action="glarchive.jsp";
                document.frmgl.submit();
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
                                                            <input type="hidden" name="hidden_gl_id" value="<%=oidGl%>">
                                                            <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">                                                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="4">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="6"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="6">                                                                                                            
                                                                                                            <table width="600" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>                                                                                                                                            
                                                                                                                    <td class="tablecell1" > 
                                                                                                                        <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td colspan="4" height="10"></td>
                                                                                                                            </tr>
                                                                                                                            <tr height="21"> 
                                                                                                                                <td width="5"></td>
                                                                                                                                <td width="19%" class="fontarial"><%=langGL[0]%></td>                                                                                                                                
                                                                                                                                <td width="36%" class="fontarial">: <%=gl.getJournalNumber()%></td>
                                                                                                                                <td width="20%" class="fontarial"><%=langGL[1]%></td>
                                                                                                                                <td class="fontarial">: <%=JSPFormater.formatDate(gl.getDate(), "dd MMM yyyy")%></td>
                                                                                                                            </tr>
                                                                                                                            <tr height="21"> 
                                                                                                                                <td width="5"></td>
                                                                                                                                <td class="fontarial"><%=langGL[2]%></td>                                                                                                                                
                                                                                                                                <td class="fontarial">: <%=gl.getRefNumber() %> </td>
                                                                                                                                <td ></td>
                                                                                                                                <td ></td>
                                                                                                                            </tr>   
                                                                                                                            <tr height="21"> 
                                                                                                                                <td width="5"></td>
                                                                                                                                <td valign="top" class="fontarial"><%=langGL[17]%></td>                                                                                                                                
                                                                                                                                <td valign="top" colspan="3" class="fontarial">: <%=gl.getMemo()%></td>                                                                                                                                
                                                                                                                            </tr> 
                                                                                                                             <tr> 
                                                                                                                                <td colspan="4" height="15"></td>
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td height="10">&nbsp;</td>
                                                                                        </tr>  
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="100%" class="page"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr>
                                                                                                                    <td rowspan="2" class="tablearialhdr" nowrap width="15%"><%=langGL[19]%></td>
                                                                                                                    <td rowspan="2" class="tablearialhdr" nowrap width="18%"><%=langGL[4]%></td>
                                                                                                                    <td rowspan="2" class="tablearialhdr" width="10%"><%=langGL[5]%></td>                                                                                                                    
                                                                                                                    <td colspan="2" class="tablearialhdr" width="15%"><%=langGL[6]%></td>
                                                                                                                    <td rowspan="2" class="tablearialhdr" width="7%"><%=langGL[9]%></td>
                                                                                                                    <td rowspan="2" class="tablearialhdr" width="10%"><%=langGL[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                    <td rowspan="2" class="tablearialhdr" width="10%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                                                                                    <td rowspan="2" class="tablearialhdr" ><%=langGL[12]%></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5%"  class="tablearialhdr"><%=langGL[7]%></td>
                                                                                                                    <td width="10%" class="tablearialhdr"><%=langGL[8]%></td>
                                                                                                                </tr>
                                                                                                                <%
            //int colspan = 0;
            double totalDebet = 0;
            double totalCredit = 0;
            if (listGlDetail != null && listGlDetail.size() > 0) {

                for (int i = 0; i < listGlDetail.size(); i++) {
                    GlDetail crd = (GlDetail) listGlDetail.get(i);

                    if (crd.getDebet() > 0) {
                        crd.setIsDebet(0);
                    } else {
                        crd.setIsDebet(1);
                    }

                    totalDebet = totalDebet + crd.getDebet();
                    totalCredit = totalCredit + crd.getCredit();

                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(crd.getCoaId());
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td class="tablearialcell"  > 
                                                                                                                        <%
                                                                                                                        String outStr = "";
                                                                                                                        if (crd.getModuleId() != 0) {
                                                                                                                            Module module = new Module();
                                                                                                                            try {
                                                                                                                                module = DbModule.fetchExc(crd.getModuleId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }
                                                                                                                            
                                                                                                                            if(module.getOID() == 0 ){
                                                                                                                                outStr = "[ Record not found ]";
                                                                                                                            }else{
                                                                                                                            StringTokenizer strTok = new StringTokenizer(module.getDescription(), ";");

                                                                                                                            int countOut = 0;

                                                                                                                            while (strTok.hasMoreTokens()) {

                                                                                                                                if (countOut != 0) {
                                                                                                                                    outStr = "(" + (countOut + 1) + ") " + outStr + " ";
                                                                                                                                }

                                                                                                                                outStr = outStr + strTok.nextToken();
                                                                                                                                countOut++;
                                                                                                                            }
                                                                                                                            }
                                                                                                                        } else {

                                                                                                                            outStr = "Non Kegiatan ";
                                                                                                                            if (segments != null && segments.size() > 0) {
                                                                                                                                for (int xx = 0; xx < segments.size(); xx++) {
                                                                                                                                    Segment seg = (Segment) segments.get(xx);
                                                                                                                                    Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), "");

                                                                                                                                    for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                                        SegmentDetail sd = (SegmentDetail) sgDetails.get(x);                                                                                                                                        
                                                                                                                                        switch (xx + 1) {
                                                                                                                                            case 1:
                                                                                                                                                if (crd.getSegment1Id() == sd.getOID()) {
                                                                                                                                                    outStr = sd.getName();                                                                                                                                                    
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 2:
                                                                                                                                                if (crd.getSegment2Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 3:
                                                                                                                                                if (crd.getSegment3Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 4:
                                                                                                                                                if (crd.getSegment4Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 5:
                                                                                                                                                if (crd.getSegment5Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 6:
                                                                                                                                                if (crd.getSegment6Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 7:
                                                                                                                                                if (crd.getSegment7Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 8:
                                                                                                                                                if (crd.getSegment8Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 9:
                                                                                                                                                if (crd.getSegment9Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 10:
                                                                                                                                                if (crd.getSegment10Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 11:
                                                                                                                                                if (crd.getSegment11Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 12:
                                                                                                                                                if (crd.getSegment12Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 13:
                                                                                                                                                if (crd.getSegment13Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 14:
                                                                                                                                                if (crd.getSegment14Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 15:
                                                                                                                                                if (crd.getSegment15Id() == sd.getOID()) {
                                                                                                                                                    outStr = outStr +" | "+sd.getName();
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            }
                                                                                                                        }
                                                                                                                        out.println(outStr);
                                                                                                                        %>
                                                                                                                    </td>
                                                                                                                    <td class="tablearialcell" nowrap height="17"><%=c.getCode()%>&nbsp;-&nbsp; <%=c.getName()%></td>
                                                                                                                    <td class="tablearialcell">
                                                                                                                        <%
                                                                                                                        try {
                                                                                                                            if (crd.getDepartmentId() != 0) {
                                                                                                                                Department dept = DbDepartment.fetchExc(crd.getDepartmentId());
                                                                                                                                out.println(dept.getName());
                                                                                                                            } else {
                                                                                                                                out.println("-");
                                                                                                                            }
                                                                                                                        } catch (Exception xcc) {
                                                                                                                        }
                                                                                                                        %>
                                                                                                                    </td>
                                                                                                                    
                                                                                                                    <td class="tablearialcell" height="17"> 
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
                                                                                                                    <td class="tablearialcell" height="17"> 
                                                                                                                    <div align="right"> <%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%> </div></td>
                                                                                                                    <td class="tablearialcell" height="17"> 
                                                                                                                    <div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div></td>
                                                                                                                    <td class="tablearialcell" height="17"> 
                                                                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></div></td>
                                                                                                                    <td class="tablearialcell" height="17"> 
                                                                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></div></td>
                                                                                                                    <td class="tablearialcell" height="17"><%=crd.getMemo()%></td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%}%>
                                                                                                                <tr> 
                                                                                                                    <td class="tablearialcell" colspan="10" height="1">&nbsp</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="6"><div align="right"><b>TOTAL : </b></div></td>
                                                                                                                    <td class="tablearialcell"> 
                                                                                                                        <div align="right"> 
                                                                                                                            <%=JSPFormater.formatNumber(totalDebet, "#,###.##")%>
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablearialcell"> 
                                                                                                                        <div align="right" >
                                                                                                                            <%=JSPFormater.formatNumber(totalCredit, "#,###.##")%>
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablearialcell">&nbsp;</td>
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
                                                                            <%
            try {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    
                                                                                </td>
                                                                            </tr>
                                                                            <%
            } catch (Exception exc) {
                System.out.println("[exception] " + exc.toString());
            }%>                                                          
                                                                            <%if (gl.getOID() != 0 && gl.getPostedStatus() == 1) {%>
                                                                            <tr>
                                                                                <td>&nbsp;</td>
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <div align="left" class="msgnextaction"> 
                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                                                                                            <tr> 
                                                                                                <td width="20"><img src="../images/success.gif" height="20"></td>
                                                                                                <td width="100" class="fontarial">Posted</td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                             <tr>
                                                                                <td>&nbsp;</td>
                                                                            </tr>  
                                                                             <tr>
                                                                                <td><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="new" height="22" border="0"></a> </td>
                                                                            </tr> 
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%"></td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp;</td>
                                                                </tr>                                                                
                                                            </table>                                                          
                                                        </form>
                                                        <!-- #EndEditable -->
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
