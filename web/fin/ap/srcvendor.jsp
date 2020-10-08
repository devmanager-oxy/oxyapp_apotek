
<%-- 
    Document   : srcvendor
    Created on : Nov 7, 2012, 2:31:53 PM
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
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            String formName = JSPRequestValue.requestString(request, "formName");
            String vendorId = JSPRequestValue.requestString(request, "vendorId");
            String txtVendor = JSPRequestValue.requestString(request, "txtvendor");
            String nameVendor = JSPRequestValue.requestString(request, "namevendor");

            Vector listVendor = new Vector();

            if (iJSPCommand == JSPCommand.SEARCH){
                String where = "";
                if (nameVendor != null && nameVendor.length() > 0) {
                    where = DbVendor.colNames[DbVendor.COL_NAME] + " like '%" + nameVendor + "%'";
                }
                listVendor = DbVendor.list(0, 0, where, DbVendor.colNames[DbVendor.COL_NAME]);
            }
            
            
            String[] langAR = {"Suplier Name","No","Code","Name","Address","Data not found","Click search to searching data"}; //0 - 6

            String[] langNav = {};

            if (lang == LANG_ID) {
                String[] langID = {"Nama Suplier","No","Kode","Nama","Alamat","Data tidak ditemukan","Klik search untuk melakukan pencarian"};
                langAR = langID;

                String[] navID = {};
                langNav = navID;
            }

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
            function cmdSelect(vendor,vendorOid){      
                self.opener.document.frmarapmemo.txt_vendor.value = vendor;
                self.opener.document.frmarapmemo.JSP_VENDOR_ID.value = vendorOid;                                 
                self.opener.document.frmarapmemo.command.value="<%=JSPCommand.REFRESH%>"; 
                //self.opener.document.frmarapmemo.submit(); 
                self.close();
            }
            
            function cmdSearch(){           
                document.frmvendor.command.value="<%=JSPCommand.SEARCH%>";
                document.frmvendor.action="srcvendor.jsp";
                document.frmvendor.submit();
            
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
        <table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
            <form name="frmvendor" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>"> 
                <input type="hidden" name="txt_vendor" value=""> 
                <input type="hidden" name="JSP_VENDOR_ID" value="0"> 
                <tr>
                    <td width="5px">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td width="5px">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td width="15%"><font size="1"><%=langAR[0]%></font></td>
                    <td>
                        <table>
                            <tr>
                                <td>
                                    <input type="text" name="namevendor" value="<%=nameVendor%>">&nbsp;
                                </td>
                                <td>
                                    <a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new1" width="59" height="21" border="0"></a>
                                </td>
                            </tr>                            
                        </table>   
                    </td>
                </tr>                  
                <tr>
                    <td width="5px">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td background="../images/line.gif"><img src="../images/line.gif"></td></tr></table></td>
                </tr>  
                <%
            if (listVendor != null && listVendor.size() > 0) {
                %>    
                <tr>
                    <td width="5px">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan=2>
                        <table width="100%" border=0 cellpadding="1" cellspacing="1">
                            <tr>
                                <td class="tablehdr" width="3%" ><font size="1"><%=langAR[1]%></font></td>
                                <td class="tablehdr" width="20%" ><font size="1"><%=langAR[2]%></font></td>
                                <td class="tablehdr" width="20%" ><font size="1"><%=langAR[3]%></font></td>
                                <td class="tablehdr" width="57%" ><font size="1"><%=langAR[4]%></font></td>
                            </tr>    
                            <%
                    for (int i = 0; i < listVendor.size(); i++) {

                        Vendor vendor = (Vendor) listVendor.get(i);

                        
                            %>
                            <tr>
                                <td class="tablecell" align="center">&nbsp;<font size="1"><%=i+1%></font></td>
                                <td class="tablecell" align="center"><font size="1">
                                    <%
                                    out.println("<a style='color:blue' href=\"javascript:cmdSelect('" + vendor.getName() + "','" + vendor.getOID() + "')\">" + vendor.getCode() + "</a>");
                                    %>
                                </font>    
                                </td>
                                <td class="tablecell" align="left">&nbsp;<font size="1"><%=vendor.getName()%></font></td>
                                <td class="tablecell" align="left">&nbsp;<font size="1"><%=vendor.getAddress()%></font></td>
                            </tr> 
                            <%
                    } 
                            %>
                        </table>
                    </td>
                </tr>
                <%
            }else{
                %>        
                <%if(iJSPCommand == JSPCommand.SEARCH){%>
                <tr>
                    <td colspan="2" height="5"></td>
                </tr>    
                <tr>
                    <td colspan="2" class="tablecell">
                        <font size="1"><%=langAR[5]%></font>
                    </td>
                </tr>
                <%}%>  
                
                <%}%>
                
                <%if(iJSPCommand == JSPCommand.NONE){%>
                <tr>
                    <td colspan="2" height="5"></td>
                </tr>    
                <tr>
                    <td colspan="2" class="tablecell">
                        <font size="1"><%=langAR[6]%></font>
                    </td>
                </tr>
                <%}%>  
            </form>
            <tr height = "40px">
                <td>&nbsp</td>
            </tr>
        </table>
    </body>
</html>
