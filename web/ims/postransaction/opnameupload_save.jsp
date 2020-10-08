<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.blob.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "java.io.BufferedReader" %>
<%@ page import = "java.io.FileReader" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

 <%
 
 System.out.println(" ");
 System.out.println(" in upload opname items");
 
 Hashtable tempOids = (Hashtable)session.getValue("UPLOAD_PARAM");

 long oidOpname = Long.parseLong((String)tempOids.get("opname"));
 long oidSubLoc = Long.parseLong((String)tempOids.get("subloc"));
 long oidOpnameSubLoc = Long.parseLong((String)tempOids.get("opnamesubloc"));

 TextLoader tL = new TextLoader();
 tL.uploadText(config, request, response);
 String strUpload = tL.getStringFile("opnamedetail");
 System.out.println("obj str : "+strUpload);
 
 StringTokenizer strTok = new StringTokenizer(strUpload, "\n");
 Vector items = new Vector();
 while(strTok.hasMoreElements()){     
     items.add(((String)strTok.nextToken()).trim());
 }
 
 System.out.println("<br>items : "+items);
 
 if(items!=null && items.size()>0){
     
     System.out.println("<br>items size : "+items.size());
     
     for(int i=0; i<items.size(); i++){
         
         String itemx = (String)items.get(i);
         System.out.println("<br>item "+i+" : "+itemx);
         
         StringTokenizer strTokx = new StringTokenizer(itemx, ",");
         Vector temp = new Vector();
         while(strTokx.hasMoreElements()){     
             temp.add(((String)strTokx.nextToken()).trim());
         }
         
         if(temp!=null && temp.size()==2){
            String barcode = (String)temp.get(0);
            double qty = Integer.parseInt((String)temp.get(1));
            
            String where = "barcode='"+barcode+"' or barcode_2='"+barcode+"' or barcode_3='"+barcode+"'";
            
            System.out.println("where : "+where);
            
            Vector itm = DbItemMaster.list(0,1, where, "");
            ItemMaster im = new ItemMaster();
            if(itm!=null && itm.size()>0){
                im = (ItemMaster)itm.get(0); 
                
                System.out.println("item found barcode : "+barcode+", id : "+im.getOID());
                                         
                if(im.getOID()!=0){            
                    where = "opname_id="+oidOpname+" and sub_location_id="+oidSubLoc+
                            " and opname_sub_location_id="+oidOpnameSubLoc+
                            " and item_master_id="+im.getOID();

                    Vector ops = DbOpnameItem.list(0, 1, where, "");
                    
                    System.out.println("where : "+where);
                    System.out.println("opname item : "+ops);
                    
                    OpnameItem oi = new OpnameItem();
                    if(ops!=null && ops.size()>0){
                        oi = (OpnameItem)ops.get(0);
                        oi.setQtyReal(oi.getQtyReal()+qty);//jumlahkan kalau ketemu barang yg sama
                        try{
                            long oid = DbOpnameItem.updateExc(oi);
                            System.out.println("updating ok");
                        }
                        catch(Exception e){                            
                        }
                    }
                    else{
                        oi.setOpnameId(oidOpname);
                        oi.setSubLocationId(oidSubLoc);
                        oi.setOpnameSubLocationId(oidOpnameSubLoc);
                        oi.setItemMasterId(im.getOID());
                        oi.setQtyReal(qty);
                        oi.setDate(new Date());
                        oi.setType(0);
                        oi.setNote("opname by barcode reader");
                        try{
                            long oid = DbOpnameItem.insertExc(oi);
                            System.out.println("updating ok");
                        }
                        catch(Exception e){                            
                        }
                    }
                }
            }
            else{
                System.out.println("barcode : "+barcode+", item not found");
            }
         }
     }
 }
 
 
 //tidur sebentar sambil menunggu file baru tercreate dengan 
 //lengkap di image cache 
 Thread th = new Thread();
 th.sleep(1000);

 response.sendRedirect(approot+"/postransaction/opnameitem.jsp?hidden_opname_id="+oidOpname+"&hidden_opname_sub_id="+oidOpnameSubLoc);
 
 %>
