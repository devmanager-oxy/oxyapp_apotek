<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.blob.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
            boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
            boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<%

//long oidRma21 = JSPRequestValue.requestLong(request, "hidden_rma21_id");

            System.out.println(" ");
            System.out.println(" ");
            System.out.println(" ");
            System.out.println(" ");
            System.out.println(" in savepict_prdComp");

            User appUser = (User) session.getValue("USER_IMAGE");

            int iCommand = JSPRequestValue.requestCommand(request);

            int delCommand = 0;
            if (session.getValue("DEL_COMMAND") != null) {
                String delCmd = (String) session.getValue("DEL_COMMAND");
                delCommand = Integer.parseInt(delCmd);
            }


            QrUserPicture qrUserPicture = new QrUserPicture();
            ImageLoader uploader = new ImageLoader();

//jika ada image lakukan penghapusan, 
//nanti baru input yang baru	 
            if (user.getOID() != 0) {
                System.out.println("---------> DELETING IMAGE ON JSP ");
                QrUserPicture.deleteImage(appUser.getEmployeeNum());
            } else {
                //message only ..
                System.out.println("xxx - can't get product id, process aborted...");
            }

            if (delCommand != JSPCommand.POST) {
                System.out.println("----- > into insert | update image ..");
                try {
                    uploader.uploadImage(config, request, response);
                    Object obj = uploader.getImage("pict");
                    if (obj != null) {
                        System.out.println("Start - the picture obj is not null");
                        qrUserPicture.updateImage(obj, appUser.getEmployeeNum());//picture.getOID());
                        System.out.println("end - OBJ NOT NULL. xxx...............");
                    } else {
                        System.out.println("OBJ NULL......yyy..........");
                    }
                } catch (Exception e) {
                    System.out.println(e.toString());
                }
            }


//tidur sebentar sambil menunggu file baru tercreate dengan 
//lengkap di image cache 
            Thread th = new Thread();
            th.sleep(5000);


%>
<%
            response.sendRedirect(approot + "/admin/user_image.jsp?user_oid=" + appUser.getOID());
%>
