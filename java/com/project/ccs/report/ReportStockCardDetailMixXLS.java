/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.adjusment.Adjusment;
import com.project.ccs.postransaction.adjusment.DbAdjusment;
import com.project.ccs.postransaction.costing.Costing;
import com.project.ccs.postransaction.costing.DbCosting;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.DbRetur;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.receiving.Retur;
import com.project.ccs.postransaction.repack.DbRepack;
import com.project.ccs.postransaction.repack.Repack;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.Sales;
import com.project.ccs.postransaction.stock.Stock;
import com.project.ccs.postransaction.transfer.DbTransfer;
import com.project.ccs.postransaction.transfer.Transfer;
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
import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
import com.project.main.db.*;
import java.sql.*;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class ReportStockCardDetailMixXLS extends HttpServlet {

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
    
    public Date getDateTime(long stockId){
	Date dt = new Date();
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT date FROM pos_stock where stock_id="+stockId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Date dtx = rs.getDate(1);
                Date tmx = rs.getTime(1);
                dt.setDate(dtx.getDate());
                dt.setMonth(dtx.getMonth());
                dt.setYear(dtx.getYear());
                dt.setHours(tmx.getHours());
                dt.setMinutes(tmx.getMinutes());
                dt.setSeconds(tmx.getSeconds());
                
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            
        }
        
        return dt;
    
    }
    
    public String getNumber(long salesId){ 

            String number = "";	

            if(salesId!=0){

                    String sql = "select number  from pos_sales where sales_id="+salesId;

                 System.out.println(sql); 

                    CONResultSet crs = null;
                    Vector list = new Vector();
                    try {
                            crs = CONHandler.execQueryResult(sql);
                            ResultSet rs = crs.getResultSet();
                            while (rs.next()) {
                                    number = rs.getString(1);		
                            }
                    } catch (Exception e) {
                            System.out.println(e.toString());
                    } finally {
                            CONResultSet.close(crs);
                    }


            }
            return number;

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
        Vector vStock = new Vector();

        try {
            rsp = (ReportStockParameter) session.getValue("RPT_PARAMETER_DETAIL_STOCK_CARD");
        } catch (Exception e) {
        }

        try {
            vStock = (Vector) session.getValue("RPT_DETAIL_STOCK_CARD");
        } catch (Exception e) {
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
        wb.println("      <Created>2013-04-05T02:22:58Z</Created>");
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
        wb.println("      <Style ss:ID=\"m68543584\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s68\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s69\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s71\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s77\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Short Date\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s79\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s90\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.0\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");

        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"37.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"91.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"96.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"78\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"91.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"89.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"85.5\"/>");

        Location location = new Location();
        ItemMaster im = new ItemMaster();

        try {
            location = DbLocation.fetchExc(rsp.getLocationId());
        } catch (Exception e) {
        }

        try {
            im = DbItemMaster.fetchExc(rsp.getItemMasterId());
        } catch (Exception e) {
        }

        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">LOCATION NAME : " + location.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">CODE : " + im.getCode().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">BARCODE : " + im.getBarcode().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">ITEM NAME : " + im.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">PERIODE : " + strPeriode + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Date</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Doc Number</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Description</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Status</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Qty In</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Qty Out</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Qty Saldo</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\" x:Ticked=\"1\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Stcok Before</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">" + rsp.getAmount() + "</Data></Cell>");
        wb.println("      </Row>");

        double qtySaldo = rsp.getAmount();
        
        for (int i = 0; i < vStock.size(); i++) {

            Stock st = (Stock) vStock.get(i);
            
            Date dt = getDateTime(st.getOID());
            
            int page = i +1;
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"Number\">"+page+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+JSPFormater.formatDate(dt, "dd-MM-yyyy")+"</Data></Cell>");
            //wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+JSPFormater.formatDate(dt, "dd-MM-yyyy HH:mm:ss")+"</Data></Cell>");
            
            switch (st.getType()) {
                case 0:
                    try {
                        Receive rec = new Receive();
                        try {
                            rec = DbReceive.fetchExc(st.getIncomingId());
                        } catch (Exception ex) {

                        }
                        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+rec.getNumber()+"</Data></Cell>");                        
                        Vendor ven = new Vendor();
                        try {
                            ven = DbVendor.fetchExc(rec.getVendorId());
                        } catch (Exception ex) {

                        }
                        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Incoming From "+ven.getName()+"</Data></Cell>");
                        

                    } catch (Exception ex) {

                    }
                    break;
                case 1:
                    try {
                        Retur ret = new Retur();
                        try {
                            ret = DbRetur.fetchExc(st.getReturId());
                        } catch (Exception ex) {

                        }
                        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+ret.getNumber()+"</Data></Cell>");                                                
                        Vendor ven = new Vendor();
                        try {
                            ven = DbVendor.fetchExc(ret.getVendorId());
                        } catch (Exception ex) {

                        }
                        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Retur to " + ven.getName()+"</Data></Cell>");                        

                    } catch (Exception ex) {

                    }
                    break;

                case 2:
                    try {
                        Transfer tr = new Transfer();
                        try {
                            tr = DbTransfer.fetchExc(st.getTransferId());
                        } catch (Exception ex) {}

                        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+tr.getNumber()+"</Data></Cell>");                                                
                        
                        Location loc = new Location();
                        try {
                            loc = DbLocation.fetchExc(tr.getToLocationId());
                        } catch (Exception ex) {}
                        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Transfer out to " + loc.getName()+"</Data></Cell>");                        

                    } catch (Exception ex) {

                    }

                    break;

                case 3:
                    try {
                        Transfer tr = new Transfer();
                        try {
                            tr = DbTransfer.fetchExc(st.getTransferId());
                        } catch (Exception ex) {}
                        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+tr.getNumber()+"</Data></Cell>");                                                
                        
                        Location loc = new Location();
                        try {
                            loc = DbLocation.fetchExc(tr.getFromLocationId());
                        } catch (Exception ex) {}
                        
                        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Transfer in from " + loc.getName()+"</Data></Cell>");                        
                    } catch (Exception ex) {

                    }
                    break;

                case 4:
                    try {
                        Adjusment ad = new Adjusment();
                        try {
                            ad = DbAdjusment.fetchExc(st.getAdjustmentId());
                        } catch (Exception ex) {}
                        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+ad.getNumber()+"</Data></Cell>");     
                        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Adjustment</Data></Cell>");                        
                    } catch (Exception ex) {

                    }
                    break;

                case 5:
                    try { 
                        
                        Adjusment ad = new Adjusment();
                        
                        try {
                            ad = DbAdjusment.fetchExc(st.getAdjustmentId());
                        } catch (Exception ex) { 
                            
                        }
                       
                        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+ad.getNumber()+"</Data></Cell>");     
                        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Cutt off stock awal</Data></Cell>");                                 
                    } catch (Exception ex) {}

                    break;
                case 7:
                    try {
                        Sales sl = new Sales();
                        try {
                            sl = DbSales.fetchExc(st.getOpnameId());
                        } catch (Exception ex) {

                        }
                        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+getNumber(st.getOpnameId())+"</Data></Cell>");   
                        if (sl.getType() == DbSales.TYPE_CASH) {
                            wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Cash Sales</Data></Cell>");                                                             
                        } else if (sl.getType() == DbSales.TYPE_CREDIT) {
                            wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Credit Sales</Data></Cell>");                                                             
                        } else if (sl.getType() == DbSales.TYPE_RETUR_CASH) {
                            wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Retur Cash Sales</Data></Cell>");                                                             
                        } else if (sl.getType() == DbSales.TYPE_RETUR_CREDIT) {
                            wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Retur Credit Sales</Data></Cell>");                                                             
                        }

                    } catch (Exception ex) {}

                    break;
                case 8:
                    try {
                        Costing cs = new Costing();
                        try {
                            cs = DbCosting.fetchExc(st.getCostingId());
                        } catch (Exception ex) {
                        }
                        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+cs.getNumber()+"</Data></Cell>");   
                        wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Costing</Data></Cell>");                                                             
                    } catch (Exception ex) {
                    }

                    break;
                case 9:
                    try {
                        Repack rp = new Repack();

                        try {
                            rp = DbRepack.fetchExc(st.getRepackId());
                        } catch (Exception ex) {}
                        wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+rp.getNumber()+"</Data></Cell>");   
                        
                        if ((st.getQty() * st.getInOut()) < 0) {
                            wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Repack Out</Data></Cell>");                                                                                         
                        } else {
                            wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Repack In</Data></Cell>");                                                                                         
                        }

                    } catch (Exception ex) {}

                    break;
                default:
                    break;
            }
            
            
            wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+st.getStatus()+"</Data></Cell>");
            
            if ((st.getQty() * st.getInOut()) < 0) {
                wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">"+(-1 * st.getQty() * st.getInOut())+"</Data></Cell>");                
            } else {
                wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">"+(st.getQty() * st.getInOut())+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"String\"></Data></Cell>");                 
            }
            qtySaldo = qtySaldo + (st.getQty() * st.getInOut());
            
            wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"Number\">"+qtySaldo+"</Data></Cell>");
            wb.println("      </Row>");
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
        wb.println("      <ActiveRow>26</ActiveRow>");
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
