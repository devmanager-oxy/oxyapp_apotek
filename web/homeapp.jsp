
<% ((HttpServletResponse) response).addCookie(new Cookie("JSESSIONID", session.getId()));%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.system.*" %>
<%@ include file="javainit-root.jsp"%>
<%@ include file="check-root.jsp"%>
<%          
            session.putValue("APP_LANG", "2");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Oxysystem Home Page</title>
        <script type="text/javascript">
            <!--
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
        <style type="text/css">
            body{
                margin:0;
                padding:0;
            }
            td{
                font-family:Tahoma, Arial, Helvetica, sans-serif;
                font-size:11px;
            }
        </style>
    </head>
    <script language="JavaScript">
        function cmdEnterApp(idx){
            document.formhome.login_id.value="<%=user.getLoginId()%>";
            document.formhome.pass_wd.value="<%=user.getPassword()%>";            
            document.formhome.command.value="1";
            
            if(parseInt(idx)==1){
                window.location="fin/home.jsp";
            }            
            if(parseInt(idx)==2){
                window.location="ims/home.jsp?command=1";
            }
            if(parseInt(idx)==3){
                window.location="sales/homesl.jsp?user_key=<%=user.getUserKey()%>&command=1";
            }
            if(parseInt(idx)==4){
                window.location="prop/homesl.jsp?user_key=<%=user.getUserKey()%>&command=1";
            }
        }
    </script>
    <body onLoad="MM_preloadImages('general/imagesapp/finance2.gif','general/imagesapp/inventory2.gif','general/imagesapp/sales2.gif','general/imagesapp/pengadaan2.gif','general/imagesapp/simpanpinjam2.gif')">
        <form name="formhome" method="post" action="">
            <input type="hidden" name="login_id">
            <input type="hidden" name="pass_wd">
            <input type="hidden" name="command"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                <tr>
                    <td height="89"> 
                        <table width="555" border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                                <td height="70"> 
                                    <div align="center"><font size="+3" face="Courier New, Courier, mono"><b><font face="Berlin Sans FB Demi" color="#DF8600" size="+2">Oxysystem Back Office<br><%=sysCompany.getName().toUpperCase()%>
                                    </font></b></font></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center"><img src="general/imagesapp/selamatdatang.gif"  /></td>
                </tr>
                <tr>
                    <td height="100%" align="center" valign="middle">
                        <table width="360" border="0" align="center">
                            <tr>
                                <td width="180">
                                    <div align="center"><a href="javascript:cmdEnterApp('1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('finance','','general/imagesapp/finance2.gif',1)"><img src="general/imagesapp/finance1.gif" name="finance" width="180" height="180" border="0"></a></div>
                                </td>
                                <td width="180">
                                    <div align="center"><a href="javascript:cmdEnterApp('2')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('inventory','','general/imagesapp/inventory2.gif',1)"><img src="general/imagesapp/inventory1.gif" name="inventory" width="180" height="180" border="0"></a></div>
                                </td>
                            </tr>                            
                        </table>
                        <table width="100" border="0">
                            <tr>
                                <td width="180"><a href="javascript:cmdEnterApp('3')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sales','','general/imagesapp/sales2.gif',1)"><img src="general/imagesapp/sales1.gif" name="sales" width="180" height="180" border="0"></a></td>                                
                                <!--td width="180"><a href="javascript:cmdEnterApp('4')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('property','','general/imagesapp/property2.gif',1)"><img src="general/imagesapp/property1.gif" name="property" width="180" height="180" border="0"></a></td-->
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center" style="padding-top:25px"><img src="general/imagesapp/home-line.gif" width="796" height="2" /></td>
                </tr>
                <tr>
                    <td height="30px" align="center" valign="top" style="color:#a35916">Copyright 
                    © 2011 OxySystem, All Rights Reserved<br>Website : <a href="http://www.oxysystem.com" target="blank">www.oxysystem.com</a>, Email : <a href="mailto:info@oxysystem.com">info@oxysystem.com</a><br></td>
                </tr>
                <tr>
                    <td align="center" style="padding-top:25px"><img src="general/imagesapp/home-line.gif" width="796" height="2" /></td>
                </tr>
                
            </table>
        </form>
    </body>
</html>