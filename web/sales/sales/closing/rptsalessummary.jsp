
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checksl.jsp" %>
<%@ include file="../../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privPrint = true;
%>
<!-- Jsp Block -->
<%

            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalTo = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDateTo"), "dd/MM/yyyy");

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            if (session.getValue("REPORT_SALES_SUMMARY") != null) {
                session.removeValue("REPORT_SALES_SUMMARY");
            }

            /*variable declaration*/
            if (tanggal == null) {
                tanggal = new Date();
            }

            if (tanggalTo == null) {
                tanggalTo = new Date();
            }

            ReportParameterLocation rp = new ReportParameterLocation();
            rp.setStartDate(tanggal);
            rp.setEndDate(tanggalTo);
            session.putValue("REPORT_SALES_SUMMARY", rp);

%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>                
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmsales.action="rptsalessummary.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
            }
            
            function cmdPrintJournalXls(){	                       
                window.open("<%=printroot%>.report.RptSalesSummaryXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../../main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../../main/menusl.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                                                                                        <form name="frmsales" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                            
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Summary Sales Report<br>
                                                                                                                                </span></font></b></td>
                                                                                                                                <td width="40%" height="23"> 
                                                                                                                                    <%@ include file = "../../main/userpreview.jsp" %>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr > 
                                                                                                                                <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="3" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" nowrap>Date From</td>
                                                                                                                                            <td colspan="3" > 
                                                                                                                                                <input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" nowrap>Date To</td>
                                                                                                                                            <td colspan="3" > 
                                                                                                                                                <input name="invStartDateTo" value="<%=JSPFormater.formatDate((tanggalTo == null) ? new Date() : tanggalTo, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDateTo);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" height="33">&nbsp;</td>
                                                                                                                                            <td height="33" colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../../images/search2.gif',1)"><img src="../../images/search.gif" name="new2" border="0"></a>                                                                  </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" height="15">&nbsp;</td>
                                                                                                                                            <td width="33%" height="15">&nbsp;</td>
                                                                                                                                            <td width="8%" height="15">&nbsp;</td>
                                                                                                                                            <td width="49%" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4"><%@ include file ="transaksisum.jsp"%></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td class="boxed1"></td>
                                                                                                                                        </tr>
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" align="left" colspan="3" class="command"> 
                                                                                                                                    <span class="command"> 
                                                                                                                                </span> </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="97%">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                                                    </td>
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
            <%@ include file="../../main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

