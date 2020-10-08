
<%-- 
    Document   : srckonsumen
    Created on : Oct 22, 2013, 2:04:45 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %> 
<%@ include file = "../main/check.jsp" %>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            String formName = JSPRequestValue.requestString(request, "formName");
            String cashid = JSPRequestValue.requestString(request, "cashid");
            String jurnalname = JSPRequestValue.requestString(request, "jurnalname");

            String cstName = JSPRequestValue.requestString(request, "cst_name");

            Vector listCustomer = new Vector();

            String where = "";
            if (cstName != null && cstName.length() > 0) {
                where = DbCustomer.colNames[DbCustomer.COL_NAME] + " like '%" + cstName + "%'";
            }
            listCustomer = DbCustomer.list(0, 0, where, DbCustomer.colNames[DbCustomer.COL_NAME]);


%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <style type="text/css">
            <!--
            .style1 {color: #FF0000}
            -->
        </style>
        <script language="JavaScript">
            function cmdSelect(cstname,cstid){      
                self.opener.document.frmcashreceivedetail.cst_name.value = cstname;
                self.opener.document.frmcashreceivedetail.<%=JspCashReceive.colNames[JspCashReceive.JSP_CUSTOMER_ID]%>.value = cstid;                                 
                self.close();
            }
            
            function cmdSearch(){   
                document.frm_nomorjurnal.command.value="<%=JSPCommand.SEARCH%>";
                document.frm_nomorjurnal.action="srckonsumen.jsp";
                document.frm_nomorjurnal.submit();                
            }
           
            //-------------- script form image -------------------
            function cmdDelPict(oidCashReceiveDetail){
                document.frmimage.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="cashreceivedetail.jsp";
                document.frmimage.submit();
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
    <body> 
        <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
            <form name="frm_nomorjurnal" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">                
                <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_CUSTOMER_ID]%>" value="">
                <input type="hidden" name="formName" value="<%=formName%>">
               
                <tr>                    
                    <td colspan="2" >
                        <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">    
                            <tr >
                                <td height="10"></td>
                            </tr>
                            <tr >
                                <td>
                                    <table width="98%" height="500" align="center" style="border:1px solid #609836" cellspacing="0" cellpadding="0">                           
                                        <tr height="20">
                                            <td colspan="3">&nbsp;</td>                                
                                        </tr>
                                        <tr height="100%">
                                            <td width="10" class="tablecell">&nbsp;</td>                                
                                            <td  valign="top" >
                                                <table border="0" width="100%" cellpadding="0" cellspacing="0">                                                                                                                                        
                                                    <tr>                                                                                                                                            
                                                        <td> 
                                                            <table border="0" cellpadding="1" cellspacing="1" width="250">                                                                                                                                        
                                                                <tr>                                                                                                                                            
                                                                    <td class="tablecell1" > 
                                                                        <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1"> 
                                                                            <tr>
                                                                                <td colspan="3" height="8"></td>
                                                                            </tr>                                                                                
                                                                            <tr>
                                                                                <td width="5" class="fontarial"></td>
                                                                                <td width="80" class="fontarial">Name</td>
                                                                                <td>
                                                                                    <table border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <input type="text" name="cst_name" value="<%=cstName%>">&nbsp;
                                                                                            </td>
                                                                                        </tr>                                                    
                                                                                    </table>   
                                                                                </td>
                                                                            </tr>    
                                                                            <tr>
                                                                                <td colspan="3" height="10"></td>
                                                                            </tr> 
                                                                        </table>   
                                                                    </td>
                                                                </tr>                                                    
                                                            </table>   
                                                        </td>
                                                    </tr>
                                                    <tr>                                                        
                                                        <td><a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new1" width="59" height="21" border="0"></a></td>
                                                    </tr>
                                                    <tr>                                                        
                                                        <td class="page">&nbsp;</td>
                                                    </tr>
                                                    <%
            if (listCustomer != null && listCustomer.size() > 0) {
                                                    %>    
                                                    <tr>                                                        
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td >
                                                            <table width="100%" border=0 cellpadding="1" cellspacing="1">
                                                                <tr height="22">
                                                                    <td class="tablearialhdr" width="20%" >Kode</td>
                                                                    <td class="tablearialhdr" width="15%" >Name</td>
                                                                    <td class="tablearialhdr" width="15%" >Phone</td>                                                                    
                                                                    <td class="tablearialhdr" >Address</td>
                                                                    
                                                                </tr>    
                                                                <%
                                                        for (int i = 0; i < listCustomer.size(); i++) {

                                                            Customer cst = (Customer) listCustomer.get(i);

                                                            String style = "";
                                                            if (i % 2 == 0) {
                                                                style = "tablearialcell";
                                                            } else {
                                                                style = "tablearialcell1";
                                                            }
                                                                %>
                                                                <tr height="21">
                                                                    <td class="<%=style%>" align="center">
                                                                        <%
                                                                    out.println("<a style='color:blue' href=\"javascript:cmdSelect('" +cst.getName()+ "','" + cst.getOID() + "')\">" + cst.getCode()+ "</a>");
                                                                        %>
                                                                    </td>
                                                                    <td class="<%=style%>" align="left"><%=cst.getName() %></td>
                                                                    <td class="<%=style%>" align="left"><%=cst.getPhone()%></td>
                                                                    <td class="<%=style%>" align="left"><%=cst.getAddress1() %></td>
                                                                </tr> 
                                                                
                                                                <%
                                                        } 
                                                                %>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <%
                                                    } else {
                                                    %>
                                                    <tr>                                                        
                                                        <td class="fontarial"><i>Data tidak ditemukan...</i></td>
                                                    </tr>
                                                    <%}%>
                                                </table>
                                            </td>                                
                                            <td width="10" class="tablecell">&nbsp;</td>                                
                                        </tr>                            
                                    </table>
                                </td>                                
                            </tr>                            
                        </table>
                    </td>
                </tr>
            </form>           
        </table>
    </body>
</html>