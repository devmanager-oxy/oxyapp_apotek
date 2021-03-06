
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                CashReceiveDetail crd = (CashReceiveDetail) listx.get(i);
                result = result + crd.getAmount();
            }
        }
        return result;
    }
%>
<%
            long oidCashPayment = JSPRequestValue.requestLong(request, "hidden_casharchive");

            PettycashPayment pettycashPayment = new PettycashPayment();
            try {
                pettycashPayment = DbPettycashPayment.fetchExc(oidCashPayment);
            } catch (Exception e) {
            }

            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(pettycashPayment.getCoaId());
            } catch (Exception e) {
            }
            
            String[] langCT = {"Receipt to Account","Journal Number","Receipt From","Amount","Memo","Transaction Date","Account - Description","Currency","Code","Booked Rate","Description","Department","Debet","Credit"};
            
            String[] langNav = {"Cash","Pettycash Payment Archives"};
            
             if (lang == LANG_ID) {
                String[] langID = {"Diterima pada","Nomor Jurnal","Diterima dari","Jumlah","Catatan","Tanggal Transaksi","Dari Perkiraan","Mata Uang","Kode","Kurs Transaksi","Keterangan","Departemen","Debet","Credit"};
                langCT = langID;

                String[] navID = {"Tunai","Arsip pembayaran Tunai"};
                langNav = navID;
            }
            
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
            // Identify a caption for all images. This can also be set inline for each image.
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>
        <script language="JavaScript">
            
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournal(){	 
                window.open("<%=printroot%>.report.RptPCPaymentPDF?oid=<%=appSessUser.getLoginId()%>&pcPayment_id=<%=pettycashPayment.getOID()%>");
                }
                
                function cmdActivity(oid){
                    document.frmcasharchive.hidden_pettycash_payment_id.value=oid;
                    <%if (pettycashPayment.getActivityStatus().equals(I_Project.NA_NOT_POSTED_STATUS)) {%>
                    document.frmcasharchive.action="pettycashpaymentactivity.jsp";
                    document.frmcasharchive.command.value="<%=JSPCommand.NONE%>";
                    <%} else {%>	
                    document.frmcasharchive.action="pettycashpaymentactivityprint.jsp";
                    <%}%>                    
                    document.frmcasharchive.submit();
                }
                
                function cmdBack(){
                    window.history.back();
                    document.frmcasharchive.action="casharchive.jsp";
                    document.frmcasharchive.submit();
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
                //-->
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif','../images/back2.gif')">
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
            String navigator = "<font class=\"lvl1\">"+langNav[0]+"</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">"+langNav[1]+"</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcasharchive" method ="post" action="">
                                                            <input type="hidden" name="hidden_casharchive" value="<%=oidCashPayment%>">
                                                            <input type="hidden" name="hidden_pettycash_payment_id" value="<%=oidCashPayment%>">
                                                            <input type="hidden" name="command" value="">
                                                            <input type="hidden" name="<%=JspCashArchive.colNames[JspCashArchive.JSP_SEARCH_FOR] %>" value="paymentpettycash">
                                                            <%
            try {
                                                            %>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="4" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="4"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="31%">&nbsp;</td>
                                                                                                        <td width="32%">&nbsp;</td>
                                                                                                        <td width="37%"> 
                                                                                                            <div align="right">Date : <%=JSPFormater.formatDate(pettycashPayment.getDate(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                                                                                : 
                                                                                                                <%
                                                                User u = new User();
                                                                try {
                                                                    u = DbUser.fetch(pettycashPayment.getOperatorId());
                                                                } catch (Exception e) {}
                                                                                                                %>
                                                                                                            <%=u.getLoginId()%>&nbsp;&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="25%">&nbsp;</td>
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="51%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="12%"><%=langCT[0]%></td>                                                
                                                                                                        <td width="25%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                                        <td width="12%"><%=langCT[3]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                        <td width="51%"><%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="12%"><%=langCT[1]%></td>                                                
                                                                                                        <td width="25%"><%=pettycashPayment.getJournalNumber()%></td>
                                                                                                        <td width="12%"><%=langCT[5]%></td>
                                                                                                        <td width="51%"><%=JSPFormater.formatDate(pettycashPayment.getTransDate(), "dd/MM/yyyy")%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="12%"><%=langCT[4]%></td>                                                
                                                                                                        <td colspan="3"><%=pettycashPayment.getMemo()%></td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td>&nbsp; </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr > 
                                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                                                                <td class="tab">Disbursement</td>
                                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                                <td class="tabin"><a href="javascript:cmdActivity('<%=oidCashPayment%>')" class="tablink">Activity</a></td>
                                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td width="100%" class="page"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td class="tablehdr" width="30%" height="20"><%=langCT[6]%></td>
                                                                                                                                            <td class="tablehdr" width="20%" height="20"><%=langCT[11]%></td>
                                                                                                                                            <td class="tablehdr" width="10%" height="20"><%=langCT[12]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                                            <td class="tablehdr" width="10%" height="20"><%=langCT[13]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                                            <td class="tablehdr" width="30%" height="20"><%=langCT[10]%></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                Vector vectorList = DbPettycashPaymentDetail.list(0, DbPettycashPaymentDetail.getCount(""), " pettycash_payment_id = " + oidCashPayment, "");
                                                                for (int i = 0; i < vectorList.size(); i++) {
                                                                    PettycashPaymentDetail crd = (PettycashPaymentDetail) vectorList.get(i);
                                                                    Coa c = new Coa();
                                                                    try {
                                                                        c = DbCoa.fetchExc(crd.getCoaId());
                                                                    } catch (Exception e) {
                                                                    }

                                                                    String cssString = "tablecell";
                                                                    if (i % 2 != 0) {
                                                                        cssString = "tablecell1";
                                                                    }

                                                                                                                                        %>
                                                                                                                                        <tr> 
                                                                                                                                            <td class="<%=cssString%>" height="17"><%=c.getCode() + " - " + c.getName()%></td>
                                                                                                                                            <td width="15%" class="<%=cssString%>"> 
                                                                                                                                                <%
                                                                                                                                            Department d = new Department();
                                                                                                                                            try {
                                                                                                                                                d = DbDepartment.fetchExc(crd.getDepartmentId());
                                                                                                                                            } catch (Exception e) {}
                                                                                                                                                %>
                                                                                                                                                <%=d.getCode() + " - " + d.getName()%>
                                                                                                                                            </td>
                                                                                                                                            <td class="<%=cssString%>" height="17"><div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                                                                                                            <td class="<%=cssString%>" height="17"><div align="right"><%=JSPFormater.formatNumber(crd.getCreditAmount(), "#,###.##")%></div>
                                                                                                                                            </td>
                                                                                                                                            <td class="<%=cssString%>" height="17"><%=crd.getMemo()%></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                }
                                                                                                                                        %>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td>&nbsp; </td>
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
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="2" height="5"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="78%"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="3%">
                                                                                                            <%
    out.print("<a href=\"../freport/rpt_pettycashpayment.jsp?pettycashPayment_id=" + pettycashPayment.getOID() + "\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('prt','','../images/printdoc2.gif',1)\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/printdoc.gif\" name=\"prt\" height=\"22\" border=\"0\"></a></div>");
                                                                                                %>
                                                                                                        </td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td width="9%">
                                                                                                        <a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new13','','../images/back2.gif',1)"><img src="../images/back.gif" name="new13"  border="0"></a></td>
                                                                                                        <td width="83%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td class="boxed1" width="22%"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="36%"> 
                                                                                                            <div align="left"><b>Total 
                                                                                                                    <%=baseCurrency.getCurrencyCode()%> : 
                                                                                                            </b></div>
                                                                                                        </td>
                                                                                                        <td width="64%"> 
                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%></b></div>
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
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="4" class="command">&nbsp; </td>
                                                                </tr>
                                                            </table>                          
                                                            <%
            } catch (Exception exc) {
            }
                                                            %>
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
