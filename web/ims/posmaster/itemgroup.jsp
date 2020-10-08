
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_CATEGORY);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_CATEGORY, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_CATEGORY, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_CATEGORY, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_CATEGORY, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspItemGroup frmObject, ItemGroup objEntity, Vector objectClass, long itemGroupId,int start) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("1500");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");        
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("<font face=\"arial\">No</font>", "20","2","0");
        jsplist.addHeader("<font face=\"arial\">Type</font>", "70","2","0");
        jsplist.addHeader("<font face=\"arial\">Code</font>", "3%","2","0");
        jsplist.addHeader("<font face=\"arial\">Name</font>", "","2","0");        
        jsplist.addHeader("<font face=\"arial\">Chart Of Account</font>", "","0","20");        
        jsplist.addHeader("<font face=\"arial\">Cash Income</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Credit Income</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Cash Sales</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Credit Sales</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Service Sales</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Service</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">COGS</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Inventory</font>", "60","0","0");
        
        jsplist.addHeader("<font face=\"arial\">Grosir Sales</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Grosir Cogs</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Grosir Inventory</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Grosir Discount</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Grosir Adjusment</font>", "60","0","0");
        
        jsplist.addHeader("<font face=\"arial\">VAT</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">PPH</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Discount</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Other Income</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Bonus</font>", "60","0","0");
        jsplist.addHeader("<font face=\"arial\">Costing</font>", "60","0","0");        
        jsplist.addHeader("<font face=\"arial\">Ajustment</font>", "60","0","0"); 
        jsplist.addHeader("<font face=\"arial\">Bonus</font>", "60","2","0"); 
        jsplist.addHeader("<font face=\"arial\">Qty Beli</font>", "60","2","0"); 
        jsplist.addHeader("<font face=\"arial\">Qty Bonus</font>", "60","2","0"); 

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;

        Vector status_value = new Vector(1, 1);
        Vector status_key = new Vector(1, 1);
        
        status_value.add("" + I_Ccs.TYPE_CATEGORY_FINISH_GOODS);        
        status_key.add(I_Ccs.strCategoryType[I_Ccs.TYPE_CATEGORY_FINISH_GOODS]);

        status_value.add("" + I_Ccs.TYPE_CATEGORY_RAW_MATERIAL);
        status_key.add(I_Ccs.strCategoryType[I_Ccs.TYPE_CATEGORY_RAW_MATERIAL]);
                
        status_value.add("" + I_Ccs.TYPE_CATEGORY_SPBU_MATERIAL);
        status_key.add(I_Ccs.strCategoryType[I_Ccs.TYPE_CATEGORY_SPBU_MATERIAL]);
        
        status_value.add("" + I_Ccs.TYPE_CATEGORY_ROOM);
        status_key.add(I_Ccs.strCategoryType[I_Ccs.TYPE_CATEGORY_ROOM]);
        
        status_value.add("" + I_Ccs.TYPE_CATEGORY_SPA_MATERIAL);
        status_key.add(I_Ccs.strCategoryType[I_Ccs.TYPE_CATEGORY_SPA_MATERIAL]);
		
        status_value.add("" + I_Ccs.TYPE_CATEGORY_HANDPHONE);
        status_key.add(I_Ccs.strCategoryType[I_Ccs.TYPE_CATEGORY_HANDPHONE]);
        
        status_value.add("" + I_Ccs.TYPE_CATEGORY_HANDPHONE_ACCESORRIES);
        status_key.add(I_Ccs.strCategoryType[I_Ccs.TYPE_CATEGORY_HANDPHONE_ACCESORRIES]);

        for (int i = 0; i < objectClass.size(); i++) {
            ItemGroup itemGroup = (ItemGroup) objectClass.get(i);
            rowx = new Vector();
            if (itemGroupId == itemGroup.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {
                rowx.add("<div=\"center\">"+(start+i+1)+"</div>");
                rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE], null, "" + itemGroup.getType(), status_value, status_key, "formElemen", "") + frmObject.getErrorMsg(frmObject.JSP_TYPE));
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_CODE] + "\" value=\"" + itemGroup.getCode() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"32\" name=\"" + frmObject.colNames[JspItemGroup.JSP_NAME] + "\" value=\"" + itemGroup.getName() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_CASH_INCOME] + "\" value=\"" + itemGroup.getAccountCashIncome() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_CREDIT_INCOME] + "\" value=\"" + itemGroup.getAccountCreditIncome() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_SALES_CASH] + "\" value=\"" + itemGroup.getAccountSalesCash() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_SALES] + "\" value=\"" + itemGroup.getAccountSales() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_SALES_JASA] + "\" value=\"" + itemGroup.getAccountSalesJasa() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_EXPENSE_JASA] + "\" value=\"" + itemGroup.getAccountExpenseJasa() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_COGS] + "\" value=\"" + itemGroup.getAccountCogs() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_INV] + "\" value=\"" + itemGroup.getAccountInv() + "\" class=\"formElemen\">" + "</div>");
                
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_GROSIR_SALES] + "\" value=\"" + itemGroup.getAccountGrosirSales() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_GROSIR_COGS] + "\" value=\"" + itemGroup.getAccountGrosirCOGS() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_GROSIR_INVENTORY] + "\" value=\"" + itemGroup.getAccountGrosirInventory() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_GROSIR_DISCOUNT] + "\" value=\"" + itemGroup.getAccountGrosirDiscount() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_GROSIR_ADJUSMENT] + "\" value=\"" + itemGroup.getAccountGrosirAdjusment() + "\" class=\"formElemen\">" + "</div>");
                
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_VAT] + "\" value=\"" + itemGroup.getAccountVat() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_PPH] + "\" value=\"" + itemGroup.getAccountPph() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_DISCOUNT] + "\" value=\"" + itemGroup.getAccountDiscount() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_OTHER_INCOME] + "\" value=\"" + itemGroup.getAccountOtherIncome() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_BONUS_INCOME] + "\" value=\"" + itemGroup.getAccountBonusIncome() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_COSTING] + "\" value=\"" + itemGroup.getAccountCosting() + "\" class=\"formElemen\">" + "</div>");                
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_AJUSTMENT] + "\" value=\"" + itemGroup.getAccountAjustment() + "\" class=\"formElemen\">" + "</div>");   
                
                rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" name=\"" + frmObject.colNames[JspItemGroup.JSP_BONUS] + "\" "+ (itemGroup.getBonus() == 1 ? "checked" : "")+ " value=\"1\" >" + "</div>");                
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_QTY_BELI] + "\" value=\"" + itemGroup.getQtyBeli() + "\" class=\"formElemen\">" + "</div>");   
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_QTY_BONUS] + "\" value=\"" + itemGroup.getQtyBonus() + "\" class=\"formElemen\">" + "</div>");   

            } else {
                rowx.add("<div=\"center\">"+(start+i+1)+"</div>");
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(itemGroup.getOID()) + "')\">" + I_Ccs.strCategoryType[itemGroup.getType()] + "</a>");
                rowx.add("<font face=\"arial\">"+itemGroup.getCode()+"</font>");
                rowx.add(itemGroup.getName());
                rowx.add((itemGroup.getAccountCashIncome() == null) ? "" : itemGroup.getAccountCashIncome());
                rowx.add((itemGroup.getAccountCreditIncome() == null) ? "" : itemGroup.getAccountCreditIncome());
                rowx.add((itemGroup.getAccountSalesCash() == null) ? "" : itemGroup.getAccountSalesCash());
                rowx.add((itemGroup.getAccountSales() == null) ? "" : itemGroup.getAccountSales());
                rowx.add((itemGroup.getAccountSalesJasa() == null) ? "" : itemGroup.getAccountSalesJasa());
                rowx.add((itemGroup.getAccountExpenseJasa() == null) ? "" : itemGroup.getAccountExpenseJasa());
                rowx.add((itemGroup.getAccountCogs() == null) ? "" : itemGroup.getAccountCogs());
                rowx.add((itemGroup.getAccountInv() == null) ? "" : itemGroup.getAccountInv());
                
                rowx.add((itemGroup.getAccountInv() == null) ? "" : itemGroup.getAccountGrosirSales());
                rowx.add((itemGroup.getAccountGrosirCOGS() == null) ? "" : itemGroup.getAccountGrosirCOGS());
                rowx.add((itemGroup.getAccountGrosirInventory() == null) ? "" : itemGroup.getAccountGrosirInventory());
                rowx.add((itemGroup.getAccountGrosirDiscount() == null) ? "" : itemGroup.getAccountGrosirDiscount());
                rowx.add((itemGroup.getAccountGrosirAdjusment() == null) ? "" : itemGroup.getAccountGrosirAdjusment());
                
                rowx.add((itemGroup.getAccountVat() == null) ? "" : itemGroup.getAccountVat());
                rowx.add((itemGroup.getAccountPph() == null) ? "" : itemGroup.getAccountPph());
                rowx.add((itemGroup.getAccountDiscount() == null) ? "" : itemGroup.getAccountDiscount());
                rowx.add((itemGroup.getAccountOtherIncome() == null) ? "" : itemGroup.getAccountOtherIncome());
                rowx.add((itemGroup.getAccountBonusIncome() == null) ? "" : itemGroup.getAccountBonusIncome());
                rowx.add((itemGroup.getAccountCosting() == null) ? "" : itemGroup.getAccountCosting());                
                rowx.add((itemGroup.getAccountAjustment() == null) ? "" : itemGroup.getAccountAjustment());                
                rowx.add("<div align=\"center\">"+(itemGroup.getBonus() == 1 ? "Y" : "N")+"</div>");
                rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(itemGroup.getQtyBeli(),"###,###.##")+"</div>");                
                rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(itemGroup.getQtyBonus(),"###,###.##")+"</div>");                

            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("");
            rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE], null, "" + objEntity.getType(), status_value, status_key, "formElemen", "") + frmObject.getErrorMsg(frmObject.JSP_TYPE));
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_CODE] + "\" value=\"" + objEntity.getCode() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"32\" name=\"" + frmObject.colNames[JspItemGroup.JSP_NAME] + "\" value=\"" + objEntity.getName() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_CASH_INCOME] + "\" value=\"" + objEntity.getAccountCashIncome() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_CREDIT_INCOME] + "\" value=\"" + objEntity.getAccountCreditIncome() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_SALES_CASH] + "\" value=\"" + objEntity.getAccountSalesCash() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_SALES] + "\" value=\"" + objEntity.getAccountSales() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_SALES_JASA] + "\" value=\"" + objEntity.getAccountSalesJasa() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_EXPENSE_JASA] + "\" value=\"" + objEntity.getAccountExpenseJasa() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_COGS] + "\" value=\"" + objEntity.getAccountCogs() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_INV] + "\" value=\"" + objEntity.getAccountInv() + "\" class=\"formElemen\">" + "</div>");
            
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_GROSIR_SALES] + "\" value=\"" + objEntity.getAccountGrosirSales() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_GROSIR_COGS] + "\" value=\"" + objEntity.getAccountGrosirCOGS() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_GROSIR_INVENTORY] + "\" value=\"" + objEntity.getAccountGrosirInventory() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_GROSIR_DISCOUNT] + "\" value=\"" + objEntity.getAccountGrosirDiscount() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_GROSIR_ADJUSMENT] + "\" value=\"" + objEntity.getAccountGrosirAdjusment() + "\" class=\"formElemen\">" + "</div>");
            
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_VAT] + "\" value=\"" + objEntity.getAccountVat() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_PPH] + "\" value=\"" + objEntity.getAccountPph() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_DISCOUNT] + "\" value=\"" + objEntity.getAccountDiscount() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_OTHER_INCOME] + "\" value=\"" + objEntity.getAccountOtherIncome() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_BONUS_INCOME] + "\" value=\"" + objEntity.getAccountBonusIncome() + "\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_COSTING] + "\" value=\"" + objEntity.getAccountCosting() + "\" class=\"formElemen\">" + "</div>");            
            rowx.add("<div align=\"center\">" + "<input type=\"text\"  size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_ACCOUNT_AJUSTMENT] + "\" value=\"" + objEntity.getAccountAjustment() + "\" class=\"formElemen\">" + "</div>");            
            rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" name=\"" + frmObject.colNames[JspItemGroup.JSP_BONUS] + "\" "+ (objEntity.getBonus() == 1 ? "checked" : "")+"\" value=\"1\" >" + "</div>");                
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_QTY_BELI] + "\" value=\"" + objEntity.getQtyBeli() + "\" class=\"formElemen\">" + "</div>");   
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"13\" name=\"" + frmObject.colNames[JspItemGroup.JSP_QTY_BONUS] + "\" value=\"" + objEntity.getQtyBonus() + "\" class=\"formElemen\">" + "</div>");   
        }

        lstData.add(rowx);

        return jsplist.drawList(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemGroup = JSPRequestValue.requestLong(request, "hidden_item_group_id");
            int showAll = JSPRequestValue.requestInt(request, "show_all");

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "code";

            whereClause = " type in (" + I_Ccs.TYPE_CATEGORY_FINISH_GOODS+"," + I_Ccs.TYPE_CATEGORY_RAW_MATERIAL+","+ I_Ccs.TYPE_CATEGORY_SPBU_MATERIAL+","+I_Ccs.TYPE_CATEGORY_ROOM+","+I_Ccs.TYPE_CATEGORY_SPA_MATERIAL+") ";
            

            CmdItemGroup ctrlItemGroup = new CmdItemGroup(request);
            ctrlItemGroup.setUserId(user.getOID());
            ctrlItemGroup.setEmployeeId(user.getEmployeeId());
            JSPLine jspLine = new JSPLine();
            Vector listItemGroup = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlItemGroup.action(iJSPCommand, oidItemGroup);
            
            
            /* end switch*/
            JspItemGroup jspItemGroup = ctrlItemGroup.getForm();

            /*count list All ItemGroup*/
            int vectSize = DbItemGroup.getCount(whereClause);

            /*switch list ItemGroup*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlItemGroup.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            ItemGroup itemGroup = ctrlItemGroup.getItemGroup();
            msgString = ctrlItemGroup.getMessage();

            /* get record to display */
            listItemGroup = DbItemGroup.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listItemGroup.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listItemGroup = DbItemGroup.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdUnShowAll(){                
                document.frmitemgroup.command.value="<%=JSPCommand.LIST%>";                
                document.frmitemgroup.show_all.value=0;
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdShowAll(){                
                document.frmitemgroup.command.value="<%=JSPCommand.LIST%>";                
                document.frmitemgroup.show_all.value=1;
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdAdd(){
                document.frmitemgroup.hidden_item_group_id.value="0";
                document.frmitemgroup.command.value="<%=JSPCommand.ADD%>";
                document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdAsk(oidItemGroup){
                document.frmitemgroup.hidden_item_group_id.value=oidItemGroup;
                document.frmitemgroup.command.value="<%=JSPCommand.ASK%>";
                document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdConfirmDelete(oidItemGroup){
                document.frmitemgroup.hidden_item_group_id.value=oidItemGroup;
                document.frmitemgroup.command.value="<%=JSPCommand.DELETE%>";
                document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdSave(){
                document.frmitemgroup.command.value="<%=JSPCommand.SAVE%>";
                document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdEdit(oidItemGroup){
                <%if(privUpdate || privDelete){%>
                document.frmitemgroup.hidden_item_group_id.value=oidItemGroup;
                document.frmitemgroup.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
                <%}%>
            }
            
            function cmdCancel(oidItemGroup){
                document.frmitemgroup.hidden_item_group_id.value=oidItemGroup;
                document.frmitemgroup.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdBack(){
                document.frmitemgroup.command.value="<%=JSPCommand.BACK%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdListFirst(){
                document.frmitemgroup.command.value="<%=JSPCommand.FIRST%>";
                document.frmitemgroup.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdListPrev(){
                document.frmitemgroup.command.value="<%=JSPCommand.PREV%>";
                document.frmitemgroup.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdListNext(){
                document.frmitemgroup.command.value="<%=JSPCommand.NEXT%>";
                document.frmitemgroup.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            function cmdListLast(){
                document.frmitemgroup.command.value="<%=JSPCommand.LAST%>";
                document.frmitemgroup.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmitemgroup.action="itemgroup.jsp";
                document.frmitemgroup.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidItemGroup){
                document.frmimage.hidden_item_group_id.value=oidItemGroup;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="itemgroup.jsp";
                document.frmimage.submit();
            }
            
            //-------------- script control line -------------------
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            
            function MM_findObj(n, d) { //v4.0
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && document.getElementById) x=document.getElementById(n); return x;
            }
            
            function MM_swapImage() { //v3.0
                var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }
            
        </script>
        
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> 
                                <!-- #BeginEditable "header" --> 
            <%@ include file = "../main/hmenu.jsp" %>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmitemgroup" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_item_group_id" value="<%=oidItemGroup%>">
                                                            <input type="hidden" name="show_all" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                        Maintenance </font><font class="tit1">&raquo; 
                                                                                        </font><span class="lvl2">Material Category 
                                                                                </span></b></td>
                                                                                <td width="40%" height="23"> 
                                                                                    <%@ include file = "../main/userpreview.jsp" %>
                                                                                </td>
                                                                            </tr>
                                                                            <tr > 
                                                                                <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="5" valign="middle" colspan="3"> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(iJSPCommand, jspItemGroup, itemGroup, listItemGroup, oidItemGroup,start)%> </td>
                                                                                        </tr>
                                                                                        <%
            } catch (Exception exc) {
            }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"> 
                                                                                                <span class="command"> 
                                                                                        <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevJSPCommand;
                }
            }
                                                                                        %>
                                                                                        <% jspLine.setLocationImg(approot + "/images/ctr_line");
            jspLine.initDefault();
                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span></td>
                                                                                        </tr>
                                                                                        <%
            if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top">
                                                                                            
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                            
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <%if(privAdd){%>
                                                                                            <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                                <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                            </tr>
                                                                            <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                            <tr align="left" valign="top" > 
                                                                                <td colspan="3" class="command"> 
                                                                                    <%
    jspLine.setLocationImg(approot + "/images/ctr_line");
    jspLine.initDefault();
    jspLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidItemGroup + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidItemGroup + "')";
    String scancel = "javascript:cmdEdit('" + oidItemGroup + "')";
    jspLine.setBackCaption("Back to List");
    jspLine.setJSPCommandStyle("buttonlink");

    jspLine.setOnMouseOut("MM_swapImgRestore()");
    jspLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
    jspLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

    //jspLine.setOnMouseOut("MM_swapImgRestore()");
    jspLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
    jspLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

    jspLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
    jspLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

    jspLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/cancel2.gif',1)");
    jspLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


    jspLine.setWidthAllJSPCommand("90");
    jspLine.setErrorStyle("warning");
    jspLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    jspLine.setQuestionStyle("warning");
    jspLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    jspLine.setInfoStyle("success");
    jspLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");


    if (privDelete) {
        jspLine.setConfirmDelJSPCommand(sconDelCom);
        jspLine.setDeleteJSPCommand(scomDel);
        jspLine.setEditJSPCommand(scancel);
    } else {
        jspLine.setConfirmDelCaption("");
        jspLine.setDeleteCaption("");
        jspLine.setEditCaption("");
    }

    if (privAdd == false && privUpdate == false) {
        jspLine.setSaveCaption("");
    }

    if (privAdd == false) {
        jspLine.setAddCaption("");
    }
                                                                                    %>
                                                                                <%= jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr>
                                                                                <td colspan="3">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr>
                                                                                <td colspan="3">
                                                                                    <table width="800" >
                                                                                        <tr>
                                                                                            <td width="120" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Date</i><b></td>
                                                                                            <td width="470" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Description</i><b></td>
                                                                                            <td bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>By</i><b></td>
                                                                                        </tr>   
                                                                                        <%
     int max = 10;
     if (showAll == 1) {
         max = 0;
     }
     int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_ITEM_GROUP);
     Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_ITEM_GROUP, DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
     if (historys != null && historys.size() > 0) {

         for (int r = 0; r < historys.size(); r++) {
             HistoryUser hu = (HistoryUser) historys.get(r);
             
             Employee e = new Employee();
             try {
                 e = DbEmployee.fetchExc(hu.getEmployeeId());
             } catch (Exception ex) {
             }
             String name = "-";
             if (e.getName() != null && e.getName().length() > 0) {
                 name = e.getName();
             }
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="fontarial" style=padding:3px;><%=JSPFormater.formatDate(hu.getDate(), "dd MMM yyyy HH:mm:ss ")%></td>
                                                                                            <td class="fontarial" style=padding:3px;><i><%=hu.getDescription()%></i></td>
                                                                                            <td class="fontarial" style=padding:3px;><%=name%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }

                                                                                        } else {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" class="fontarial" style=padding:3px;><i>No history available</i></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <%
     if (countx > max) {
         if (showAll == 0) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdShowAll()"><i>Show All History (<%=countx%>) Data</i></a></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            } else {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdUnShowAll()"><i>Show By Limit</i></a></td>
                                                                                        </tr>
                                                                                        <%
         }
     }%>
                                                                                                                                                                       
                                                                                    </table>
                                                                                    
                                                                                </td>
                                                                            </tr>    
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                        
                                                        <span class="level2"><br>
                                                        </span><!-- #EndEditable -->
                                                    </td>
                                                </tr>
                                                
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr> 
                            <td height="25"> 
                                <!-- #BeginEditable "footer" --> 
            <%@ include file = "../main/footer.jsp" %>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
