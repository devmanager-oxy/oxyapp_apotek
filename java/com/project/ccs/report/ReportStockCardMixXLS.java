/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;


import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbUom;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.posmaster.Uom;
import com.project.ccs.postransaction.stock.DbStock;
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
import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.crm.project.*;
import com.project.ccs.session.ReportStockParameter;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.ccs.session.*;

/**
 *
 * @author Roy Andika
 */
public class ReportStockCardMixXLS extends HttpServlet {

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

    String XMLSafe(String in) {
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

        response.setContentType("application/x-msexcel");

        // Company Id        
        ReportStockParameter rsp = new ReportStockParameter();
        HttpSession session = request.getSession();
        long vendorId = Long.parseLong(""+session.getValue("SRC_VENDOR")) ;
        long groupId = Long.parseLong(""+session.getValue("SRC_ITEM_GROUP")) ;
        try {
            rsp = (ReportStockParameter) session.getValue("RPT_PARAMETER");
        } catch (Exception e) {
        }

        String whereClause = "";
        
        if (rsp.getCode() != null && rsp.getCode().length() > 0){
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            //whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + rsp.getCode() + "%'";
            whereClause = whereClause + " (" + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + rsp.getCode() + "%' or " + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " like '%" + rsp.getCode() + "%') ";
            
        }

        if (rsp.getName() != null && rsp.getName().length() > 0){
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + rsp.getName() + "%'";
        }
        
        if(vendorId!=0){
                if(whereClause.length()>0){
                    whereClause = whereClause +" and ";
                }
                whereClause= whereClause + " pos_vendor_item.vendor_id=" + vendorId;
        }
       if(groupId!=0){
                if(whereClause.length()>0){
                    whereClause = whereClause +" and ";
                }
                whereClause= whereClause + " pos_item_master.item_group_id=" + groupId;
        }
        
        Vector listReport = new Vector();
        if(vendorId!=0){
                listReport = DbItemMaster.listByVendor(0,0, whereClause , "pos_item_master.item_category_id");
        }else{
                listReport = DbItemMaster.list(0,0, whereClause , "item_category_id");
        }
        
       
        
        String strPeriode = "" + JSPFormater.formatDate(rsp.getStartDate(), "dd MMM yyyy") + " S/D " + JSPFormater.formatDate(rsp.getEndDate(), "dd MMM yyyy");
        Company cmp = new Company();
        try {
            Vector listCompany = DbCompany.list(0, 0, "", "");
            if (listCompany != null && listCompany.size() > 0) {
                cmp = (Company) listCompany.get(0);
            }
        } catch (Exception ext) {
            System.out.println(ext.toString());
        }

        boolean gzip = false;

        OutputStream gzo;
        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }
        
        PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));

        wb.println("      <?xml version=\"1.0\"?>");        
	wb.println("      <?mso-application progid=\"Excel.Sheet\"?>");
	wb.println("      <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
	wb.println("      xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
	wb.println("      xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
	wb.println("      xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
	wb.println("      xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
	wb.println("      <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
	wb.println("      <Author>PNCI</Author>");
	wb.println("      <LastAuthor>PNCI</LastAuthor>");
	wb.println("      <Created>2013-04-04T07:12:43Z</Created>");
	wb.println("      <Company>PNCI</Company>");
	wb.println("      <Version>12.00</Version>");
	wb.println("      </DocumentProperties>");
	wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
	wb.println("      <WindowHeight>8895</WindowHeight>");
	wb.println("      <WindowWidth>18975</WindowWidth>");
	wb.println("      <WindowTopX>120</WindowTopX>");
	wb.println("      <WindowTopY>120</WindowTopY>");
	wb.println("      <ProtectStructure>False</ProtectStructure>");
	wb.println("      <ProtectWindows>False</ProtectWindows>");
	wb.println("      </ExcelWorkbook>");
	wb.println("      <Styles>");
	wb.println("      <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      <Interior/>");
	wb.println("      <NumberFormat/>");
	wb.println("      <Protection/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s62\">");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      </Borders>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s63\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      </Borders>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s65\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      </Borders>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s66\">");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
	wb.println("      ss:Bold=\"1\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s68\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      </Borders>");
	wb.println("      <NumberFormat ss:Format=\"@\"/>");
	wb.println("      </Style>");
	wb.println("      </Styles>");
	wb.println("      <Worksheet ss:Name=\"Sheet1\">");
	wb.println("      <Table >");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"41.25\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"107.25\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"126\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"194.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"70\"/>");
        wb.println("      <Row >");
	wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      </Row>");        
        wb.println("      <Row >");
	wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">"+cmp.getName().toUpperCase()+"</Data></Cell>");
	wb.println("      </Row>");        
	wb.println("      <Row >");
	wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">STOCK CARD REPORT</Data></Cell>");
	wb.println("      </Row>");        
        wb.println("      <Row >");
	wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">"+strPeriode+"</Data></Cell>");
	wb.println("      </Row>");        
        wb.println("      <Row >");
	wb.println("      <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      </Row>");
        
        if(listReport != null && listReport.size() > 0){
	wb.println("      <Row >");
	wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">No</Data></Cell>");
        
	wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">Code</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">Barcode</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">Item Name</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">Total Stock</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s65\"><Data ss:Type=\"String\">Unit</Data></Cell>");
	wb.println("      </Row>");
        for(int i = 0 ; i < listReport.size(); i++){
            ItemMaster itemMaster = (ItemMaster) listReport.get(i);
            Uom uom = new Uom();
            try{
                uom =  DbUom.fetchExc(itemMaster.getUomStockId());
            }catch(Exception ex){
                
            }
            int page = i+1;
            
	wb.println("      <Row>");
	wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"Number\">"+page+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">"+itemMaster.getCode().toString()+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">"+itemMaster.getBarcode().toString()+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">"+itemMaster.getName()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">"+""+SessStockCardByDate.getItemTotalStock(rsp.getLocationId(), itemMaster.getOID(),JSPFormater.formatDate(rsp.getEndDate(), "yyyy-MM-dd"))+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">"+uom.getUnit()+"</Data></Cell>");
	wb.println("      </Row>");
        }
        }
	
	wb.println("      </Table>");
	wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
	wb.println("      <PageSetup>");
	wb.println("      <Header x:Margin=\"0.3\"/>");
	wb.println("      <Footer x:Margin=\"0.3\"/>");
	wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
	wb.println("      </PageSetup>");
	wb.println("      <Print>");
	wb.println("      <ValidPrinterInfo/>");
	wb.println("      <HorizontalResolution>300</HorizontalResolution>");
	wb.println("      <VerticalResolution>300</VerticalResolution>");
	wb.println("      </Print>");
	wb.println("      <Selected/>");
	wb.println("      <Panes>");
	wb.println("      <Pane>");
	wb.println("      <Number>3</Number>");
	wb.println("      <ActiveRow>13</ActiveRow>");
	wb.println("      <ActiveCol>3</ActiveCol>");
	wb.println("      </Pane>");
	wb.println("      </Panes>");
	wb.println("      <ProtectObjects>False</ProtectObjects>");
	wb.println("      <ProtectScenarios>False</ProtectScenarios>");
	wb.println("      </WorksheetOptions>");
	wb.println("      </Worksheet>");
	wb.println("      <Worksheet ss:Name=\"Sheet2\">");
	wb.println("      <Table >");
	wb.println("      </Table>");
	wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
	wb.println("      <PageSetup>");
	wb.println("      <Header x:Margin=\"0.3\"/>");
	wb.println("      <Footer x:Margin=\"0.3\"/>");
	wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
	wb.println("      </PageSetup>");
	wb.println("      <ProtectObjects>False</ProtectObjects>");
	wb.println("      <ProtectScenarios>False</ProtectScenarios>");
	wb.println("      </WorksheetOptions>");
	wb.println("      </Worksheet>");
	wb.println("      <Worksheet ss:Name=\"Sheet3\">");
	wb.println("      <Table >");
	wb.println("      </Table>");
	wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
	wb.println("      <PageSetup>");
	wb.println("      <Header x:Margin=\"0.3\"/>");
	wb.println("      <Footer x:Margin=\"0.3\"/>");
	wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
	wb.println("      </PageSetup>");
	wb.println("      <ProtectObjects>False</ProtectObjects>");
	wb.println("      <ProtectScenarios>False</ProtectScenarios>");
	wb.println("      </WorksheetOptions>");
	wb.println("      </Worksheet>");
	wb.println("      </Workbook>");


        wb.flush();
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

    public static void main(String[] arg) {
        try {
            String str = "";
            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
