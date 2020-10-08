/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
 */

package com.project.ccs.report;

import com.project.ccs.posmaster.DbItemCategory;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemCategory;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.opname.*;
import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.util.Vector;
import java.net.URLEncoder;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.util.JSPFormater;
//import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.fms.activity.*;
import com.project.general.*;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.sql.*;


public class RptOpnameSumaryByGroupXLS1 extends HttpServlet {
    
    /** Initializes the servlet.
    */  
    public static String formatDate = "dd MMMM yyyy";
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
    */  
    public void destroy() {

    }

    String XMLSafe ( String in )
    {
        return in;
    	//return HTMLEncoder.encode(in);
    }
    
    public Vector getGroupDistinct(long oidOpname){ 
	
		if(oidOpname!=0){
			String sql = "select distinct item_group_id, item_category_id  from pos_closing_opname co "+
				" inner join pos_item_master im on im.item_master_id=co.item_master_id where opname_id="+oidOpname+
				" order by item_group_id, item_category_id";
			
                        System.out.println(sql); 
                        
			CONResultSet crs = null;
			Vector list = new Vector();
			try {
				crs = CONHandler.execQueryResult(sql);
				java.sql.ResultSet rs = crs.getResultSet();
				while (rs.next()) {
					Vector temp = new Vector();
					String groupId = rs.getString("item_group_id");
					String catId = rs.getString("item_category_id");
					temp.add(groupId);
					temp.add(catId);
					list.add(temp);
				}
			} catch (Exception e) {
				System.out.println(e.toString());
			} finally {
				CONResultSet.close(crs);
			}
			
			Vector grps = new Vector();
			if(list!=null && list.size()>0){
				long prevId = 0;
				for(int i=0; i<list.size(); i++){
					Vector xtemp = (Vector)list.get(i);
					long grId = Long.parseLong((String)xtemp.get(0));
					if(prevId!=grId){
						prevId = grId;
						grps.add(""+prevId);
					}					
				}
			}
			
			Vector temp = new Vector();
			temp.add(grps);
			temp.add(list);
			
			return temp;	
		}
		else{
			return new Vector();
		}

	} 
	
	public Vector getCategories(long grpId, Vector list){
		Vector result = new Vector();
		if(grpId!=0 && list!=null){
			for(int i=0; i<list.size(); i++){
				Vector xtemp = (Vector)list.get(i);
				long grId = Long.parseLong((String)xtemp.get(0));
				long catId = Long.parseLong((String)xtemp.get(1));
				if(grpId==grId){
					result.add(""+catId);
				}
			}
		}
		return result;
	}
	
	
        public Vector getClosingOpname(long opnameId, long groupId, long catId){ 
	
		String sql = "select item_master_id, sum(totreal) as totalreal, sum(totclosing) as totalclosing, (sum(totreal)-sum(totclosing)) as selisih, "+
				" hpokok, hjual, ((sum(totreal)-sum(totclosing))* hpokok) as selisihhpp, "+
				" ((sum(totreal)-sum(totclosing))* hjual) as selisihjual  from ((select item_master_id, 0 as totreal, sum(qty) as totclosing, "+
				" hpp as hpokok, harga_jual as hjual from pos_closing_opname where opname_id="+opnameId+
				" and (item_master_id in (select item_master_id from pos_item_master where item_group_id="+groupId+" and item_category_id="+catId+")) "+
				" group by item_master_id) union (select item_master_id, sum(qty_real) as totreal, 0 as totclosing, 0 as hpokok, 0 as hjual "+
				" from pos_opname_item where opname_id="+opnameId+
				" and (item_master_id in (select item_master_id from pos_item_master where item_group_id="+groupId+" and item_category_id="+catId+")) "+
				" group by item_master_id)) as tabel group by item_master_id"; 
				
		CONResultSet dbrs = null;
        
                System.out.println(sql);
                
                Vector vsum = new Vector();
                try {

                    dbrs = CONHandler.execQueryResult(sql);
                    java.sql.ResultSet rs = dbrs.getResultSet();

                    while (rs.next()){
                        Vector vdet = new Vector();
                        vdet.add(rs.getLong(1));
                        vdet.add(rs.getDouble(2));
                        vdet.add(rs.getDouble(3));
                        vdet.add(rs.getDouble(4));
                        vdet.add(rs.getDouble(5));
                        vdet.add(rs.getDouble(6));
                        vdet.add(rs.getDouble(7));
                        vdet.add(rs.getDouble(8));
                        vsum.add(vdet);

                    }

                    rs.close();

                } catch (Exception e) {
                    return new Vector();
                } finally {
                    CONResultSet.close(dbrs);
                }
				
		return vsum;		
	
	}
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
    * @param request servlet request
    * @param response servlet response
    * 
    * Why not use a DOM? Because we want to be able to create the spreadsheet on-the-fly, without
    * having to use up a lot of memory before hand
    */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        System.out.println("---===| Excel Report |===---");
        response.setContentType("application/x-msexcel");
        
        Company cmp = new Company();
        try{
            Vector listCompany = DbCompany.list(0,0, "", "");
            if(listCompany!=null && listCompany.size()>0){
                cmp = (Company)listCompany.get(0);
            }
        }catch(Exception ext){
            System.out.println(ext.toString());
        }
        
        //RptStockOpname rptKonstan = new RptStockOpname();
        long oidOpname=0;
        //OpnameSubLocation opSubLoc = new OpnameSubLocation();
        //SubLocation subLoc = new SubLocation();
        Location loc = new Location();
        Opname opname = new Opname();
        try{
            HttpSession session = request.getSession();
            oidOpname =  (Long)session.getValue("DETAIL");
            opname = DbOpname.fetchExc(oidOpname);
            loc = DbLocation.fetchExc(opname.getLocationId());
            
        }catch(Exception ex){
            System.out.println(ex.toString());
        }
        
        Vector vOpitem= new Vector();
                
        vOpitem =  DbClosingOpname.getDetailTotalSummary(oidOpname);
               
        
        
        boolean gzip = false ;
        
        //response.setCharacterEncoding( "UTF-8" ) ;
        OutputStream gzo ;
        if ( gzip ) {
            response.setHeader( "Content-Encoding", "gzip" ) ;
            gzo = new GZIPOutputStream( response.getOutputStream() ) ;
        } else {
            gzo = response.getOutputStream() ;
        }
        PrintWriter wb = new PrintWriter( new OutputStreamWriter( gzo, "UTF-8" ) ) ;

        //PrintWriter wb = response.getWriter() ;
        wb.println("<?xml version=\"1.0\"?>");
        wb.println("<?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<LastAuthor>Victor</LastAuthor>");
        wb.println("<LastPrinted>2009-07-21T06:26:34Z</LastPrinted>");
        wb.println("<Created>1996-10-14T23:33:28Z</Created>");
        wb.println("<LastSaved>2009-07-21T06:27:07Z</LastSaved>");
        wb.println("<Version>11.5606</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>9300</WindowHeight>");
        wb.println("<WindowWidth>15135</WindowWidth>");
        wb.println("<WindowTopX>120</WindowTopX>");
        wb.println("<WindowTopY>120</WindowTopY>");
        wb.println("<AcceptLabelsInFormulas/>");
        wb.println("<ProtectStructure>False</ProtectStructure>");
        wb.println("<ProtectWindows>False</ProtectWindows>");
        wb.println("</ExcelWorkbook>");
        wb.println("<Styles>");
        wb.println("<Style ss:ID=\"m56488220\">");
        wb.println("   <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("   <Interior ss:Color=\"#EBF1DE\" ss:Pattern=\"Solid\"/>");
        wb.println("  </Style>");
        wb.println("<Style ss:ID=\"m56488240\">");
        wb.println("   <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("   <Interior ss:Color=\"#FDE9D9\" ss:Pattern=\"Solid\"/>");
        wb.println("  </Style>");
        wb.println(" <Style ss:ID=\"s147\">");
        wb.println("    <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("    <Borders>");
        wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    </Borders>");
        wb.println("    <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("    <Interior ss:Color=\"#FDE9D9\" ss:Pattern=\"Solid\"/>");
        wb.println("   </Style>");
        wb.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat/>");
        wb.println("<Protection/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175768\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s21\">");
        wb.println("<Borders/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s22\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s23\">");
        wb.println("<Alignment ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s24\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s25\">");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s26\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s26x\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s27\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s28\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s29\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s30\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s40\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s41\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s42\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s43\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s50\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s51\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        //wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s52\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        
        wb.println("<Table ss:ExpandedColumnCount=\"60\"  x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"24.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"30\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"55\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"45\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"65\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"200.75\"/>");
       // for(int i=0;i<vopsubLoc.size();i++){
           // wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");
        //}
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"65\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"65\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"65\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"65\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"65\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"100\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"120\"/>");
        
        
        //wb.println("<Column ss:Index=\"8\" ss:AutoFitWidth=\"0\" ss:Width=\"33\"/>");
        wb.println("<Row ss:Index=\"2\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s40\"><Data ss:Type=\"String\">STOCK OPNAME</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">"+cmp.getName()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s42\"><Data ss:Type=\"String\">"+cmp.getAddress()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("</Row>");
        wb.println("<Row ss:Index=\"6\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Opname Number</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">: "+opname.getNumber()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Date</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">: "+JSPFormater.formatDate(opname.getDate(), "dd/MM/yyyy")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
       
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Location</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">: "+loc.getName()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("</Row>");
        
        
        
            //OpnameSubLocation opSubloc = (OpnameSubLocation)vopsubLoc.get(a);
            //vOpitem = DbOpnameItem.list(0, 0, DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_SUB_LOCATION_ID]+ "=" + opSubloc.getOID(), "");
            
            
        
            //wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"6.75\"/>");
            wb.println("<Row>");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s26\"><Data ss:Type=\"String\">No</Data></Cell>");
            wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s26\"><Data ss:Type=\"String\">SKU/Code</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Barcode</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Item Name</Data></Cell>");
           // SubLocation subLoc = new SubLocation();
           // for(int a=0;a<vopsubLoc.size();a++){
           //     OpnameSubLocation opSub = (OpnameSubLocation)vopsubLoc.get(a);
            //    try{
            ///        subLoc = DbSubLocation.fetchExc(opSub.getSubLocationId());
            //        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">"+subLoc.getName()+"</Data></Cell>");
             //   }catch(Exception ex){
                    
             //   }
                
           // }
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Total Real</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Qty System</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Selisih Stock</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Hpp</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Harga Jual</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Total Selisih Hpp</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Total Selisih Harga Jual</Data></Cell>");
            wb.println("</Row>");

            
            Vector tempGroupX = getGroupDistinct(oidOpname);
            Vector tempGroup = (Vector)tempGroupX.get(0);
            Vector listAllCats = (Vector)tempGroupX.get(1);
            
            long currIgId = 0;
            long prevGrId = 0;
            boolean isIgChanged = true;
            double finalTotQtyReal = 0;
            double finalTotQtySystem = 0;
            double finalTotQtySelisih = 0;
            double finalTotSelisihHpp = 0;
            double finalTotSelisihHJual = 0;


            for(int i=0; i<tempGroup.size(); i++){

                double grnTotQtyReal = 0;
                double grnTotQtySystem = 0;
                double grnTotQtySelisih = 0;
                double grnTotSelisihHpp = 0;
                double grnTotSelisihHJual = 0;

                //Vector temp = (Vector)tempGroup.get(i);
                long groupId = Long.parseLong((String)tempGroup.get(i));

                ItemGroup ig = new ItemGroup();
                try{
                                ig = DbItemGroup.fetchExc(groupId);
                }
                catch(Exception e){
                }
                
                wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"> GROUP :"+ig.getName()+"</Data></Cell>");
                //wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("</Row>");
                
                Vector categories = getCategories(groupId, listAllCats);

                if(categories!=null && categories.size()>0){

                for(int ax=0; ax<categories.size(); ax++){

                        long catId = Long.parseLong((String)categories.get(ax));

                        ItemCategory ic = new ItemCategory();
                        try{
                                        ic = DbItemCategory.fetchExc(catId);
                        }
                        catch(Exception e){
                        }
                        
                        wb.println("<Row>");
                        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"> CATEGORY :"+ic.getName()+"</Data></Cell>");
                        //wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                        wb.println("</Row>");
            
                        Vector closingStock = getClosingOpname(oidOpname, groupId, catId);
											  
                        if(closingStock!=null && closingStock.size()>0){

                            double subTotQtyReal = 0; 
                            double subTotQtySystem = 0;
                            double subTotQtySelisih = 0;
                            double subTotSelisihHpp = 0;
                            double subTotSelisihHJual = 0;

                            for(int x=0; x<closingStock.size(); x++){

                                    Vector vDet = new Vector();
                                    vDet = (Vector) closingStock.get(x);
                                    ItemMaster im = new ItemMaster();

                                    try{
                                            im = DbItemMaster.fetchExc( Long.valueOf(vDet.get(0).toString()));
                                    }catch(Exception ex){

                                    }
                                    
                                    double totalqty=0;
                                    double grantotalreal=Double.parseDouble(vDet.get(1).toString());
                                    double qtyClosing= Double.parseDouble(vDet.get(2).toString());//DbClosingOpname.getTotalQtyClosing(im.getOID(), oidOpname, opname.getLocationId());
                                    double cogs=Double.parseDouble(vDet.get(4).toString());//DbClosingOpname.getCogs(im.getOID(), oidOpname);
                                    double hargaJual = Double.parseDouble(vDet.get(5).toString());//DbClosingOpname.getHargaJual(im.getOID(), oidOpname);
                                    
                                    subTotQtyReal = subTotQtyReal + grantotalreal;
                                    subTotQtySystem = subTotQtySystem + qtyClosing;
                                    subTotQtySelisih = subTotQtySelisih + (grantotalreal - qtyClosing);
                                    subTotSelisihHpp = subTotSelisihHpp + (cogs*(grantotalreal - qtyClosing));
                                    subTotSelisihHJual = subTotSelisihHJual + (hargaJual*(grantotalreal - qtyClosing));

                                    grnTotQtyReal = grnTotQtyReal + grantotalreal;
                                    grnTotQtySystem = grnTotQtySystem + qtyClosing;
                                    grnTotQtySelisih = grnTotQtySelisih + (grantotalreal - qtyClosing);
                                    grnTotSelisihHpp = grnTotSelisihHpp + (cogs*(grantotalreal - qtyClosing));
                                    grnTotSelisihHJual = grnTotSelisihHJual + (hargaJual*(grantotalreal - qtyClosing));

                                    finalTotQtyReal = finalTotQtyReal + grantotalreal; 
                                    finalTotQtySystem = finalTotQtySystem + qtyClosing;
                                    finalTotQtySelisih = finalTotQtySelisih + (grantotalreal - qtyClosing);
                                    finalTotSelisihHpp = finalTotSelisihHpp + (cogs*(grantotalreal - qtyClosing));
                                    finalTotSelisihHJual = finalTotSelisihHJual + (hargaJual*(grantotalreal - qtyClosing));

                                    wb.println("<Row>");
                                    wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+(1+x)+"</Data></Cell>");
                                    wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+im.getCode()+"</Data></Cell>");
                                    wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+im.getBarcode()+"</Data></Cell>");
                                    wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+im.getName()+"</Data></Cell>");
                                    wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(Double.parseDouble(vDet.get(1).toString()), "###.##")+"</Data></Cell>");
                                    wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(Double.parseDouble(vDet.get(2).toString()), "###.##")+"</Data></Cell>");
                                    wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(Double.parseDouble(vDet.get(3).toString()), "###.##")+"</Data></Cell>");
                                    //wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+vDet.get(4)+"</Data></Cell>");
                                    //wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+vDet.get(5)+"</Data></Cell>");
                                    //wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+vDet.get(6).toString()+"</Data></Cell>");
                                    //wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+vDet.get(7).toString()+"</Data></Cell>");
                                    wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(Double.parseDouble(vDet.get(4).toString()), "###.##")+"</Data></Cell>");
                                    wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(Double.parseDouble(vDet.get(5).toString()), "###.##")+"</Data></Cell>");
                                    wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(Double.parseDouble(vDet.get(6).toString()),"###.##")+"</Data></Cell>");
                                    wb.println("<Cell ss:StyleID=\"s51\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(Double.parseDouble(vDet.get(7).toString()),"###.##")+"</Data></Cell>");
                                    wb.println("</Row>");
                            }
                            //end per cat sub tulis total
                            
                            wb.println("<Row>");
                            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s50\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s28\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"> TOTAL CATEGORY :"+ic.getName()+"</Data></Cell>");
                            wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(subTotQtyReal,"###.##")+"</Data></Cell>");
                            wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(subTotQtySystem,"###.##")+"</Data></Cell>");
                            wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(subTotQtySelisih,"###.##")+"</Data></Cell>");
                            wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"String\"></Data></Cell>");
                            wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(subTotSelisihHpp,"###.##")+"</Data></Cell>");
                            wb.println("<Cell ss:StyleID=\"m56488240\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(subTotSelisihHJual,"###.##")+"</Data></Cell>");
                            wb.println("</Row>");
                            
                        }//end per cat sub tulis total
                        
                    }//end categories
                    
                    wb.println("<Row>");
                    wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s50\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s28\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"> TOTAL GROUP :"+ig.getName()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(grnTotQtyReal,"###.##")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(grnTotQtySystem,"###.##")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(grnTotQtySelisih,"###.##")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(grnTotSelisihHpp,"###.##")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"m56488220\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(grnTotSelisihHJual,"###.##")+"</Data></Cell>");
                    wb.println("</Row>");
                    
                }
                
                
                
                /*Vector vTot = new Vector();
                vTot = DbClosingOpname.getTotalSummary(oidOpname);
                
                wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s50\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:MergeAcross=\"8\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
                    
                wb.println("<Cell ss:StyleID=\"s52\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(Double.parseDouble(vTot.get(0).toString()),"#,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s52\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(Double.parseDouble(vTot.get(1).toString()),"#,###.##")+"</Data></Cell>");
                wb.println("</Row>");
                 */ 
                
                
            }
            
            wb.println("<Row>");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s26\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s26\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\"> GRAND TOTAL </Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26x\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(finalTotQtyReal,"###.##")+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26x\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(finalTotQtySystem,"###.##")+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26x\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(finalTotQtySelisih,"###.##")+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26x\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(finalTotSelisihHpp,"###.##")+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s26x\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(finalTotSelisihHJual,"###.##")+"</Data></Cell>");
            wb.println("</Row>");

            
            
            wb.println("<Row>");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s21\"/>");
            wb.println("<Cell ss:StyleID=\"s21\"/>");
            wb.println("<Cell ss:StyleID=\"s21\"/>");
            wb.println("<Cell ss:StyleID=\"s21\"/>");
            wb.println("<Cell ss:StyleID=\"s21\"/>");
            wb.println("<Cell ss:StyleID=\"s21\"/>");
            wb.println("</Row>");
        
        /*
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"3\" ss:MergeAcross=\"2\" ss:StyleID=\"m25175768\"><Data");
        wb.println("ss:Type=\"String\">Total</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s30\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalQtySystem()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s30\"><Data ss:Type=\"Number\">"+rptKonstan.getTotalQtyReal()+"</Data></Cell>");
        wb.println("</Row>");
        */
        
        //=======penambahan batas
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        //=======end batas
        
        //wb.println("<Row>");
        //wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Notes </Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">:</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s25\"/>");
        //wb.println("<Cell ss:StyleID=\"s25\"/>");
        //wb.println("<Cell ss:StyleID=\"s25\"/>");
        //wb.println("</Row>");
        
        //wb.println("<Row>");
        ///wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        //wb.println("<Cell ss:StyleID=\"s25\"/>");
        //wb.println("<Cell ss:MergeAcross=\"3\" ss:StyleID=\"s43\"><Data ss:Type=\"String\">"+rptKonstan.getNotes()+"</Data></Cell>");
        //wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Location</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">Accounting</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">Supervisor</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">( "+loc.getName()+" )</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">( . . . . . . . . . . . . . . . . . . . . . . . )</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s27\"><Data ss:Type=\"String\">( . . . . . . . . . . . . . . . . . . . . . . . )</Data></Cell>");
        wb.println("</Row>");
        
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<DisplayPageBreak/>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<HorizontalResolution>600</HorizontalResolution>");
        wb.println("<VerticalResolution>600</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<DoNotDisplayGridlines/>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("<ActiveRow>12</ActiveRow>");
        wb.println("<ActiveCol>6</ActiveCol>");
        wb.println("</Pane>");
        wb.println("</Panes>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet2\">");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet3\">");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("</Workbook>");

        wb.flush() ;
    }
    
    
    /** Handles the HTTP <code>GET</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        processRequest(request, response);
    } 

    /** Handles the HTTP <code>POST</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Returns a short description of the servlet.
    */
    public String getServletInfo() {
        return "Short description";
    }
    
    public static void main(String[] arg){
        try{
            String str = "aku anak cerdas > pandai & rajin";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
    }

    
}
