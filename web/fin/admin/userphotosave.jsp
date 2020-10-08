
<%-- 
    Document   : userphotosave
    Created on : Apr 20, 2013, 11:03:37 PM
    Author     : Roy Andika
--%>

<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.blob.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ include file = "../main/check.jsp" %>

<%
            JSPLine jspLine = new JSPLine();
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long appUserOID = JSPRequestValue.requestLong(request, "user_oid");            
            int subMenuAdmIdx = JSPRequestValue.requestInt(request, "sub_menu_adm_idx");

            User appUser = new User();

            if (iJSPCommand == JSPCommand.EDIT) {
                try {
                    appUser = DbUser.fetch(appUserOID);
                } catch (Exception e) {}
            }

            QrPictureSave sessPictureSave = new QrPictureSave();
            ImageLoader uploader = new ImageLoader();

            if (iJSPCommand == JSPCommand.DELETE) {
                try {
                } catch (Exception e) {
                    System.out.println(e.toString());
                }
            } else {

                try {

                 if(appUser.getOID() != 0){
                        uploader.uploadImage(config, request, response);
                        Object obj = uploader.getImage("pict");

                        String fileName = "pic_" + appUser.getOID();

                        if (obj != null) {
                            sessPictureSave.updateImageUser(obj, fileName);                            
                        }
                    }
                } catch (Exception e) {
                    System.out.println(e.toString());
                }
            }

//tidur sebentar sambil menunggu file baru tercreate dengan 
//lengkap di image cache 
            Thread th = new Thread();
            th.sleep(5000);
            response.sendRedirect("userphoto.jsp?command="+JSPCommand.EDIT+"&menu_idx=15&sub_menu_adm_idx=2&user_oid="+appUser.getOID());
%>