
<%-- 
    Document   : giro_ap
    Created on : May 4, 2014, 11:08:53 PM
    Author     : Roy Andika
--%>

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
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privUpdate = true;
            boolean privAdd = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public String getSubstring1(String s) {
        if (s.length() > 60) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 55) + "...</font></a>";
        }
        return s;
    }

    public String getSubstring(String s) {
        if (s.length() > 105) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 100) + "...</font></a>";
        }
        return s;
    }
%>

<%!    public static String getAccountRecursif(int minus, Coa coa, long oid, boolean isPostableOnly) {
    
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
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            int allDate = JSPRequestValue.requestInt(request, "all_date");

            Date dueDate = new Date();
            if (JSPRequestValue.requestString(request, "due_date").length() > 0) {
                dueDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "due_date"), "dd/MM/yyyy");
            }

            int vectSize = 0;
            String where = DbGiroTransaction.colNames[DbGiroTransaction.COL_TRANSACTION_TYPE] + " = " + DbGiroTransaction.TYPE_PO_TRSANCTION +
                    " and " + DbGiroTransaction.colNames[DbGiroTransaction.COL_STATUS] + " = " + DbGiroTransaction.STATUS_NOT_PAID;


            if (allDate == 0) {
                where = where + " and to_days(" + DbGiroTransaction.colNames[DbGiroTransaction.COL_DUE_DATE] + ") <= to_days('" + JSPFormater.formatDate(dueDate, "yyyy-MM-dd") + "')";
            }

            String[] langNav = {"Acc. Payable", "Outstanding BG "};
            if (lang == LANG_ID) {
                String[] navID = {"Hutang", "BG Outstanding"};
                langNav = navID;
            }

            Vector segment = DbSegment.list(0, 0, DbSegment.colNames[DbSegment.COL_COUNT] + " = 1", "count");
            Vector vsd = new Vector();

            if (segment != null && segment.size() > 0) {
                try {
                    Segment s = (Segment) segment.get(0);
                    if (s.getOID() != 0) {
                        vsd = DbSegmentDetail.list(0, 0, DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + s.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);
                    }

                } catch (Exception e) {
                }
            }
            Vector list = DbGiroTransaction.list(0, 0, where, null);
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ALL_LINK_ACCOUNT_GIRO + "'", "");
            int err = 0;
            int success = 0;

            if (iJSPCommand == JSPCommand.ACTIVATE) {
                ExchangeRate er = DbExchangeRate.getStandardRate();
                if (list != null && list.size() > 0) {
                    for (int i = 0; i < list.size(); i++) {

                        GiroTransaction gt = (GiroTransaction) list.get(i);

                        if (JSPRequestValue.requestInt(request, "ck" + gt.getOID()) == 1) {

                            Date transDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "trans_date" + gt.getOID()), "dd/MM/yyyy");
                            String ket = JSPRequestValue.requestString(request, "keterangan" + gt.getOID());
                            long segment1 = JSPRequestValue.requestLong(request, "segment1_id" + gt.getOID());
                            long seg = JSPRequestValue.requestLong(request, "segment" + gt.getOID());
                            long coaId = JSPRequestValue.requestLong(request, "bank_acc" + gt.getOID());
                            Periode periode = new Periode();

                            try {
                                periode = DbPeriode.getPeriodByTransDate(transDate);

                                if (periode.getOID() != 0 && periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {

                                    boolean numberOk = false;
                                    int p = 0;
                                    String number = "";
                                    while (numberOk == false) {
                                        String numberJournal = "";
                                        if (p == 0) {
                                            numberJournal = gt.getNumber() + "G";
                                        } else {
                                            numberJournal = gt.getNumber() + "G" + p;
                                        }

                                        int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + numberJournal + "'");
                                        if (count == 0) {
                                            number = numberJournal;
                                            numberOk = true;
                                        }
                                        p++;
                                    }

                                    long oid = DbGl.postJournalMain(er.getCurrencyIdrId(), new Date(), gt.getCounter(), number, gt.getNumberPrefix(), I_Project.JOURNAL_TYPE_GIRO_KELUAR,
                                            ket, user.getOID(), "", gt.getOID(), "", transDate, periode.getOID());


                                    if (oid != 0) {
                                        DbGl.postJournalDetail(er.getValueIdr(), gt.getCoaId(), 0, gt.getAmount(),
                                                gt.getAmount(), er.getCurrencyIdrId(), oid, ket, 0,
                                                seg, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);


                                        DbGl.postJournalDetail(er.getValueIdr(), coaId, gt.getAmount(), 0,
                                                gt.getAmount(), er.getCurrencyIdrId(), oid, ket, 0,
                                                segment1, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        gt.setSegment1IdPosted(segment1);
                                        gt.setStatus(DbGiroTransaction.STATUS_PAID);
                                        try {
                                            DbGiroTransaction.updateExc(gt);
                                        } catch (Exception e) {
                                        }
                                        success++;
                                    }
                                } else {
                                    err++;
                                }
                            } catch (Exception e) {
                            }
                        }
                    }
                    list = DbGiroTransaction.list(0, 0, where, null);
                }
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" -->
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <!--Begin Region JavaScript-->
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';        
            // Identify a caption for all images. This can also be set inline for each image.
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function setChecked(val){
                 <%
            for (int k = 0; k < list.size(); k++) {
                GiroTransaction gt = (GiroTransaction) list.get(k);
                 %>
                     document.frmargiro.ck<%=gt.getOID()%>.checked=val.checked;
                     <% }%>
                 }
                 
                 function cmdPost(){                
                     document.all.closecmd.style.display="none";
                     document.all.closemsg.style.display="";
                     document.frmargiro.command.value="<%=JSPCommand.ACTIVATE%>";                     
                     document.frmargiro.action="giro_ap.jsp";
                     document.frmargiro.submit();
                 }
                 
                 function cmdSearch(){
                     document.frmargiro.start.value="0";	
                     document.frmargiro.command.value="<%=JSPCommand.SUBMIT%>";
                     document.frmargiro.prev_command.value="<%=prevCommand%>";
                     document.frmargiro.action="giro_ap.jsp";
                     document.frmargiro.submit();
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
        <!--End Region JavaScript-->
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmargiro" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">                                                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <!--DWLayoutTable-->
                                                                            <tr align="left" valign="top"> 
                                                                                <td width="100%" valign="top">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td width="100%" valign="top">
                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="300">                                                                                                                                        
                                                                                        <tr>                                                                                                                                            
                                                                                            <td class="tablecell1" > 
                                                                                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">   
                                                                                                    <tr>
                                                                                                        <td colspan="3" height="10"></td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td class="fontarial">&nbsp;&nbsp;Due Date</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td>
                                                                                                            <table border="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="due_date" value="<%=JSPFormater.formatDate((dueDate == null) ? new Date() : dueDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmargiro.due_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                    </td>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                    <td>
                                                                                                                    <input type="checkbox" name="all_date" value="1" <%if (allDate == 1) {%> checked<%}%> >
                                                                                                                           </td>
                                                                                                                    <td class="fontarial">All Date</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td colspan="3" height="10"></td>
                                                                                                    </tr>    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>    
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td align="left">
                                                                                    <table border="0" cellpadding="1" cellspacing="1">                                                                                                                                        
                                                                                        <tr>                                                                                            
                                                                                            <td ><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td width="100%" valign="top" height="30">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td width="100%" valign="top"> 
                                                                                    <table width="1000" cellpadding="0" cellspacing="1">
                                                                                        <tr height="27">
                                                                                            <td class="tablehdr" width="25">No.</td>
                                                                                            <td class="tablehdr" width="120">Sales Number</td>
                                                                                            <td class="tablehdr" width="140">Due Date</td>                                                                                            
                                                                                            <td class="tablehdr" width="150">Amount</td>                                                                                                                                                                                        
                                                                                            <td class="tablehdr">Giro</td>                                                                                                                                                                              
                                                                                            <td class="tablehdr" width="20"><input type="checkbox" name="ck_all" value="1" onClick="setChecked(this)"></td>     
                                                                                        </tr> 
                                                                                        <%
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {

                    GiroTransaction gt = (GiroTransaction) list.get(i);
                    String style = "tablecell1";

                    Coa cGiro = new Coa();
                    try {
                        cGiro = DbCoa.fetchExc(gt.getCoaId());
                    } catch (Exception e) {
                    }

                    long segment1 = JSPRequestValue.requestLong(request, "segment1_id" + gt.getOID());
                    if (segment1 == 0) {
                        segment1 = gt.getSegmentId();
                    }
                    long coaId = JSPRequestValue.requestLong(request, "bank_acc" + gt.getOID());
                    String ket = JSPRequestValue.requestString(request, "keterangan" + gt.getOID());
                    Date transDate = new Date();
                    if (JSPRequestValue.requestString(request, "trans_date" + gt.getOID()).length() > 0) {
                        transDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "trans_date" + gt.getOID()), "dd/MM/yyyy");
                    } else {
                        transDate = gt.getDueDate();
                        ket = "Pencairan Giro " + gt.getNumber();
                    }

                                                                                        %>
                                                                                        <input type="hidden" name="segment<%=gt.getOID()%>" value="<%=gt.getSegmentId()%>">
                                                                                        <tr height="25">
                                                                                            <td class="<%=style%>" align="center"><%=(i + 1)%></td>
                                                                                            <td class="<%=style%>" align="center"><%=gt.getNumber()%></td>
                                                                                            <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(gt.getDueDate(), "dd MMM yyyy") %></td>                                                                                            
                                                                                            <td class="<%=style%>" align="center"><%=JSPFormater.formatNumber(gt.getAmount(), "###,###.##") %></td>                                                                                                                                                                                                                                                                                                                                                                                
                                                                                            <td class="<%=style%>"><%=cGiro.getCode()%> - <%=cGiro.getName()%></td>
                                                                                            <td class="<%=style%>" align="center"><input type="checkbox" name="ck<%=gt.getOID()%>" value="1"></td>
                                                                                        </tr> 
                                                                                        <tr height="28">
                                                                                            <td class="<%=style%>" align="center"></td>
                                                                                            <td colspan="4" class="tablecell1">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr height="22">
                                                                                                        <td class="tablearialcell" width="25%" align="center"><b><i>Segment</i></b></td>
                                                                                                        <td class="tablearialcell" width="30%" align="center"><b><i>Bank</i></b></td>
                                                                                                        <td class="tablearialcell" width="15%" align="center"><b><i>Date Transaction</i></b></td>
                                                                                                        <td class="tablearialcell" width="10%" align="center"><b><i>Amount</i></b></td>
                                                                                                        <td class="tablearialcell" align="center"><b><i>Keterangan</i></b></td>
                                                                                                    </tr> 
                                                                                                    <tr height="22">
                                                                                                        <td class="tablearialcell" >
                                                                                                            <table>
                                                                                                                <tr>
                                                                                                                    <td class="fonrarial" width="50">Lokasi&nbsp;:</td>
                                                                                                                    <td>
                                                                                                                        <select name="segment1_id<%=gt.getOID()%>" class="fonrarial">
                                                                                                                            <%
                                                                                                for (int j = 0; j < vsd.size(); j++) {
                                                                                                    SegmentDetail sd = (SegmentDetail) vsd.get(j);
                                                                                                                            %>
                                                                                                                            <option value="<%=sd.getOID()%>" <%if (sd.getOID() == segment1) {%> selected <%}%> ><%=sd.getName()%></option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr>    
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell" align="center">
                                                                                                            <select name="bank_acc<%=gt.getOID()%>">
                                                                                                                <%if (accLinks != null && accLinks.size() > 0) {
                                                                                                    for (int x = 0; x < accLinks.size(); x++) {

                                                                                                        AccLink accLink = (AccLink) accLinks.get(x);
                                                                                                        Coa coa = new Coa();
                                                                                                        try {
                                                                                                            coa = DbCoa.fetchExc(accLink.getCoaId());
                                                                                                        } catch (Exception e) {
                                                                                                            System.out.println("Exception " + e.toString());
                                                                                                        }
                                                                                                                %>
                                                                                                                <option <%if (coaId == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                <%=getAccountRecursif(coa.getLevel() * -1, coa, coaId, isPostableOnly)%> 
                                                                                                                <%}
} else {%>
                                                                                                                <option>select ..</option>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell" align="center">
                                                                                                            <table border="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="trans_date<%=gt.getOID()%>" value="<%=JSPFormater.formatDate((transDate == null) ? new Date() : transDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmargiro.trans_date<%=gt.getOID()%> ); return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                    </td>                                                                                                                    
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(gt.getAmount(), "###,###.##") %></td>
                                                                                                        <td class="tablearialcell" align="center">&nbsp;<input type="text" name="keterangan<%=gt.getOID()%>" value="<%=ket%>" size="30"></td>
                                                                                                    </tr> 
                                                                                                </table>
                                                                                            </td>        
                                                                                            <td class="<%=style%>" align="center"></td>
                                                                                        </tr> 
                                                                                        <tr >
                                                                                            <td class="tablearialcell1" colspan="7" height="8" ></td>
                                                                                        </tr>   
                                                                                        <tr >
                                                                                            <td bgcolor="#609836" colspan="7" height="1" ></td>
                                                                                        </tr>    
                                                                                        <%}%>
                                                                                        <tr align="left" > 
                                                                                            <td valign="middle" colspan="7">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top" id="closecmd"> 
                                                                                            <td valign="middle" colspan="7"> 
                                                                                                <a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr id="closemsg" align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="7"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td> <font color="#006600">Posting Giro in progress, please wait .... </font> </td>
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
                                                                                        <tr align="left" height="22"> 
                                                                                            <td valign="middle" colspan="7" class="tablearialcell"><i>Tidak ada data yang perlu di posting</i></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%if (iJSPCommand == JSPCommand.ACTIVATE) {%>
                                                                                        <tr align="left" > 
                                                                                            <td valign="middle" colspan="7">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if (err > 0) {%>                                                                                        
                                                                                        <tr align="left" > 
                                                                                            <td valign="middle" colspan="7" class="fontarial"><i><font color="#FF0000">Beberapa Data gagal di posting</font></i></td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <%if (success > 0) {%> 
                                                                                        <tr align="left" > 
                                                                                            <td valign="middle" colspan="7" class="fontarial"><i><font color="#FF0000">Posting jurnal sukses</font></i></td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <tr align="left" > 
                                                                                            <td valign="middle" colspan="7" class="fontarial"><i><font color="#FF0000">Tidak ada jurnal yang di posting</font></i></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
                                                                </tr>
                                                            </table>  
                                                            <script language="JavaScript">
                                                                document.all.closecmd.style.display="";
                                                                document.all.closemsg.style.display="none";
                                                            </script>
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
                                <!-- #BeginEditable "footer" --><%@ include file="../main/footer.jsp"%><!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>

