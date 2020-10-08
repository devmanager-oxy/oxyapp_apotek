<%-- 
    Document   : preview_data
    Created on : Jun 28, 2011, 4:23:17 PM
    Author     : ngurah
--%>

<%@ page language="JAVA"%>
<%@ page import="java.io.*"%>
<%@ page import="java.lang.System"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.util.blob.TextLoader" %>
<%@ page import="com.project.datasync.*" %>
<%@ page import="com.project.fms.transaction.*" %>
<%//@ page import="com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
//boolean datasyncPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC);
%>
<%	
	
	
	if(session.getValue("MENU_IDX")!=null){    
		menuIdx = Integer.parseInt((String)session.getValue("MENU_IDX"));
	}
	
	//out.println(menuIdx);

	TextLoader uploader = new TextLoader();
        FileOutputStream fOut = null;
	String str = "";
	
	boolean result = false;
	String uploadOut = "";
	
    try {
        uploader.uploadText(config, request, response);
        Object obj = uploader.getTextFile("file");
        byte byteText[] = null;
        byteText = (byte[]) obj;
		str = new String(byteText);
		//out.println(str);
		if(str!=null && str.length()>0){
			//out.println("<br>in meeeee .....");
                        DataSalesUploader dataSalesUpload = new DataSalesUploader();
			uploadOut = dataSalesUpload.uplaodData(str);
			//DbGl.synchGLPeriodId();
			//DbTransactionActivityDetail.synchActivityPeriodId();
		}
		else{
			result = false;
			uploadOut = "No data to upload, file is empty or no file selected";
		}
		
    }
    catch (Exception e) {
		result = false;
		uploadOut = "Error, exception occure when try to upload\n"+e.toString();
        System.out.println("---======---\nError : " + e);
    }
	
	

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Finance System</title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<%if(!datasyncPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>
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
           <%@ include file="../main/hmenusl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Data 
                        Synchronization</span> &raquo; <span class="level2">Upload 
                        Process<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frm_name" method="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="container">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="container"><%=uploadOut%></td>
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
            <%@ include file="../main/footersl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>

