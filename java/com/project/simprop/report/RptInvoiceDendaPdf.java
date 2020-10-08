/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.report;

import com.lowagie.text.*;
import com.lowagie.text.Image;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Document;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.io.ByteArrayOutputStream;
import java.util.Vector;
import java.util.Date;
import java.net.MalformedURLException;
import java.net.URL;

import com.lowagie.text.Font;
import com.project.crm.master.DbLot;
import com.project.crm.master.Lot;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.transaction.*;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;

import com.project.general.Company;
import com.project.general.Customer;
import com.project.general.DbCompany;
import com.project.general.DbCustomer;
import com.project.simprop.property.Building;
import com.project.simprop.property.DbBuilding;
import com.project.simprop.property.DbFloor;
import com.project.simprop.property.DbProperty;
import com.project.simprop.property.DbProperty;
import com.project.simprop.property.DbSalesData;
import com.project.simprop.property.Floor;
import com.project.simprop.property.Property;
import com.project.simprop.property.SalesData;
import com.project.simprop.session.RptAging;
import com.project.simprop.session.RptCustomer;
import com.project.simprop.session.RptPayment;
/**
 *
 * @author PNCI
 */
public class RptInvoiceDendaPdf extends HttpServlet {
    
     /** Initializes the servlet.
     */
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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        System.out.println("===| RptIncomingGoodsPdf |===");
        int lang = 0;
        long oidInvoice = JSPRequestValue.requestLong(request, "oid");
        SewaTanahInvoice sti = new SewaTanahInvoice();
        try {
            sti = DbSewaTanahInvoice.fetchExc(oidInvoice);
            lang = JSPRequestValue.requestInt(request, "lang");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        Company cmp = new Company();
        try {
            Vector listCompany = DbCompany.list(0, 0, "", "");
            if (listCompany != null && listCompany.size() > 0) {
                cmp = (Company) listCompany.get(0);
            }
        } catch (Exception ext) {
            System.out.println(ext.toString());
        }

        Customer cst = new Customer();

        try {
            cst = DbCustomer.fetchExc(sti.getSaranaId());
        } catch (Exception e) {
        }

        String title = "";
        if (lang == 0) {
            title = "INVOICE";
        } else {
            title = "INVOICE";
        }

        Color border = new Color(0x00, 0x00, 0x00);

        // setting some fonts in the color chosen by the user
        Font fontHeaderBig = new Font(Font.HELVETICA, 10, Font.BOLD, border);
        Font fontHeader = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font fontContent = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font fontTitle = new Font(Font.HELVETICA, 10, Font.BOLD, border);
        Font tableContent = new Font(Font.HELVETICA, 8, Font.NORMAL, border);
        Font tableMain = new Font(Font.HELVETICA, 10, Font.NORMAL, border);
        Font fontSpellCharge = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontItalic = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontItalicBottom = new Font(Font.HELVETICA, 8, Font.ITALIC, border);
        Font fontUnderline = new Font(Font.HELVETICA, 8, Font.UNDERLINE, border);

        Color bgColor = new Color(240, 240, 240);

        Color blackColor = new Color(0, 0, 0);
        
        Color blColor = new Color(0, 250, 0);

        Color putih = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4, 30, 30, 50, 50);
        //Document document = new Document(PageSize.A4.rotate(), 10, 10, 30, 30);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        int start = 0;

        try {
            // step2.2: creating an instance of the writer
            PdfWriter.getInstance(document, baos);

            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");

            document.open();

            //for header =========================================================== 
            int titleHeader[] = {10, 10, 10, 7, 10, 10, 10};
            Table titleTable = new Table(7);

            titleTable.setWidth(100);
            titleTable.setWidths(titleHeader);
            titleTable.setBorderColor(new Color(255, 255, 255));
            titleTable.setBorderWidth(0);
            titleTable.setAlignment(1);
            titleTable.setCellpadding(0);
            titleTable.setCellspacing(1);
            
            String reprint = "";
            if(sti.getStsPrintPdf() == 1){
                reprint = "Re-Print";
            }
            
            Cell titleCellHeader = new Cell(new Chunk("" + reprint, tableMain));
            titleCellHeader.setColspan(7);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);            
            
            titleCellHeader = new Cell(new Chunk("" + cmp.getName().toUpperCase() + "", fontTitle));
            titleCellHeader.setColspan(7);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(title, fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk((lang == 0 ? "Customer" : "Customer"), tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(": " + cst.getName(), tableMain));
            titleCellHeader.setColspan(2);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk((lang == 0 ? "No Faktur" : "No Invoice"), tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(": " + sti.getNumber(), tableMain));
            titleCellHeader.setColspan(2);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            

            titleCellHeader = new Cell(new Chunk((lang == 0 ? "Tanggal dibuat" : "Date Created"), tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(": " + JSPFormater.formatDate(new Date(), "dd MMMM yyyy"), tableMain));
            titleCellHeader.setColspan(2);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk((lang == 0 ? "Tgl. Batas Waktu" : "Due Date"), tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(": " + JSPFormater.formatDate(sti.getTanggal(), "dd MMMM yyyy"), tableMain));
            titleCellHeader.setColspan(2);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            
            SalesData sd = new SalesData();
            String desc1 = "";
            String desc2 = "";
            String desc3 = "";
            String desc4 = "";
            try{
                sd = DbSalesData.fetchExc(sti.getSalesDataId());
                Property prop = DbProperty.fetchExc(sd.getPropertyId());
                desc1 = prop.getBuildingName();
                Building bld = DbBuilding.fetchExc(sd.getBuildingId());
                desc2 = bld.getBuildingName();
                Floor fld = DbFloor.fetchExc(sd.getFloorId());
                desc3 = fld.getName();
                Lot lot = DbLot.fetchExc(sd.getLotId());
                desc4 = lot.getNama();
            }catch(Exception e){}   
            
            titleCellHeader = new Cell(new Chunk((lang == 0 ? "Catatan" : "Description"), tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));            
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(": " + desc1, tableMain));
            titleCellHeader.setColspan(2);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk((lang == 0 ? "Tipe Pembayaran" : "Payment Type"), tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(": "+DbSalesData.paymentTypeKey[sti.getPaymentType()], tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(2);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));            
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(": " + desc2, tableMain));
            titleCellHeader.setColspan(2);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(2);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            
            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));            
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(": " + desc3, tableMain));
            titleCellHeader.setColspan(2);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(2);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            
            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));            
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(": " + desc4, tableMain));
            titleCellHeader.setColspan(2);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableMain));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(2);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk("", fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk("", fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            document.add(titleTable);

            int poHeaderTop[] = {10, 60, 50};

            Table prTable = new Table(3);
            prTable.setWidth(100);
            prTable.setWidths(poHeaderTop);
            prTable.setBorderColor(blackColor);
            prTable.setBorderWidth(1);
            prTable.setAlignment(1);
            prTable.setCellpadding(0);
            prTable.setCellspacing(1);            

            Cell titlePrCellTop = new Cell(new Chunk(" ", tableContent));

            titlePrCellTop = new Cell(new Chunk((lang == 0 ? "NO" : "NO"), fontHeader));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(blackColor);
            titlePrCellTop.setBackgroundColor(bgColor);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk((lang == 0 ? "TYPE PENJUALAN" : "SALES TYPE"), fontHeader));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(blackColor);
            titlePrCellTop.setBackgroundColor(bgColor);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk((lang == 0 ? "JUMLAH" : "AMOUNT"), fontHeader));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(blackColor);
            titlePrCellTop.setBackgroundColor(bgColor);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("1", tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titlePrCellTop.setBorderColor(blackColor);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("Denda - "+sti.getKeterangan(), tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(blackColor);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(sti.getDendaDiakui(), "#,###.##"), tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(blackColor);
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("TOTAL", tableContent));            
            titlePrCellTop.setColspan(2);
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(blackColor);            
            prTable.addCell(titlePrCellTop);

            titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(sti.getDendaDiakui(), "#,###.##"), tableContent));
            titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titlePrCellTop.setBorderColor(blackColor);
            prTable.addCell(titlePrCellTop);

            document.add(prTable);          
            
            int poFooterTop[] = {60, 60};

            Table prFooterTable = new Table(2);
            prFooterTable.setWidth(100);
            prFooterTable.setWidths(poFooterTop);            
            prFooterTable.setBorderColor(blackColor);
            prFooterTable.setBorderWidth(0);
            prFooterTable.setAlignment(1);
            prFooterTable.setCellpadding(0);
            prFooterTable.setCellspacing(1);

            Cell titleFtCellTop = new Cell(new Chunk(" ", tableContent));
            
            titleFtCellTop = new Cell(new Chunk("", tableContent));
            titleFtCellTop.setBorderWidth(0);
            titleFtCellTop.setColspan(2);
            titleFtCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleFtCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            prFooterTable.addCell(titleFtCellTop);
            
            titleFtCellTop = new Cell(new Chunk("", tableContent));
            titleFtCellTop.setBorderWidth(0);
            titleFtCellTop.setColspan(2);
            titleFtCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleFtCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            prFooterTable.addCell(titleFtCellTop);
            
            titleFtCellTop = new Cell(new Chunk("", tableContent));
            titleFtCellTop.setBorderWidth(0);
            titleFtCellTop.setColspan(2);
            titleFtCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleFtCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            prFooterTable.addCell(titleFtCellTop);
            
            titleFtCellTop = new Cell(new Chunk("Prepared By", tableContent));
            titleFtCellTop.setBorderWidth(0);
            titleFtCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleFtCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            prFooterTable.addCell(titleFtCellTop);
            
            titleFtCellTop = new Cell(new Chunk("Approval By", tableContent));
            titleFtCellTop.setBorderWidth(0);
            titleFtCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleFtCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            prFooterTable.addCell(titleFtCellTop);
            
            titleFtCellTop = new Cell(new Chunk("", tableContent));
            titleFtCellTop.setBorderWidth(0);
            titleFtCellTop.setColspan(2);
            titleFtCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleFtCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            prFooterTable.addCell(titleFtCellTop);
            
            titleFtCellTop = new Cell(new Chunk("", tableContent));            
            titleFtCellTop.setBorderWidth(0);
            titleFtCellTop.setColspan(2);
            titleFtCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleFtCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            prFooterTable.addCell(titleFtCellTop);
            
            titleFtCellTop = new Cell(new Chunk("(                                         )", tableContent));
            titleFtCellTop.setBorderWidth(0);
            titleFtCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleFtCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            prFooterTable.addCell(titleFtCellTop);
            
            titleFtCellTop = new Cell(new Chunk("(                                         )", tableContent));
            titleFtCellTop.setBorderWidth(0);
            titleFtCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleFtCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            prFooterTable.addCell(titleFtCellTop);
            
            sti.setStsPrintPdf(1);
            try{
                DbSewaTanahInvoice.updateExc(sti);
            }catch(Exception e){}
            
            document.add(prFooterTable);

        } catch (Exception e) {
            System.out.println(e.toString());
        }

        document.close();

        System.out.println("print==============");
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
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

}
