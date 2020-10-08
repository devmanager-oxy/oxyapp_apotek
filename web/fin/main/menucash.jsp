
<%-- 
    Document   : menucash
    Created on : Mar 9, 2012, 11:50:31 AM
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

            String[] langNav = {"Cash Transaction"};
            String strCTCashReceipt = "Cash Receipt";
            String strCTAdvanceReceipt = "Advance Refund";
            String strCTPettyCash = "Cash Transaction";
            String strCTCashPayment = "Disbushment";
            String strCTCashPay = "Cash Payment";
            String strCTKasbon = "Advance Release";
            String strKasbon = "Advance";
            String strCTCashRegister = "Cash Register";
            String strPostJournal = "Post Journal";
            String strCTArchives = "Archives";
            String strCTCashAccountLink = "Cash Account Link";
            String strGJAdvance = "Advance Reimbursement";
            String strStrKasir = "Setoran Kasir";
            String strStrPostingKasir = "Posting Setoran Kasir";
            String strStrKasirArchive = "Setoran Archive";
            
            if (lang == LANG_ID) {
                String[] navID = {"Transaksi Tunai"};
                langNav = navID;
                strCTCashReceipt = "Penerimaan Tunai";
                strCTAdvanceReceipt = "Pengembalian Kasbon";
                strCTPettyCash = "Transaksi Kas";
                strCTCashPayment = "Pengakuan Biaya";
                strCTCashPay = "Pembayaran Tunai";
                strKasbon = "Kasbon";
                strCTKasbon = "Pemberian Kasbon";
                strCTCashRegister = "Kas Register";
                strPostJournal = "Post Jurnal";
                strCTArchives = "Arsip";
                strCTCashAccountLink = "Setup Perkiraan Tunai";
                strGJAdvance = "Pemakaian Kasbon";
                strStrKasir = "Setoran Kasir";
                strStrPostingKasir = "Posting Setoran Kasir";
                strStrKasirArchive = "Arsip Setoran"; 
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
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="jspmenucash" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if (cashRecPriv || cashPPayPriv || cashPayPriv || fnCR) {%>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr height="15">
                                                                                                        <td colspan="1" ></td>
                                                                                                        <td width="80" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strCTPettyCash%></font>&nbsp;</td>                                                                                
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
                                                                                                                    <%if (cashRecPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/cashreceivedetail.jsp?menu_idx=2"><img src="<%=approot%>/images/mn14.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/cashreceivedetail.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCTCashReceipt%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%> 
                                                                                                                    <%if (cashPPayPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/pettycashpaymentdetail.jsp?menu_idx=2"><img src="<%=approot%>/images/mn15.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/pettycashpaymentdetail.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCTCashPay%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>
                                                                                                                    <%if (cashPayPriv && false) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="52">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/cash_receive.jsp?menu_idx=2"><img src="<%=approot%>/images/mn12.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/cash_receive.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCTCashPay%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>                                                                                                                    
                                                                                                                    <%if (fnCR) {%>                                                                       
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/cashregister.jsp?menu_idx=2"><img src="<%=approot%>/images/mn01.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/cashregister.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCTCashRegister%></font></a>
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
                                                                                            </td>
                                                                                        </tr>    
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>  
                                                                                        
                                                                                         <%if (cashsetoran) {%>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr height="15">
                                                                                                        <td colspan="1" ></td>
                                                                                                        <td width="80" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strStrKasir%></font>&nbsp;</td>                                                                                
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
                                                                                                                            <tr height="52">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/setorankasir.jsp?menu_idx=2"><img src="<%=approot%>/images/mn12.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/setorankasir.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strStrKasir%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>   
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="52">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/postingsetorankasir.jsp?menu_idx=2"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/postingsetorankasir.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strStrPostingKasir%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>   
                                                                                                                    <td width="20" align="center" valign="middle"></td>   
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="52">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/setorankasir_arsip.jsp?menu_idx=2"><img src="<%=approot%>/images/mn08.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/setorankasir_arsip.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strStrKasirArchive%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>    
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
                                                                                            <td height="25">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        
                                                                                        
                                                                                        
                                                                                        
                                                                                        <%if (cashPPARriv || cashRecAdPriv || cashRPPriv) {%>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr height="15">
                                                                                                        <td colspan="1" ></td>
                                                                                                        <td width="50" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strKasbon%></font>&nbsp;</td>                                                                                
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
                                                                                                                    <%if (cashPPARriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="52">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/kasbon.jsp?menu_idx=2"><img src="<%=approot%>/images/mn12.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/kasbon.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCTKasbon%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>    
                                                                                                                    <%if (cashRecAdPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="52">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/penerimaan_kasbon.jsp?menu_idx=2"><img src="<%=approot%>/images/mn27.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/penerimaan_kasbon.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCTAdvanceReceipt%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%> 
                                                                                                                    <%if (advanceReimbPriv) {%>
                                                                                                                    
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr height="52">
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/glkasbon.jsp?menu_idx=2"><img src="<%=approot%>/images/mn13.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/glkasbon.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strGJAdvance%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%> 
                                                                                                                    <%if (cashRPPriv) {%>                                                                                            
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/posting_glkasbon.jsp?menu_idx=2"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/posting_glkasbon.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPostJournal%></font></a>
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
                                                                                            </td>
                                                                                        </tr>                                                                    
                                                                                        <tr> 
                                                                                            <td height="25">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr height="35">
                                                                                                        <td width="10" align="center" valign="middle"></td>                                                                                
                                                                                                        <%if (cashRPPriv) {%>
                                                                                                        <td valign="top">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                        <a href="<%=approot%>/<%=transactionFolder%>/casharchivepost.jsp?menu_idx=2"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                            
                                                                                                                <tr>
                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                        <a href="<%=approot%>/<%=transactionFolder%>/casharchivepost.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPostJournal%></font></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>     
                                                                                                        <td width="20" align="center" valign="middle"></td>
                                                                                                        <%}%>
                                                                                                        <%if (cashArPriv) {%>                                                                                
                                                                                                        <td valign="top">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                        <a href="<%=approot%>/<%=transactionFolder%>/casharchive.jsp?menu_idx=2"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                            
                                                                                                                <tr>
                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                        <a href="<%=approot%>/<%=transactionFolder%>/casharchive.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCTArchives%></font></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>     
                                                                                                        <td width="20" align="center" valign="middle"></td>
                                                                                                        <%}%>
                                                                                                        <%if (cashArcPriv) {%>    
                                                                                                        <td valign="top">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                        <a href="<%=approot%>/master/cashacclink.jsp?menu_idx=2"><img src="<%=approot%>/images/mn17.jpg" border="0"></a>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                            
                                                                                                                <tr>
                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                        <a href="<%=approot%>/master/cashacclink.jsp?menu_idx=2" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCTCashAccountLink%></font></a>
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
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                            
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                    <!-- #EndEditable --> </td>
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
