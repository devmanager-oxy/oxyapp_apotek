
<%-- 
    Document   : cashreceivedetail-det
    Created on : Feb 15, 2012, 12:35:26 AM
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
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
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
            String[] langCT = {"Receipt to Account", "Receipt From", "Amount", "Memo", "Journal Number", "Transaction Date", //0-5
                "Receipt From", "Currency", "Code", "Amount", "Booked Rate", "Amount in", "Description", //6-12
                "Cash Received document is ready to be saved", "Cash Receive document has been saved successfully", "Search Journal Number", "Customer", "Search Advance"}; //13-17
            String[] langNav = {"Cash Transaction", "Cash Receive", "Date", "SEARCHING", "CASH RECEIVE FORM", "required"};
            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};
            if (lang == LANG_ID) {

                String[] langID = {"Diterima Pada", "Diterima Dari", "Jumlah", "Catatan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Dari Perkiraan", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Jumlah", "Keterangan",//6-12
                    "Dokumen Penerimaan Tunai siap untuk disimpan", "Dokumen Penerimaan Tunai sudah disimpan dengan sukses", "Cari Nomor Jurnal", "Konsumen", "Cari Kasbon"}; //13-17
                langCT = langID;
                String[] navID = {"Transaksi Tunai", "Penerimaan Tunai", "Tanggal", "PENCARIAN", "PENERIMAAN TUNAI", "Data harus diisi"};
                langNav = navID;
                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidCashReceive = JSPRequestValue.requestLong(request, "hidden_casharchive");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");
            long referensi_id = 0;

            CashReceive cashReceive = new CashReceive();
            if (oidCashReceive != 0) {
                try {
                    cashReceive = DbCashReceive.fetchExc(oidCashReceive);
                } catch (Exception e) {
                }
            }
            Vector listCashReceiveDetail = DbCashReceiveDetail.list(0, 0, DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] + "=" + cashReceive.getOID(), null);
            double totalDetail = getTotalDetail(listCashReceiveDetail);
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
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
            
            //-------------- script control line -------------------
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            
            function cmdBack(){
                document.frmcashreceivedetail.command.value="<%=JSPCommand.NONE%>";
                document.frmcashreceivedetail.action="casharchive.jsp";
                document.frmcashreceivedetail.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/savedoc2.gif','../images/no1.gif','../images/success1.gif','../images/back2.gif')">
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
                                                        <form name="frmcashreceivedetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="hidden_cash_receive_id" value="<%=oidCashReceive%>">
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
                                                                                            <td height="5">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="8%" class="fontarial"><%=langCT[4]%></td>
                                                                                            <td width="1%">&nbsp;</td>
                                                                                            <td width="33%" class="fontarial">: <%=cashReceive.getJournalNumber()%></td>
                                                                                            <td width="12%">&nbsp;</td>
                                                                                            <td >&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td class="fontarial"><%=langCT[0]%></td>
                                                                                            <td >&nbsp;</td>
                                                                                            <td class="fontarial">: 
                                                                                                <%
            Coa coa = new Coa();

            try {
                coa = DbCoa.fetchExc(cashReceive.getCoaId());
            } catch (Exception e) {
                System.out.println("Exception " + e.toString());
            }
                                                                                                %>
                                                                                            <%=coa.getCode() + " - " + coa.getName()%> </td>
                                                                                            <td class="fontarial"><%=langCT[5]%></td>
                                                                                            <td class="fontarial">: <%=JSPFormater.formatDate(cashReceive.getTransDate(), "dd/MM/yyyy")%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td class="fontarial"><%=langCT[1]%></td>
                                                                                            <td >&nbsp;</td>
                                                                                            <td class="fontarial">: <%=cashReceive.getReceiveFromName()%></td>
                                                                                            <td class="fontarial"><%=langCT[16]%></td>
                                                                                            <td class="fontarial"> : 
                                                                                                <%
            Customer cus = new Customer();
            try {
                cus = DbCustomer.fetchExc(cashReceive.getCustomerId());
            } catch (Exception e) {
            }
                                                                                                %>
                                                                                            <%=cus.getName()%> </td>
                                                                                        </tr>
                                                                                        <%
            String jur_num = "";
            if (cashReceive.getReferensiId() != 0 || referensi_id != 0) {
                if (cashReceive.getReferensiId() != 0) {
                    jur_num = DbPettycashPayment.getNomorReferensi(cashReceive.getReferensiId());
                } else {
                    jur_num = DbPettycashPayment.getNomorReferensi(referensi_id);
                }
            }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="fontarial"><%=langCT[2]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                            <td class="fontarial">&nbsp;</td>
                                                                                            <td class="fontarial">: <%=JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##")%></td>
                                                                                            <td class="fontarial"> 
                                                                                                <%if (jur_num.length() > 0) {%>
                                                                                                Momor Referensi
                                                                                                <%} else {%>
                                                                                                &nbsp; 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="fontarial"> 
                                                                                            <%if (jur_num.length() > 0) {%>
                                                                                            <%=jur_num%> 
                                                                                            <%} else {%>
                                                                                            &nbsp; 
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td class="fontarial" valign="top"><%=langCT[3]%></td>
                                                                                            <td >&nbsp;</td>
                                                                                            <td colspan="3" >: <%=cashReceive.getMemo()%></td>
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
                                                                                            <td rowspan="2" class="tablearialhdr" nowrap width="10%"><%=langCT[6]%></td>
                                                                                            <td colspan="2" class="tablearialhdr"><%=langCT[7]%></td>
                                                                                            <td rowspan="2" class="tablearialhdr" width="12%"><%=langCT[10]%></td>
                                                                                            <td rowspan="2" class="tablearialhdr" width="13%"><%=langCT[11]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                            <td rowspan="2" class="tablearialhdr" width="46%"><%=langCT[12]%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="6%" class="tablearialhdr"><%=langCT[8]%></td>
                                                                                            <td width="13%" class="tablearialhdr"><%=langCT[9]%></td>
                                                                                        </tr>
                                                                                        <%
            if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {
                for (int i = 0; i < listCashReceiveDetail.size(); i++) {
                    CashReceiveDetail crd = (CashReceiveDetail) listCashReceiveDetail.get(i);
                    Coa c = new Coa();

                    try {
                        c = DbCoa.fetchExc(crd.getCoaId());
                    } catch (Exception e) {
                    }

                    String cssName = "tablearialcell";
                    if (i % 2 != 0) {
                        cssName = "tablearialcell1";
                    }
                                                                                        %>
                                                                                        <tr height="22"> 
                                                                                            <td class="<%=cssName%>" nowrap width="10%"><%=c.getCode()%> &nbsp;-&nbsp; <%=c.getName()%> </td>
                                                                                            <td width="6%" class="<%=cssName%>"> 
                                                                                                <div align="center"> 
                                                                                                    <%
                                                                                                Currency xc = new Currency();

                                                                                                try {
                                                                                                    xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                                                                                                } catch (Exception e) {
                                                                                                    System.out.println("[Exception] " + e.toString());
                                                                                                }
                                                                                                    %>
                                                                                                <%=xc.getCurrencyCode()%></div>
                                                                                            </td>
                                                                                            <%
                                                                                                String famount = "";

                                                                                                if (crd.getAmount() == 0) {
                                                                                                    famount = "(" + JSPFormater.formatNumber(crd.getForeignCreditAmount(), "#,###.##") + ")";
                                                                                                } else {
                                                                                                    famount = JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##");
                                                                                                }
                                                                                            %>
                                                                                            <td width="13%" class="<%=cssName%>"><div align="right"> <%=famount%> </div></td>
                                                                                            <td width="12%" class="<%=cssName%>"><div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div></td>
                                                                                            <%
                                                                                                String amount = "";

                                                                                                if (crd.getAmount() == 0) {
                                                                                                    amount = "(" + JSPFormater.formatNumber(crd.getCreditAmount(), "#,###.##") + ")";
                                                                                                } else {
                                                                                                    amount = JSPFormater.formatNumber(crd.getAmount(), "#,###.##");
                                                                                                }
                                                                                            %>
                                                                                            <td width="13%" class="<%=cssName%>"> 
                                                                                                <div align="right"><%=amount%></div>
                                                                                            </td>
                                                                                            <td width="46%" class="<%=cssName%>"><%=crd.getMemo()%></td>
                                                                                        </tr>
                                                                                        <%
                }
            }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td colspan="6">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="4"><div align="right"><b>Total <%=baseCurrency.getCurrencyCode()%></b></div></td>
                                                                                            <td><div align="right"><b><%=JSPFormater.formatNumber(totalDetail, "#,###.##")%></b></div></td>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>                                                                                        
                                                                                        <%if (cashReceive.getOID() != 0) {
                String name = "-";
                String date = "";
                try {
                    User u = DbUser.fetch(cashReceive.getOperatorId());
                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                    name = e.getName();
                } catch (Exception e) {
                }
                try {
                    date = JSPFormater.formatDate(cashReceive.getDate(), "dd MMM yyyy");
                } catch (Exception e) {
                }


                String postedName = "";
                String postedDate = "";
                try {
                    User u = DbUser.fetch(cashReceive.getPostedById());
                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                    postedName = e.getName();
                } catch (Exception e) {
                }
                try {
                    if (cashReceive.getPostedDate() != null) {
                        postedDate = JSPFormater.formatDate(cashReceive.getPostedDate(), "dd MMM yyyy");
                    }
                } catch (Exception e) {
                    postedDate = "";
                }
                                                                                        %>
                                                                                        <tr>
                                                                                            <td height="30">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <tr colspan="3" align="left" valign="top"> 
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
                                                                                        <tr> 
                                                                                            <td colspan="6">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                        </table>
                                                                    </td>
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
