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

import com.lowagie.text.Font;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.crm.master.DbLot;
import com.project.crm.master.Lot;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.crm.transaction.DbPembayaran;
import com.project.crm.transaction.Pembayaran;
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
import com.project.simprop.property.DbSalesData;
import com.project.simprop.property.Floor;
import com.project.simprop.property.SalesData;
/**
 *
 * @author Roy Andika
 */
public class RptKwitansiInvoicePdf extends HttpServlet{
    
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

        Pembayaran pembayaran = new Pembayaran();
        Customer cst = new Customer();
        SewaTanahInvoice sti = new SewaTanahInvoice();
        SalesData salesData = new SalesData();
        Building building = new Building();
        Floor floor = new Floor();
        Lot lot = new Lot();
        User user = new User();
        Employee emp = new Employee();

        int lang = 0;
        long userId = 0;
        long pembayaranId = 0;

        try {
            pembayaranId = JSPRequestValue.requestLong(request, "pembayaranId");
            userId = JSPRequestValue.requestLong(request, "userId");
            lang = JSPRequestValue.requestInt(request, "lang");
        } catch (Exception e) {
        }

        try {
            pembayaran = DbPembayaran.fetchExc(pembayaranId);
            cst = DbCustomer.fetchExc(pembayaran.getCustomerId());
        } catch (Exception e) {
        }

        try {
            user = DbUser.fetch(userId);
        } catch (Exception e) {
        }

        try {
            emp = DbEmployee.fetchExc(user.getEmployeeId());
        } catch (Exception e) {
        }

        try {
            sti = DbSewaTanahInvoice.fetchExc(pembayaran.getSewaTanahInvoiceId());
        } catch (Exception e) {
        }

        try {
            salesData = DbSalesData.fetchExc(sti.getSalesDataId());
        } catch (Exception e) {
        }

        try {
            building = DbBuilding.fetchExc(salesData.getBuildingId());
        } catch (Exception e) {
        }

        try {
            floor = DbFloor.fetchExc(salesData.getFloorId());
        } catch (Exception e) {
        }

        try {
            lot = DbLot.fetchExc(salesData.getLotId());
        } catch (Exception e) {
        }

        double totPembayaran = DbPembayaran.sumPembayaran(DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+" = "+pembayaran.getSewaTanahInvoiceId());

        Color border = new Color(0x00, 0x00, 0x00);

        // setting some fonts in the color chosen by the user
        Font fontTitle = new Font(Font.HELVETICA, 13, Font.BOLD | Font.UNDERLINE, border);
        Font tableContent = new Font(Font.HELVETICA, 8, Font.NORMAL, border);
        Font fontSpellCharge = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontSmall = new Font(Font.HELVETICA, 5, Font.NORMAL, border);
        Font fontBold = new Font(Font.HELVETICA, 14, Font.BOLDITALIC, border);
        Font fontFooter = new Font(Font.HELVETICA, 7, Font.NORMAL, border);

        Color bgColor = new Color(240, 240, 240);
        Color blackColor = new Color(0, 0, 0);
        Color putih = new Color(250, 250, 250);

        Document document = new Document(PageSize.HALFA4, 60, 20, 20, 10);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        String pathImageLeft = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH") + "/kwleft.png";
        String pathImageRight = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH") + "/kwright.png";

        Image gambarLeft = null;
        try {
            gambarLeft = Image.getInstance(pathImageLeft);
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }

        Image gambarRight = null;
        try {
            gambarRight = Image.getInstance(pathImageRight);
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }

        String title = "";
        if (lang == 0) {
            title = "K W I T A N S I";
        } else {
            title = "K W I T A N S I";
        }

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
            titleTable.setBorderColor(putih);
            titleTable.setBorderWidth(0);
            titleTable.setAlignment(1);
            titleTable.setCellpadding(0);
            titleTable.setCellspacing(1);

            Cell titleCellHeader = new Cell(new Chunk("", fontTitle));
            titleCellHeader.setColspan(3);
            titleCellHeader.add(Image.getInstance(gambarLeft));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontTitle));
            titleCellHeader.setColspan(2);            
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));            
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk("", fontTitle));            
            titleCellHeader.add(Image.getInstance(gambarRight));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));            
            titleCellHeader.setColspan(2);
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

            document.add(titleTable);

            int titleB1[] = {3, 14, 14, 9, 18, 9, 21};
            Table titleTableB1 = new Table(7);
            titleTableB1.setWidth(100);
            titleTableB1.setWidths(titleB1);
            titleTableB1.setBorder(0);
            titleTableB1.setBorderColor(new Color(255, 255, 255));
            titleTableB1.setAlignment(1);
            titleTableB1.setCellpadding(0);
            titleTableB1.setCellspacing(0);

            Cell titleCellHeader2 = new Cell(new Chunk("", fontSmall));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT);
            titleCellHeader2.setBorderColor(blackColor);
            titleCellHeader2.setColspan(7);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.LEFT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Sudah Terima Dari ", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(":  " + cst.getName(), tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(4);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.RIGHT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.LEFT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Banyaknya Uang", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);

            String a = JSPFormater.formatNumber(totPembayaran, "#,###");
            NumberSpeller numberSpeller = new NumberSpeller();
            String u = a.replaceAll(",", "");

            titleCellHeader2 = new Cell(new Chunk(": " + numberSpeller.spellNumberToIna(Double.parseDouble(u)) + " Rupiah", fontSpellCharge));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(4);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.RIGHT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setColspan(7);
            titleCellHeader2.setBorder(Rectangle.RIGHT | Rectangle.LEFT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.LEFT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Cara Pembayaran", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);
            
            titleCellHeader2 = new Cell(new Chunk(": "+DbPembayaran.paymentTypeStr[pembayaran.getType()], tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setColspan(5);
            titleCellHeader2.setBorder(Rectangle.RIGHT);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setColspan(7);
            titleCellHeader2.setBorder(Rectangle.RIGHT | Rectangle.LEFT | Rectangle.BOTTOM);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setColspan(7);
            titleCellHeader2.setBorder(Rectangle.RIGHT | Rectangle.LEFT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.LEFT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Untuk Pembayaran", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(":  " + pembayaran.getMemo(), tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(4);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.RIGHT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setColspan(7);
            titleCellHeader2.setBorder(Rectangle.RIGHT | Rectangle.LEFT | Rectangle.BOTTOM);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.LEFT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Data Properti", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);
            
            titleCellHeader2 = new Cell(new Chunk(":  " + DbBuilding.buildingTypeKey[building.getBuildingType()], tableContent));            
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleCellHeader2.setColspan(5);
            titleCellHeader2.setBorder(Rectangle.RIGHT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.LEFT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Tower", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(":  " + building.getBuildingName(), tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("  Lantai", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(": " + floor.getName(), tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("  No. Unit", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(": " + lot.getNama(), tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(Rectangle.RIGHT);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setColspan(7);
            titleCellHeader2.setBorder(Rectangle.RIGHT | Rectangle.LEFT | Rectangle.BOTTOM);
            titleCellHeader2.setBorderColor(blackColor);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(7);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Rp. " + JSPFormater.formatNumber(totPembayaran, "###,###")+",-", fontBold));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(4);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("..............,  " + JSPFormater.formatDate(new Date(), "dd-MMM-yyyy"), tableContent));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(2);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", fontSmall));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(7);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Bank BCA, Cab Roxy Square - Jakarta", fontFooter));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(3);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Bank Mandiri,Cab Mutiara Kosambi - Tanggerang", fontFooter));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(4);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("a/c : 084.332.060.8", fontFooter));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(3);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("a/c : 155.00.5665660.9", fontFooter));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(4);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("a/n : PT. Graha Cemerlang", fontFooter));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(3);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("a/n : PT. Graha Cemerlang", fontFooter));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(2);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("" + emp.getName(), fontFooter));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(2);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", fontSmall));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(7);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("CATATAN : * Apabila dalam waktu 7 hari boking fee belum dilunasi maka pemesanan dianggap batal dan booking fee hangus", fontSmall));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(7);
            titleTableB1.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("                    * Pembayaran dianggap sah apabila uang sudah masuk rekening PT Graha Cemerlang dan dibubuhi cap yang berlaku", fontSmall));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorder(0);
            titleCellHeader2.setBorderColor(putih);
            titleCellHeader2.setColspan(7);
            titleTableB1.addCell(titleCellHeader2);

            document.add(titleTableB1);

        } catch (Exception e) {
            System.out.println(e.toString());
        }

        document.close();
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
