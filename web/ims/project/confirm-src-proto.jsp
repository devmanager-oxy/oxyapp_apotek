 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//jsp content
int x = (request.getParameter("abc")==null) ? 0 : Integer.parseInt(request.getParameter("abc"));

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

function abc(){
	<%if(x==1){%>
		window.location="newproject-list-proto.jsp";
	<%}
	else if(x==2){%>
		window.location="installation-proto.jsp";
	<%}
	else{
	%>
		window.location="neworderconfirm-proto.jsp";
	<%}%>
}

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
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Project</span> 
                        &raquo; <span class="level2">Order Confirmation<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="17%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="66%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4"><b><i>Please search project 
                                      for order confirmation setup !</i></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="17%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="66%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">Customer</td>
                                    <td width="17%"> 
                                      <select name="select">
                                        <option selected>----- All ----</option>
                                        <option>C002 - Customer 2</option>
                                        <option>C003 - Customer 3</option>
                                      </select>
                                    </td>
                                    <td width="9%">Date Between</td>
                                    <td width="66%"> 
                                      <input type="text" name="textfield3">
                                      and 
                                      <input type="text" name="textfield4">
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">Project Name</td>
                                    <td width="17%"> 
                                      <input type="text" name="textfield">
                                    </td>
                                    <td width="9%">Project Status</td>
                                    <td width="66%"> 
                                      <select name="select2">
                                        <option selected>-- All --</option>
                                        <option>Draft</option>
                                        <option>Manufacturing</option>
                                        <option>Installation</option>
                                        <option>Closed</option>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">Project Number</td>
                                    <td width="17%"> 
                                      <input type="text" name="textfield2">
                                    </td>
                                    <td width="9%"><img src="../images/search.gif" width="59" height="21"></td>
                                    <td width="66%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="17%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="66%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" background="../images/line1.gif" height="3"></td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="17%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="66%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4">
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="13%" class="tablehdr" height="18">Start 
                                            Date</td>
                                          <td width="13%" class="tablehdr" height="18">Project 
                                            Number</td>
                                          <td width="18%" class="tablehdr" height="18">Project 
                                            Name</td>
                                          <td width="19%" class="tablehdr" height="18">Customer</td>
                                          <td width="24%" class="tablehdr" height="18">Address</td>
                                          <td width="13%" class="tablehdr" height="18">Status</td>
                                        </tr>
                                        <tr> 
                                          <td width="13%" class="tablecell1"> 
                                            <div align="center"><a href="javascript:abc()">20 
                                              October 2008</a></div>
                                          </td>
                                          <td width="13%" class="tablecell1"> 
                                            <div align="center">PPJ/PNCI/1008/0001</div>
                                          </td>
                                          <td width="18%" class="tablecell1">Bio 
                                            Save Tabanan Asri</td>
                                          <td width="19%" class="tablecell1">Pemda 
                                            Tabanan </td>
                                          <td width="24%" class="tablecell1">Jln. 
                                            ... </td>
                                          <td width="13%" class="tablecell1"> 
                                            <div align="center">Draft</div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="13%" class="tablecell"> 
                                            <div align="center"><a href="javascript:abc()">10 
                                              September 2008</a></div>
                                          </td>
                                          <td width="13%" class="tablecell"> 
                                            <div align="center">PPJ/PNCI/0908/001</div>
                                          </td>
                                          <td width="18%" class="tablecell">Bio 
                                            Save ....</td>
                                          <td width="19%" class="tablecell">Ronald 
                                            Deboer </td>
                                          <td width="24%" class="tablecell">&nbsp;</td>
                                          <td width="13%" class="tablecell"> 
                                            <div align="center"></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="13%" class="tablecell1"> 
                                            <div align="center">.....</div>
                                          </td>
                                          <td width="13%" class="tablecell1"> 
                                            <div align="center"></div>
                                          </td>
                                          <td width="18%" class="tablecell1">&nbsp;</td>
                                          <td width="19%" class="tablecell1">&nbsp;</td>
                                          <td width="24%" class="tablecell1">&nbsp;</td>
                                          <td width="13%" class="tablecell1"> 
                                            <div align="center"></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="13%" class="tablecell"> 
                                            <div align="center"></div>
                                          </td>
                                          <td width="13%" class="tablecell"> 
                                            <div align="center"></div>
                                          </td>
                                          <td width="18%" class="tablecell">&nbsp;</td>
                                          <td width="19%" class="tablecell">&nbsp;</td>
                                          <td width="24%" class="tablecell">&nbsp;</td>
                                          <td width="13%" class="tablecell"> 
                                            <div align="center"></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="13%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="18%">&nbsp;</td>
                                          <td width="19%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="13%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="18%">&nbsp;</td>
                                          <td width="19%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="13%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="18%">&nbsp;</td>
                                          <td width="19%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="13%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="18%">&nbsp;</td>
                                          <td width="19%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="13%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="18%">&nbsp;</td>
                                          <td width="19%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="17%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="66%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="17%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="66%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="17%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="66%">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
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
