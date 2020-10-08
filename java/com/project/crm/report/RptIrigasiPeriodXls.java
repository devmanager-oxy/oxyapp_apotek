/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.report;


import java.util.*;
import java.text.*;
import javax.servlet.*;
import javax.servlet.http.*;


// package lowagie
import com.lowagie.text.*;


import com.project.util.*;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
/**
 *
 * @author Tu Roy
 */
public class RptIrigasiPeriodXls extends HttpServlet{
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
     */
    public void destroy() {

    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
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

    private static HSSFFont createFont(HSSFWorkbook wb, int size, int color, boolean isBold) {
        HSSFFont font = wb.createFont();
        font.setFontHeightInPoints((short) size);
        font.setColor((short) color);
        if (isBold) {
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        }
        return font;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        
        throws ServletException, java.io.IOException {        

        System.out.println("---===| Excel Report |===---");
        
        response.setContentType("application/x-msexcel");

        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("Report Detail Period - Dp, AL, LL");

        //Style
        HSSFCellStyle styleTitle = wb.createCellStyle();
        styleTitle.setFillBackgroundColor(HSSFCellStyle.WHITE);
        styleTitle.setFillForegroundColor(HSSFCellStyle.WHITE);
        styleTitle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        styleTitle.setFont(createFont(wb, 12, HSSFFont.BLACK, true));

        HSSFCellStyle styleSubTitle = wb.createCellStyle();
        styleSubTitle.setFillBackgroundColor(HSSFCellStyle.WHITE);
        styleSubTitle.setFillForegroundColor(HSSFCellStyle.WHITE);
        styleSubTitle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        styleSubTitle.setFont(createFont(wb, 10, HSSFFont.BLACK, true));

        HSSFCellStyle styleHeader = wb.createCellStyle();
        styleHeader.setFillBackgroundColor(HSSFCellStyle.GREY_25_PERCENT);
        styleHeader.setFillForegroundColor(HSSFCellStyle.GREY_25_PERCENT);
        styleHeader.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        
        styleHeader.setFont(createFont(wb, 10, HSSFFont.BLACK, true));

        HSSFCellStyle styleHeaderBig = wb.createCellStyle();
        styleHeaderBig.setFillBackgroundColor(HSSFCellStyle.GREY_25_PERCENT);
        styleHeaderBig.setFillForegroundColor(HSSFCellStyle.GREY_25_PERCENT);
        styleHeaderBig.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        
        styleHeaderBig.setFont(createFont(wb, 12, HSSFFont.BLACK, true));

        HSSFCellStyle styleFooter = wb.createCellStyle();
        styleFooter.setFillBackgroundColor(HSSFCellStyle.GREY_25_PERCENT);
        styleFooter.setFillForegroundColor(HSSFCellStyle.GREY_25_PERCENT);
        styleFooter.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        styleFooter.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        styleFooter.setBorderTop(HSSFCellStyle.BORDER_THIN);
        styleFooter.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        styleFooter.setBorderRight(HSSFCellStyle.BORDER_THIN);
        styleFooter.setFont(createFont(wb, 10, HSSFFont.BLACK, true));

        HSSFCellStyle styleValueBold = wb.createCellStyle();
        styleValueBold.setFillBackgroundColor(HSSFCellStyle.GREY_25_PERCENT);
        styleValueBold.setFillForegroundColor(HSSFCellStyle.GREY_25_PERCENT);
        styleValueBold.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        styleValueBold.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        styleValueBold.setBorderTop(HSSFCellStyle.BORDER_THIN);
        styleValueBold.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        styleValueBold.setBorderRight(HSSFCellStyle.BORDER_THIN);
        styleValueBold.setFont(createFont(wb, 12, HSSFFont.BLACK, true));

        HSSFCellStyle styleValue = wb.createCellStyle();
        styleValue.setFillBackgroundColor(HSSFCellStyle.WHITE);
        styleValue.setFillForegroundColor(HSSFCellStyle.WHITE);
        styleValue.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        styleValue.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        styleValue.setBorderTop(HSSFCellStyle.BORDER_THIN);
        styleValue.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        styleValue.setBorderRight(HSSFCellStyle.BORDER_THIN);
        styleValue.setFont(createFont(wb, 10, HSSFFont.BLACK, false));        
        
        /* Get Data From Session */
         
        Vector vlistRptIrigasiBulanan = new Vector();
        
        HttpSession sess = request.getSession(true);
        
        try {               
            
            vlistRptIrigasiBulanan = (Vector)sess.getValue("RPT_IRIGASI_BULANAN");

        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }
        
        if(vlistRptIrigasiBulanan != null && vlistRptIrigasiBulanan.size() > 0 ){
            
            String frmCurrency = "#,###";
            
            RptIrigasiPeriod objRpt = (RptIrigasiPeriod)vlistRptIrigasiBulanan.get(0);
            String namePeriod = "";
            
            if(objRpt.getPeriodName().length() > 0){
                namePeriod = objRpt.getPeriodName();
            }
                    
            HSSFRow row = sheet.createRow((short) 0);
            HSSFCell cell = row.createCell((short) 0);
            
            String[] tableTitle = {
                "PENGAKUAN PENDAPATAN IRIGASI",
                "BULAN",
                ""+namePeriod
            };
            
            String[] tableSubTitle = {};
            
            String[] tableHeader = {                
                "NO", "KETERANGAN", "BULAN INI","BULAN LALU","PEMAKAIAN","HARGA (RP)","JUMLAH","REK. KREDIT","PPN","TOTAL PENDAPATAN","REK. DEBET"                
            };            
            
            /**
             *@DESC     :UNTUK COUNT ROW
             */
            
            int countRow = 0;

            /**
             * @DESC    : TITTLE
             */
            for (int k = 0; k < tableTitle.length; k++) {
                row = sheet.createRow((short) (countRow));
                countRow++;
                cell = row.createCell((short) 0);
                cell.setCellValue(tableTitle[k]);
                cell.setCellStyle(styleTitle);
            }

            /**
             * @DESC    : SUB TITTLE
             */
            for (int k = 0; k < tableSubTitle.length; k++) {
                row = sheet.createRow((short) (countRow));
                countRow++;
                cell = row.createCell((short) 0);
                cell.setCellValue(tableSubTitle[k]);
                cell.setCellStyle(styleSubTitle);
            }

            countRow = countRow + 2;
            /**
             * @DESC    : HEADER
             */
            row = sheet.createRow((short) (countRow));
            countRow = countRow + 1;
            for (int k = 0; k < tableHeader.length; k++) {
                cell = row.createCell((short) k);
                cell.setCellValue(tableHeader[k]);
                cell.setCellStyle(styleHeader);
            }
            
            int counterData = 1;
            double bulIni = 0;
            double bulLalu = 0;
            double jumStand = 0;
           // double pemakain = 0;            
            double jum = 0;            
            double ppn = 0;
            double totPendapatan = 0;
            
            
            for(int i = 0; i < vlistRptIrigasiBulanan.size() ; i ++){
                
                int collPos = 0;
                
                RptIrigasiPeriod rptIrigasiPeriod = new RptIrigasiPeriod();
                
                try{
                    rptIrigasiPeriod = (RptIrigasiPeriod)vlistRptIrigasiBulanan.get(i);
                }catch(Exception e){
                    System.out.println("Exception "+e.toString());
                }
                
                /**
                 * @DESC    : CREATE NEW ROW
                 */
                row = sheet.createRow((short) (countRow));
                countRow++;
                
                /**
                 * @DESC    : NO
                 */
                cell = row.createCell((short) collPos);
                cell.setCellValue(String.valueOf(counterData));
                cell.setCellStyle(styleValue);
                collPos++;
                counterData++;
                
                /**
                 * @DESC    : NAMA CLIENT / KETERANGAN
                 */
                cell = row.createCell((short) collPos);
                cell.setCellValue(String.valueOf(rptIrigasiPeriod.getCustName()));
                cell.setCellStyle(styleValue);
                collPos++;
                
                /**
                 * @DESC    : BULAN INI
                 */
                cell = row.createCell((short) collPos);
                cell.setCellValue(JSPFormater.formatNumber(rptIrigasiPeriod.getTransBulanIni(),frmCurrency));
                cell.setCellStyle(styleValue);
                collPos++;
                
                bulIni = bulIni + rptIrigasiPeriod.getTransBulanIni();
                /**
                 * @DESC    : FULL NAME
                 */
                cell = row.createCell((short) collPos);
                cell.setCellValue(JSPFormater.formatNumber(rptIrigasiPeriod.getTransBulanLalu(),frmCurrency));
                cell.setCellStyle(styleValue);
                collPos++;                
               
                bulLalu = bulLalu + rptIrigasiPeriod.getTransBulanLalu();
                
                double stand = rptIrigasiPeriod.getTransBulanIni() - rptIrigasiPeriod.getTransBulanLalu();
                
                /**
                 * @DESC    : STAND
                 */
                cell = row.createCell((short) collPos);
                cell.setCellValue(JSPFormater.formatNumber(stand,frmCurrency));
                cell.setCellStyle(styleValue);
                collPos++;
                
                jumStand = jumStand + stand;
                
                
                double tmpPemakaian = ((rptIrigasiPeriod.getTransBulanIni() - rptIrigasiPeriod.getTransBulanLalu()));
                
                /**
                 * @DESC    : PEMAKAIAN
                 */
                //cell = row.createCell((short) collPos);
                //cell.setCellValue(JSPFormater.formatNumber(tmpPemakaian,frmCurrency));
                //cell.setCellStyle(styleValue);
                //collPos++;
                
                //pemakain = pemakain + tmpPemakaian;
                
                /**
                 * @DESC    : HARGA
                 */
                cell = row.createCell((short) collPos);
                cell.setCellValue(JSPFormater.formatNumber(rptIrigasiPeriod.getTransHarga(),frmCurrency));
                cell.setCellStyle(styleValue);
                collPos++;
                
                                
                /**
                 * @DESC    : JUMLAH
                 */
                double jumlah = tmpPemakaian * rptIrigasiPeriod.getTransHarga();
                
                cell = row.createCell((short) collPos);
                cell.setCellValue(JSPFormater.formatNumber(jumlah,frmCurrency));
                cell.setCellStyle(styleValue);
                collPos++;
                
                jum = jum + jumlah;
                                
                /**
                 * @DESC    : REK. KREDIT
                 */
                cell = row.createCell((short) collPos);
                cell.setCellValue(String.valueOf(0));
                cell.setCellStyle(styleValue);
                collPos++;
                
                
                /**
                 * @DESC    : PPN
                 */
                double tmpPpn = rptIrigasiPeriod.getIrigasiPpnPercent() * jumlah;
                
                cell = row.createCell((short) collPos);
                cell.setCellValue(JSPFormater.formatNumber(tmpPpn,frmCurrency));
                cell.setCellStyle(styleValue);
                collPos++;
                
                ppn = ppn + tmpPpn;
                
                /**
                 * @DESC    : TOTAL PENDAPATAN
                 */
                double totTotalPendapatan = jumlah + tmpPpn;
                cell = row.createCell((short) collPos);
                cell.setCellValue(JSPFormater.formatNumber(totTotalPendapatan,frmCurrency));
                cell.setCellStyle(styleValue);
                collPos++;
                
                totPendapatan = totPendapatan + totTotalPendapatan;
                
                /**
                 * @DESC    : REK. DEBET
                 */
                cell = row.createCell((short) collPos);
                cell.setCellValue(String.valueOf(0));
                cell.setCellStyle(styleValue);
                collPos++;
                
            }
            
            
            int collPos = 0;
            
            /**
              * @DESC    : CREATE NEW ROW
              */
            row = sheet.createRow((short) (countRow));
            countRow++;
            
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(String.valueOf(""));
            cell.setCellStyle(styleValue);
            collPos++;
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(String.valueOf("TOTAL"));
            cell.setCellStyle(styleValue);
            collPos++;
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(JSPFormater.formatNumber(bulIni,frmCurrency));
            cell.setCellStyle(styleValue);
            collPos++;
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(JSPFormater.formatNumber(bulLalu,frmCurrency));
            cell.setCellStyle(styleValue);
            collPos++;
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(JSPFormater.formatNumber(jumStand,frmCurrency));
            cell.setCellStyle(styleValue);
            collPos++;
            
          //  cell = row.createCell((short) collPos);
           // cell.setCellValue(JSPFormater.formatNumber(pemakain,frmCurrency));
           // cell.setCellStyle(styleValue);
            //collPos++;
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(String.valueOf(""));
            cell.setCellStyle(styleValue);
            collPos++;
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(JSPFormater.formatNumber(jum,frmCurrency));
            cell.setCellStyle(styleValue);
            collPos++;
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(String.valueOf(""));
            cell.setCellStyle(styleValue);
            collPos++;
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(JSPFormater.formatNumber(ppn,frmCurrency));
            cell.setCellStyle(styleValue);
            collPos++;
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(JSPFormater.formatNumber(totPendapatan,frmCurrency));
            cell.setCellStyle(styleValue);
            collPos++;
            
            cell = row.createCell((short) collPos);
            cell.setCellValue(String.valueOf(""));
            cell.setCellStyle(styleValue);
            collPos++;
            
            ServletOutputStream sos = response.getOutputStream();
            wb.write(sos);
            sos.close();
            
        }
    }
}
