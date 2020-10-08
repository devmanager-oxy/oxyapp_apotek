
<%-- 
    Document   : menubank
    Created on : Mar 12, 2012, 3:12:48 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            String[] langNav = {"Bank Transaction"};

            String strBTBankDeposit = "Bank Deposit";
            String strBTPayment = "Payment";
            String strBTBankAccountLink = "Bank Account Link";
            String strBTArchives = "Archives";
            String strBTNPost = "Post Jurnal";
            String strBTNonPOPayment = "Direct Bank Payment";
            String strBTCashPayment = "Invoice Payment";
            String strBTPaymentOfPO = "Invoice Selection";
            String strBTPaymentPO = "Invoice Payment";
            String strFRBudgetSulier = "Budget Suplier Report";
            String strBankRecon = "Reconsile Bank (Credit Card)";
            String strGenerateBG = "Generate BG/Check Number";
            
            String strBgOutstanding = "Bg Outstanding";
            String strBgArsip = "Bg Archive";
            String strBankReport = "Bank Report";
            String strBankReportDaily = "Daily Report";
            String strBankReportMonthly = "Monthly Report";

            if (lang == LANG_ID) {
                String[] navID = {"Transaksi Bank"};
                langNav = navID;

                strBTBankDeposit = "Setoran Bank";
                strBTPayment = "Pelunasan";
                strBTBankAccountLink = "Setup Perkiraan Bank";
                strBTArchives = "Arsip";
                strBTNPost = "Post Jurnal";
                strBTNonPOPayment = "Pembayaran Bank Langsung";
                strBTCashPayment = "Pelunasan Invoice";
                strBTPaymentOfPO = "Pilih/Seleksi Invoice";
                strBTPaymentPO = "Pembayaran Invoice";
                strFRBudgetSulier = "Laporan Budget Suplier";
                strBankRecon = "Reconsile Bank (Kartu Credit)";
                strGenerateBG = "Generate BG/Check Number";
                
                strBgOutstanding = "Bg Outstanding";
                strBgArsip = "Arsip Bg";
                strBankReport = "Laporan Bank";
                strBankReportDaily = "Laporan Harian";
                strBankReportMonthly = "Laporan Bulanan";
                
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <title><%=systemTitle%></title>
        <script language="JavaScript">            
            
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','<%=approot%>/images/BtnNewOn.jpg')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file = "../main/hmenu.jsp" %>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp" %>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="jspmenubank" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <%if (bankDepPriv || bankNonPriv || bankPostPriv || bankrecon || bankArcPriv || bankArcPriv || bankBgOutstanding ){%>
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr height="15">
                                                                                                        <td colspan="1" ></td>
                                                                                                        <td width="90" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=langNav[0]%></font>&nbsp;</td>                                                                                
                                                                                                        <td colspan="1" ></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                        <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                    </tr>  
                                                                                                    <tr>                                                                                
                                                                                                        <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td width="10" align="center" valign="middle"></td>
                                                                                                                    <%if (bankDepPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/bankdepositdetail.jsp?menu_idx=3"><img src="<%=approot%>/images/mn23.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/bankdepositdetail.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBTBankDeposit%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>         
                                                                                                                    <%if (bankNonPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/banknonpopaymentdetail.jsp?menu_idx=3"><img src="<%=approot%>/images/mn12.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/banknonpopaymentdetail.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBTNonPOPayment%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>
                                                                                                                    <%if (bankPostPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/posting_transaksi_bank.jsp?menu_idx=3"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/posting_transaksi_bank.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBTNPost%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%> 
                                                                                                                    <%if (bankrecon) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/cardrelease.jsp?menu_idx=3"><img src="<%=approot%>/images/mn14.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/cardrelease.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBankRecon%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>
                                                                                                                    <%if (bankArcPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/bankarchive.jsp?menu_idx=3"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/bankarchive.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBTArchives%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>
                                                                                                                </tr>
                                                                                                                <%if(bankGenBg || bankBgOutstanding){%>
                                                                                                                <tr>
                                                                                                                    <td colspan="1" >&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="1" >&nbsp;</td>
                                                                                                                    <%if(bankGenBg){%>
                                                                                                                    <td colspan="1" >
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/bank/generatebg.jsp?menu_idx=3"><img src="<%=approot%>/images/mn08.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/bank/generatebg.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strGenerateBG%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td> 
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <%if (bankBgOutstanding) {%>
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <td>        
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/bankpayment_release.jsp?menu_idx=3"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/bankpayment_release.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBgOutstanding%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>                                                                                                                      
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <td>        
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/ap/giro_archives.jsp?menu_idx=3"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/ap/giro_archives.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBgArsip%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>  
                                                                                                                    <%}%> 
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <tr>
                                                                                                                    <td colspan="1" >&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>                                                                                
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>    
                                                                                        <%}%>
                                                                                        <%if (bankReport && false) {%>
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td>
                                                                                                 <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr height="15">
                                                                                                        <td colspan="1" ></td>
                                                                                                        <td width="90" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strBankReport%></font>&nbsp;</td>                                                                                
                                                                                                        <td colspan="1" ></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                        <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                    </tr>  
                                                                                                    <tr>                                                                                
                                                                                                        <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td width="10" align="center" valign="middle"></td>                                                                                                                    
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/subledgerbankdaily.jsp?menu_idx=3"><img src="<%=approot%>/images/mn01.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/subledgerbankdaily.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBankReportDaily%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>                                                                                                                    
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/banknonpopaymentdetail.jsp?menu_idx=3"><img src="<%=approot%>/images/mn01.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/banknonpopaymentdetail.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBankReportMonthly%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>                                                                                                                    
                                                                                                                    <td colspan="1" >&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="1" >&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>   
                                                                                                    
                                                                                                </table>                                                                                            
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr height="35">
                                                                                                        <td width="10" align="center" valign="middle"></td>                                                                                                        
                                                                                                        <%if (bankLinkPriv) {%> 
                                                                                                        <td valign="top">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                        <a href="<%=approot%>/master/bankacclink.jsp?menu_idx=3"><img src="<%=approot%>/images/mn17.jpg" border="0"></a>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                            
                                                                                                                <tr>
                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                        <a href="<%=approot%>/master/bankacclink.jsp?menu_idx=3" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBTBankAccountLink%></font></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>     
                                                                                                        <td width="20" align="center" valign="middle"></td>
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="25">&nbsp;</td>
                                                                                        </tr>                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
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
            <%@ include file = "../main/footer.jsp" %>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>
