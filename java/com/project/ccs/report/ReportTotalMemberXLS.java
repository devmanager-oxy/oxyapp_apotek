/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.I_Project;
import com.project.admin.DbSegmentUser;
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

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.session.MemberParameter;
import com.project.ccs.session.SessReportClosing;
import com.project.general.Bank;
import com.project.general.Company;
import com.project.general.Customer;
import com.project.general.DbBank;
import com.project.general.DbCompany;

import com.project.general.DbCustomer;
import com.project.general.DbIndukCustomer;
import com.project.general.DbLocation;
import com.project.general.DbMerchant;
import com.project.general.IndukCustomer;
import com.project.general.Location;
import com.project.general.Merchant;
import com.project.general.Vendor;
import com.project.system.DbSystemProperty;
import java.util.Date;
import java.util.Hashtable;

/**
 *
 * @author Roy
 */
public class ReportTotalMemberXLS extends HttpServlet {

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

        long userId = 0;
        User user = new User();
        MemberParameter memberParameter = new MemberParameter();
        HttpSession session = request.getSession();

        try {
            memberParameter = (MemberParameter) session.getValue("REPORT_GROUP_CUSTOMER");
        } catch (Exception e) {
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
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

        boolean gzip = false;

        OutputStream gzo;
        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }

        String whereClause = DbCustomer.colNames[DbCustomer.COL_TYPE] + " in (" + DbCustomer.CUSTOMER_TYPE_REGULAR + "," + DbCustomer.CUSTOMER_TYPE_COMMON_AREA + ")";

        long oidPub = 0;
        try {
            oidPub = Long.parseLong(DbSystemProperty.getValueByName("OID_CUSTOMER_PUBLIC"));
        } catch (Exception e) {
            oidPub = 0;
        }

        if (oidPub != 0) {
            whereClause = whereClause + " and " + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " != " + oidPub;
        }

        String status = "";
        if (memberParameter.getStatusDraft() == 1 || memberParameter.getStatusApprove() == 1 || memberParameter.getStatusExpired() == 1) {
            if (memberParameter.getStatusDraft() == 1) {
                if (status.length() > 0) {
                    status = status + ",";
                }
                status = status + "'','" + I_Project.DOC_STATUS_DRAFT + "'";
            }

            if (memberParameter.getStatusApprove() == 1) {
                if (status.length() > 0) {
                    status = status + ",";
                }
                status = status + "'" + I_Project.DOC_STATUS_APPROVED + "'";
            }

            if (memberParameter.getStatusExpired() == 1) {
                if (status.length() > 0) {
                    status = status + ",";
                }
                status = status + "'" + I_Project.DOC_STATUS_EXPIRED + "'";
            }
        } else {
            status = "-1";
        }

        if (status.length() > 0) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }

            whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_STATUS] + " in (" + status + ") ";
        }

        if (memberParameter.getCode() != null && memberParameter.getCode().length() > 0) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_CODE] + " like '%" + memberParameter.getCode() + "%' ";
        }

        if (memberParameter.getName() != null && memberParameter.getName().length() > 0) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_NAME] + " like '%" + memberParameter.getName() + "%' ";
        }

        if (memberParameter.getAddress() != null && memberParameter.getAddress().length() > 0) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_ADDRESS_1] + " like '%" + memberParameter.getAddress() + "%' ";
        }

        if (memberParameter.getId() != null && memberParameter.getId().length() > 0) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_ID_NUMBER] + " like '%" + memberParameter.getId() + "%' ";
        }


        Vector loc = new Vector();
        try {
            if (memberParameter.getLocationRegId() != 0) {
                loc = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + memberParameter.getLocationRegId(), DbLocation.colNames[DbLocation.COL_NAME]);
            } else {
                loc = DbSegmentUser.userLocations(user.getOID());
            }
        } catch (Exception e) {
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
        wb.println("      <Author>Roy</Author>");
        wb.println("      <LastAuthor>Roy</LastAuthor>");
        wb.println("      <Created>2015-10-15T17:28:12Z</Created>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>8445</WindowHeight>");
        wb.println("      <WindowWidth>20055</WindowWidth>");
        wb.println("      <WindowTopX>240</WindowTopX>");
        wb.println("      <WindowTopY>105</WindowTopY>");
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
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s77\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s78\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s80\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s82\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"mmm\\-yy\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s83\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"30\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"153\"/>");
        wb.println("      <Column ss:Width=\"58.5\"/>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s83\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s83\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"4\">");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s83\"><Data ss:Type=\"String\">Data Total Register Member</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s83\"><Data ss:Type=\"String\">Registrasi Date between : " + JSPFormater.formatDate(memberParameter.getRegStart(), "dd-MM-yyyy") + " and " + JSPFormater.formatDate(memberParameter.getRegEnd(), "dd-MM-yyyy") + "</Data></Cell>");
        wb.println("      </Row>");
        int yearStart = memberParameter.getRegStart().getYear() + 1900;
        int yearEnd = memberParameter.getRegEnd().getYear() + 1900;

        Vector strDate = new Vector();
        int grandTotal[];
        int grandSubTotal = 0;
        grandTotal = new int[100];

        wb.println("      <Row ss:Index=\"7\">");
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">NO</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">LOCATION</Data></Cell>");
        while (yearStart <= yearEnd) {
            int m = 1;
            int y = 12;

            if (yearStart == (memberParameter.getRegStart().getYear() + 1900)) {
                m = memberParameter.getRegStart().getMonth() + 1;
            }

            if (yearStart == yearEnd) {
                y = memberParameter.getRegEnd().getMonth() + 1;
            }

            for (int i = m; i <= y; i++) {

                String strMonth = "";
                String intMonth = "";
                if (i == 1) {
                    strMonth = "Jan";
                    intMonth = "01";
                } else if (i == 2) {
                    strMonth = "Feb";
                    intMonth = "02";
                } else if (i == 3) {
                    strMonth = "Mar";
                    intMonth = "03";
                } else if (i == 4) {
                    strMonth = "Apr";
                    intMonth = "04";
                } else if (i == 5) {
                    strMonth = "Mei";
                    intMonth = "05";
                } else if (i == 6) {
                    strMonth = "Jun";
                    intMonth = "06";
                } else if (i == 7) {
                    strMonth = "Jul";
                    intMonth = "07";
                } else if (i == 8) {
                    strMonth = "Agu";
                    intMonth = "08";
                } else if (i == 9) {
                    strMonth = "Sep";
                    intMonth = "09";
                } else if (i == 10) {
                    strMonth = "Okt";
                    intMonth = "10";
                } else if (i == 11) {
                    strMonth = "Nov";
                    intMonth = "11";
                } else if (i == 12) {
                    strMonth = "Des";
                    intMonth = "12";
                }
                strMonth = strMonth + "-" + yearStart;
                strDate.add(intMonth + "-" + yearStart);
                wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + strMonth + "</Data></Cell>");

            }
            yearStart++;
        }
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println("      </Row>");
        int number = 1;
        for (int i = 0; i < loc.size(); i++) {

            Location l = (Location) loc.get(i);
            Location lxx = new Location();
            try {
                lxx = DbLocation.fetchExc(l.getOID());
            } catch (Exception e) {
            }
            if (lxx.getType().equals(DbLocation.TYPE_STORE) && lxx.getCode().compareTo("1024") != 0 && lxx.getCode().compareTo("1033") != 0 && lxx.getCode().compareTo("1022") != 0 && lxx.getCode().compareTo("1007") != 0 ) {

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"Number\">" + (number) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">" + l.getName() + "</Data></Cell>");
                String where = whereClause;

                where = where + " and " + DbCustomer.colNames[DbCustomer.COL_KECAMATAN_ID] + " = " + l.getOID();

                where = where + " and ( " + DbCustomer.colNames[DbCustomer.COL_REG_DATE] + " between '" + JSPFormater.formatDate(memberParameter.getRegStart(), "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(memberParameter.getRegEnd(), "yyyy-MM-dd") + " 23:59:59') ";
                Hashtable value = DbCustomer.getTotal(where, DbCustomer.colNames[DbCustomer.COL_REG_DATE]);
                int subTotal = 0;
                for (int x = 0; x < strDate.size(); x++) {
                    String per = String.valueOf(strDate.get(x));
                    int total = 0;
                    try {
                        total = Integer.parseInt(String.valueOf(value.get(String.valueOf(per))));
                    } catch (Exception e) {
                    }
                    subTotal = subTotal + total;
                    grandTotal[x] = grandTotal[x] + total;
                    grandSubTotal = grandSubTotal + total;
                    wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
                }
                wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"Number\">" + subTotal + "</Data></Cell>");
                wb.println("      </Row>");
                number++;
            }

        }

        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s76\"><Data ss:Type=\"String\">Grand Total</Data></Cell>");
        for (int x = 0; x < strDate.size(); x++) {
            wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + grandTotal[x] + "</Data></Cell>");
        }
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">" + grandSubTotal + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <HorizontalResolution>-3</HorizontalResolution>");
        wb.println("      <VerticalResolution>0</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>6</ActiveRow>");
        wb.println("      <ActiveCol>9</ActiveCol>");
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
        wb.println("      ");

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
