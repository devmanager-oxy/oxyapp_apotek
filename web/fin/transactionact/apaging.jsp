
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.DbReceive" %>
<%@ page import = "com.project.fms.transaction.DbBankpoPaymentDetail" %>
<%@ page import = "com.project.fms.transaction.DbBankpoPayment" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%@ page import = "com.project.I_Project" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AAN);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AAN, AppMenu.PRIV_VIEW);
%>
<%
            if (session.getValue("AGE_ANALYSIS") != null) {
                session.removeValue("AGE_ANALYSIS");
            }

            long unitUsahaId = JSPRequestValue.requestLong(request, "src_ap_id");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidVendor = JSPRequestValue.requestLong(request, "vendor_id");
            String codeVendor = JSPRequestValue.requestString(request, "text_code");
            int ageDate = JSPRequestValue.requestInt(request, "age_date");

            Vector vPayList = new Vector();
            if (iJSPCommand == JSPCommand.SUBMIT) {
                vPayList = QrAR.listApAging(oidVendor, codeVendor);                   
            }

            Company company = new Company();
            try {
                company = DbCompany.getCompany();
            } catch (Exception ex) {
            }

            session.putValue("AGE_ANALYSIS", vPayList);            
            session.putValue("AGE_ANALYSIS_UNIT_USAHA", unitUsahaId + "");

            /*** LANG ***/
            String[] langAP = {"Vendor", "Business Unit", "Aged by", //0-2
                "Code", "Vendor", "Current", "Over 30 Days", "Over 60 Days", "Over 90 Days", "Over 120 Days", "Balance", "Code"}; //3-11

            String[] langNav = {"Account Payable", "Aging Analysis", "Date", "All", "Searching Parameter", "Click search button to searching the data", "Data not found"};

            if (lang == LANG_ID) {
                String[] langID = {"Suplier", "Unit Bisnis", "Umur Berdasarkan",
                    "Kode", "Suplier", "Saat Ini", "> 30 Hari", "> 60 Hari", "> 90 Hari", "> 120 Hari", "Saldo", "Code"
                };
                langAP = langID;

                String[] navID = {"Hutang", "Aging Analysis", "Tanggal", "Semua", "Parameter Pencarian", "Klik tombol search untuk melakukan pencarian", "Data tidak ditemukan"};
                langNav = navID;
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrint(){	 
                window.open("<%=printroot%>.report.RptAccPayableAgingXLS?oid=<%=company.getOID()%>&age=<%=ageDate%>");
                }
                
                function cmdSearch(){
                    document.form1.command.value="<%=JSPCommand.SUBMIT%>";
                    document.form1.action="apaging.jsp";
                    document.form1.submit();
                }
                
                function MM_swapImgRestore() { //v3.0
                    var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
                }
                function MM_preloadImages() { //v3.0
                    var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                        if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
                }
                
                function MM_findObj(n, d) { //v4.01
                    var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                    if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                    for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                    if(!x && d.getElementById) x=d.getElementById(n); return x;
                }
                
                function MM_swapImage() { //v3.0
                    var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                    if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
                }
                //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                                    <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                                                        <tr> 
                                                                            <td valign="top"> 
                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                                                    <!--DWLayoutTable-->
                                                                                    <tr> 
                                                                                        <td width="100%" valign="top"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td> 
                                                                                                        <form id="form1" name="form1" method="post" action="">
                                                                                                            <input type="hidden" name="command">
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                                               
                                                                                                                <tr> 
                                                                                                                    <td class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td> 
                                                                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="330">                                                                                                                                        
                                                                                                                                        <tr>                                                                                                                                            
                                                                                                                                            <td class="tablecell1" >                                                                                                            
                                                                                                                                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                                                                                                                                    <tr> 
                                                                                                                                                        <td height="8" colspan="4"></td>
                                                                                                                                                    </tr>    
                                                                                                                                                    <tr> 
                                                                                                                                                        <td height="8" ></td>
                                                                                                                                                        <td height="8" colspan="3"><b><i><%=langNav[4]%></i></b></td>
                                                                                                                                                    </tr>    
                                                                                                                                                    <tr> 
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td width="15%"><%=langAP[3]%></td>
                                                                                                                                                        <td ><input type="text" name="text_code" size="25" value="<%=codeVendor%>"></td>
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                    </tr>  
                                                                                                                                                    <tr> 
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td ><%=langAP[0]%></td>
                                                                                                                                                        <td > 
                                                                                                                                                            <%
            Vector vend = DbVendor.list(0, 0, "", DbVendor.colNames[DbVendor.COL_NAME]);
                                                                                                                                                            %>
                                                                                                                                                            <select name="vendor_id">
                                                                                                                                                                <option value="0">< all ></option>
                                                                                                                                                                <%if (vend != null && vend.size() > 0) {
                for (int i = 0; i < vend.size(); i++) {
                    Vendor c = (Vendor) vend.get(i);
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=c.getOID()%>" <%if (c.getOID() == oidVendor) {%>selected<%}%>><%=c.getName().toUpperCase()%></option>
                                                                                                                                                                <%}
            }%>
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                        <td ></td>
                                                                                                                                                    </tr>  
                                                                                                                                                    <tr> 
                                                                                                                                                        <td height="10" colspan="4"></td>
                                                                                                                                                    </tr>  
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                                          
                                                                                                                            <tr> 
                                                                                                                                <td class="boxed1"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td> 
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td height="10"></td>
                                                                                                                            </tr>  
                                                                                                                            <%
            if (iJSPCommand == JSPCommand.SUBMIT) {
                                                                                                                            %>   
                                                                                                                            <%if (vPayList != null && vPayList.size() > 0) {%>   
                                                                                                                            <tr> 
                                                                                                                                <td class="boxed1"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td class="tablehdr" width="2%">No</td>
                                                                                                                                            <td class="tablehdr" width="5%"><%=langAP[3]%></td>
                                                                                                                                            <td class="tablehdr" width="18%"><%=langAP[4]%></td>
                                                                                                                                            <td class="tablehdr" width="9%"><%=langAP[5]%></td>
                                                                                                                                            <td class="tablehdr" width="8%"><%=langAP[6]%></td>
                                                                                                                                            <td class="tablehdr" width="9%"><%=langAP[7]%></td>
                                                                                                                                            <td class="tablehdr" width="8%"><%=langAP[8]%></td>
                                                                                                                                            <td class="tablehdr" width="9%"><%=langAP[9]%></td>
                                                                                                                                            <td class="tablehdr" width="17%"><%=langAP[10]%></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
    double totalAmount = 0;
    double totalCurrent = 0;
    double totalOver30 = 0;
    double totalOver60 = 0;
    double totalOver90 = 0;
    double totalOver120 = 0;    

    if (vPayList != null && vPayList.size() > 0) {
        for (int i = 0; i < vPayList.size(); i++) {
            SesAgingAnalysis vAgingAnalysis = (SesAgingAnalysis) vPayList.get(i);

            //Load Class
            String tableClass = "tablecell1";
            if (i % 2 != 0) {
                tableClass = "tablecell";
            }

            //Load Total
            totalAmount = totalAmount + vAgingAnalysis.getLastPaymentAmount();
            totalCurrent = totalCurrent + vAgingAnalysis.getAgeCurrent();
            totalOver30 = totalOver30 + vAgingAnalysis.getAgeOver30();
            totalOver60 = totalOver60 + vAgingAnalysis.getAgeOver60();
            totalOver90 = totalOver90 + vAgingAnalysis.getAgeOver90();
            totalOver120 = totalOver120 + vAgingAnalysis.getAgeOver120();
                                                                                                                                        %>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="2%" class="<%=tableClass%>"> 
                                                                                                                                                <div align="center"><%=i + 1%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="5%" align="center" class="<%=tableClass%>"><%=vAgingAnalysis.getCustomerCode()%></td>
                                                                                                                                            <td width="18%" class="<%=tableClass%>" nowrap><%=vAgingAnalysis.getCustomerName()%></td>
                                                                                                                                            <td width="9%" class="<%=tableClass%>"> 
                                                                                                                                                <div align="right"><%=(vAgingAnalysis.getAgeCurrent() == 0) ? "" : JSPFormater.formatNumber(vAgingAnalysis.getAgeCurrent(), "#,###")%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="8%" class="<%=tableClass%>"> 
                                                                                                                                                <div align="right"><%=(vAgingAnalysis.getAgeOver30() == 0) ? "" : JSPFormater.formatNumber(vAgingAnalysis.getAgeOver30(), "#,###")%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="9%" class="<%=tableClass%>"> 
                                                                                                                                                <div align="right"><%=(vAgingAnalysis.getAgeOver60() == 0) ? "" : JSPFormater.formatNumber(vAgingAnalysis.getAgeOver60(), "#,###")%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="8%" class="<%=tableClass%>"> 
                                                                                                                                                <div align="right"><%=(vAgingAnalysis.getAgeOver90() == 0) ? "" : JSPFormater.formatNumber(vAgingAnalysis.getAgeOver90(), "#,###")%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="9%" class="<%=tableClass%>"> 
                                                                                                                                                <div align="right"><%=(vAgingAnalysis.getAgeOver120() == 0) ? "" : JSPFormater.formatNumber(vAgingAnalysis.getAgeOver120(), "#,###")%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="17%" class="<%=tableClass%>"> 
                                                                                                                                                <%
                                                                                                                                                double total = 0;
                                                                                                                                                total = vAgingAnalysis.getAgeCurrent() + vAgingAnalysis.getAgeOver30() + vAgingAnalysis.getAgeOver60() + vAgingAnalysis.getAgeOver90() + vAgingAnalysis.getAgeOver120();
                                                                                                                                                %>
                                                                                                                                                <div align="right"><%=(total == 0) ? "" : JSPFormater.formatNumber(total, "#,###")%></div>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <%
        }
    }
                                                                                                                                        %>
                                                                                                                                        <tr > 
                                                                                                                                            <td class="tablecell1"></td>
                                                                                                                                            <td class="tablecell1">&nbsp;</td>
                                                                                                                                            <td class="tablecell1"> 
                                                                                                                                                <div align="center"><b>T O T A L : </b></div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell1"> 
                                                                                                                                                <div align="right"><b><%=(totalCurrent == 0) ? "" : JSPFormater.formatNumber(totalCurrent, "#,###")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell1"> 
                                                                                                                                                <div align="right"><b><%=(totalOver30 == 0) ? "" : JSPFormater.formatNumber(totalOver30, "#,###")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell1"> 
                                                                                                                                                <div align="right"><b><%=(totalOver60 == 0) ? "" : JSPFormater.formatNumber(totalOver60, "#,###")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell1"> 
                                                                                                                                                <div align="right"><b><%=(totalOver90 == 0) ? "" : JSPFormater.formatNumber(totalOver90, "#,###")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell1"> 
                                                                                                                                                <div align="right"><b><%=(totalOver120 == 0) ? "" : JSPFormater.formatNumber(totalOver120, "#,###")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell1"> 
                                                                                                                                                <%
    double grandTotal = 0;
    grandTotal = totalCurrent + totalOver30 + totalOver60 + totalOver90 + totalOver120;
                                                                                                                                                %>
                                                                                                                                                <div align="right"><b><%=(grandTotal == 0) ? "" : JSPFormater.formatNumber(grandTotal, "#,###")%></b></div>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>                                                                                                                            
                                                                                                                            <tr> 
                                                                                                                                <td> 
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%"><a href="javascript:cmdPrint()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/print2.gif',1)"><img src="../images/print.gif" name="new21" border="0"></a></td>                                                                                                                                            
                                                                                                                                            <td width="80%">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                                            
                                                                                                                            <%} else {%>
                                                                                                                            <tr> 
                                                                                                                                <td><i><%=langNav[6]%></i></td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <%}%>
                                                                                                                            <%if (iJSPCommand != JSPCommand.SUBMIT) {%>
                                                                                                                            <tr> 
                                                                                                                                <td><i><%=langNav[5]%></i></td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <tr> 
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </form>
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
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
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

