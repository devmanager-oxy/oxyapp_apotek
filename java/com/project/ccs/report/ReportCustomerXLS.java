/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.I_Project;
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
public class ReportCustomerXLS extends HttpServlet {

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
            memberParameter = (MemberParameter) session.getValue("REPORT_CUSTOMER");
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
        wb.println("      <Created>2015-05-19T23:06:06Z</Created>");
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
        wb.println("      <Style ss:ID=\"s81\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s84\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s91\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s92\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s93\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s94\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Medium Date\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s95\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s96\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"33\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"60.75\"/>");
        wb.println("      <Column ss:Width=\"71.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"50.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"68.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"149.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"101.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"118.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"96\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"135\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"99\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66\"/>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"9\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"9\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"4\">");
        wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s81\"><Data ss:Type=\"String\">Printed by : " + user.getFullName() + ", date : " + JSPFormater.formatDate(new Date(), "dd-MMM-yyyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");

        if (memberParameter.getType() != -1) {
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s81\"><Data ss:Type=\"String\">Type : " + DbCustomer.customerGroup[memberParameter.getType()] + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (memberParameter.getLocationRegId() != 0) {
            Location l = new Location();
            try {
                l = DbLocation.fetchExc(memberParameter.getLocationRegId());
                wb.println("      <Row >");
                wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s81\"><Data ss:Type=\"String\">Location Register : " + l.getName() + "</Data></Cell>");
                wb.println("      </Row>");
            } catch (Exception e) {
            }
        }

        if ((memberParameter.getName() != null && memberParameter.getName().length() > 0) || (memberParameter.getCode() != null && memberParameter.getCode().length() > 0) || (memberParameter.getId() != null && memberParameter.getId().length() > 0)) {
            String str = "";
            if (memberParameter.getName() != null && memberParameter.getName().length() > 0) {
                if (str.length() > 0) {
                    str = str + ",";
                }
                str = str + "Name:" + memberParameter.getName();
            }
            if (memberParameter.getCode() != null && memberParameter.getCode().length() > 0) {
                if (str.length() > 0) {
                    str = str + ",";
                }
                str = str + "code:" + memberParameter.getCode();
            }
            if (memberParameter.getId() != null && memberParameter.getId().length() > 0) {
                if (str.length() > 0) {
                    str = str + ",";
                }
                str = str + "Id:" + memberParameter.getId();
            }
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s81\"><Data ss:Type=\"String\">Parameter : " + str + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (memberParameter.getAddress() != null && memberParameter.getAddress().length() > 0) {
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s81\"><Data ss:Type=\"String\">Parameter : Address " + memberParameter.getAddress() + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (memberParameter.getIgnoreReg() == 0) {
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s81\"><Data ss:Type=\"String\">Registrasi Date between : " + JSPFormater.formatDate(memberParameter.getRegStart(), "dd-MM-yyyy") + " and " + JSPFormater.formatDate(memberParameter.getRegEnd(), "dd-MM-yyyy") + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (memberParameter.getIgnoreDob() == 0) {
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s81\"><Data ss:Type=\"String\">Registrasi Date between : " + JSPFormater.formatDate(memberParameter.getDobStart(), "dd-MM-yyyy") + " and " + JSPFormater.formatDate(memberParameter.getDobEnd(), "dd-MM-yyyy") + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (memberParameter.getStatusDraft() == 1 || memberParameter.getStatusApprove() == 1 || memberParameter.getStatusExpired() == 1) {
            String str = "";

            if (memberParameter.getStatusDraft() == 1) {
                if (str.length() > 0) {
                    str = str + ",";
                }
                str = str + "Draft";
            }

            if (memberParameter.getStatusApprove() == 1) {
                if (str.length() > 0) {
                    str = str + ",";
                }
                str = str + "Approved";
            }

            if (memberParameter.getStatusExpired() == 1) {
                if (str.length() > 0) {
                    str = str + ",";
                }
                str = str + "Expired";
            }

            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s81\"><Data ss:Type=\"String\">Status : " + str + "</Data></Cell>");
            wb.println("      </Row>");

        }

        String whereClause = "";

        int type = memberParameter.getType();
        long oidPub = 0;
        try {
            oidPub = Long.parseLong(DbSystemProperty.getValueByName("OID_CUSTOMER_PUBLIC"));
        } catch (Exception e) {
            oidPub = 0;
        }

        if (type == -1) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_TYPE] + " in (" + DbCustomer.CUSTOMER_TYPE_REGULAR + "," + DbCustomer.CUSTOMER_TYPE_COMMON_AREA + ")";
        } else {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_TYPE] + " = " + type;
        }

        if (memberParameter.getLocationRegId() != 0) {
            whereClause = whereClause + " and " + DbCustomer.colNames[DbCustomer.COL_KECAMATAN_ID] + " = " + memberParameter.getLocationRegId();
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

        if (memberParameter.getIgnoreDob() == 0) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " ( " + DbCustomer.colNames[DbCustomer.COL_DOB] + " between '" + JSPFormater.formatDate(memberParameter.getDobStart(), "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(memberParameter.getDobEnd(), "yyyy-MM-dd") + " 23:59:59') and " + DbCustomer.colNames[DbCustomer.COL_DOB_IGNORE] + " = 0";
        }

        if (memberParameter.getIgnoreReg() == 0) {
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " ( " + DbCustomer.colNames[DbCustomer.COL_REG_DATE] + " between '" + JSPFormater.formatDate(memberParameter.getRegStart(), "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(memberParameter.getRegEnd(), "yyyy-MM-dd") + " 23:59:59') ";
        }

        Vector listCustomer = DbCustomer.list(0, 0, whereClause, DbCustomer.colNames[DbCustomer.COL_CODE]);

        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s81\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">No.</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Code</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Type</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Price Zone</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Reg. Date</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Name</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Term Of Payment(Days)</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Telphone / Mobile</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Address</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Location Reg.</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Email</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">Status</Data></Cell>");
        wb.println("      </Row>");

        if (listCustomer != null && listCustomer.size() > 0) {

            Vector list = DbLocation.listAll();
            Hashtable lx = new Hashtable();
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    Location l = (Location) list.get(i);
                    lx.put("" + l.getOID(), l.getName());
                }
            }
            for (int i = 0; i < listCustomer.size(); i++) {

                Customer c = (Customer) listCustomer.get(i);

                String telephone = "";
                if (c.getPhone() != null && c.getPhone().length() > 0) {
                    if (telephone.length() > 0) {
                        telephone = telephone + ", ";
                    }
                    telephone = telephone + "" + c.getPhone();
                }

                if (c.getHp() != null && c.getHp().length() > 0) {
                    if (telephone.length() > 0) {
                        telephone = telephone + ", ";
                    }
                    telephone = telephone + "" + c.getHp();
                }

                String strReg = "";
                if (c.getRegDate() != null) {
                    try {
                        strReg = JSPFormater.formatDate(c.getRegDate(), "dd MMM yyyy");
                    } catch (Exception e) {
                    }
                } else {
                    strReg = "";
                }

                String sts = "DRAFT";
                if (c.getStatus().length() > 0) {
                    sts = c.getStatus();
                }

                String locName = "";
                try {
                    locName = String.valueOf(lx.get("" + c.getKecamatanId()));
                } catch (Exception e) {
                    locName = "";
                }
                if(locName == null || locName.equalsIgnoreCase("null")){
                    locName = "";
                }
                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">" + c.getCode() + "</Data></Cell>");                
                wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">" + DbCustomer.customerGroup[c.getType()] + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\">" + c.getGolPrice() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s94\"><Data ss:Type=\"String\" x:Ticked=\"1\">" + strReg + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">" + c.getName() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"String\">"+(c.getJatuhTempo())+ "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">" + telephone + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">" + c.getAddress1() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">" + locName + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">" + c.getEmail() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">" + sts + "</Data></Cell>");
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
        wb.println("      <PaperSizeIndex>125</PaperSizeIndex>");
        wb.println("      <HorizontalResolution>120</HorizontalResolution>");
        wb.println("      <VerticalResolution>72</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <RangeSelection>R1C1:R1C10</RangeSelection>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table>");
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
