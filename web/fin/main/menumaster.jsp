
<%-- 
    Document   : menumaster
    Created on : Mar 14, 2012, 2:50:58 PM
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

            String[] langNav = {"Master"};
            String strComp = "Company";
            String strMDAccounting = "Accounting";
            String strMDChartOfAccount = "Chart of Account";
            String strMDAccountBudgetTarget = "Account Budget/Target";
            String strMDPortofolioSetup = "Portofolio Setup";
            String strMDSegment = "Segment";
            String strMDAccountCategory = "Account Category";
            String strMDAccountGroupAliases = "Account Group Aliases";
            String strMDBookkeepingRate = "Bookkeeping Rate";
            String strMDPeriod = "Period";
            String strMDDocCode = "Doc. Code Setup";
            String strMDSetupApproval = "Doc. Approval Setup";
            String strMDApproval = "Document";
            String strMDDesignPrint = "Printout Design";
            String strMDExpense = "Expense Allocation to Activity";
            String strMDDonorList = "Donor List";
            String strMDActivityPeriod = "Activity Period";
            String strMDCompany = "Company";
            String strMDEmployeeList = "Employee";
            String strMDDepartmentList = "Department";
            String strMDGeneral = "General";
            String strMDCountry = "Country";
            String strMDMerchant = "Merchant";
            String strMDGiro = "Giro";
            String strMDCurrency = "Currency";
            String strMDTermOfPayment = "Term of Payment";
            String strMDShippingAddress = "Shipping Address";
            String strMDPaymentMethod = "Payment Method";
            String strMDLocationList = "Location List";
            String strMDSubDistrict = "Sub-District Area";
            String strMDVillage = "Village Area";
            String strMDOccupationList = "Occupation List";
            String strMDOfficialUnit = "Official Unit";
            String strBisnisUnit = "Business Unit";
            
            String strSuplier = "Suplier";
            
            if (lang == LANG_ID) {
                String[] navID = {"Data Induk"};
                langNav = navID;

                strComp = "Company";
                strMDAccounting = "Akuntansi";
                strMDChartOfAccount = "Daftar Perkiraan";
                strMDAccountBudgetTarget = "Anggaran/Target";
                strMDPortofolioSetup = "Portofolio Setup";
                strMDSegment = "Segmen";
                strMDAccountCategory = "Kategori Perkiraan";
                strMDAccountGroupAliases = "Pengelompokan Perkiraan";
                strMDBookkeepingRate = "Kurs Pembukuan";
                strMDPeriod = "Periode";
                strMDApproval = "Dokumen";
                strMDDocCode = "Setup Kode Dok.";
                strMDSetupApproval = "Setup Persetujuan Dok.";
                strMDDesignPrint = "Design Printout";
                strMDExpense = "Alokasi Biaya Kegiatan";
                strMDDonorList = "Daftar Donor";
                strMDActivityPeriod = "Activity Period";
                strMDCompany = "Perusahaan";
                strMDEmployeeList = "Pegawai";
                strMDDepartmentList = "Departemen";
                strMDGeneral = "Umum";
                strMDCountry = "Negara";
                strMDCurrency = "Mata Uang";
                strMDTermOfPayment = "Term Pembayaran";
                strMDShippingAddress = "Alamat Pengiriman";
                strMDPaymentMethod = "Metode Pembayaran";
                strMDLocationList = "Daftar Lokasi";
                strMDSubDistrict = "Kecamatan";
                strMDVillage = "Desa";
                strMDOccupationList = "Daftar Pekerjaan";
                strMDOfficialUnit = "Unit Dinas";
                strBisnisUnit = "Unit Usaha";
                strMDMerchant = "Merchant";
                strMDGiro = "Giro";
                strSuplier = "Suplier";
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
                            <form name="jspkecamatan" method ="post" action="">
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
                                                        <tr> 
                                                            <td>&nbsp;</td>
                                                        </tr>
                                                        <tr> 
                                                            <td> 
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr> 
                                                                        <td width="100%"> 
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                <%if (mastSysConf || mastAcc || mastBgt || mastSegment) {%>
                                                                                <tr> 
                                                                                    <td>
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <%if (mastSysConf) {%>
                                                                                                <td >
                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                        <tr height="55">
                                                                                                            <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                <a href="<%=approot%>/master/company.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                            </td>
                                                                                                        </tr>                                                                                                            
                                                                                                        <tr>
                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                <a href="<%=approot%>/master/company.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strComp%></font></a>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>                                                                                                                      
                                                                                                </td>                                                                                                                                
                                                                                                <%}%>
                                                                                                <%if (mastAcc || mastBgt || mastSegment) {%>
                                                                                                <td width="20" align="center" valign="middle"></td>
                                                                                                <td>
                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                        <tr height="15">
                                                                                                            <td colspan="1" ></td>
                                                                                                            <td width="80" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strMDAccounting%></font>&nbsp;</td>                                                                                
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
                                                                                                                        <%if (mastAcc) {%>
                                                                                                                        <td valign="top">
                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                <tr height="55">
                                                                                                                                    <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                                        <a href="<%=approot%>/master/coa.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                                                    </td>
                                                                                                                                </tr>                                                                                                            
                                                                                                                                <tr >
                                                                                                                                    <td align="center" width="90" valign="top">                                                                                                                      
                                                                                                                                        <a href="<%=approot%>/master/coa.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDChartOfAccount%></font></a>
                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </td>     
                                                                                                                        <td width="20" align="center" valign="middle"></td>  
                                                                                                                        <%}%>
                                                                                                                        <%if (mastBgt) {%>
                                                                                                                        <td valign="top">
                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                <tr height="55">
                                                                                                                                    <td align="center" width="90" valign="top">                                                                                                                       
                                                                                                                                        <a href="<%=approot%>/master/coabudget_edt.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                                                    </td>
                                                                                                                                </tr>                                                                                                            
                                                                                                                                <tr >
                                                                                                                                    <td align="center" width="90" valign="top">                                                                                                                       
                                                                                                                                        <a href="<%=approot%>/master/coabudget_edt.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDAccountBudgetTarget%></font></a>
                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </td>     
                                                                                                                        <td width="20" align="center" valign="middle"></td>  
                                                                                                                        <%}%>
                                                                                                                        <%if (mastSegment) {%>
                                                                                                                        <td valign="top">
                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                <tr height="55">
                                                                                                                                    <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                                        <a href="<%=approot%>/segment/segment.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                                                    </td>
                                                                                                                                </tr>                                                                                                            
                                                                                                                                <tr>
                                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                                        <a href="<%=approot%>/segment/segment.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDSegment%></font></a>
                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </td>     
                                                                                                                        <td width="20" align="center" valign="middle"></td>  
                                                                                                                        <%}%>
                                                                                                                        <%if (mastAcc) {%>
                                                                                                                        <td valign="top">
                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                <tr height="55">
                                                                                                                                    <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                                        <a href="<%=approot%>/general/exchangerate.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                                                    </td>
                                                                                                                                </tr>                                                                                                            
                                                                                                                                <tr>
                                                                                                                                    <td align="center" width="90">                                                                                                                        
                                                                                                                                        <a href="<%=approot%>/general/exchangerate.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDBookkeepingRate%></font></a>
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
                                                                                                <%}%>
                                                                                            </tr>
                                                                                        </table>                                                                                                                      
                                                                                    </td>
                                                                                </tr>
                                                                                <%}%> 
                                                                                <%if (mastAcc || (applyActivity && mastWp) || mastComp || mastVendor) {%>
                                                                                <tr> 
                                                                                    <td height="20">&nbsp;</td>
                                                                                </tr>
                                                                                <tr> 
                                                                                    <td height="20">
                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                        <tr >
                                                                                        <td>
                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                <tr >
                                                                                                    <%if (mastAcc) {%>
                                                                                                    <td>                                                                                                                                    
                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                            <tr height="15">
                                                                                                                <td colspan="1" ></td>
                                                                                                                <td width="70" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strMDApproval%></font>&nbsp;</td>                                                                                
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
                                                                                                                                    <tr height="55">
                                                                                                                                        <td align="center" width="90" valign="top">                                                                                                                      
                                                                                                                                            <a href="<%=approot%>/general/systemdoccode.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>                                                                                                            
                                                                                                                                    <tr>
                                                                                                                                        <td align="center" width="90">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/general/systemdoccode.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDDocCode%></font></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>
                                                                                                                                </table>
                                                                                                                            </td>     
                                                                                                                            <td width="20" align="center" valign="middle"></td>  
                                                                                                                            <td valign="top">
                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr height="55">
                                                                                                                                        <td align="center" width="90" valign="top">                                                                                                                         
                                                                                                                                            <a href="<%=approot%>/master/approval.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>                                                                                                            
                                                                                                                                    <tr>
                                                                                                                                        <td align="center" width="90">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/master/approval.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDSetupApproval%></font></a>
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
                                                                                                    <%}%>
                                                                                                    <%if (applyActivity && mastWp && sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_NGO) {%>
                                                                                                    <td width="10"></td>
                                                                                                    <td valign="top">
                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                            <tr height="15">
                                                                                                                <td colspan="1" ></td>
                                                                                                                <td width="70" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282">Workplan</font>&nbsp;</td>                                                                                
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
                                                                                                                                    <tr height="55">
                                                                                                                                        <td align="center" width="90" valign="top">                                                                                                                       
                                                                                                                                            <a href="<%=approot%>/activity/activityperiod.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>                                                                                                            
                                                                                                                                    <tr height="30">
                                                                                                                                        <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/activity/activityperiod.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDActivityPeriod%></font></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>
                                                                                                                                </table>
                                                                                                                            </td>     
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td colspan="1" >&nbsp;</td>
                                                                                                                        </tr>
                                                                                                                    </table>
                                                                                                                </td>
                                                                                                            </tr>                                                                                                                                        
                                                                                                        </table>
                                                                                                    </td>
                                                                                                    <%}%>
                                                                                                    <%if (mastVendor) {%>
                                                                                                    <td width="10"></td>
                                                                                                    <td valign="top">
                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                            <tr height="15">
                                                                                                                <td colspan="1" ></td>
                                                                                                                <td width="60" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strSuplier%></font>&nbsp;</td>                                                                                
                                                                                                                <td colspan="1" ></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                            </tr>  
                                                                                                            <tr >                                                                                
                                                                                                                <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                        <tr>
                                                                                                                            <td width="10" align="center" valign="middle"></td>                                                                                                                                                          
                                                                                                                            <td valign="top">
                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr height="55">
                                                                                                                                        <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/general/vendorlist.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>                                                                                                            
                                                                                                                                    <tr height="30">
                                                                                                                                        <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/general/vendorlist.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strSuplier%></font></a>
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
                                                                                                    <%}%>
                                                                                                    
                                                                                                    
                                                                                                    <%if (mastComp) {%>
                                                                                                    <td width="10"></td>
                                                                                                    <td valign="top">
                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                            <tr height="15">
                                                                                                                <td colspan="1" ></td>
                                                                                                                <td width="80" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strMDCompany%></font>&nbsp;</td>                                                                                
                                                                                                                <td colspan="1" ></td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                            </tr>  
                                                                                                            <tr >                                                                                
                                                                                                                <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                        <tr>
                                                                                                                            <td width="10" align="center" valign="middle"></td>                                                                                                                                                          
                                                                                                                            <td valign="top">
                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr height="55">
                                                                                                                                        <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/payroll/employee.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>                                                                                                            
                                                                                                                                    <tr height="30">
                                                                                                                                        <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/payroll/employee.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDEmployeeList%></font></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>
                                                                                                                                </table>
                                                                                                                            </td>     
                                                                                                                            <td width="20" align="center" valign="middle"></td> 
                                                                                                                            <td valign="top">
                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                    <tr height="55">
                                                                                                                                        <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/payroll/department.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                                                        </td>
                                                                                                                                    </tr>                                                                                                            
                                                                                                                                    <tr height="30">
                                                                                                                                        <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                                            <a href="<%=approot%>/payroll/department.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDDepartmentList%></font></a>
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
                                                                                                    <%}%>
                                                                                                </tr>
                                                                                            </table>                                                                                                                       
                                                                                        </td>                                                                                                                                
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>                                                                        
                                                                    </tr>                                                                                                                
                                                                    <%}%> 
                                                                    <%if (mastGen || mastCurrency) {%>
                                                                    <tr> 
                                                                        <td height="20">&nbsp;</td>
                                                                    </tr>
                                                                    <tr> 
                                                                        <td height="20">
                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                <tr height="15">
                                                                                    <td colspan="1" ></td>
                                                                                    <td width="60" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strMDGeneral%></font>&nbsp;</td>                                                                                
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
                                                                                                <%if(mastGen){%>
                                                                                                <td width="10" align="center" valign="middle"></td> 
                                                                                                <td valign="top">
                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                        <tr height="55">
                                                                                                            <td align="center" width="90" valign="top">                                                                                                                      
                                                                                                                <a href="<%=approot%>/general/bank.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                            </td>
                                                                                                        </tr>                                                                                                            
                                                                                                        <tr>
                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                <a href="<%=approot%>/general/bank.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A">Bank</font></a>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>     
                                                                                                <%}%>
                                                                                                <%if(mastCurrency){%>
                                                                                                <td width="20" align="center" valign="middle"></td> 
                                                                                                <td valign="top">
                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                        <tr height="55">
                                                                                                            <td align="center" width="90" valign="top">                                                                                                                        
                                                                                                                <a href="<%=approot%>/general/currency.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                            </td>
                                                                                                        </tr>                                                                                                            
                                                                                                        <tr>
                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                <a href="<%=approot%>/general/currency.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDCurrency%></font></a>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>     
                                                                                                <%}%>
                                                                                                <%if(mastGen){%>
                                                                                                <td width="20" align="center" valign="middle"></td>
                                                                                                <td valign="top">
                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                        <tr height="55">
                                                                                                            <td align="center" width="90" valign="top">                                                                                                                       
                                                                                                                <a href="<%=approot%>/master/paymentmethod.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                            </td>
                                                                                                        </tr>                                                                                                            
                                                                                                        <tr>
                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                <a href="<%=approot%>/master/paymentmethod.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDPaymentMethod%></font></a>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>     
                                                                                                <td width="20" align="center" valign="middle"></td>
                                                                                                <td valign="top">
                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                        <tr height="55">
                                                                                                            <td align="center" width="90" valign="top">                                                                                                                       
                                                                                                                <a href="<%=approot%>/general/merchant.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                            </td>
                                                                                                        </tr>                                                                                                            
                                                                                                        <tr>
                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                <a href="<%=approot%>/general/merchant.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDMerchant%></font></a>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>    
                                                                                                <td width="20" align="center" valign="middle"></td>
                                                                                                <td valign="top">
                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                        <tr height="55">
                                                                                                            <td align="center" width="90" valign="top">                                                                                                                       
                                                                                                                <a href="<%=approot%>/general/giro.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                            </td>
                                                                                                        </tr>                                                                                                            
                                                                                                        <tr>
                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                <a href="<%=approot%>/general/giro.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A"><%=strMDGiro%></font></a>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>    
                                                                                                <td width="20" align="center" valign="middle"></td>
                                                                                                <td valign="top">
                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                        <tr height="55">
                                                                                                            <td align="center" width="90" valign="top">                                                                                                                       
                                                                                                                <a href="<%=approot%>/ap/budgetgroup.jsp?menu_idx=17"><img src="<%=approot%>/images/master.gif" border="0"></a>
                                                                                                            </td>
                                                                                                        </tr>                                                                                                            
                                                                                                        <tr>
                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                <a href="<%=approot%>/general/budgetgroup.jsp?menu_idx=17" style="text-decoration: none"><font face="arial" color="#07770A">Group Budget</font></a>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>    
                                                                                                <td width="20" align="center" valign="middle"></td>
                                                                                            </tr>    
                                                                                            <tr>
                                                                                                <td colspan="1" >&nbsp;</td>
                                                                                            </tr>
                                                                                            <%}%>
                                                                                        </table>
                                                                                    </td>
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
