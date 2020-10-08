<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.system.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
    int iCommand = JSPRequestValue.requestCommand(request);
    long lOid = JSPRequestValue.requestLong(request, "oid");
    //System.out.println("lOid " + lOid);

    CmdSystemProperty cmdSystemProperty = new CmdSystemProperty(request);
    cmdSystemProperty.action(iCommand, lOid);

    SystemProperty sysProp = cmdSystemProperty.getSystemProperty();
    JspSystemProperty jspSystemProperty = cmdSystemProperty.getForm();
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=titleIS%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language=javascript>

<%if(!adminPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

    function cmdSave() {
	  document.jspData.command.value="<%= JSPCommand.SAVE %>";          
          document.jspData.oid.value = "<%= lOid %>";
          document.jspData.action = "syspropnew.jsp";
	  document.jspData.submit();
    }

    function cmdEdit() {
	  document.jspData.command.value="<%= JSPCommand.EDIT %>";          
          document.jspData.oid.value = "<%= lOid %>";
          document.jspData.action = "syspropnew.jsp";
	  document.jspData.submit();
    }
	
	function cmdAdd() {
	  document.jspData.command.value="<%= JSPCommand.ADD %>";          
          document.jspData.oid.value = "0";
          document.jspData.action = "syspropnew.jsp";
	  document.jspData.submit();
    }

    function cmdBack() {
          document.jspData.action = "sysprop.jsp";
	  document.jspData.submit();
    }

    function cmdAsk() {
          document.jspData.command.value="<%= JSPCommand.ASK %>";          
          document.jspData.action = "syspropnew.jsp";
	  document.jspData.submit();
    }

    function cmdDelete() {
          document.jspData.command.value="<%= JSPCommand.DELETE %>";          
          document.jspData.action = "sysprop.jsp";
	  document.jspData.submit();
    }

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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="jspData" method="post" action="">
                          <input type="hidden" name="command" value="0">
                          <input type="hidden" name="oid" value="0">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Administrator 
                                      </font><font class="tit1">&raquo; </font><span class="lvl2">System 
                                      Properties </span></b></td>
                                    <td width="40%" height="23"> 
                                      <%@ include file = "../main/userpreview.jsp" %>
                                    </td>
                                  </tr>
                                  <tr > 
                                    <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                          <table width="100%" border="0" cellspacing="6" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td width="13%">&nbsp;</td>
                              <td width="87%" valign="top">&nbsp;</td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="13%">Property Name</td>
                              <td width="87%" valign="top"> 
                                <input type="text" name="<%= JspSystemProperty.fieldNames[JspSystemProperty.JSP_NAME] %>" size="30" maxlength="255" value="<%= sysProp.getName() %>" class="formElemen">
                                * <%= jspSystemProperty.getErrorMsg(jspSystemProperty.JSP_NAME) %> </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="13%" height="2">Value Type</td>
                              <td width="87%" height="2" valign="top"> 
                                <%
						String selVal = sysProp.getValueType(); 
						if(selVal == null || selVal.equals("")) selVal = "-- No Value --";
						Vector vct = Validator.toVector(com.project.system.DbSystemProperty.valueTypes);            
						String cbxName = com.project.system.JspSystemProperty.fieldNames[JspSystemProperty.JSP_VALTYPE];
						out.println(JSPCombo.draw(cbxName, null, selVal, vct));
					%>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="13%" height="2">Property Group</td>
                              <td width="87%" height="2" valign="top"> 
                                <%
						selVal = sysProp.getGroup(); 
						if(selVal == null || selVal.equals("")) selVal = "-- No Value --";
						Vector grs = Validator.toVector(QrSystemProperty.groups, QrSystemProperty.subGroups, "> ", "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - ", true);
						Vector val = Validator.toVector(QrSystemProperty.groups, QrSystemProperty.subGroups, "", "", false);
						cbxName = JspSystemProperty.fieldNames[JspSystemProperty.JSP_GROUP];
						out.println(JSPCombo.draw(cbxName, "formElemen", null, selVal, val, grs));
			
					%>
                                * <%= jspSystemProperty.getErrorMsg(jspSystemProperty.JSP_GROUP) %> </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="13%" height="29">Property Value</td>
                              <td width="87%" height="29" valign="top"> 
                                <input type="text" name="<%= JspSystemProperty.fieldNames[JspSystemProperty.JSP_VALUE] %>" size="30" maxlength="255" value="<%= sysProp.getValue() %>" class="formElemen">
                                * <%= jspSystemProperty.getErrorMsg(jspSystemProperty.JSP_VALUE) %> </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="13%" height="81">Description</td>
                              <td width="87%" height="81" valign="top"> 
                                <textarea name="<%= JspSystemProperty.fieldNames[JspSystemProperty.JSP_NOTE] %>" cols="50" rows="2" class="formElemen"><%= sysProp.getNote() %></textarea>
                              </td>
                            </tr>
                            <tr> 
                              <td colspan="2"> 
                                <%
            JSPLine cln = new JSPLine();
            //cln.setConfirmDelCommand("javascript:cmdDelete()");
            cln.setDeleteCaption("");
			
            out.println(cln.drawFrm(iCommand, cmdSystemProperty.getMsgCode(), cmdSystemProperty.getMessage()));
         %>
                              </td>
                            </tr>
                            <tr> 
                              <td colspan="2">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="2">N O T E : <br>
                                - Use "\\" character when you want to input "\" 
                                character in value field.<br>
                                - Click "Load new value" link when property it's 
                                updated. </td>
                            </tr>
                          </table>
                        </form>
                        <span class="level1">System 
                        Property </span><span class="level2"><br>
                        </span><!-- #EndEditable -->
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
