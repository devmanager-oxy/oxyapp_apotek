
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<% 
Vector userlist = DbUser.listFullObj(0, 0, "","","","");
Vector segment1s = DbSegmentDetail.list(0, 0, "", null);

if(userlist != null && userlist.size() > 0) {
    for(int i = 0; i < userlist.size() ; i++){
        User u = (User)userlist.get(i);
        
        if(u.getSegment1Id() == 0){
            if(segment1s != null && segment1s.size()> 0){                
                for(int x = 0; x < segment1s.size(); x++){
                    SegmentDetail sd = (SegmentDetail)segment1s.get(x);
                    SegmentUser su = new SegmentUser();
                    su.setUserId(u.getOID());
                    su.setSegmentDetailId(sd.getOID());
                    su.setLocationId(sd.getLocationId());
                    try{
                        DbSegmentUser.insertExc(su);
                    }catch(Exception e){}
                }
            }
            
        }else{
            SegmentUser su = new SegmentUser();
            su.setUserId(u.getOID());
            su.setSegmentDetailId(u.getSegment1Id());
            
            SegmentDetail sd = new SegmentDetail();
            try{
                sd = DbSegmentDetail.fetchExc(u.getSegment1Id());
                su.setLocationId(sd.getLocationId());
            }catch(Exception e){}
            try{
                DbSegmentUser.insertExc(su);
            }catch(Exception e){}
            
        }
        
    }
    
}


%>
