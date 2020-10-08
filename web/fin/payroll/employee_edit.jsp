
<%-- 
    Document   : employee_edit
    Created on : May 10, 2014, 9:08:03 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>

<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_COMPANY);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_COMPANY, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_COMPANY, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_COMPANY, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_COMPANY, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidEmployee = JSPRequestValue.requestLong(request, "hidden_employee_id");            

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdEmployee ctrlEmployee = new CmdEmployee(request);
            JSPLine ctrLine = new JSPLine();

            /*switch statement */
            iErrCode = ctrlEmployee.action(iJSPCommand, oidEmployee);
            /* end switch*/
            JspEmployee jspEmployee = ctrlEmployee.getForm();

            /*count list All Employee*/
            int vectSize = 0;

            Employee employee = ctrlEmployee.getEmployee();
            msgString = ctrlEmployee.getMessage();

            /*** LANG ***/
            String[] langMD = {"Name", "Emp. Num", "Address", "ID-Card", "Nationality", "Emp. Type", "required", //0-6
                "Name", "Emp. Number", "Address", "City", "Province", "Country", "Nationality", "ID-Card", "Phone", "HP", "Date of Birth", "Ignore", "Marital Status", //7-19
                "Location of Duty", "Emp. Type", "Department", "Commencing Date", "Jamsostek", "Emp. Status", //20-25
                "Resign Date", "Resign Reason", "Resign Note", "Position", "Can take advance"}; //26-30

            String[] langNav = {"Masterdata", "Employee Editor", "Name", "Date Of Birth", "Nip", "Address", "Department", "Status", "Ignore", "Data employee not found"};

            if (lang == LANG_ID) {
                String[] langID = {"Nama", "NIP", "Alamat", "Kartu Identitas", "Warga Negara", "Jenis Karyawan", "harus diisi", //0-6
                    "Nama", "NIP", "Alamat", "Kota", "Propinsi", "Negara", "Warga Negara", "Kartu Identitas", "Telpon", "HP", "Tanggal Lahir", "Abaikan", "Status Pernikahan", //7-19
                    "Lokasi Bertugas", "Jenis Karyawan", "Departemen", "Mulai Bekerja", "Jamsostek", "Status Karyawan", //20-25
                    "Tanggal Resign", "Alasan Resign", "Catatan Resign", "Jabatan", "Bisa ambil kasbon"}; //26-30
                langMD = langID;

                String[] navID = {"Data Induk", "Pegawai Editor", "Nama", "Tanggal Lahir", "Nip", "Alamat", "Departemen", "Status", "Abaikan", "Data pengguna tidak ditemukan"};
                langNav = navID;
            }

            Vector deps = DbDepartment.list(0, 0, DbDepartment.colNames[DbDepartment.COL_LEVEL] + " = " + DbDepartment.LEVEL_DEPARTMENT, DbDepartment.colNames[DbDepartment.COL_CODE]);
            if(iJSPCommand == JSPCommand.SAVE && iErrCode <=0){
                msgString = "</font face=\"arial\"><i>Data tersimpan</i></font>";
            }
            
%>
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
            
            function cmdAsk(oidEmployee){
                document.frmemployee.hidden_employee_id.value=oidEmployee;
                document.frmemployee.command.value="<%=JSPCommand.ASK%>";
                document.frmemployee.prev_command.value="<%=prevJSPCommand%>";
                document.frmemployee.action="employee_edit.jsp";
                document.frmemployee.submit();
            }
            
            function cmdConfirmDelete(oidEmployee){
                document.frmemployee.hidden_employee_id.value=oidEmployee;
                document.frmemployee.command.value="<%=JSPCommand.DELETE%>";
                document.frmemployee.prev_command.value="<%=prevJSPCommand%>";
                document.frmemployee.action="employee_edit.jsp";
                document.frmemployee.submit();
            }
            function cmdSave(){
                document.frmemployee.command.value="<%=JSPCommand.SAVE%>";
                document.frmemployee.prev_command.value="<%=prevJSPCommand%>";
                document.frmemployee.action="employee_edit.jsp";
                document.frmemployee.submit();
            }
            
            function cmdEdit(oidEmployee){
                <%if (privUpdate) {%>
                document.frmemployee.hidden_employee_id.value=oidEmployee;
                document.frmemployee.command.value="<%=JSPCommand.EDIT%>";
                document.frmemployee.prev_command.value="<%=prevJSPCommand%>";
                document.frmemployee.action="employee_edit.jsp";
                document.frmemployee.submit();
                <%}%>
            }
            
            function cmdCancel(oidEmployee){
                document.frmemployee.hidden_employee_id.value=oidEmployee;
                document.frmemployee.command.value="<%=JSPCommand.EDIT%>";
                document.frmemployee.prev_command.value="<%=prevJSPCommand%>";
                document.frmemployee.action="employee.jsp";
                document.frmemployee.submit();
            }
            
            function cmdBack(){
                document.frmemployee.command.value="<%=JSPCommand.BACK%>";
                document.frmemployee.action="employee.jsp";
                document.frmemployee.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmemployee" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_employee_id" value="<%=oidEmployee%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <%//if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspEmployee.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                    <%if(true){%>
                                                                                    
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr height="10"> 
                                                                                            <td width="100"></td>
                                                                                            <td width="330"></td>
                                                                                            <td width="100" ></td>
                                                                                            <td ></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="21" valign="middle" >&nbsp;</td>
                                                                                            <td height="21" colspan="3" class="fontarial" valign="top" align="left"><i>*)= <%=langMD[6]%></i></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[7]%></td>
                                                                                            <td height="21" >: 
                                                                                                <input type="text" name="<%=jspEmployee.colNames[JspEmployee.JSP_NAME] %>"  value="<%= employee.getName() %>" class="fontarial" size="35">
                                                                                            * <i><%= jspEmployee.getErrorMsg(JspEmployee.JSP_NAME) %></i></td> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[8]%></td>
                                                                                            <td height="21" >: 
                                                                                                <input type="text" name="<%=jspEmployee.colNames[JspEmployee.JSP_EMP_NUM] %>"  value="<%= employee.getEmpNum() %>" class="fontarial" size="35">
                                                                                            * <i><%= jspEmployee.getErrorMsg(JspEmployee.JSP_EMP_NUM)%></i></td>
                                                                                        </tr> 
                                                                                        <tr> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[9]%></td>
                                                                                            <td height="21" >: 
                                                                                                <input type="text" name="<%=jspEmployee.colNames[JspEmployee.JSP_ADDRESS] %>"  value="<%= employee.getAddress() %>" class="fontarial" size="35">
                                                                                            * <i><%= jspEmployee.getErrorMsg(JspEmployee.JSP_ADDRESS) %></i></td>
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[10]%></td>
                                                                                            <td height="21" >: 
                                                                                            <input type="text" name="<%=jspEmployee.colNames[JspEmployee.JSP_CITY] %>"  value="<%= employee.getCity() %>" class="fontarial" size="35"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[11]%></td>
                                                                                            <td height="21" >: 
                                                                                            <input type="text" name="<%=jspEmployee.colNames[JspEmployee.JSP_STATE] %>"  value="<%= employee.getState() %>" class="fontarial" size="35"></td>
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[12]%></td>
                                                                                            <td height="21" >: 
                                                                                                <% Vector countryid_value = new Vector(1, 1);
    Vector countryid_key = new Vector(1, 1);

    Vector countries = DbCountry.list(0, 0, "", "name");
    String sel_countryid = "" + employee.getCountryId();
    countryid_value.add("-select country-");
    countryid_key.add("0");
    if (countries != null && countries.size() > 0) {
        for (int i = 0; i < countries.size(); i++) {
            Country c = (Country) countries.get(i);
            countryid_value.add("" + c.getName());
            countryid_key.add("" + c.getOID());
        }
    }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspEmployee.colNames[JspEmployee.JSP_COUNTRY_ID], null, sel_countryid, countryid_key, countryid_value, "", "fontarial") %> * <%= jspEmployee.getErrorMsg(JspEmployee.JSP_COUNTRY_ID) %></td> 
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[13]%></td>
                                                                                            <td height="21" >: 
                                                                                                <% Vector nationalityid_value = new Vector(1, 1);
    Vector nationalityid_key = new Vector(1, 1);
    String sel_nationalityid = "" + employee.getNationalityId();
    nationalityid_value.add("-select nationality-");
    nationalityid_key.add("0");

    if (countries != null && countries.size() > 0) {
        for (int i = 0; i < countries.size(); i++) {
            Country c = (Country) countries.get(i);
            nationalityid_value.add("" + c.getNationality());
            nationalityid_key.add("" + c.getOID());
        }
    }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspEmployee.colNames[JspEmployee.JSP_NATIONALITY_ID], null, sel_nationalityid, nationalityid_key, nationalityid_value, "", "fontarial") %> * <i><%= jspEmployee.getErrorMsg(JspEmployee.JSP_NATIONALITY_ID) %></i></td> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[14]%></td>
                                                                                            <td height="21" >: 
                                                                                                <% Vector idtype_value = new Vector(1, 1);
    Vector idtype_key = new Vector(1, 1);
    String sel_idtype = "" + employee.getIdType();
    
    for (int i = 0; i < I_Project.strId.length; i++) {
        idtype_key.add(I_Project.strId[i]);
        idtype_value.add(I_Project.strId[i]);
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspEmployee.colNames[JspEmployee.JSP_ID_TYPE], null, sel_idtype, idtype_key, idtype_value, "", "fontarial") %> 
                                                                                            <input type="text" name="<%=jspEmployee.colNames[JspEmployee.JSP_ID_NUMBER] %>"  value="<%= employee.getIdNumber() %>" class="fontarial" size="30"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[15]%></td>
                                                                                            <td height="21" >: 
                                                                                            <input type="text" name="<%=jspEmployee.colNames[JspEmployee.JSP_PHONE] %>"  value="<%= employee.getPhone() %>" class="formElemen" size="20"></td>
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[16]%></td>
                                                                                            <td height="21" >: 
                                                                                            <input type="text" name="<%=jspEmployee.colNames[JspEmployee.JSP_HP] %>"  value="<%= employee.getHp() %>" class="formElemen" size="20"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[17]%></td>
                                                                                            <td height="21" >
                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td>:&nbsp;</td>
                                                                                                        <td ><input name="<%=jspEmployee.colNames[JspEmployee.JSP_DOB]%>" value="<%=JSPFormater.formatDate((employee.getDob() == null) ? new Date() : employee.getDob(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmemployee.<%=jspEmployee.colNames[JspEmployee.JSP_DOB]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>
                                                                                                        <td><input type="checkbox" name="<%=jspEmployee.colNames[JspEmployee.JSP_IGNORE_BIRTH]%>" value="1" <%if (employee.getIgnoreBirth() == 1) {%>checked<%}%>></td>
                                                                                                        <td class="fontarial"><i><%=langMD[18]%></i></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[19]%></td>
                                                                                            <td height="21" >: 
                                                                                                <% Vector maritalstatus_value = new Vector(1, 1);
    Vector maritalstatus_key = new Vector(1, 1);
    String sel_maritalstatus = "" + employee.getMaritalStatus();
    for (int i = 0; i < I_Project.strMarital.length; i++) {
        maritalstatus_key.add(I_Project.strMarital[i]);
        maritalstatus_value.add(I_Project.strMarital[i]);
    }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspEmployee.colNames[JspEmployee.JSP_MARITAL_STATUS], null, sel_maritalstatus, maritalstatus_key, maritalstatus_value, "", "formElemen") %></td> 
                                                                                        </tr> 
                                                                                        <tr> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[21]%></td>
                                                                                            <td height="21" >: 
                                                                                            <% Vector emptype_value = new Vector(1, 1);
    Vector emptype_key = new Vector(1, 1);
    String sel_emptype = "" + employee.getEmpType();
    for (int i = 0; i < I_Project.empType.length; i++) {
        emptype_key.add(I_Project.empType[i]);
        emptype_value.add(I_Project.empType[i]);
    }
                                                                                            %>
                                                                                            <%= JSPCombo.draw(jspEmployee.colNames[JspEmployee.JSP_EMP_TYPE], null, sel_emptype, emptype_key, emptype_value, "", "fontarial") %> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[22]%></td>
                                                                                            <td height="21" >: 
                                                                                                <%
    Vector department_value = new Vector(1, 1);
    Vector department_key = new Vector(1, 1);
    String sel_department = "" + employee.getDepartmentId();
    department_key.add("0");
    department_value.add("-select department");

    if (deps != null && deps.size() > 0) {
        for (int i = 0; i < deps.size(); i++) {
            Department d = (Department) deps.get(i);
            department_key.add("" + d.getOID());
            department_value.add("" + d.getName());
        }
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspEmployee.colNames[JspEmployee.JSP_DEPARTMENT_ID], null, sel_department, department_key, department_value, "", "fontarial") %>
                                                                                            </td>
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[29]%></td>
                                                                                            <td height="21" >:
                                                                                            <input type="text" name="<%=jspEmployee.colNames[JspEmployee.JSP_POSITION]%>" value="<%=employee.getPosition()%>" size="35" class="fontarial"></td>
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[24]%></td>
                                                                                            <td height="21">:
                                                                                            <input type="text" name="<%=jspEmployee.colNames[JspEmployee.JSP_JAMSOSTEK_ID] %>"  value="<%= employee.getJamsostekId() %>" class="fontarial"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[23]%></td>
                                                                                            <td height="21"> 
                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td>:&nbsp;</td>
                                                                                                    <td><input name="<%=jspEmployee.colNames[JspEmployee.JSP_COMMENCING_DATE]%>" value="<%=JSPFormater.formatDate((employee.getCommencingDate() == null) ? new Date() : employee.getCommencingDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmemployee.<%=jspEmployee.colNames[JspEmployee.JSP_COMMENCING_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>
                                                                                                </tr>
                                                                                            </table>
                                                                                            </td>
                                                                                            <%if (employee.getEmpType().equals(I_Project.EMP_TYPE_CONTRACTUAL)) {%>                                                                                        
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;Contract End</td>
                                                                                            <td height="21" > 
                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td>:&nbsp;</td>
                                                                                                        <td><input name="<%=jspEmployee.colNames[JspEmployee.JSP_CONTRACT_END]%>" value="<%=JSPFormater.formatDate((employee.getContractEnd() == null) ? new Date() : employee.getContractEnd(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmemployee.<%=jspEmployee.colNames[JspEmployee.JSP_CONTRACT_END]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>                                                                                
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%} else {%>
                                                                                            <td>&nbsp;</td>
                                                                                            <td>&nbsp;</td>
                                                                                            <%}%>
                                                                                        </tr> 
                                                                                        <tr> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[25]%></td>
                                                                                            <td height="21" >: 
                                                                                            <% Vector empstatus_value = new Vector(1, 1);
    Vector emptatus_key = new Vector(1, 1);
    String sel_empstatus = "" + employee.getEmpStatus();
    for (int i = 0; i < I_Project.statusArray2.length; i++) {
        emptatus_key.add(I_Project.statusArray2[i]);
        empstatus_value.add(I_Project.statusArray2[i]);
    }
                                                                                            %>
                                                                                            <%= JSPCombo.draw(jspEmployee.colNames[JspEmployee.JSP_EMP_STATUS], null, sel_empstatus, emptatus_key, empstatus_value, "", "formElemen") %></td> 
                                                                                            <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[30]%></td>
                                                                                            <td height="21" >:
                                                                                            <input type="checkbox" name="<%=jspEmployee.colNames[JspEmployee.JSP_CAN_TAKE_ADVANCE]%>" value="<%=DbEmployee.CAN_TAKE_ADVANCE%>" <%if (employee.getCanTakeAdvance() == 1) {%>checked<%}%>></td>
                                                                                        </tr>
                                                                                        <%if (employee.getEmpStatus().equals(I_Project.STATUS_RESIGNED)) {%>
                                                                                        <tr> 
                                                                                        <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[26]%></td>
                                                                                        <td height="21" > 
                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td>:&nbsp;</td>
                                                                                                    <td><input name="<%=jspEmployee.colNames[JspEmployee.JSP_RESIGN_DATE]%>" value="<%=JSPFormater.formatDate((employee.getResignDate() == null) ? new Date() : employee.getResignDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmemployee.<%=jspEmployee.colNames[JspEmployee.JSP_RESIGN_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td> 
                                                                                                </tr>    
                                                                                            </table>    
                                                                                        </td>
                                                                                        <td colspan="2">&nbsp;</td>
                                                                                        <tr> 
                                                                                            <td height="8" align="left" class="tablearialcell1">&nbsp;&nbsp;<%=langMD[27]%></td>
                                                                                            <td height="8" valign="top" align="left">: 
                                                                                                <% Vector reason_value = new Vector(1, 1);
    Vector reason_key = new Vector(1, 1);
    String sel_reason = "" + employee.getResignReason();
    for (int i = 0; i < I_Project.empResignReason.length; i++) {
        reason_key.add(I_Project.empResignReason[i]);
        reason_value.add(I_Project.empResignReason[i]);
    }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspEmployee.colNames[JspEmployee.JSP_RESIGN_REASON], null, sel_reason, reason_key, reason_value, "", "formElemen") %></td>
                                                                                            <td colspan="2">&nbsp;</td>    
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="8" class="tablearialcell1" align="left" valign="top">&nbsp;&nbsp;<%=langMD[28]%></td>
                                                                                            <td height="8" valign="top" align="left">&nbsp; 
                                                                                                <textarea name="<%=jspEmployee.colNames[JspEmployee.JSP_RESIGN_NOTE] %>" class="formElemen" cols="35" rows="3"><%= employee.getResignNote() %></textarea>
                                                                                            </td>
                                                                                            <td colspan="2">&nbsp;</td>    
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr> 
                                                                                            <td colspan="4">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr > 
                                                                                            <td colspan="4" class="command" valign="top" align="left"> 
                                                                                                <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidEmployee + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidEmployee + "')";
    String scancel = "javascript:cmdEdit('" + oidEmployee + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setDeleteCaption("Delete");

    ctrLine.setOnMouseOut("MM_swapImgRestore()");
    ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
    ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
    
    ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/back2.gif',1)");
    ctrLine.setBackImage("<img src=\"" + approot + "/images/back.gif\" name=\"back\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
    ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/back2.gif',1)");
    ctrLine.setEditImage("<img src=\"" + approot + "/images/back.gif\" name=\"edit\" height=\"22\" border=\"0\">");


    ctrLine.setWidthAllJSPCommand("90");
    ctrLine.setErrorStyle("warning");
    ctrLine.setErrorImage(approot + "/images/error.gif\" height=\"20");
    ctrLine.setQuestionStyle("warning");
    ctrLine.setQuestionImage(approot + "/images/error.gif\" height=\"20");
    ctrLine.setInfoStyle("success");
    ctrLine.setSuccessImage(approot + "/images/success.gif\" height=\"20");

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

    //if (privAdd == false) {
        ctrLine.setAddCaption("");
    //}
                                                                                                %>
                                                                                                <%//if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK || iErrCode != 0) {%>
                                                                                                <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                                                                <%//}%>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                    </table>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
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
