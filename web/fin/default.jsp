
<% ((HttpServletResponse) response).addCookie(new Cookie("JSESSIONID", session.getId()));%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.main.db.*" %>
<%@ page import="com.project.fms.transaction.*" %>
<%@ page import="com.project.general.*" %>
<%@ include file="main/javainit.jsp"%>
<%@ include file="main/check.jsp"%> 
<html>
    <head>
        <title></title>
    </head>
    <body>
        <script type="text/javascript" src="<%=approot%>/js/jquery.min.js"></script>
        <link href="<%=approot%>/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<%=approot%>/js/bootstrap.min.js"></script>
        <link href="<%=approot%>/js/bootstrap-multiselect.css" rel="stylesheet" type="text/css" />
        <script src="<%=approot%>/js/bootstrap-multiselect.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(function () {
                $('#lstFruits').multiselect({
                    includeSelectAllOption: true
                });
                $('#btnSelected').click(function () {
                    var selected = $("#lstFruits option:selected");
                    var message = "";
                    selected.each(function () {
                        message += $(this).text() + " " + $(this).val() + "\n";
                    });
                    alert(message);
                });
            });
        </script>
        <select id="lstFruits" multiple="multiple">
            <option value="1">Mango</option>
            <option value="2">Apple</option>
            <option value="3">Banana</option>
            <option value="4">Guava</option>
            <option value="5">Orange</option>
        </select>
        <input type="button" id="btnSelected" value="Get Selected" />
    </body>
</html>
