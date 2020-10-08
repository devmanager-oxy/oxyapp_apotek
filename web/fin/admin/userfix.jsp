
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %> 
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file = "../main/javainit.jsp" %> 
<% int appObjCode = 0;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_DELETE);
%>
<!-- JSP Block -->
<%!
    public String drawListUser(Vector objectClass, String[] lang) {
        String temp = "";
        String regdatestr = "";

        JSPList jspList = new JSPList();
        jspList.setAreaWidth("100%");
        //jspList.setAreaWidth("20%");
        jspList.setListStyle("listgen");
        jspList.setTitleStyle("tablehdr");
        jspList.setCellStyle("tablecell");
        jspList.setCellStyle1("tablecell1");
        jspList.setHeaderStyle("tablehdr");

        jspList.addHeader(lang[0], "15%");
        jspList.addHeader(lang[1], "25%");
        jspList.addHeader(lang[2], "50%");
        jspList.addHeader(lang[3], "10%");

        jspList.setLinkRow(0);
        jspList.setLinkSufix("");

        Vector lstData = jspList.getData();

        Vector lstLinkData = jspList.getLinkData();

        jspList.setLinkPrefix("javascript:cmdEdit('");
        jspList.setLinkSufix("')");
        jspList.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            User appUser = (User) objectClass.get(i);

            Vector rowx = new Vector();

            rowx.add(String.valueOf(appUser.getLoginId()));
            rowx.add(String.valueOf(appUser.getFullName()));
            rowx.add(String.valueOf(appUser.getDescription()));
            rowx.add(String.valueOf(User.getStatusTxt(appUser.getUserStatus())));

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(appUser.getOID()));
        }

        return jspList.draw(index);
    }
	
	public String isChecked(long oid, Vector sus){
        if(sus!=null && sus.size()>0){
            for(int i=0; i<sus.size(); i++){
                SegmentUser su = (SegmentUser)sus.get(i);
                if(oid==su.getSegmentDetailId()){
                    return "checked";
                } 
            }
        }
        
        return "";  
    }

%>
<%

            /* VARIABLE DECLARATION */
            int recordToGet = 20; 
			String where = "";
            String order = " " + DbUser.colNames[DbUser.COL_LOGIN_ID];

            Vector listUser = new Vector(1, 1);
            JSPLine jspLine = new JSPLine();

            /* GET REQUEST FROM HIDDEN TEXT */
            int iJSPCommand = JSPRequestValue.requestCommand(request); 
            int start = JSPRequestValue.requestInt(request, "start");
            long appUserOID = JSPRequestValue.requestLong(request, "user_oid");
            int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");
			String loginId = JSPRequestValue.requestString(request, "login_id");
			String fullName = JSPRequestValue.requestString(request, "fullname");
            if (listJSPCommand == JSPCommand.NONE) {
                listJSPCommand = JSPCommand.LIST;
            }
			
			

            listUser = DbUser.listFullObj(0, 0, "", "", "", ""); 

            /*** LANG ***/
            String[] langMD = {"Login-ID", "Full Name", "Description", "Status"};
            if (lang == LANG_ID) {
                String[] langID = {"Login-ID", "Nama Lengkap", "Keterangan", "Status"};
                langMD = langID;
            }
			
			Vector segLocs = DbSegmentUser.getSegmentDetailLocation();
			
			

            if (iJSPCommand == JSPCommand.SAVE && listUser!=null && listUser.size()>0) {
                for(int i=0; i<listUser.size(); i++){
                    User userapp = (User)listUser.get(i); 
                    out.println("<br>processing user :"+userapp.getLoginId() +", idx : "+i);
                    Vector sgSelected = new Vector(); 
                    //process segment user
                    if(segLocs!=null && segLocs.size()>0){
                        
						if(userapp.getSegment1Id()==0){
						
							for(int x=0; x<segLocs.size(); x++){
								SegmentDetail sd = (SegmentDetail)segLocs.get(x);
								sgSelected.add(""+sd.getOID());								                            
							}
							
							DbSegmentUser.proceedSegment(sgSelected, userapp.getOID());
						}
						else{
							for(int x=0; x<segLocs.size(); x++){
								SegmentDetail sd = (SegmentDetail)segLocs.get(x);
								if(sd.getLocationId()==userapp.getSegment1Id()){
									sgSelected.add(""+sd.getOID());								                            
								}
							}
							
							DbSegmentUser.proceedSegment(sgSelected, userapp.getOID());
						}
                        
                    }
                }
            }

%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (!privView && !privAdd && !privUpdate && !privDelete) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <% if (privAdd) {%>
            function addNew(){
                document.frmUser.user_oid.value="0";
                document.frmUser.list_command.value="<%=listJSPCommand%>";
                document.frmUser.command.value="<%=JSPCommand.ADD%>";
                document.frmUser.action="useredit.jsp";
                document.frmUser.submit();
            }
            <%}%>
            
            function cmdEdit(oid){
                 <%if(privUpdate){%>
                document.frmUser.user_oid.value=oid;
                document.frmUser.list_command.value="<%=listJSPCommand%>";
                document.frmUser.command.value="<%=JSPCommand.EDIT%>";
                document.frmUser.action="useredit.jsp";
                document.frmUser.submit();
                <%}%>
            }
             
            function cmdSave(){
                document.frmUser.command.value="<%=JSPCommand.SAVE%>";
                document.frmUser.list_command.value="<%=JSPCommand.SAVE%>";
                document.frmUser.action="userfix.jsp";
                document.frmUser.submit();
            }
            
            function cmdSearch(){
                document.frmUser.action="userfix.jsp";
                document.frmUser.submit();
            }
			
			function first(){
                document.frmUser.command.value="<%=JSPCommand.FIRST%>";
                document.frmUser.list_command.value="<%=JSPCommand.FIRST%>";
                document.frmUser.action="userfix.jsp";
                document.frmUser.submit();
            }
			
            function prev(){
                document.frmUser.command.value="<%=JSPCommand.PREV%>";
                document.frmUser.list_command.value="<%=JSPCommand.PREV%>";
                document.frmUser.action="userfix.jsp";
                document.frmUser.submit();
            }
            
            function next(){
                document.frmUser.command.value="<%=JSPCommand.NEXT%>";
                document.frmUser.list_command.value="<%=JSPCommand.NEXT%>";
                document.frmUser.action="userfix.jsp";
                document.frmUser.submit();
            }
            function last(){
                document.frmUser.command.value="<%=JSPCommand.LAST%>";
                document.frmUser.list_command.value="<%=JSPCommand.LAST%>";
                document.frmUser.action="userfix.jsp";
                document.frmUser.submit();
            }
            
            function backMenu(){ 
                document.frmUser.action="<%=approot%>/management/main_systemadmin.jsp";
                document.frmUser.submit();
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
            //--> 
        </script>  
        <!-- #EndEditable -->
    </head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/save2.gif','../images/search2.gif')">
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
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">User List</span></font>";
                                           %>
                        <%@ include file="../main/navigator.jsp"%>
                        <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmUser" method="post" action="">
                          <input type="hidden" name=sel_top_mn">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="user_oid" value="<%=appUserOID%>">
                          <input type="hidden" name="vectSize" value="">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">&nbsp; </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" cellpadding="0" cellspacing="0">
                                  <tr> 
                                    <td colspan="2"> <span class="command">&nbsp; 
                                      </span> </td>
                                  </tr>
                                  <tr valign="middle"> 
                                    <td colspan="2" class="command"> 
                                      <table width="25%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <% if (privAdd) {%>
                                          <td width="11%">&nbsp;</td>
                                          <td nowrap width="29%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td nowrap width="29%"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save21','','../images/save2.gif',1)"><img src="../images/save.gif" name="save21" border="0"></a></td>
                                          <%}%>
                                          <td width="13%">&nbsp;</td>
                                          <td nowrap width="47%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="13%">&nbsp;</td>
                                    <td width="87%">&nbsp;</td>
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
<!-- #EndTemplate --></html>
