 
<%@ page language="java" %>
<%@ page import ="java.util.*" %>

<%@ include file = "../main/javainit.jsp" %>
<%@ page import = "com.dimata.hanoman.entity.admin.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_ADMIN, AppObjInfo.G2_ADMIN_USER, AppObjInfo.OBJ_ADMIN_USER_USER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%
boolean running = false;

%>
<!-- JSP Block -->
<!-- End of JSP Block -->
<script language="JavaScript">
function cmdStop(){
      document.serviceManager.command.value="11";
	  //document.serviceManager.startRow.value="0";
	 // document.serviceManager.maxLog.value="0";  
	  document.serviceManager.submit();
	  
  }
  
  function cmdStart(){
  	 // document.serviceManager.startRow.value="0";
	 // document.serviceManager.maxLog.value="0";
      document.serviceManager.command.value="10";	  
	  document.serviceManager.submit();
  }
  
  function cmdUpdate(){
  	  alert("Attention...\nThe change will not take effect until you restart the BackUp Service Manager!\n\t-If the service is running, please stop and then start again.\n\t-If the service is stopped, just start the service.");
      document.serviceManager.command.value="<%= 12 %>";
	  //document.serviceManager.startRow.value="0";
	  //document.serviceManager.maxLog.value="0";
	  document.serviceManager.submit();
  } 
  function cmdListLog(){
      document.serviceManager.command.value="<%= 13%>";
	  //document.serviceManager.startRow.value="0";
	  //document.serviceManager.maxLog.value="0";
	  document.serviceManager.submit();
  }  
  function cmdClearLog(){
  	  if(confirm("Are you sure you want to delete all existing log?\nWarning...\nThis can not be undone!!!")){
		  document.serviceManager.command.value="14";
		  document.serviceManager.submit();
	  }
  } 

</script>
<html><!-- #BeginTemplate "/Templates/admin.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Prochain - Service</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td colspan="2" background="<%=approot%>/image/bg2.jpg" height=59> 
      <img  height="60" src="<%=approot%>/image/main2.jpg">
    </td>
  </tr>
  <tr> 
    <td colspan="2" class="topmenu" height="20">       
      <!-- #BeginEditable "menu_main" --> 
      <%@ include file = "../main/menumain.jsp" %>
      <!-- #EndEditable --> </td>
  </tr>
  <tr> 
    <td width="200" valign="top" align="left" >
      
      <!-- #BeginEditable "menu_purchasing" --> 
      <%@ include file = "../main/menuadmin.jsp" %>
      <!-- #EndEditable --> 
    </td>
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" -->System 
            &gt; Back Up Service Manager<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --><form name="serviceManager" method="post" action="">
		  <input type="hidden" name="command" value ="">
              <table width="100%">
                <tr> 
                  <td height="13"> 
                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                      <tr> 
                        <td colspan="3"> 
                          <hr>
                        </td>
                      </tr>
                      <tr> 
                        <td width="8%"><b>Status</b></td>
                        <td colspan="2"> 
                          <% if(running){%>
                          <font color="#009900">Running...</font> 
                          <%}else{%>
                          <font color="#FF0000">Stopped</font> 
                          <%}%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="8%">&nbsp;</td>
                        <td colspan="2"> 
                          <% String stopSts="";
					   String startSts="";
					if(running){
					   startSts="disabled=\"true\"";
					   stopSts="";
					}else{
					   startSts="";
					   stopSts="disabled=\"true\"";
					}%>
                          <%//if(hasExecutePriv){%>
                          <input type="button" name="Button" value="  Start  " onClick="javascript:cmdStart()" class="formElemen" <%=startSts%>>
                          <input type="button" name="Submit2" value="  Stop  " onClick="javascript:cmdStop()" class="formElemen" <%=stopSts%>>
                          <%//}%>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <hr>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan="2"><b>Configurations</b></td>
                        <td width="78%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="8%">&nbsp;</td>
                        <td width="14%" nowrap>Start Time</td>
                        <%Date dt=new Date();%>
                        <td width="78%"> 
                          <%//=WP_ControlDate.drawTime("startTime",svcMan.getStartTime(),"formElemen")%>
                          <select name="select">
                            <%for(int i=1; i<25; i++){%>
                            <option><%=i%></option>
                            <%}%>
                          </select>
                          <select name="select2">
                            <%for(int i=1; i<61; i++){%>
                            <option><%=i%></option>
                            <%}%>
                          </select>
                        </td>
                      </tr>
                      <tr> 
                        <td width="8%">&nbsp;</td>
                        <td width="14%" nowrap>Periode</td>
                        <td width="78%"> 
                          <input type="text" name="periode" size="10" class="formElemen" value="10">
                          (in Minutes)</td>
                      </tr>
                      <tr> 
                        <td width="8%">&nbsp;</td>
                        <td width="14%" nowrap>Source Path</td>
                        <td width="78%" nowrap> 
                          <input type="text" name="source" size="40" class="formElemen" value="C:/hanoman/db">
                          *(database directory)</td>
                      </tr>
                      <tr> 
                        <td width="8%">&nbsp;</td>
                        <td width="14%" nowrap>Target 1</td>
                        <td width="78%" nowrap> 
                          <input type="text" name="target1" size="60" class="formElemen" value="E:/backup/hanoman/db">
                          * </td>
                      </tr>
                      <tr> 
                        <td width="8%">&nbsp;</td>
                        <td width="14%" nowrap>Tartget 2</td>
                        <td width="78%" nowrap> 
                          <input type="text" name="target2" size="60" class="formElemen">
                        </td>
                      </tr>
                      <tr> 
                        <td width="8%">&nbsp;</td>
                        <td colspan="2"><font color="#FF0000">note :</font> <font color="#CC0000">use 
                          slash( &quot;/&quot; ) as path separator</font></td>
                      </tr>
                      <tr> 
                        <td width="8%">&nbsp;</td>
                        <td colspan="2"> 
                          <%//if(hasUpdatePriv){%>
                          <input type="button" name="Button2" value="Update Configurations" class="formElemen" onClick="cmdUpdate()">
                          <%//}%>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <hr>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan="2"><b>Log</b></td>
                        <td width="78%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="8%">&nbsp;</td>
                        <td colspan="2"> 
                          <input type="button" name="Button2" value="List log" onClick="cmdListLog()" class="formElemen">
                          <input type="button" name="Submit3" value="Clear Log" onClick="cmdClearLog()" class="formElemen">
                        </td>
                      </tr>
                      <tr> 
                        <td colspan="3"> </td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <table width="64%" border="0" cellspacing="1" cellpadding="1" class="listgen">
                            <tr> 
                              <td width="8%" class="listgentitle">No</td>
                              <td width="13%" class="listgentitle">Date</td>
                              <td width="10%" class="listgentitle"> Time</td>
                              <td width="42%" class="listgentitle">Target 1</td>
                              <td width="27%" class="listgentitle">Target 2</td>
                            </tr>
                            <tr> 
                              <td width="8%" class="listgensell" valign="top">1</td>
                              <td width="13%" class="listgensell" valign="top"> 
                                06/02-2002 </td>
                              <td width="10%" class="listgensell" valign="top">10:56:8</td>
                              <td width="42%" class="listgensell"> E:/backup/hanoman/db, 
                                status:Unable to locate source directory..., please 
                                check source path directory !!! </td>
                              <td width="27%" class="listgensell" valign="top">Target2 
                                directory has not been set yet..</td>
                            </tr>
                            <tr> 
                              <td width="8%" class="listgensell" valign="top">2</td>
                              <td width="13%" class="listgensell" valign="top"> 
                                07/02-2002 </td>
                              <td width="10%" class="listgensell" valign="top">10:56:8</td>
                              <td width="42%" class="listgensell"> E:/backup/hanoman/db, 
                                status:Unable to locate source directory..., please 
                                check source path directory !!! </td>
                              <td width="27%" class="listgensell" valign="top">Target2 
                                directory has not been set yet..</td>
                            </tr>
                            <tr> 
                              <td width="8%" class="listgensell" valign="top">3</td>
                              <td width="13%" class="listgensell" valign="top"> 
                                08/02-2002 </td>
                              <td width="10%" class="listgensell" valign="top">10:56:8</td>
                              <td width="42%" class="listgensell"> E:/backup/hanoman/db, 
                                status:Unable to locate source directory..., please 
                                check source path directory !!! </td>
                              <td width="27%" class="listgensell" valign="top">Target2 
                                directory has not been set yet..</td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan="3" align="right" class="command"> <a href="#">&lt;&lt;</a> 
                          |<a href="#"> &gt;&gt;</a></td>
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
</form>
<!-- #EndEditable --></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="20" class="footer"> 
      <div align="center"> copyright Bali Information Technologies 2002</div>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>

