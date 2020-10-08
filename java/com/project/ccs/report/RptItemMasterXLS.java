/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
 */

package com.project.ccs.report;

import com.project.ccs.posmaster.DbItemCategory;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbPriceType;
import com.project.ccs.posmaster.DbUom;
import com.project.ccs.posmaster.DbVendorItem;
import com.project.ccs.posmaster.ItemCategory;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.posmaster.PriceType;
import com.project.ccs.posmaster.Uom;
import com.project.ccs.posmaster.VendorItem;
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

public class RptItemMasterXLS extends HttpServlet {
    
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
        
        //RptIRSupplier rptKonstan = new RptIRSupplier();
        try{
            HttpSession session = request.getSession();
            //rptKonstan = (RptIRSupplier)session.getValue("KONSTAN");
        }catch(Exception ex){
            System.out.println(ex.toString());
        }
        
        String whereClause = "";
        String orderClause = "";
        long srcVendorId = 0;
        
        Vector vDetail = new Vector();
        try{
            HttpSession session = request.getSession();
            vDetail = (Vector)session.getValue("DETAIL");
            if(vDetail!=null && vDetail.size()==3){
                whereClause = (String)vDetail.get(0);
                orderClause = (String)vDetail.get(1);
                srcVendorId = Long.parseLong((String)vDetail.get(2));
            }
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
        if(srcVendorId!=0){
            vDetail = DbItemMaster.listByVendor(0,0, whereClause , orderClause);
        }else{
            vDetail = DbItemMaster.list(0,0, whereClause , orderClause);
        }
        
        
        
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
        wb.println("<LastPrinted>2009-08-06T06:07:58Z</LastPrinted>");
        wb.println("<Created>1996-10-14T23:33:28Z</Created>");
        wb.println("<LastSaved>2009-08-06T06:11:49Z</LastSaved>");
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
 
        wb.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat/>");
        wb.println("<Protection/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175646\">");
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
        wb.println("<Style ss:ID=\"m25175656\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m25175666\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
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
        wb.println("<Style ss:ID=\"s27\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s28\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s29\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s30\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s31\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s32\">");
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
        wb.println("<Style ss:ID=\"s42\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s43\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s44\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");
 
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        //wb.println("<Table ss:ExpandedColumnCount=\"20\"  x:FullColumns=\"1\"");
        wb.println("<Table ss:ExpandedColumnCount=\"30\"  x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"4.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//no
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"70\"/>");//barcode
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//sku
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"200\"/>");//name
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"150\"/>");//supplier
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//lastprice
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//gol1
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//m1
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//gol2
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//m2
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//gol3
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//m3
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//gol4
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//m4
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//gol5
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//m5
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//gol6
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//m6
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//gol7
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//m7
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//gol8
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//m8
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//gol9
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//m9
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//gol10
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//m10
        
        
        
        
        wb.println("<Row ss:Index=\"2\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"14\" ss:StyleID=\"s43\"><Data ss:Type=\"String\">DAFTAR BARANG</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"14\" ss:StyleID=\"s44\"><Data ss:Type=\"String\">"+cmp.getName()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        
        wb.println("<Row ss:AutoFitHeight=\"0\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"14\" ss:StyleID=\"s42\"><Data ss:Type=\"String\">"+cmp.getAddress()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("</Row>");
        
        wb.println("<Row ss:AutoFitHeight=\"0\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"8\" ss:StyleID=\"s42\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("</Row>");
       
            
           wb.println("<Row>");
           wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">No</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">BARCODE</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">SKU</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">ITEM NAME</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">SUPPLIER</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">LAST PRICE</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">GOL1</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">M1</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">GOL2</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">M2</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">GOL3</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">M3</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">GOL4</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">M4</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">GOL5</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">M5</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">GOL6</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">M6</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">GOL7</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">M7</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">GOL8</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">M8</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">GOL9</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">M9</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">GOL10</Data></Cell>");
           wb.println("<Cell ss:StyleID=\"m25175646\"><Data ss:Type=\"String\">M10</Data></Cell>");
           wb.println("</Row>");
       
        
        //double tt = 0; 
        //double tamount=0;
        //double tdis=0;
        //m25175646
        
        if(vDetail!=null && vDetail.size()>0){
            
            System.out.println("loop - vDetail.size() : "+vDetail.size());
            
            for(int i=0;i<vDetail.size();i++){
                //RptIRSupplierL detail = (RptIRSupplierL)vDetail.get(i);
                //RptItemMasterL detail = (RptItemMasterL)vDetail.get(i);
                
                ItemMaster itemMaster = (ItemMaster)vDetail.get(i);
                
                System.out.println("loop - i : "+i);
                
                /*ItemGroup ig = new ItemGroup();
                try{
                        ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                }
                catch(Exception e){
                }
                ItemCategory ic = new ItemCategory();
                try{
                        ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
                }
                catch(Exception e){
                }
                Uom uo = new Uom();
                try{
                        uo = DbUom.fetchExc(itemMaster.getUomStockId());
                }
                catch(Exception e){
                }
                 */ 
                Vendor vnd = new Vendor();
                try{
                        vnd = DbVendor.fetchExc(itemMaster.getDefaultVendorId());
                }
                catch(Exception e){
                }
                Vector vItem = new Vector();
                vItem= DbVendorItem.list(0, 0, "vendor_id=" + itemMaster.getDefaultVendorId() + " and item_master_id="+ itemMaster.getOID(), "");
                VendorItem vendorItem = new VendorItem();
                if(vItem.size()>0){
                    vendorItem = (VendorItem)vItem.get(0);
                }
                
                Vector vp = new Vector();
                vp = DbPriceType.list(0, 0, "item_master_id="+ itemMaster.getOID(), "");
                PriceType pt = new PriceType();
                if(vp.size()>0 && vp.isEmpty()== false ){
                    pt = (PriceType) vp.get(0);
                }
                
                /*wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s29\"><Data ss:Type=\"Number\">"+(i+1)+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m25175656\"><Data ss:Type=\"String\">"+detail.getBarcode()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m25175656\"><Data ss:Type=\"String\">"+detail.getCode()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m25175656\"><Data ss:Type=\"String\">"+detail.getName()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m25175656\"><Data ss:Type=\"String\">"+detail.getVendor()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getLastPrice(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getGol1(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getMGol1(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getGol2(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getMGol2(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getGol3(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getMGol3(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getGol4(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getMGol4(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getGol5(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(detail.getMGol5(), "##,###.##")+"</Data></Cell>");
                                
                wb.println("</Row>");
                 */
                wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s29\"><Data ss:Type=\"Number\">"+(i+1)+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m25175656\"><Data ss:Type=\"String\">"+itemMaster.getBarcode()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m25175656\"><Data ss:Type=\"String\">"+itemMaster.getCode()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m25175656\"><Data ss:Type=\"String\">"+itemMaster.getName()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"m25175656\"><Data ss:Type=\"String\">"+vnd.getName()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(vendorItem.getLastPrice(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol1(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol1_margin(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol2(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol2_margin(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol3(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol3_margin(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol4(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol4_margin(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol5(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol5_margin(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol6(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol6_margin(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol7(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol7_margin(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol8(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol8_margin(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol9(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol9_margin(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol10(), "##,###.##")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(pt.getGol10_margin(), "##,###.##")+"</Data></Cell>");                                
                wb.println("</Row>");
                
                wb.flush() ;
                
               // tt = tt + detail.getTotalAmount();
                //tamount =  tamount + detail.getAmount();
            }
        }
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"3.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("</Row>");
        
        //wb.println("<Row>");
        //wb.println("<Cell ss:Index=\"4\" ss:MergeAcross=\"1\" ss:StyleID=\"m25175666\"><Data");
        //wb.println("ss:Type=\"String\">Total</Data></Cell>");
       // wb.println("<Cell ss:StyleID=\"s32\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(tamount,"##,###.##")+"</Data></Cell>");
        //wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s32\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(tt,"##,###.##")+"</Data></Cell>");
       // wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s24\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
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
        wb.println("<ActiveCol>5</ActiveCol>");
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
