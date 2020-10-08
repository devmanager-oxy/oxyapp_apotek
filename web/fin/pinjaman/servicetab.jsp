 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.coorp.services.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/checksp.jsp"%>
<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
ServiceManagerTabungan svt = new ServiceManagerTabungan();
switch (iJSPCommand){
	case  JSPCommand.START :
		try{
			svt.startWatcherTabungan();  //menghidupkan service presence analyser
		}
		catch(Exception e){
			System.out.println("exc when servicePresence.startService() : " + e.toString());
		}
		break;

	case  JSPCommand.STOP :
		try	{
			svt.stopWatcherTabungan();  //mematikan service
		}
		catch(Exception e){
			System.out.println("exc when servicePresence.stopService : " + e.toString());
		}
		break;
}	

boolean serviceRunning = svt.getStatus();

String stopSts="";
String startSts="";
if(serviceRunning){ 					
	startSts="disabled=\"true\"";
	stopSts="";
} 
else{
	startSts="";
	stopSts="disabled=\"true\"";
}

%>
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">    

function cmdStartSvc()
{
  document.formxx.command.value="<%=JSPCommand.START%>"; 
  document.formxx.start.value="0";  
  document.formxx.maxLog.value="0";  
  document.formxx.submit();  
}

function cmdStopSvc()
{
  document.formxx.command.value="<%=JSPCommand.STOP%>";  
  document.formxx.start.value="0";
  document.formxx.maxLog.value="0";  
  document.formxx.submit();  
}

<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.imagessp){ if(!d.MM_p) d.MM_p=new Array();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusp.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Setup</span> 
                        &raquo; <span class="level2">Service Manager<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="formxx" name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="start">
						  <input type="hidden" name="maxLog"><table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <input type="button" name="Button" value="Start Service"  <%=startSts%> onClick="javascript:cmdStartSvc()">
                                      <input type="submit" name="Submit2" value="Stop Service" <%=stopSts%> onClick="javascript:cmdStopSvc()">
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td height="13">&nbsp;</td>
                                  </tr>
								  <%if(serviceRunning){%> 
                                  <tr> 
                                    <td>Service status running, click &quot;Stop 
                                      Service&quot; button to stop.</td>
                                  </tr>
								  <%}else{%>
                                  <tr> 
                                    <td>Service status stop, click &quot;Start 
                                      Service&quot; button to run.</td>
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
            <%@ include file="../main/footersp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
