<%@ page language = "java" %>
<%@ page import = "com.project.ccs.sql.*" %>

<%
	String locationId = request.getParameter("location_id");
	String command = request.getParameter("command");

	try{
		if(Integer.parseInt(command)==11){ // create file
			String fileName = "";
			String path = "//srv//tomcat5coco01//webapps//oxysystemcoco01//ims//oxydata//d_"+locationId+".txt";
			//String path = "D://tomcat//webapps//oxyminimarket//ims//oxydata//d_"+locationId+".txt";
			String sql = "select * from logs where table_name in('customer','pos_item_master'," +
				"'pos_price_type','pos_item_group','pos_unit','pos_location'," +
				"'member','sysuser','bank','pos_promotion','pos_promotion_item','pos_promotion_location','merchant') and DATE_SUB(CURDATE(),INTERVAL 14 DAY) <= date order by date asc";
			fileName = SQLGeneral.createExportFile(path,sql);
		}
	}catch(Exception e){
		
	}

%>