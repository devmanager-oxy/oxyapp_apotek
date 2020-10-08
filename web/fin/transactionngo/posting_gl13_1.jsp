
<%-- 
    Document   : posting_gl13
    Created on : Sep 5, 2011, 3:26:13 PM
    Author     : Roy Andika
--%>

<%@ page language="java"%>
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL13);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL13, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL13, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL13, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL13, AppMenu.PRIV_DELETE);

%>
<!-- Jsp Block -->
<%@ include file="../calendar/calendarframe.jsp"%>

<%

            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");

            Vector list = DbGl.getGL13Posted();

            if (iCommand == JSPCommand.POST) {

                if (list != null && list.size() > 0) {

                    for (int i = 0; i < list.size(); i++) {

                        Gl gl = (Gl) list.get(i);

                        if (JSPRequestValue.requestInt(request, "check_" + gl.getOID()) == 1) {

                            DbGl.updateStatusPosting(gl, user.getOID());

                        }
                    }
                }
                list = DbGl.getGL13Posted();
            }

            String[] langCT = {"Journal Number", "Transaction Date", "Receipt to Account", "Currency", "Memo", "Posting", "Code", "Summary", "Data not found", "Journal has been posted successfully.","Debet","Credit"};

            String[] langNav = {"Journal 13", "Post Jurnal", "Search for", "Journal 13", "Journal Reversal"};

            if (lang == LANG_ID) {

                String[] langID = {"Nomor Jurnal", "Tgl. Transaksi", "Perkiraan Penerimaan", "Mata Uang", "Memo", "Posting", "Code", "Jumlah", "Transaksi Bank", "Post Jurnal", "Data tidak ditemukan", "Jurnal sukses di posting","Debet","Credit"};
                langCT = langID;

                String[] navID = {"Jurnal 13", "Post Jurnal", "Pencarian", "Jurnal 13", "Jurnal Reversal"};
                langNav = navID;

            }
            
            Vector result = new Vector();
            
            result = DbExchangeRate.listAll();
            
            String idr = "";            
            
            if(result != null && result.size() > 0){
                ExchangeRate exchangeRate = new ExchangeRate();
                exchangeRate = (ExchangeRate)result.get(0);
                try{
                    Currency curr= DbCurrency.fetchExc(exchangeRate.getCurrencyIdrId());
                    idr = curr.getCurrencyCode();
                }catch(Exception e){}        
            }
            
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" -->
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <!--Begin Region JavaScript-->
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>        
            
            function cmdSearch(){            
                document.frmposgl.command.value="<%=JSPCommand.SAVE%>";
                document.frmposgl.prev_command.value="<%=prevCommand%>";
                document.frmposgl.action="posting_gl13.jsp";
                document.frmposgl.submit();
            }
            
            function cmdPost(){            	
                document.frmposgl.command.value="<%=JSPCommand.POST%>";
                document.frmposgl.prev_command.value="<%=prevCommand%>";
                document.frmposgl.action="posting_gl13.jsp";
                document.frmposgl.submit();
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
        <!--End Region JavaScript-->
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/savedoc2.gif','../images/post_journal2.gif')">
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
                                            <!-- #BeginEditable "menu" --><%@ include file="../main/menu.jsp"%>
                <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                        <%
            String navigator = "&nbsp;&nbsp;&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                        %>
                        <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmposgl" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                        
                                                                            <%
            if (list != null && list.size() > 0) {
                                                                            %>                                                               
                                                                            <tr> 
                                                                                <td>                                                                                    
                                                                                    <table width="90%" border="0" cellpadding="1" cellspacing="1">
                                                                                        <tr>
                                                                                            <td width="10%" class="tablehdr"><%=langCT[0]%></td>
                                                                                            <td width="10%" class="tablehdr"><%=langCT[1]%></td>                                                                                            
                                                                                            <td width="10%"  class="tablehdr"><%=langCT[3]%></td>                                                                                            
                                                                                            <td width="15%"  class="tablehdr"><%=langCT[12]%></td>
                                                                                            <td width="15%"  class="tablehdr"><%=langCT[13]%></td>
                                                                                            <td width="35%" class="tablehdr"><%=langCT[4]%></td>
                                                                                            <td width="5%"  class="tablehdr"><%=langCT[5]%></td>
                                                                                        </tr>                                                        
                                                                                        <%
                                                                                for (int i = 0; i < list.size(); i++){

                                                                                    Gl gl = (Gl) list.get(i);
                                                                                    
                                                                                    GlDetail glDet = DbGl.sumGlDetail(gl.getOID());

                                                                                        %>
                                                                                        <%if (i % 2 != 0) {%>
                                                                                        <tr>
                                                                                            <td class="tablecell" align="center"><%=gl.getJournalNumber()%></td>
                                                                                            <td class="tablecell" align="center"><%=JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy")%></td>   
                                                                                            <td class="tablecell" ><div align="center"><%=idr%></div></td>
                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(glDet.getDebet(), "#,###.##")%></td>
                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(glDet.getCredit(), "#,###.##")%></td>
                                                                                            <td class="tablecell" align="left"><%=gl.getMemo()%></td>
                                                                                            <td class="tablecell" align="center"><input type="checkbox" name="check_<%=gl.getOID()%>" value="1"></td>
                                                                                        </tr>                                                        
                                                                                        <%
} else {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td class="tablecell1" align="center"><%=gl.getJournalNumber()%></td>
                                                                                            <td class="tablecell1" align="center"><%=JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy")%></td>                                                                                                                                                                                   
                                                                                            <td class="tablecell1" ><div align="center"><%=idr%></div></td>
                                                                                            <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(glDet.getDebet(), "#,###.##")%></td>
                                                                                            <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(glDet.getCredit(), "#,###.##")%></td>
                                                                                            <td class="tablecell1" align="left"><%=gl.getMemo()%></td>
                                                                                            <td class="tablecell1" align="center"><input type="checkbox" name="check_<%=gl.getOID()%>" value="1"></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            } 
                                                                                        %>
                                                                                        <%
                                                                                }
                                                                                        %>
                                                                                    </table>
                                                                                    
                                                                                </td>
                                                                            </tr>
                                                                            <%
                                                                                if (iCommand == JSPCommand.POST) {
                                                                            %>
                                                                            <tr>
                                                                                <td height="40px;">
                                                                                    <div align="left" class="msgnextaction"> 
                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                                                                                            <tr> 
                                                                                                <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                <td width="180"><%=langCT[11]%></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr>
                                                                                <td height="20px;">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr>
                                                                                <td class="container">
                                                                                    <%if (privUpdate || privAdd) {%>
                                                                                    <a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a>
                                                                                    <%}%>
                                                                                </td>                                     
                                                                            </tr>    
                                                                            <tr>
                                                                                <td height="40px;">&nbsp;</td>
                                                                            </tr>    
                                                                            <% } else {%>
                                                                            <%if (iCommand == JSPCommand.POST) {%>
                                                                            <tr>
                                                                                <td height="40px;">
                                                                                    <div align="left" class="msgnextaction"> 
                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                                                                                            <tr> 
                                                                                                <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                <td width="180"><%=langCT[11]%></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr> 
                                                                            <%} else {%>
                                                                            <tr>
                                                                                <td height="40px;"><%=langCT[10]%></td>
                                                                            </tr> 
                                                                            <%}%>
                                                                            <%}%>
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
                                <!-- #BeginEditable "footer" --><%@ include file="../main/footer.jsp"%><!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
