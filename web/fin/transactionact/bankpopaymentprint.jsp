
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean bankPriv = true;
%>
<!-- Jsp Block -->
<%!
    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                BanknonpoPaymentDetail crd = (BanknonpoPaymentDetail) listx.get(i);
                result = result + crd.getAmount();
            }
        }
        return result;
    }

    public BankpoPaymentDetail getBankpoPaymentDetail(Invoice ii, Vector bankpoPaymentDetail) {
        BankpoPaymentDetail bpd = new BankpoPaymentDetail();
        try {
            if (bankpoPaymentDetail != null && bankpoPaymentDetail.size() > 0) {
                for (int i = 0; i < bankpoPaymentDetail.size(); i++) {
                    BankpoPaymentDetail x = (BankpoPaymentDetail) bankpoPaymentDetail.get(i);
                    if (x.getInvoiceId() == ii.getOID()) {
                        return x;
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("\nerror : " + e.toString() + "\n");
        }
        return bpd;
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidBankpoPayment = JSPRequestValue.requestLong(request, "hidden_bankarchive");
            long oidBankpoPaymentx = JSPRequestValue.requestLong(request, "hidden_bankpo_payment_id");

            int iErrCode = JSPMessage.NONE;
            CmdBankpoPayment ctrlBankpoPayment = new CmdBankpoPayment(request);

            if (oidBankpoPaymentx > 0) {
                iErrCode = ctrlBankpoPayment.action(iJSPCommand, oidBankpoPayment);
                Vector vBPDx = DbBankpoPaymentDetail.list(0, 0, "bankpo_payment_id=" + oidBankpoPayment, "");
                DbInvoice.checkForClosed(oidBankpoPayment, vBPDx);
            }
            int vectSize = 0;
            BankpoPayment bankpoPayment = new BankpoPayment();
            if (oidBankpoPayment != 0) {
                try {
                    bankpoPayment = DbBankpoPayment.fetchExc(oidBankpoPayment);
                } catch (Exception e) {
                }
            }
            Vector listBankpoPaymentDetail = DbBankpoPaymentDetail.list(0, 0, "bankpo_payment_id=" + bankpoPayment.getOID(), "");

            if (bankpoPayment.getOID() != 0 && iJSPCommand == JSPCommand.SUBMIT) {
                DbReceive.checkForClosed(bankpoPayment.getOID(), listBankpoPaymentDetail);
            }

            /*** LANG ***/
            String[] langCT = {"Payment from Account", "Payment Method", "Cheque/Transfer Number", "Memo", "Journal Number", "Date Transaction", //0-5
                "Invoice Number", "Vendor", "Currency", "Balance", "Booked Rate", "Payment", "Payment By Invoice <BR>Currency", "Deduction", "Description"};

            String[] langNav = {"Bank Transaction", "Archive PO Payment"};

            if (lang == LANG_ID) {
                String[] langID = {"Account Pembayaran", "Tipe Pembayaran", "Check/No Transfer", "Catatan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Nomor Faktur", "Suplier", "Mata Uang", "Balance", "Rate", "Pembayaran", "Pembayaran Dg. Mata Uang <BR>Faktur", "Deduction", "Keterangan"};
                langCT = langID;

                String[] navID = {"Transaksi Bank", "Arsip Pembayaran PO"};
                langNav = navID;
            }
            Vector segments = DbSegment.list(0, 0, "", "count");
            String str = DbSystemProperty.getValueByName("APPLY_DOC_WORKFLOW");
            
            
         
            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {         
                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />        
        <script language="JavaScript">
            <%if (!bankPriv) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>	
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptApMemoPDF?user_id=<%=appSessUser.getUserOID()%>&bankpopayment_id=<%=oidBankpoPayment%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdBack(){
                    window.history.back();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/post_journal2.gif','../images/print2.gif','../images/back2.gif','../images/close2.gif')">
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
                                                        <form name="frmbankpopayment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="hidden_bankarchive" value="<%=oidBankpoPayment%>">
                                                            <input type="hidden" name="hidden_bankpo_payment_id" value="<%=oidBankpoPayment%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="top" colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="10" valign="middle" width="14%">&nbsp;</td>
                                                                                <td height="10" valign="middle" width="26%">&nbsp;</td>
                                                                                <td height="10" valign="middle" width="13%">&nbsp;</td>
                                                                                <td height="10" colspan="2" width="47%" class="comment"></td>
                                                                            </tr>                                                                           
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="21" valign="middle" width="14%" bgcolor="#EBEBEB">&nbsp;<%=langCT[0]%></td>
                                                                                <td height="21" valign="middle" width="26%"> : 
                                                                                    <%
            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(bankpoPayment.getCoaId());
            } catch (Exception e) {
            }
                                                                                    %>
                                                                                <%=coa.getCode() + " - " + coa.getName()%> </td>
                                                                                <td height="21" valign="middle" width="13%" bgcolor="#EBEBEB">&nbsp;<%=langCT[4]%></td>
                                                                                <td height="21" colspan="2" width="47%" class="comment"> : 
                                                                                    <%
            int counter = DbBankpoPayment.getNextCounter(sysCompany.getOID());
            String strNumber = DbBankpoPayment.getNextNumber(counter, sysCompany.getOID());

            if (bankpoPayment.getOID() != 0) {
                strNumber = bankpoPayment.getJournalNumber();
            }

                                                                                    %>
                                                                                <%=strNumber%> </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="21" valign="middle" width="14%" bgcolor="#EBEBEB">&nbsp;<%=langCT[3]%></td>
                                                                                <td height="21" valign="middle" width="26%"> : 
                                                                                <%=bankpoPayment.getMemo()%>
                                                                                 </td>
                                                                                <td height="21" valign="middle" width="13%" bgcolor="#EBEBEB">&nbsp;<%=langCT[5]%></td>
                                                                                <td height="21" colspan="2" width="47%" class="comment"> : 
                                                                                <%=JSPFormater.formatDate(bankpoPayment.getTransDate(), "dd/MM/yyyy")%></td>
                                                                            </tr>
                                                                            <%
            if (segments != null && segments.size() > 0) {
                for (int is = 0; is < segments.size(); is++) {
                    String seg = "";
                    String nameSeg = "";
                    Segment objSeg = (Segment) segments.get(is);

                    seg = objSeg.getName();
                    switch (is + 1) {
                        case 1:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment1Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }
                        case 2:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment2Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 3:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment3Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 4:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment4Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 5:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment5Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 6:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment6Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 7:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment7Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 8:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment8Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 9:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment9Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 10:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment10Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 11:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment11Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 12:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment12Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 13:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment13Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 14:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment14Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }

                        case 15:
                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(bankpoPayment.getSegment15Id());
                                nameSeg = sdet.getName();
                            } catch (Exception e) {
                            }
                            break;
                    }
                                                                            %>
                                                                            <tr height="21"> 
                                                                                <td  bgcolor="#EBEBEB">&nbsp;<%=seg%></td>
                                                                                <td colspan="4">: <%=nameSeg%></td>                                                                                                        
                                                                            </tr>
                                                                            
                                                                            <%
                }
            }

                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="21" valign="top" width="14%">&nbsp;</td>
                                                                                <td height="21" valign="top" width="26%">&nbsp;</td>
                                                                                <td height="21" valign="top" width="13%">&nbsp;</td>
                                                                                <td height="21" colspan="2" width="47%">&nbsp;</td> 
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="21" valign="top" colspan="5"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                        
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="100%" class="page"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td  class="tablehdr" width="8%"><font size="1"><%=langCT[6]%></font></td>
                                                                                                                    <td class="tablehdr" width="20%"><font size="1"><%=langCT[7]%></font></td>
                                                                                                                    <td class="tablehdr" width="5%"><font size="1"><%=langCT[8]%></font></td>                                                                                                                    
                                                                                                                    <td class="tablehdr" width="7%"><font size="1"><%=langCT[9]%></font></td>
                                                                                                                    <td class="tablehdr" width="7%"><font size="1"><%=langCT[10]%></font></td>
                                                                                                                    <td class="tablehdr" width="8%"><font size="1"><%=langCT[9]%> <%=baseCurrency.getCurrencyCode()%></font></td>
                                                                                                                    <td class="tablehdr" width="9%"><font size="1"><%=langCT[11]%> <%=baseCurrency.getCurrencyCode()%></font></td>
                                                                                                                    <td class="tablehdr" width="11%"><font size="1"><%=langCT[12]%></font></td>
                                                                                                                    <td class="tablehdr" width="8%"><font size="1"><%=langCT[13]%></font></td>
                                                                                                                    <td class="tablehdr" width="15%"><font size="1"><%=langCT[14]%></font></td>
                                                                                                                </tr>
                                                                                                                <%

            if (listBankpoPaymentDetail != null && listBankpoPaymentDetail.size() > 0) {
                for (int i = 0; i < listBankpoPaymentDetail.size(); i++) {
                    BankpoPaymentDetail bpd = (BankpoPaymentDetail) listBankpoPaymentDetail.get(i);

                    String number = "";
                    String vendor = "";
                    double balance = 0;
                    double balanceRp = 0;

                    Currency c = new Currency();
                    try {
                        c = DbCurrency.fetchExc(bpd.getCurrencyId());
                    } catch (Exception e) {
                    }

                    ExchangeRate eRate = DbExchangeRate.getStandardRate();

                    double exRateValue = 1;
                    if (c.getCurrencyCode().equals(IDRCODE)) {
                        exRateValue = eRate.getValueIdr();
                    } else if (c.getCurrencyCode().equals(USDCODE)) {
                        exRateValue = eRate.getValueUsd();
                    } else {
                        exRateValue = eRate.getValueEuro();
                    }

                    if (bpd.getInvoiceId() != 0) {

                        Receive receive = new Receive();
                        try {
                            receive = DbReceive.fetchExc(bpd.getInvoiceId());
                        } catch (Exception e) {
                        }

                        number = receive.getNumber() + "/" + receive.getInvoiceNumber();

                        Vendor vnd = new Vendor();
                        try {
                            vnd = DbVendor.fetchExc(receive.getVendorId());
                            vendor = vnd.getName();
                        } catch (Exception e) {
                        }

                        balance = DbReceive.getInvoiceBalance(receive.getOID());
                        balanceRp = exRateValue * balance;

                    } else {

                        ArapMemo arapMemo = new ArapMemo();
                        try {
                            arapMemo = DbArapMemo.fetchExc(bpd.getArapMemoId());
                        } catch (Exception e) {
                        }

                        number = arapMemo.getNumber();

                        Vendor vnd = new Vendor();
                        try {
                            vnd = DbVendor.fetchExc(arapMemo.getVendorId());
                            vendor = vnd.getName();
                        } catch (Exception e) {
                        }

                        balance = DbArapMemo.getInvoiceBalance(arapMemo.getOID());
                        balanceRp = exRateValue * balance;
                    }

                    double purchase = 0;
                    double purchaseByCurrency = 0;
                    double deduction = 0;

                    if (bpd.getPaymentAmount() >= 0) {
                        purchase = bpd.getPaymentAmount();
                        purchaseByCurrency = bpd.getPaymentAmount();
                        ;
                    } else {
                        deduction = bpd.getPaymentAmount() * -1;
                    }

                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell" width="8%"> 
                                                                                                                        <div align="left"><font size="1"><%=number%></font></div>
                                                                                                                    </td>
                                                                                                                    <td width="20%" class="tablecell"><font size="1"><%=vendor%></font></td>
                                                                                                                    <td width="5%" class="tablecell"> 
                                                                                                                        <div align="center"><font size="1"><%=c.getCurrencyCode()%> </font></div>
                                                                                                                    </td>                                                                                                                   
                                                                                                                    <td width="7%" class="tablecell" align="right"> 
                                                                                                                    <font size="1"><%=JSPFormater.formatNumber(balance, "#,###.##")%> </font></td>
                                                                                                                    <td width="7%" class="tablecell" align="right"> 
                                                                                                                        <font size="1"> 
                                                                                                                            <%

                                                                                                                            %>
                                                                                                                    <%=JSPFormater.formatNumber(exRateValue, "#,###.##")%> </font></td>
                                                                                                                    <td width="10%" class="tablecell" align="right"> 
                                                                                                                    <font size="1"><%=JSPFormater.formatNumber(balanceRp, "#,###.##")%> </font></td>
                                                                                                                    <td width="9%" class="tablecell" align="right"> 
                                                                                                                    <font size="1"><%=JSPFormater.formatNumber(purchase, "#,###.##")%> </font></td>
                                                                                                                    <td width="11%" class="tablecell" align="right"> 
                                                                                                                    <font size="1"><%=JSPFormater.formatNumber(purchaseByCurrency, "#,###.##")%> </font></td>
                                                                                                                    <td width="15%" class="tablecell" align="right"><font size="1"><%=JSPFormater.formatNumber(deduction, "#,###.##")%></font></td>
                                                                                                                    <td width="15%" class="tablecell"><font size="1"><%=bpd.getMemo()%> </font></td>
                                                                                                                </tr>
                                                                                                                <%}
            }%>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr id="command_line"> 
                                                                                <td colspan="4"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="2" height="5"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="78%">&nbsp;</td>
                                                                                            <td width="22%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="78%">&nbsp;</td>
                                                                                            <td class="boxed1" width="22%"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="36%"> 
                                                                                                            <div align="left"><b>Total <%=baseCurrency.getCurrencyCode()%> : </b></div>
                                                                                                        </td>
                                                                                                        <td width="64%"> 
                                                                                                            <div align="right"> 
                                                                                                                <input type="text" name="tot" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>" style="text-align:right" size="20" class="readonly" readOnly>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4">&nbsp; </td>
                                                                            </tr>                                                                          
                                                                            <%if (bankpoPayment.getOID() != 0) {%>
                                                                            <tr> 
                                                                                <td colspan="4"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="3%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="9%"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print11','','../images/back2.gif',1)"><img src="../images/back.gif" name="print11"  border="0"></a></td>
                                                                                            <td width="47%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                                                            <td width="38%"> 
                                                                                                <%
    if (oidBankpoPaymentx > 0) {
                                                                                                %>
                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                                                                    <tr> 
                                                                                                        <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                        <td width="220">Journal has been 
                                                                                                        posted successfully</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="21" valign="top" width="14%">&nbsp;</td>
                                                                                <td height="21" valign="top" width="26%">&nbsp;</td>
                                                                                <td height="21" valign="top" width="13%">&nbsp;</td>
                                                                                <td height="21" colspan="2" width="47%">&nbsp;</td>
                                                                            </tr>
                                                                            <%if (bankpoPayment.getOID() != 0 && str.equalsIgnoreCase("Y") && false) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="5">&nbsp;</td> 
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="5"> 
                                                                                    <%
    Vector temp = DbApprovalDoc.getDocApproval(bankpoPayment.getOID());
                                                                                    %>
                                                                                    <table width="800" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="7" height="20"><b><%=langApp[0].toUpperCase()%></b> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="5%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[1]%> </font></b></td>
                                                                                            <td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[3]%></font></b></td>
                                                                                            <td width="18%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[2]%></font></b></td>
                                                                                            <td width="11%" height="20" bgcolor="#F3F3F3" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                                                                                            <td width="9%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[5]%></font></b></td>
                                                                                            <td width="27%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[6]%></font></b></td>
                                                                                            <td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[7]%></font></b></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="7" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <%
    if (temp != null && temp.size() > 0) {
        Employee userEmp = new Employee();
        try {
            userEmp = DbEmployee.fetchExc(user.getEmployeeId());
        } catch (Exception e) {
        }

        for (int i = 0; i < temp.size(); i++) {

            ApprovalDoc apd = (ApprovalDoc) temp.get(i);

            String tanggal = "";
            String status = "";
            String catatan = (apd.getNotes() == null) ? "" : apd.getNotes();
            String nama = "";
            Employee employee = new Employee();
            try {
                employee = DbEmployee.fetchExc(apd.getEmployeeId());
            } catch (Exception e) {
            }

            Department dep = new Department();
            try {
                dep = DbDepartment.fetchExc(employee.getDepartmentId());
            } catch (Exception e) {
            }

            Approval app = new Approval();
            try {
                app = DbApproval.fetchExc(apd.getApprovalId());
            } catch (Exception e) {
            }

            if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED || apd.getStatus() == DbApprovalDoc.STATUS_NOT_APPROVED) {
                tanggal = JSPFormater.formatDate(apd.getApproveDate(), "dd/MM/yyyy");
                status = DbApprovalDoc.strStatus[apd.getStatus()];
                nama = employee.getName();
            }

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="11%"><%=apd.getSequence()%></td>
                                                                                            <td width="13%"><%=employee.getPosition()%></td>
                                                                                            <td width="20%"><%=nama%></td>
                                                                                            <td width="13%"><%=tanggal%></td>
                                                                                            <td width="11%"><%=status%></td>
                                                                                            <td width="20%"> 
                                                                                                <%if (bankpoPayment.getPostedStatus() == 0) {
                                                                                                    if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED && user.getEmployeeId() == apd.getEmployeeId()) {%>
                                                                                                <div align="center"> 
                                                                                                    <input type="text" name="approval_doc_note" size="30" value="<%=catatan%>">
                                                                                                </div>
                                                                                                <%} else if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {%>
                                                                                                <div align="center"> 
                                                                                                    <input type="text" name="approval_doc_note" size="30" value="<%=catatan%>">
                                                                                                </div>
                                                                                                <%} else {%>
                                                                                                <%=catatan%> 
                                                                                                <%}
} else {%>
                                                                                                <%=catatan%> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td width="12%"> 
                                                                                                <%if (bankpoPayment.getPostedStatus() == 0) {%>
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td> 
                                                                                                            <%if (apd.getStatus() == DbApprovalDoc.STATUS_DRAFT) {
        if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {
                                                                                                            %>
                                                                                                            <div align="center"> 
                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <tr> 
                                                                                                                        <td> 
                                                                                                                            <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save1','','../images/success-2.gif',1)" alt="Klik : Untuk Menyetujui Dokumen"><img src="../images/success.gif" name="save1" height="20" border="0"></a></div>
                                                                                                                        </td>
                                                                                                                        <td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','2')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no3','','../images/no1.gif',1)" alt="Klik : Untuk tidak menyetujui"><img src="../images/no.gif" name="no3" height="20" border="0"></a></div></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                            <% }
} else {
    if (user.getEmployeeId() == apd.getEmployeeId()) {
        if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED) {
                                                                                                            %>
                                                                                                            <div align="center">
                                                                                                                <a href="javascript:cmdApproval('<%=apd.getOID()%>','0')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no','','../images/no1.gif',1)" alt="Klik : Untuk Membatalkan Persetujuan"><img src="../images/no.gif" name="no" height="20" border="0"></a>                                                                                                                
                                                                                                            </div>
                                                                                                            <%	} else {%>
                                                                                                            <div align="center">
                                                                                                                <a href="javascript:cmdApproval('<%=apd.getOID()%>','1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save2','','../images/success-2.gif',1)" alt="Klik : Untuk Melakukan Persetujuan"><img src="../images/success.gif" name="save2" height="20" border="0"></a>                                                                                                                
                                                                                                            </div>
                                                                                                            <%}
        }
    }%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <%} else {%>
                                                                                                &nbsp; 
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr><td colspan="7" height="1" bgcolor="#CCCCCC"></td></tr>
                                                                                        <%}
    }%>
                                                                                        <tr> 
                                                                                            <td width="11%">&nbsp;</td><td width="13%">&nbsp;</td><td width="20%">&nbsp;</td><td width="13%">&nbsp;</td><td width="11%">&nbsp;</td><td width="20%">&nbsp;</td><td width="12%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>                                                                                    
                                                                                </td>
                                                                            </tr> 
                                                                            <%}%>
                                                                            <%if (bankpoPayment.getOID() != 0) {
                                                                                String name = "-";
                                                                                String date = "";
                                                                                try{
                                                                                    User u = DbUser.fetch(bankpoPayment.getOperatorId());
                                                                                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                                                                                    name = e.getName();
                                                                                }catch(Exception e){}
                                                                                try{
                                                                                    date = JSPFormater.formatDate(bankpoPayment.getDate(),"dd MMM yyyy");
                                                                                }catch(Exception e){}
                                                                                
                                                                                
                                                                                String postedName = "";
                                                                                String postedDate = "";
                                                                                try{
                                                                                    User u = DbUser.fetch(bankpoPayment.getPostedById());
                                                                                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                                                                                    postedName = e.getName();
                                                                                }catch(Exception e){}
                                                                                try{
                                                                                    if(bankpoPayment.getPostedDate() != null){
                                                                                        postedDate = JSPFormater.formatDate(bankpoPayment.getPostedDate(),"dd MMM yyyy");
                                                                                    }
                                                                                }catch(Exception e){postedDate= "";}
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="21" valign="top" width="14%">&nbsp;</td>
                                                                                <td height="21" valign="top" width="26%">&nbsp;</td>
                                                                                <td height="21" valign="top" width="13%">&nbsp;</td>
                                                                                <td height="21" colspan="2" width="47%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="21" valign="top" width="14%">&nbsp;</td>
                                                                                <td height="21" valign="top" width="26%">&nbsp;</td>
                                                                                <td height="21" valign="top" width="13%">&nbsp;</td>
                                                                                <td height="21" colspan="2" width="47%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="14%">&nbsp;</td>
                                                                                <td width="26%">&nbsp;</td>
                                                                                <td width="13%">&nbsp;</td>
                                                                                <td width="47%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" > 
                                                                                <td colspan="5"> 
                                                                                    <div align="left"></div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
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
