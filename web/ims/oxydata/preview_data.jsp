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

<%	
String approot="/oxy-retail";
String imageroot ="/oxy-retail/";	
	
	TextLoader uploader = new TextLoader();
        FileOutputStream fOut = null;
	String str = "";
	
	boolean result = false;
	String uploadOut = "";

	uploadOut = "success!";	
    try {
        uploader.uploadText(config, request, response);
        Object obj = uploader.getTextFile("file");
        byte byteText[] = null;
        byteText = (byte[]) obj;
		str = new String(byteText);
		
		//out.println(str);
		
		if(str!=null && str.length()>0){
			//uploadOut = DataUploader.uplaodData(str);
			uploadOut = DataUploader.uplaodDataRetail(str);
			uploadOut = "Success!";
		}
		else{
			result = false;
			uploadOut = "No data to upload, file is empty or no file selected";
		}
		
    }
    catch (Exception e){
		uploadOut = "failed!";
		result = false;
		uploadOut = "Error, exception occure when try to upload\n"+e.toString();
        System.out.println("---======---\nError : " + e);
    }
     
			
	

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title><%=uploadOut%></title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
<!-- #EndEditable -->
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top">&nbsp;
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Data 
                        Synchronization</span> &raquo; <span class="level2">Upload 
                        Process<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frm_name" method="post" action="">
                          <input type="hidden" name="command" value="">
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
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
