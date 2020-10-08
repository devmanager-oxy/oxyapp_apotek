<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>  
<%//@ page import = "com.project.fms.journal.*" %>   
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.postransaction.memberpoint.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %> 
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.sql.*" %>
<% int appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
            boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
            boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

            String memberId = JSPRequestValue.requestString(request, "mid");
            double pointx = 0;
            double lastpoint = 0;
            double lastpointtype = 0;

            CONResultSet dbrs = null;
            try {
                String sql = "select sum(point*in_out) from pos_member_point where customer_id=" + memberId;

                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();

                int count = 0;
                while (rs.next()) {
                    pointx = rs.getDouble(1);
                }

                rs.close();

            } catch (Exception e) {

            } finally {
                CONResultSet.close(dbrs);
            }

            Vector temp = DbMemberPoint.list(0, 1, "customer_id=" + memberId, "date desc");
            if (temp != null && temp.size() > 0) {
                MemberPoint mp = (MemberPoint) temp.get(0);
                lastpoint = mp.getPoint();
                lastpointtype = mp.getType();
            }

%>
<input type="hidden" name="member_point" id="member_point" value="<%=pointx%>">
<input type="hidden" name="last_point" id="last_point" value="<%=lastpoint%>">
<input type="hidden" name="last_point_type" id="last_point_type" value="<%=lastpointtype%>">
<input type="hidden" name="sts_ok" id="sts_ok" value="1">
<%=pointx%>
