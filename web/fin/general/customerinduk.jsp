
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
            boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
            boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidIndukCustomer = JSPRequestValue.requestLong(request, "hidden_induk_customer_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;

            CmdIndukCustomer cmdIndukCustomer = new CmdIndukCustomer(request);
            JSPLine ctrLine = new JSPLine();
            Vector listIndukCustomer = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdIndukCustomer.action(iJSPCommand, oidIndukCustomer);
            /* end switch*/
            JspIndukCustomer jspIndukCustomer = cmdIndukCustomer.getForm();

            IndukCustomer indukCustomer = cmdIndukCustomer.getIndukCustomer();
            msgString = cmdIndukCustomer.getMessage();
            oidIndukCustomer = indukCustomer.getOID();
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">            
            <%//if((iJSPCommand==JSPCommand.SAVE || iJSPCommand==JSPCommand.DELETE) && iErrCode==0 ){
            if ((iJSPCommand == JSPCommand.DELETE) && iErrCode == 0) {

         %>
             //%>
             
             window.location="customerinduklist.jsp?command=<%=JSPCommand.LIST%>&customer_id=0";
             //cmdBack();
             <%}%>
             
             function cmdAdd(){
                 document.frmindukCustomer.hidden_induk_customer_id.value="0";
                 document.frmindukCustomer.command.value="<%=JSPCommand.ADD%>";
                 document.frmindukCustomer.action="customerinduk.jsp";
                 document.frmindukCustomer.submit();
             }
             
             function cmdAsk(oidIndukCustomer){
                 document.frmindukCustomer.hidden_induk_customer_id.value=oidIndukCustomer;
                 document.frmindukCustomer.command.value="<%=JSPCommand.ASK%>";
                 document.frmindukCustomer.action="customerinduk.jsp";
                 document.frmindukCustomer.submit();
             }
             
             function cmdEdit(oidIndukCustomer){
                 document.frmindukCustomer.hidden_induk_customer_id.value=oidIndukCustomer;
                 document.frmindukCustomer.command.value="<%=JSPCommand.EDIT%>";
                 document.frmindukCustomer.action="customerinduk.jsp";
                 document.frmindukCustomer.submit();
             }
             
             function cmdConfirmDelete(oidIndukCustomer){
                 document.frmindukCustomer.hidden_induk_customer_id.value=oidIndukCustomer;
                 document.frmindukCustomer.command.value="<%=JSPCommand.DELETE%>";
                 document.frmindukCustomer.action="customerinduk.jsp";
                 document.frmindukCustomer.submit();
             }
             function cmdSave(){  
                 document.frmindukCustomer.command.value="<%=JSPCommand.SAVE%>";
                 document.frmindukCustomer.action="customerinduk.jsp";
                 document.frmindukCustomer.submit();
             }
             
             
             function cmdCancel(oidIndukCustomer){
                 document.frmindukCustomer.hidden_induk_customer_id.value=oidIndukCustomer;
                 document.frmindukCustomer.command.value="<%=JSPCommand.EDIT%>";
                 document.frmindukCustomer.action="customerinduk.jsp";
                 document.frmindukCustomer.submit();
             }
             
             function cmdBack(){
                 document.frmindukCustomer.command.value="<%=JSPCommand.BACK%>";
                 document.frmindukCustomer.action="customerinduklist.jsp";
                 document.frmindukCustomer.submit();
             }
             
             //-------------- script control line -------------------
             function MM_swapImgRestore() { //v3.0
                 var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
             }
             
             function MM_preloadImages() { //v3.0
                 var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                     var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                     if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
             }
             
             function MM_findObj(n, d) { //v4.0
                 var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                     d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                 if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                 for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                 if(!x && document.getElementById) x=document.getElementById(n); return x;
             }
             
             function MM_swapImage() { //v3.0
                 var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                 if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
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
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" --> 
                        <%
            String navigator = "<font class=\"lvl1\">Data Induk</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Induk Customer</span></font>";
                                           %>
                        <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmindukCustomer" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="hidden_customer_id" value="<%=oidIndukCustomer%>">
                                                            <input type="hidden" name="hidden_induk_customer_id" value="<%=oidIndukCustomer%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                            <tr align="left"> 
                                                                                <td height="21" valign="middle" width="13%">&nbsp;</td>
                                                                                <td height="21" colspan="2" class="comment" valign="top" width="87%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                                <td height="21" valign="middle" width="13%">&nbsp;</td>
                                                                                <td height="21" colspan="2" width="87%" class="comment" valign="top">*)= 
                                                                                Harus diisi</td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;Nama </td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input type="text" name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_NAME] %>"  value="<%= indukCustomer.getName() %>" class="formElemen" size="60">
                                                                            * <span class="style1"> <%=jspIndukCustomer.getErrorMsg(JspIndukCustomer.JSP_NAME)%> </span> 
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;Alamat</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input type="text" name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_ADDRESS] %>"  value="<%= indukCustomer.getAddress() %>" class="formElemen" size="60">
                                                                            * <span class="style1"><%=jspIndukCustomer.getErrorMsg(JspIndukCustomer.JSP_ADDRESS)%></span> 
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;N.P.W.P</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input type="text" name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_NPWP] %>"  value="<%= indukCustomer.getNpwp() %>" class="formElemen" size="60">
                                                                            * <span class="style1"><%=jspIndukCustomer.getErrorMsg(JspIndukCustomer.JSP_NPWP)%></span> 
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;Kota</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input type="text" name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_CITY] %>"  value="<%= indukCustomer.getCity() %>" class="formElemen" size="60">
                                                                            * <span class="style1"><%=jspIndukCustomer.getErrorMsg(JspIndukCustomer.JSP_CITY)%></span> 
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;Negara</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <%
            Vector vctCtr = DbCountry.list(0, 0, "", "name");

            Vector countryid_value = new Vector(1, 1);
            Vector countryid_key = new Vector(1, 1);
            String sel_countryid = "" + indukCustomer.getCountryId();

            if (vctCtr != null && vctCtr.size() > 0) {
                for (int i = 0; i < vctCtr.size(); i++) {
                    Country ctr = (Country) vctCtr.get(i);
                    countryid_key.add("" + ctr.getOID());
                    countryid_value.add("" + ctr.getName());
                }
            }
                                                                            %>
                                                                            <%= JSPCombo.draw(jspIndukCustomer.colNames[JspIndukCustomer.JSP_COUNTRY_ID], null, sel_countryid, countryid_key, countryid_value, "", "formElemen") %> * <span class="style1"><%=jspIndukCustomer.getErrorMsg(JspIndukCustomer.JSP_COUNTRY_ID)%></span> 
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;Kode Pos 
                                                                            </td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_POSTAL_CODE] %>" type="text" class="formElemen"  value="<%= indukCustomer.getPostalCode() %>" size="60" maxlength="6">
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%" nowrap>&nbsp;Telephone&nbsp;</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_COUNTRY_CODE] %>" type="text" class="formElemen"  value="<%= indukCustomer.getCountryCode() %>" size="5" maxlength="3">
                                                                            - 
                                                                            <input name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_AREA_CODE] %>" type="text" class="formElemen"  value="<%= indukCustomer.getAreaCode() %>" size="5" maxlength="4">
                                                                            - 
                                                                            <input type="text" name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_PHONE] %>"  value="<%= indukCustomer.getPhone() %>" class="formElemen" size="37">
                                                                            * <span class="style1"><%=jspIndukCustomer.getErrorMsg(JspIndukCustomer.JSP_PHONE)%></span> 
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;Fax</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_COUNTRY_CODE] %>2" type="text" class="formElemen"  value="<%= indukCustomer.getCountryCode() %>" size="5" maxlength="3">
                                                                            - 
                                                                            <input name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_AREA_CODE] %>2" type="text" class="formElemen"  value="<%= indukCustomer.getAreaCode() %>" size="5" maxlength="4">
                                                                            - 
                                                                            <input type="text" name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_FAX] %>"  value="<%= (indukCustomer.getFax() == null) ? "" : indukCustomer.getFax() %>" class="formElemen" size="37">
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;Kontak Person</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input type="text" name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_CONTACT_PERSON] %>"  value="<%= indukCustomer.getContactPerson() %>" class="formElemen" size="60">
                                                                            * <span class="style1"><%=jspIndukCustomer.getErrorMsg(JspIndukCustomer.JSP_CONTACT_PERSON)%></span> 
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%" nowrap>&nbsp;Jabatan 
                                                                            Kontak Person &nbsp;</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input type="text" name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_POSISI_CONTACT_PERSON] %>"  value="<%= indukCustomer.getPosisiContactPerson() %>" class="formElemen" size="60">
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;Website</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input type="text" name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_WEBSITE] %>"  value="<%= indukCustomer.getWebsite() %>" class="formElemen" size="60">
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;Email</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <input type="text" name="<%=jspIndukCustomer.colNames[JspIndukCustomer.JSP_EMAIL] %>"  value="<%= indukCustomer.getEmail() %>" class="formElemen" size="60">
                                                                            <tr align="left"> 
                                                                            <td height="21" width="13%">&nbsp;</td>
                                                                            <td height="21" colspan="2" width="87%"> 
                                                                            <tr align="left"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            //ctrLine.setLocationImg(approot+"/images");
            ctrLine.initDefault();
            ctrLine.setTableWidth("100%");
            String scomDel = "javascript:cmdAsk('" + oidIndukCustomer + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidIndukCustomer + "')";
            String scancel = "javascript:cmdEdit('" + oidIndukCustomer + "')";
            ctrLine.setBackCaption("Back to List");
            ctrLine.setJSPCommandStyle("buttonlink");
            ctrLine.setDeleteCaption("Delete");
            ctrLine.setSaveCaption("Save");
            ctrLine.setAddCaption("");

            ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverSave("MM_swapImage('save_item','','" + approot + "/images/save2.gif',1)");
            ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save_item\" height=\"22\" border=\"0\">");

            //ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverBack("MM_swapImage('back_item','','" + approot + "/images/cancel2.gif',1)");
            ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back_item\" height=\"22\" border=\"0\">");

            ctrLine.setOnMouseOverDelete("MM_swapImage('delete_item','','" + approot + "/images/delete2.gif',1)");
            ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete_item\" height=\"22\" border=\"0\">");

            ctrLine.setOnMouseOverEdit("MM_swapImage('edit_item','','" + approot + "/images/cancel2.gif',1)");
            ctrLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit_item\" height=\"22\" border=\"0\">");


            ctrLine.setWidthAllJSPCommand("90");
            ctrLine.setErrorStyle("warning");
            ctrLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
            ctrLine.setQuestionStyle("warning");
            ctrLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
            ctrLine.setInfoStyle("success");
            ctrLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");

            if (privDelete) {
                ctrLine.setConfirmDelJSPCommand(sconDelCom);
                ctrLine.setDeleteJSPCommand(scomDel);
                ctrLine.setEditJSPCommand(scancel);
            } else {
                ctrLine.setConfirmDelCaption("");
                ctrLine.setDeleteCaption("");
                ctrLine.setEditCaption("");
            }

            if (privAdd == false && privUpdate == false) {
                ctrLine.setSaveCaption("");
            }

            if (privAdd == false) {
                ctrLine.setAddCaption("");
            }

            //out.println("iErrCode : "+iErrCode+", msgString : "+msgString);
%>
                                                                                <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td colspan="3" class="command" valign="top">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="13%">&nbsp;</td>
                                                                                <td width="87%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td colspan="3" valign="top"> 
                                                                                    <div align="left"></div>
                                                                                </td>
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
