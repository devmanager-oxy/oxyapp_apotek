
<%-- 
    Document   : menuservice
    Created on : Dec 1, 2011, 10:51:55 AM
    Author     : Roy Andika
--%>

<%
            menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
%>
<script language="JavaScript">
    
    function cmdChangeMenu(idx){
        var x = idx;
        
        switch(parseInt(idx)){ 
            
            case 1 :             
                document.all.service1.style.display="none";
                document.all.service2.style.display="";
                document.all.service.style.display="";
                break;	
            
            case 0 :
                document.all.service1.style.display="";
                document.all.service2.style.display="none";
                document.all.service.style.display="none";
                break;
            
        }
    }
    
    </script>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td valign="top" height="32"><img src="<%=approot%>/images/logo-finance2.jpg" width="216" height="32" /></td>
                </tr>
                <tr> 
                    <td><img src="<%=approot%>/images/spacer.gif" width="1" height="5"></td>
                </tr>
                <tr> 
                    <td style="padding-left:10px" valign="top" height="1"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td><img src="<%=approot%>/images/spacer.gif" width="1" height="1" /></td>
                            </tr>
                            <tr> 
                                <td>&nbsp;</td>
                            </tr>
                            <tr id="service1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Service</a></td>
                            </tr>
                            <tr id="service2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Service</span></a></td>
                            </tr>
                            <tr id="service"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <tr> 
                                            <td class="menu1"><a href="">Service</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <tr> 
                                <td class="menu0"><a href="<%=approot%>/logout.jsp">Logout</a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <tr> 
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td height="100%">&nbsp;</td>
                </tr>
                <tr> 
                    <td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<script language="JavaScript">
    cmdChangeMenu('<%=menuIdx%>');
        </script>
