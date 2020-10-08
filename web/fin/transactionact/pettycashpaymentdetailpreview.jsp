
<%-- 
    Document   : pettycashpaymentdetail-det
    Created on : Feb 15, 2012, 12:36:32 AM
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
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<!-- Jsp Block -->
<%!
    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                PettycashPaymentDetail crd = (PettycashPaymentDetail) listx.get(i);
                result = result + crd.getAmount() - crd.getCreditAmount();
            }
        }
        return result;
    }
%>
<%
            /*** LANG ***/
            String[] langCT = {"Suspense Account", "Amount", "Memo", "Account Balance", "Journal Number", "Transaction Date", //0-5
                "Detail", "Expense Account", "Description", "Insufficient cash balance",//6-9
                "Petty cash payment document is ready to be saved", "Petty cash payment document has been saved successfully",
                "Search Journal Number", "Customer", "Department", "Non postable department, please select another department", "Payment to", "Credit in", "Budget Balance", "Total Cash"
            }; //10-19

            String[] langNav = {"Cash Transaction", "Disbushment", "Date", "Required", "SEARCHING", "DISBUSHMENT FORM", "ADVANCE FORM"};
            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {
                String[] langID = {"Account Sementara", "Amount", "Catatan", "Saldo Perkiraan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Detail", "Untuk Biaya", "Penjelasan", "Saldo kas tidak mencukupi", //6-9
                    "Dokumen pembayaran tunai siap untuk disimpan", "Dokumen pembayaran tunai sudah disimpan dengan sukses",
                    "Cari Nomor Jurnal", "Konsumen", "Departemen", "Bukan department dengan level terendah, Harap memilih department yang levelnya postable", "Dibayarkan kepada", "Kredit", "Sisa Anggaran", "Total Kas"
                }; //10-19

                langCT = langID;
                String[] navID = {"Transaksi Tunai", "Pengakuan Biaya", "Tanggal", "Harus diisi", "PENCARIAN", "PENGAKUAN BIAYA", "PEMBERIAN KASBON"};
                langNav = navID;

                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidPettycashPayment = JSPRequestValue.requestLong(request, "hidden_casharchive");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");

            PettycashPayment pettycashPayment = new PettycashPayment();

            if (oidPettycashPayment != 0) {
                try {
                    pettycashPayment = DbPettycashPayment.fetchExc(oidPettycashPayment);
                } catch (Exception e) {
                }
            }

            Vector listPettycashPaymentDetail = DbPettycashPaymentDetail.list(0, 0, DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + "=" + pettycashPayment.getOID(), null);
            double totalDetail = getTotalDetail(listPettycashPaymentDetail);
%>
<html>
    <head>
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
            function cmdBack(){
                document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
                document.frmpettycashpaymentdetail.action="casharchive.jsp";
                document.frmpettycashpaymentdetail.submit();
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
            //-->
        </script>
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif','../images/success1.gif','../images/no1.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="76"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="<%="background:url(" + approot + "/images/leftmenu-bg.gif) repeat-y"%>">
                                            <%@ include file="../main/menu.jsp"%>
                                            <%@ include file="../calendar/calendarframe.jsp"%>
                                        </td>
                                        <td width="100%" valign="top"> 
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
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmpettycashpaymentdetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="hidden_cash_receive_id" value="<%=oidPettycashPayment%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="preview_type" value="<%=previewType%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" colspan="3"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" width="1%">&nbsp;</td>
                                                                                <td height="8" valign="top" colspan="3" width="99%">
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr>
                                                                                            <td colspan="5" height="23"></td>                                                                                           
                                                                                        </tr>                                                                                        
                                                                                        <tr> 
                                                                                            <td width="10%" nowrap class="fontarial"><%=langCT[4]%></td>
                                                                                            <td width="2%">&nbsp;</td>
                                                                                            <td width="37%" class="fontarial">: <%=pettycashPayment.getJournalNumber()%></td>
                                                                                            <td width="13%" nowrap>&nbsp;</td>
                                                                                            <td width="38%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="10%" nowrap class="fontarial"><%=langCT[0]%></td>
                                                                                            <td width="2%">&nbsp;</td>
                                                                                            <td width="37%" class="fontarial"> :
                                                                                                <%
            Coa coaxx = new Coa();

            try {
                coaxx = DbCoa.fetchExc(pettycashPayment.getCoaId());
            } catch (Exception e) {
            }
                                                                                                %>
                                                                                            <%=coaxx.getCode() + " - " + coaxx.getName()%></td>
                                                                                            <td width="13%" nowrap class="fontarial"><%=langCT[5]%></td>
                                                                                            <td width="38%">: <%=JSPFormater.formatDate(pettycashPayment.getTransDate(), "dd/MM/yyyy")%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="10%" class="fontarial"><%=langCT[19]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                            <td width="2%">&nbsp;</td>
                                                                                            <td width="37%">:<%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%></td>
                                                                                            <td width="13%" class="fontarial"><%=langCT[16]%></td>
                                                                                            <td width="38%"> : <%=pettycashPayment.getPaymentTo()%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="10%" height="16" class="fontarial"><%=langCT[2]%></td>
                                                                                            <td width="2%" height="16">&nbsp;</td>
                                                                                            <td colspan="3" width="37%" valign="top" class="fontarial">: <%=pettycashPayment.getMemo()%></td>                                                                                                                                                                                        
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" width="1%" class="comment">&nbsp;</td>
                                                                                <td height="20" valign="middle" colspan="3" class="comment" width="99%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td  valign="middle" width="1%">&nbsp;</td>
                                                                                <td  valign="middle" colspan="3" width="99%">
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td class="tablearialhdr" width="30%" height="20"><%=langCT[7]%></td>                                                                                            
                                                                                            <td class="tablearialhdr" width="20%" height="20"><%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>                                                                                                                                                                                        
                                                                                            <td class="tablearialhdr" height="20">&nbsp;<%=langCT[8]%></td>
                                                                                        </tr>
                                                                                        <%
            if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0) {
                for (int i = 0; i < listPettycashPaymentDetail.size(); i++) {
                    PettycashPaymentDetail crd = (PettycashPaymentDetail) listPettycashPaymentDetail.get(i);
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
                                                                                            <td class="<%=cssString%>" width="17%"><%=c.getCode()%>&nbsp;-&nbsp;<%=c.getName()%></td>                                                                                            
                                                                                            <td class="<%=cssString%>"><div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div></td>
                                                                                            <td class="<%=cssString%>"><%=crd.getMemo()%></td>
                                                                                        </tr>
                                                                                        <%
                }
            }%>
                                                                                        <tr> 
                                                                                            <td colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="1"><div align="right"><b>Total <%=baseCurrency.getCurrencyCode()%></b></div></td>
                                                                                            <td ><div align="right"><b><%=JSPFormater.formatNumber(totalDetail, "#,###.##")%></b></div></td>                                                                                            
                                                                                            <td ></td>
                                                                                        </tr>
                                                                                        <%if (pettycashPayment.getOID() != 0) {
                String name = "-";
                String date = "";
                try {
                    User u = DbUser.fetch(pettycashPayment.getOperatorId());
                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                    name = e.getName();
                } catch (Exception e) {
                }
                try {
                    date = JSPFormater.formatDate(pettycashPayment.getDate(), "dd MMM yyyy");
                } catch (Exception e) {
                }


                String postedName = "";
                String postedDate = "";
                try {
                    User u = DbUser.fetch(pettycashPayment.getPostedById());
                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                    postedName = e.getName();
                } catch (Exception e) {
                }
                try {
                    if (pettycashPayment.getPostedDate() != null) {
                        postedDate = JSPFormater.formatDate(pettycashPayment.getPostedDate(), "dd MMM yyyy");
                    }
                } catch (Exception e) {
                    postedDate = "";
                }
                                                                                        %>
                                                                                        <tr>
                                                                                            <td height="30">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td valign="middle" colspan="3"> 
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
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td colspan="3">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="8" colspan="3" class="container"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" border="0"  alt="Kembali ke lembar kerja anda"></a></td>
                                                                </tr>
                                                                <tr> 
                                                                    <td colspan="3">&nbsp;</td>
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
