<%@ page language = "java" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%
	
	String strQuery = "";
	String command = request.getParameter("command");
	String fieldNames = request.getParameter("fieldnames");
       String start = request.getParameter("start_limit");
       String recordToGet = "3";//request.getParameter("record_limit");
	
	System.out.println("--- in download 1  : "+fieldNames );

	try{
		if(Integer.parseInt(command)==11){
			
			
				//long startx = System.currentTimeMillis();
                            //System.out.println("--- start x : "+startx);
				String sql = "select * from logs1 where table_name in('customer','sysuser') " +
				" and "+ fieldNames +"=0 order by date asc limit "+start+" , "+recordToGet;
				strQuery = SQLGeneral.createMasterUpdate(sql);
				
                                if(strQuery==null || strQuery.length()==0){

				sql = "select * from logs1 where table_name in('pos_shift','pos_price_type','pos_item_group','pos_unit','pos_location','currency','pos_item_category'," +
					"'pos_promotion','pos_promotion_item','pos_promotion_location'," +
					"'member','bank','merchant', 'pos_item_master') and query_string not like 'update pos_item_master%'" +
					" and "+ fieldNames +"=0 order by date asc limit "+start+" , "+recordToGet;

				strQuery = SQLGeneral.createMasterUpdate(sql);
			
				if(strQuery==null || strQuery.length()==0){
					
					//System.out.println("--- user kosong in item");

					sql = "select * from logs1 where table_name in('pos_item_master')" +				
						" and "+ fieldNames +"=0 order by date asc limit "+start+" , "+recordToGet;

					strQuery = SQLGeneral.createMasterUpdate(sql);

				}
				}
				//long endx = System.currentTimeMillis();
                            //System.out.println("--- end x : "+endx);
                            //System.out.println("--- durasi : "+(endx-startx));

		}
	}catch(Exception e){

	}

	//System.out.println("--- fieldNames > "+fieldNames+", strQuery : "+strQuery);

	
%>
<%=strQuery%>