 
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
//boolean datasyncPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC);
%>
<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);

//Vector temp = DbPeriode.list(0,0, "", "start_date desc");

if(iJSPCommand==JSPCommand.SUBMIT){
	//if(temp!=null && temp.size()>2){
		
		Date dt = new Date();
		dt.setMonth(dt.getMonth()-2);
		dt.setDate(1);
		
		System.out.println("******* - maintain logs deleting transaction date before : "+dt);
		
		//Periode p1 = (Periode)temp.get(0);
		//Periode p2 = (Periode)temp.get(1);
		//Date dt = new Date();
		//dt.setMonth(dt.getMonth()-2);
		//dt.setDate(1);
		String sql = "delete from logs where date <'"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'";//periode_id<>"+p1.getOID()+" and periode_id<>"+p2.getOID();
		//out.println(sql);
		try{
			CONHandler.execUpdate(sql);	
		}
		catch(Exception e){
			System.out.println(e.toString());
		}
	//}
}


/*** LANG ***/
String[] langAT = {"WARNING", "This action will delete logs data in 2 months ago backward.", "Be carefull", "this action is not recoverable", "Execute Process", "Execution process done successfully."};

String[] langNav = {"Data Synchronization", "Backup", "Maintenance"};

if (lang == LANG_ID) {
	String[] langID = {"PERHATIAN", "Aksi ini akan menghapus logs data 2 bulan lalu kebelakang.", "Hati-hati", "aksi ini tidak bisa dibatalkan", "Jalankan Proses", "Proses sudah selesai."};
	langAT = langID;

	String[] navID = {"Data Singkronisasi", "Backup", "Perawatan Data"};
	langNav = navID;
}

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<%if(!datasyncPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>
function cmdMaintain(){
	document.form1.command.value="<%=JSPCommand.SUBMIT%>";
	document.form1.action="maintain.jsp";
	document.form1.submit();
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
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><%
            String navigator = "<font class=\"lvl1\">" + langNav[0]+"</font><font class=\"level2\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[2] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td>&nbsp; </td>
                            </tr>
                            <tr> 
                              <td class="container">
							 
							   <%if(iJSPCommand!=JSPCommand.SUBMIT){%>
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td><font color="#FF0000"><b><%=langAT[0]%> !!</b></font></td>
                                  </tr>
                                  <tr> 
                                    <td><font color="#000000"><%=langAT[1]%></font></td>
                                  </tr>
                                  <tr> 
                                    <td><font color="#000000"><%=langAT[2]%></font><font color="#000099">, 
                                      <font color="#FF0000"><%=langAT[3]%> !! </font></font></td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>
                                      <input type="button" name="Button" value="<%=langAT[4]%>" onClick="javascript:cmdMaintain()">
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
								<%}else{%>
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr>
                                    <td><%=langAT[5]%></td>
                                  </tr>
                                  <tr>
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
								<%}%>
								
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
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
            <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
