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
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.SessReportSales;
import com.project.crm.master.DbLot;
import com.project.crm.master.Lot;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.transaction.*;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.simprop.property.Building;
import com.project.simprop.property.DbBuilding;
import com.project.simprop.property.DbFloor;
import com.project.simprop.property.DbLotType;
import com.project.simprop.property.DbPaymentSimulation;
import com.project.simprop.property.DbProperty;
import com.project.simprop.property.DbSalesData;
import com.project.simprop.property.Floor;
import com.project.simprop.property.LotType;
import com.project.simprop.property.PaymentSimulation;
import com.project.simprop.property.Property;
import com.project.simprop.property.SalesData;

/**
 *
 * @author Roy Andika
 */
public class SuratPesananPDF extends HttpServlet {

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

        System.out.println("===| Rpt Sales Member |===");
        int lang = 0;

        Vector result = new Vector();

        long userId = 0;
        User user = new User();

        long oidProperty = JSPRequestValue.requestLong(request, "hidden_property_id");
        long oidFloor = JSPRequestValue.requestLong(request, "hidden_floor_id");
        long oidLot = JSPRequestValue.requestLong(request, "hidden_lot_id");
        long oidBuilding = JSPRequestValue.requestLong(request, "hidden_building_id");
        long oidSalesData = JSPRequestValue.requestLong(request, "hidden_sales_data_id");
        
        SalesData salesData = new SalesData();
        try{
            salesData = DbSalesData.fetchExc(oidSalesData);
        }catch(Exception e){}

        Property property = new Property();
        try {
            property = DbProperty.fetchExc(oidProperty);
        } catch (Exception e) {
        }

        Building building = new Building();
        try {
            building = DbBuilding.fetchExc(oidBuilding);
        } catch (Exception e) {
        }

        Floor floor = new Floor();
        try {
            floor = DbFloor.fetchExc(oidFloor);
        } catch (Exception e) {
        }

        Lot lot = new Lot();
        LotType lotType = new LotType();
        try {
            lot = DbLot.fetchExc(oidLot);
            lotType = DbLotType.fetchExc(lot.getLotTypeId());
        } catch (Exception e) {
        }

        Vector pPayment = new Vector();
        PaymentSimulation psA1 = new PaymentSimulation();
        PaymentSimulation psA2 = new PaymentSimulation();
        PaymentSimulation psA3 = new PaymentSimulation();
        pPayment = DbPaymentSimulation.list(0, 3, DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID] + "=" + salesData.getOID() + " and " + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_PAYMENT] + "=2", null);
        if (pPayment != null && pPayment.size() > 0) {
            try{
                psA1 = (PaymentSimulation) pPayment.get(0);
            }catch(Exception e){}
        }

        if (pPayment != null && pPayment.size() > 0) {
            try{
                psA2 = (PaymentSimulation) pPayment.get(1);
            }catch(Exception e){}
        }

        if (pPayment != null && pPayment.size() > 0) {
            try{
                psA3 = (PaymentSimulation) pPayment.get(2);
            }catch(Exception e){}    
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
        } catch (Exception e) {
        }

        Employee emp = new Employee();
        try {
            emp = DbEmployee.fetchExc(user.getEmployeeId());
        } catch (Exception e) {
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

        Color border = new Color(0x00, 0x00, 0x00);

        // setting some fonts in the color chosen by the user       

        Font fontHeader = new Font(Font.HELVETICA, 13, Font.BOLD | Font.UNDERLINE, border);
        Font tableContent = new Font(Font.HELVETICA, 10, Font.NORMAL, border);
        Font tableContentItem = new Font(Font.HELVETICA, 10, Font.BOLD, border);
        
        Font tableContentX = new Font(Font.HELVETICA, 50, Font.NORMAL, border);
        
        Font fontHeaderTable = new Font(Font.COURIER, 9, Font.NORMAL, border);
        Font fontContent = new Font(Font.HELVETICA, 11, Font.BOLD, border);
        Font fontTitle = new Font(Font.COURIER, 11, Font.BOLD, border);

        Font tableContentUnderline = new Font(Font.COURIER, 11, Font.UNDERLINE, border);
        Font fontSpellCharge = new Font(Font.HELVETICA, 11, Font.BOLDITALIC, border);
        Font fontItalic = new Font(Font.HELVETICA, 11, Font.BOLDITALIC, border);
        Font fontItalicBottom = new Font(Font.HELVETICA, 11, Font.ITALIC, border);
        Font fontUnderline = new Font(Font.COURIER, 9, Font.UNDERLINE, border);
        Font fontCourier = new Font(Font.COURIER, 8, Font.NORMAL, border);

        Color bgColor = new Color(240, 240, 240);
        Color black = new Color(0, 0, 0);
        Color putih = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4, 40, 40, 30, 35);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            // step2.2: creating an instance of the writer
            PdfWriter.getInstance(document, baos);

            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");
            document.open();

            //for header =========================================================== 
            int titleHeader[] = {15, 3, 37, 12, 3, 22};

            Table titleTable = new Table(6);
            titleTable.setWidth(100);
            titleTable.setWidths(titleHeader);
            titleTable.setPadding(0);
            titleTable.setBorderColor(new Color(255, 255, 255));
            titleTable.setBorderWidth(0);
            titleTable.setAlignment(1);
            titleTable.setCellpadding(0);
            titleTable.setCellspacing(1);

            String pathImageLeft = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH") + "/spleft.png";
            String pathImageRight = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH") + "/spright.png";

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

            Cell titleCellHeader = new Cell(new Chunk("", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(3);
            titleCellHeader.add(Image.getInstance(pathImageLeft));
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontHeader));
            titleCellHeader.setColspan(3);
            titleCellHeader.add(Image.getInstance(gambarRight));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("SURAT PESANAN", fontHeader));
            titleCellHeader.setColspan(6);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableContentItem));
            titleCellHeader.setColspan(6);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableContentItem));
            titleCellHeader.setColspan(6);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Yang bertanda tangan di bawah ini :", tableContent));
            titleCellHeader.setColspan(6);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableContent));
            titleCellHeader.setColspan(6);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Nama", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(""+salesData.getName(), tableContent));
            titleCellHeader.setColspan(4);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("No. KTP", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(""+salesData.getIdNumber(), tableContent));
            titleCellHeader.setColspan(4);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Alamat Surat", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(""+salesData.getAddress(), tableContent));
            titleCellHeader.setColspan(4);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableContent));
            titleCellHeader.setColspan(6);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Telp.", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(""+salesData.getTelephone(), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);


            titleCellHeader = new Cell(new Chunk("HP", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(""+salesData.getPh(), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);


            titleCellHeader = new Cell(new Chunk("Email", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(""+salesData.getEmail(), tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Fax.", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(":", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableContent));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontHeader));
            titleCellHeader.setColspan(6);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("Menyatakan membeli unit sebagai berikut :", tableContent));
            titleCellHeader.setColspan(6);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", tableContentItem));
            titleCellHeader.setColspan(6);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            document.add(titleTable);

            int titleItem[] = {6, 10, 3, 15, 10, 3, 15, 10, 3, 15};

            Table title = new Table(10);
            title.setWidth(100);
            title.setWidths(titleItem);
            title.setPadding(0);
            title.setBorderColor(new Color(255, 255, 255));
            title.setBorderWidth(0);
            title.setAlignment(1);
            title.setCellpadding(0);
            title.setCellspacing(1);

            Cell titleCellHI = new Cell(new Chunk("I.)", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("  Data Properti", tableContentItem));
            titleCellHI.setColspan(9);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            String prop = "";
            for (int it = 0; it < DbBuilding.buildingTypeValue.length; it++) {
                                                            
            if (building.getBuildingType() == DbBuilding.buildingTypeValue[it]) {
                
                prop = prop + " ( x ) ";
            } else {
                prop = prop + " (   ) ";
            
                }
                prop = prop + DbBuilding.buildingTypeKey[it]+"     ";     
                                                            
            }
            
            titleCellHI = new Cell(new Chunk("  "+prop, tableContent));        
            titleCellHI.setColspan(9);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            if (building.getBuildingType() == DbBuilding.buildingTypeValue[0] || building.getBuildingType() == DbBuilding.buildingTypeValue[1] || building.getBuildingType() == DbBuilding.buildingTypeValue[2]) {
            
            titleCellHI = new Cell(new Chunk("  Tower", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(""+building.getBuildingName(), tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("Lantai", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(""+floor.getName(), tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("No. Unit", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(""+lot.getNama(), tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("  Blok", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("LT", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("LB", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            }else{
                
            titleCellHI = new Cell(new Chunk("  Tower", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("Lantai", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("No. Unit", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
                
            titleCellHI = new Cell(new Chunk("", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("  Blok", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(""+building.getBuildingName(), tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("LT", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(""+floor.getName(), tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("LB", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(":", tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(""+lot.getNama(), tableContent));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
                
            }
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setColspan(10);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("II.)", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("  Harga & Cara Pembayaran", tableContentItem));
            titleCellHI.setColspan(9);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("  a) Harga", tableContentItem));
            titleCellHI.setColspan(9);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("      Harga Jual", tableContent));
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk(": "+JSPFormater.formatNumber(salesData.getSalesPrice(), "#,###.##"), tableContent));            
            titleCellHI.setColspan(6);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Discount", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk(": "+JSPFormater.formatNumber(salesData.getDiscount(), "#,###.##"), tableContent));            
            titleCellHI.setColspan(6);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Harga setelah discount", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk(": "+JSPFormater.formatNumber(salesData.getPriceAfterDiscount(), "#,###.##"), tableContent));            
            titleCellHI.setColspan(6);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContent));                    
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Harga + PPN", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk(": "+JSPFormater.formatNumber(salesData.getFinalPrice(), "#,###.##"), tableContent));            
            titleCellHI.setColspan(6);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContent));            
            titleCellHI.setColspan(10);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("  a) Pembayaran", tableContentItem));
            titleCellHI.setColspan(9);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Cara Pembayaran", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContent));        
            titleCellHI.setColspan(6);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Booking Fee (BF)", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk(": "+JSPFormater.formatNumber(salesData.getBfAmount(), "#,###.##"), tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("Tgl.  :   "+JSPFormater.formatDate(salesData.getBfDueDate(), "dd/MM/yyyy"), tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Uang Muka (DP)", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk(": "+JSPFormater.formatNumber(salesData.getDpAmount()-salesData.getBfAmount(), "#,###.##"), tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("Tgl.  :   "+JSPFormater.formatDate(salesData.getDpDueDate(), "dd/MM/yyyy"), tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Angsuran 1", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk(": "+JSPFormater.formatNumber(psA1.getAmount()+psA1.getBunga(), "#,###.##"), tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            String dt = "-";
            try {
                dt = JSPFormater.formatDate(psA1.getDueDate(), "dd/MM/yyyy");
            } catch (Exception e) {
                dt = "-";
            }
            
            titleCellHI = new Cell(new Chunk("Tgl.  :   "+dt, tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Angsuran 2 s/d", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk(": "+JSPFormater.formatNumber(psA2.getAmount()+psA2.getBunga(), "#,###.##"), tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);            
            
            dt = "-";
            try {
                if(psA2.getDueDate() != null){
                    dt = JSPFormater.formatDate(psA2.getDueDate(), "dd/MM/yyyy");
                }
            } catch (Exception e) {
                dt = "-";
            }
            
            titleCellHI = new Cell(new Chunk("Tgl.  :   "+dt, tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
             
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Angsuran", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk(": "+JSPFormater.formatNumber(psA3.getAmount()+psA3.getBunga(), "#,###.##"), tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);            
            
            dt = "-";
            try {
                if(psA3.getDueDate() != null){
                    dt = JSPFormater.formatDate(psA3.getDueDate(), "dd/MM/yyyy");
                }
            } catch (Exception e) {
                dt = "-";
            }
            
            titleCellHI = new Cell(new Chunk("Tgl.  :   "+dt, tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setColspan(10);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);

            titleCellHI = new Cell(new Chunk("  a) Pelunasan", tableContentItem));
            titleCellHI.setColspan(9);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Cara Pelunasan", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContent));        
            titleCellHI.setColspan(6);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContentItem));
            titleCellHI.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("      Sisa Pembayaran", tableContent));        
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk(": ", tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);            
            
            titleCellHI = new Cell(new Chunk("Tgl.  :   ", tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);            
            
            titleCellHI = new Cell(new Chunk("", tableContent));            
            titleCellHI.setColspan(10);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);            
            
            titleCellHI = new Cell(new Chunk("", tableContent));            
            titleCellHI.setColspan(10);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("", tableContent));            
            titleCellHI.setColspan(7);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);
            
            titleCellHI = new Cell(new Chunk("...... , ........ ", tableContent));            
            titleCellHI.setColspan(3);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);    
            
            titleCellHI = new Cell(new Chunk("", tableContent));            
            titleCellHI.setColspan(10);
            titleCellHI.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHI.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHI.setBorderColor(new Color(255, 255, 255));
            title.addCell(titleCellHI);            
            
            document.add(title);            
            
            int titleTab[] = {30,30,30};

            Table titleTb = new Table(3);
            titleTb.setWidth(100);            
            titleTb.setWidths(titleTab);
            titleTb.setPadding(0);
            titleTb.setBorderColor(black);
            titleTb.setBorderWidth(0);
            titleTb.setAlignment(1);
            titleTb.setCellpadding(0);
            titleTb.setCellspacing(3);
            
            Cell titleCellTb = new Cell(new Chunk("Menyetujui", tableContent));            
            titleCellTb.setColspan(2);                        
            titleCellTb.setBorderColor(black);
            titleCellTb.setBackgroundColor(putih);
            titleCellTb.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTb.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleTb.addCell(titleCellTb); 
            
            titleCellTb = new Cell(new Chunk("Pemesan/Pembeli", tableContent));            
            titleCellTb.setRowspan(2);
            titleCellTb.setBorderColor(black);
            titleCellTb.setBackgroundColor(putih);
            titleCellTb.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTb.setVerticalAlignment(Element.ALIGN_TOP);            
            titleTb.addCell(titleCellTb); 
            
            titleCellTb = new Cell(new Chunk("Kepala Bagian Penjualan", tableContent));                        
            titleCellTb.setBorderColor(black);
            titleCellTb.setBackgroundColor(putih);
            titleCellTb.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTb.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleTb.addCell(titleCellTb); 
            
            titleCellTb = new Cell(new Chunk("Bagian Penjualan", tableContent));                        
            titleCellTb.setBorderColor(black);
            titleCellTb.setBackgroundColor(putih);
            titleCellTb.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTb.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleTb.addCell(titleCellTb); 
            
            titleCellTb = new Cell(new Chunk("", tableContentX));                        
            titleCellTb.setVerticalAlignment(50);            
            titleCellTb.setBorderColor(black);    
            titleCellTb.setBackgroundColor(putih);
            titleCellTb.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTb.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleTb.addCell(titleCellTb); 
            
            titleCellTb = new Cell(new Chunk("", tableContent));                     
            titleCellTb.setVerticalAlignment(50);
            titleCellTb.setBorderColor(black);    
            titleCellTb.setBackgroundColor(putih);
            titleCellTb.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTb.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleTb.addCell(titleCellTb); 
            
            titleCellTb = new Cell(new Chunk("", tableContent));                                
            titleCellTb.setBorderColor(black);    
            titleCellTb.setBackgroundColor(putih);
            titleCellTb.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTb.setVerticalAlignment(Element.ALIGN_MIDDLE);            
            titleTb.addCell(titleCellTb); 
            
            document.add(titleTb);

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

