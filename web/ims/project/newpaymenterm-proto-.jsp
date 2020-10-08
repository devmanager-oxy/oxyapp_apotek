 
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


%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Cash 
                        </span> &raquo; <span class="level1">Petty Cash</span> 
                        &raquo; <span class="level2">Payment<br>
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
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                <td class="tab" nowrap>Journal 
                                                  Detail</td>
                                                
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                            	</td>
											    <td class="tabin">
												</td>
												<td nowrap class="tabheader"><font color="#FF0000">&nbsp;GL 
                                                  with no expense account, ( Non 
                                                  activity transaction )</font></td>
											    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000"> 
                                                  </font></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="100%" class="page"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td rowspan="2"  class="tablehdr" nowrap width="21%">Account 
                                                        - Description</td>
                                                      <td rowspan="2" class="tablehdr" width="19%">Department 
                                                      </td>
                                                      <td colspan="2" class="tablehdr">Currency</td>
                                                      <td rowspan="2" class="tablehdr" width="7%">Booked 
                                                        Rate</td>
                                                      <td rowspan="2" class="tablehdr" width="15%">Debet 
                                                        <%=baseCurrency.getCurrencyCode()%></td>
                                                      <td rowspan="2" class="tablehdr" width="15%">Credit 
                                                        <%=baseCurrency.getCurrencyCode()%> </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="4%" class="tablehdr">Code</td>
                                                      <td width="19%" class="tablehdr"> 
                                                        Amount</td>
                                                    </tr>
                                            
                                                    <tr> 
                                                      <td class="tablecell" width="21%"> 
                                             </td>
                                                      <td width="19%" class="tablecell"> 
                                                        
                                                      </td>
                                                      <td width="4%" class="tablecell"> 
                                                        
                                                      </td>
                                                      <td width="19%" class="tablecell" nowrap> 
                                                        
                                                      </td>
                                                      <td width="7%" class="tablecell"> 
                                                        
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                        
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                        
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="tablecell" nowrap width="21%" height="17">
													
														</td>
                                                      <td width="19%" class="tablecell" height="17" nowrap> 
                                                    
                                                      </td>
                                                      <td width="4%" class="tablecell" height="17"> 
                                                        <div align="center"> 
                                                    
                                                          </div>
                                                      </td>
                                                      <td width="19%" class="tablecell" height="17"> 
                                                        </td>
                                                      <td width="7%" class="tablecell" height="17"> 
                                                        </td>
                                                      <td width="15%" class="tablecell" height="17"> 
                                                        </td>
                                                      <td width="15%" class="tablecell" height="17"> 
                                                        </td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="tablecell" width="21%"> 
                                                    </td>
                                                      <td width="19%" class="tablecell"> 
                                                        
                                                          
                                                      </td>
                                                      <td width="4%" class="tablecell"> 
                                                        
                                                      </td>
                                                      <td width="19%" class="tablecell" nowrap> 
                                                        
                                                      </td>
                                                      <td width="7%" class="tablecell"> 
                                                        
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                        
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                        
                                                      </td>
                                                    </tr>
                                                    
                                                    <tr> 
                                                      <td class="tablecell" colspan="5" height="1"></td>
                                                      <td width="15%" class="tablecell" height="1"> 
                                                        <div align="right"></div>
                                                      </td>
                                                      <td width="15%" class="tablecell" height="1"> 
                                                        <div align="right"></div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="5"> 
                                                        <div align="right"><b>TOTAL 
                                                          : </b></div>
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                     
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                     
                                                      </td>
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
