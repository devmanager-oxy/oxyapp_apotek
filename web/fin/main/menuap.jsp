
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

            String[] langNav = {"Account Payable"};

            String strInc = "Incoming Goods";
            String strIncoming = "Incoming Goods List";
            String invList = "Invoice List";
            String agingAnalysis = "Aging Analysis";
            String purchaseAcc = "AP Acc. List";
            String releaseStatus = "Release Status";
            String releaseHistory = "Release History";
            String apArchive = "Archive";
            String apPost = "Post Journal";
            String apMemorialTitle = "AP Memorial";
            String apMemo = "AP Memo";
            String apMemoPost = "Post Journal";
            String postSelInvoice = "Post Invoice";
            String strApArchives = "AP Archive";

            String strBTPaymentOfPO = "Invoice Selection";
            String strBTPaymentPO = "Invoice Payment";
            String strFRBudgetSulier = "Budget Suplier Report";
            String strFRBudgetSummary = "Budget Suplier Report (Summary)";
            String strFRBudgetPayment = "Budget Suplier Report (By Payment)";
            String strFRBudgetSulierTT = "Budget Suplier Report (TT Check & BG)";

            String strARGiroList = "Outstanding BG";
            String strARGiroArchives = "BG Archives";

            String strReleaseBG = "Release BG";

            if (lang == LANG_ID) {
                String[] navID = {"Hutang"};
                langNav = navID;
                strIncoming = "Daftar Barang Masuk";
                invList = "Daftar Faktur";
                agingAnalysis = "Analisis Aging";
                purchaseAcc = "Daftar Account Hutang";
                apArchive = "Arsip";
                apPost = "Post Jurnal";
                strInc = "Penerimaan Barang";
                strBTPaymentOfPO = "Seleksi Invoice";
                strBTPaymentPO = "Pembayaran Invoice";
                strFRBudgetSulier = "Laporan Budget Suplier";
                strFRBudgetSummary = "Laporan Budget Suplier (Summary)";
                strFRBudgetPayment = "Laporan Budget Suplier (By Payment)";
                apMemorialTitle = "AP Memorial";
                postSelInvoice = "Post Invoice";
                strApArchives = "Arsip Hutang";

                strARGiroList = "BG Outstanding";
                strARGiroArchives = "Arsip BG";
                releaseStatus = "Release Status";
                releaseHistory = "Release History";
                strReleaseBG = "Pencairan BG BG";
                strFRBudgetSulierTT = "Laporan Budget Suplier (TT Check & BG)";
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
            String navigator = "<font face=\"arial\" class=\"lvl1\">" + langNav[0] + "</font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="jspmenuap" method ="post" action="">
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
                                                                                        <%if (payIGL || payILI || seleksiInvoice || postInvoice || invoicePayment || budgetReport || payAAN || bGOutstanding || arsipBG || releaseInvoice) {%>
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>    
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr height="15">
                                                                                                        <td colspan="1" ></td>
                                                                                                        <td width="110" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strInc%></font>&nbsp;</td>                                                                                
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
                                                                                                                    <%if (payIGL) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/invoicesrc.jsp?menu_idx=5"><img src="<%=approot%>/images/mn15.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/invoicesrc.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=strIncoming%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>              
                                                                                                                    <%if (payILI) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="55">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/invoicearchive.jsp?menu_idx=5"><img src="<%=approot%>/images/mn18.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/invoicearchive.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=invList%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%> 
                                                                                                                    <%if (seleksiInvoice) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/bankpopaymentsrc.jsp?menu_idx=5"><img src="<%=approot%>/images/mn08.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/bankpopaymentsrc.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBTPaymentOfPO%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%> 
                                                                                                                    <%if (postInvoice) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/postinginvoice.jsp?menu_idx=5"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/postinginvoice.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=postSelInvoice%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%> 
                                                                                                                    <%if (invoicePayment) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/bankpopaymentlist.jsp?menu_idx=5"><img src="<%=approot%>/images/mn09.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/bankpopaymentlist.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBTPaymentPO%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>                                                                                                                    
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="1">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>  
                                                                                                                <tr>
                                                                                                                    <td width="10" align="center" valign="middle"></td>      
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/aparchive.jsp?menu_idx=5"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/aparchive.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=strApArchives%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>                                                                                                                    
                                                                                                                    <%if (budgetReport) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="55">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/reportbudgetsuplier.jsp?menu_idx=5"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/reportbudgetsuplier.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=strFRBudgetSulier%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%> 
                                                                                                                    
                                                                                                                    <%if (budgetReportSummary) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="55">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/reportbudgetsuplierttcek.jsp?menu_idx=5"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/reportbudgetsuplierttcek.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=strFRBudgetSulierTT%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="55">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/reportbudgetsupliersummary.jsp?menu_idx=5"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/reportbudgetsupliersummary.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=strFRBudgetSummary%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="55">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/reportbudgetsuplierbydate.jsp?menu_idx=5"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/reportbudgetsuplierbydate.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=strFRBudgetPayment%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%> 
                                                                                                                    <%if (budgetReportGA) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="55">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/reportbudgetsuplierop.jsp?menu_idx=5"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/freport/reportbudgetsuplierop.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=strFRBudgetSulier%> <BR> ( Operational )</font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%> 
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>    
                                                                                                                <tr>
                                                                                                                    <%if (payAAN) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="55">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/apaging.jsp?menu_idx=5"><img src="<%=approot%>/images/mn20.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/apaging.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=agingAnalysis%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td> 
                                                                                                                    <%}%> 
                                                                                                                  
                                                                                                                    <%if (releaseInvoice) {%>
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <td>        
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/admin/releasehutang.jsp?menu_idx=5"><img src="<%=approot%>/images/mn08.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/admin/releasehutang.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=releaseStatus%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td> 
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <td>        
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/admin/releasehutanghistory.jsp?menu_idx=5"><img src="<%=approot%>/images/mn14.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/admin/releasehutanghistory.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=releaseHistory%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td> 
                                                                                                                    <%}%> 
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="1">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>                                                                                
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr> 
                                                                                        <%}%>
                                                                                        <%if (apMemorial || postApMemorial || payPAL) {%>
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr>
                                                                                                        <%if (apMemorial || postApMemorial) {%>
                                                                                                        <td>
                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                            <tr height="15">
                                                                                                                <td colspan="1" ></td>
                                                                                                                <td width="70" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=apMemorialTitle%></font>&nbsp;</td>                                                                                
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
                                                                                                                            <%if (apMemorial) {%>
                                                                                                                            <td valign="top">
                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr>
                                                                                                                                        <td align="center" width="90">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/ap/apmemo.jsp?menu_idx=5"><img src="<%=approot%>/images/mn15.jpg" border="0"></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>                                                                                                            
                                                                                                                                    <tr>
                                                                                                                                        <td align="center" width="90">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/ap/apmemo.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=apMemo%></font></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>
                                                                                                                                </table>
                                                                                                                            </td>     
                                                                                                                            <td width="20" align="center" valign="middle"></td>
                                                                                                                            <%}%>              
                                                                                                                            <%if (postApMemorial) {%>
                                                                                                                            <td valign="top">
                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr>
                                                                                                                                        <td align="center" width="90">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/ap/apmemopost.jsp?menu_idx=5"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>                                                                                                            
                                                                                                                                    <tr>
                                                                                                                                        <td align="center" width="90">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/ap/apmemopost.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=apMemoPost%></font></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>
                                                                                                                                </table>
                                                                                                                            </td>     
                                                                                                                            <td width="20" align="center" valign="middle"></td>
                                                                                                                            <%}%>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td colspan="1" >&nbsp;</td>
                                                                                                                        </tr>
                                                                                                                    </table>
                                                                                                                </td>
                                                                                                            </tr>                                                                                
                                                                                                        </table>
                                                                                                        <td width="20" align="center" valign="middle"></td>
                                                                                                        <%}%>
                                                                                                        <%if (payPAL) {%>
                                                                                                        <td>
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                        <a href="<%=approot%>/master/purchaseacclink.jsp?menu_idx=5"><img src="<%=approot%>/images/mn17.jpg" border="0"></a>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                            
                                                                                                                <tr>
                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                        <a href="<%=approot%>/master/purchaseacclink.jsp?menu_idx=5" style="text-decoration: none"><font face="arial" color="#07770A"><%=purchaseAcc%></font></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr> 
                                                                                        <%}%> 
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
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
