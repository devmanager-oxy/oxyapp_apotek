
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long itemMasterId, int start, int command, long vendorId) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell1");
        jsplist.setCellStyle1("tablecell");
        jsplist.setHeaderStyle("tablehdr");

        int totGol = Integer.parseInt(DbSystemProperty.getValueByName("jum_gol"));

        jsplist.addHeader("No", "3%");
        jsplist.addHeader("Barcode", "10%");
        jsplist.addHeader("SKU", "7%");
        jsplist.addHeader("Name", "20%");
        jsplist.addHeader("Base Price", "10%");
        jsplist.addHeader("Unit Cost", "10%");
        if (totGol >= 1) {
            jsplist.addHeader("M1(%)", "5%");
            jsplist.addHeader("gol1", "5%");
        }
        if (totGol >= 2) {
            jsplist.addHeader("M2(%)", "5%");
            jsplist.addHeader("gol2", "5%");
        }
        if (totGol >= 3) {
            jsplist.addHeader("M3(%)", "5%");
            jsplist.addHeader("gol3", "5%");
        }
        if (totGol >= 4) {
            jsplist.addHeader("M4(%)", "5%");
            jsplist.addHeader("gol4", "5%");
        }
        if (totGol >= 5) {
            jsplist.addHeader("M5(%)", "5%");
            jsplist.addHeader("gol5", "5%");
        }
        if (totGol >= 6) {
            jsplist.addHeader("M6(%)", "5%");
            jsplist.addHeader("gol6", "5%");
        }
        if (totGol >= 7) {
            jsplist.addHeader("M7(%)", "5%");
            jsplist.addHeader("gol7", "5%");
        }
        if (totGol >= 8) {
            jsplist.addHeader("M8(%)", "5%");
            jsplist.addHeader("gol8", "5%");
        }
        if (totGol >= 9) {
            jsplist.addHeader("M9(%)", "5%");
            jsplist.addHeader("gol9", "5%");
        }
        if (totGol >= 10) {
            jsplist.addHeader("M10(%)", "5%");
            jsplist.addHeader("gol10", "5%");
        }

        jsplist.setLinkRow(-1);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        jsplist.setLinkPrefix("javascript:cmdEdit('");
        jsplist.setLinkSufix("')");
        jsplist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            ItemMaster itemMaster = (ItemMaster) objectClass.get(i);
            Vector rowx = new Vector();
            if (itemMasterId == itemMaster.getOID()) {
                index = i;
            }
            Vector vvi = new Vector();
            if (vendorId == 0) {
                vvi = DbVendorItem.list(0, 0, "item_master_id=" + itemMaster.getOID() + " and  vendor_id=" + itemMaster.getDefaultVendorId(), "");
            } else {
                vvi = DbVendorItem.list(0, 0, "item_master_id=" + itemMaster.getOID() + " and vendor_id=" + vendorId, "");
            }
            VendorItem vi = new VendorItem();
            if (vvi.size() > 0) {
                try {
                    vi = (VendorItem) vvi.get(0);
                } catch (Exception ex) {

                }
            }

            rowx.add("<div align=\"center\">" + "" + (start + i + 1) + "</div>");
            rowx.add(itemMaster.getBarcode());
            rowx.add(itemMaster.getCode());
            rowx.add(itemMaster.getName());

            Uom uo = new Uom();
            try {
                uo = DbUom.fetchExc(itemMaster.getUomStockId());
            } catch (Exception e) {
            }
            PriceType pt = new PriceType();
            try {
                pt = DbPriceType.getPriceType(itemMaster.getOID());
            } catch (Exception ex) {

            }
            if (itemMaster.getIs_bkp() == 1) {
                rowx.add("<div align=\"center\">" + "<input readonly class=\"readonly\"  type=\"text\" size=\"10\" name=\"hpp_" + itemMaster.getOID() + "\" value=\"" + itemMaster.getNew_cogs() + "\" class=\"formElemen\" onChange=javascript:checkCost('" + itemMaster.getOID() + "')   >" + "<input type=\"hidden\" size=\"5\" name=\"ppn_" + itemMaster.getOID() + "\" value=\"" + (itemMaster.getNew_cogs() / 10) + "\" class=\"formElemen\"  ></div>");
            } else {
                rowx.add("<div align=\"center\">" + "<input readonly class=\"readonly\" type=\"text\" size=\"10\" name=\"hpp_" + itemMaster.getOID() + "\" value=\"" + itemMaster.getNew_cogs() + "\" class=\"formElemen\" onChange=javascript:checkCost('" + itemMaster.getOID() + "')   >" + "<input type=\"hidden\" size=\"5\" name=\"ppn_" + itemMaster.getOID() + "\" value=\"0\" class=\"formElemen\"  ></div>");
            }

            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"cost_" + itemMaster.getOID() + "\" value=\"" + vi.getLastPrice() + "\" class=\"formElemen\" onChange=javascript:checkCost('" + itemMaster.getOID() + "')   ></div>");
            if (totGol >= 1) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"5\" name=\"m1_" + itemMaster.getOID() + "\" value=\"" + pt.getGol1_margin() + "\" class=\"formElemen\" onChange=javascript:checkMargin1('" + itemMaster.getOID() + "') ></div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"7\" name=\"gol1_" + itemMaster.getOID() + "\" value=\"" + JSPFormater.formatNumber(pt.getGol1(), "###,###.##") + "\" class=\"formElemen\" onChange=javascript:checkGol1('" + itemMaster.getOID() + "')>" + "</div>");
            }
            if (totGol >= 2) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"5\" name=\"m2_" + itemMaster.getOID() + "\" value=\"" + pt.getGol2_margin() + "\" class=\"formElemen\" onChange=javascript:checkMargin2('" + itemMaster.getOID() + "')>" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"7\" name=\"gol2_" + itemMaster.getOID() + "\" value=\"" + JSPFormater.formatNumber(pt.getGol2(), "###,###.##") + "\" class=\"formElemen\" onChange=javascript:checkGol2('" + itemMaster.getOID() + "')>" + "</div>");
            }
            if (totGol >= 3) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"5\" name=\"m3_" + itemMaster.getOID() + "\" value=\"" + pt.getGol3_margin() + "\" class=\"formElemen\" onChange=javascript:checkMargin3('" + itemMaster.getOID() + "')>" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"7\" name=\"gol3_" + itemMaster.getOID() + "\" value=\"" + JSPFormater.formatNumber(pt.getGol3(), "###,###.##") + "\" class=\"formElemen\" onChange=javascript:checkGol3('" + itemMaster.getOID() + "')>" + "</div>");
            }
            if (totGol >= 4) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"5\" name=\"m4_" + itemMaster.getOID() + "\" value=\"" + pt.getGol4_margin() + "\" class=\"formElemen\" onChange=javascript:checkMargin4('" + itemMaster.getOID() + "')>" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"7\" name=\"gol4_" + itemMaster.getOID() + "\" value=\"" + JSPFormater.formatNumber(pt.getGol4(), "###,###.##") + "\" class=\"formElemen\" onChange=javascript:checkGol4('" + itemMaster.getOID() + "')>" + "</div>");
            }
            if (totGol >= 5) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"5\" name=\"m5_" + itemMaster.getOID() + "\" value=\"" + pt.getGol5_margin() + "\" class=\"formElemen\" onChange=javascript:checkMargin5('" + itemMaster.getOID() + "')>" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"7\" name=\"gol5_" + itemMaster.getOID() + "\" value=\"" + JSPFormater.formatNumber(pt.getGol5(), "###,###.##") + "\" class=\"formElemen\" onChange=javascript:checkGol5('" + itemMaster.getOID() + "')>" + "</div>");
            }
            if (totGol >= 6) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"5\" name=\"m6_" + itemMaster.getOID() + "\" value=\"" + pt.getGol6_margin() + "\" class=\"formElemen\" onChange=javascript:checkMargin6('" + itemMaster.getOID() + "')>" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"7\" name=\"gol6_" + itemMaster.getOID() + "\" value=\"" + JSPFormater.formatNumber(pt.getGol6(), "###,###.##") + "\" class=\"formElemen\" onChange=javascript:checkGol6('" + itemMaster.getOID() + "')>" + "</div>");
            }
            
            if (totGol >= 7) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"5\" name=\"m7_" + itemMaster.getOID() + "\" value=\"" + pt.getGol7_margin() + "\" class=\"formElemen\" onChange=javascript:checkMargin7('" + itemMaster.getOID() + "')>" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"7\" name=\"gol7_" + itemMaster.getOID() + "\" value=\"" + JSPFormater.formatNumber(pt.getGol7(), "###,###.##") + "\" class=\"formElemen\" onChange=javascript:checkGol7('" + itemMaster.getOID() + "')>" + "</div>");
            }
            
            if (totGol >= 8) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"5\" name=\"m8_" + itemMaster.getOID() + "\" value=\"" + pt.getGol8_margin() + "\" class=\"formElemen\" onChange=javascript:checkMargin8('" + itemMaster.getOID() + "')>" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"7\" name=\"gol8_" + itemMaster.getOID() + "\" value=\"" + JSPFormater.formatNumber(pt.getGol8(), "###,###.##") + "\" class=\"formElemen\" onChange=javascript:checkGol8('" + itemMaster.getOID() + "')>" + "</div>");
            }
            
            if (totGol >= 9) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"5\" name=\"m9_" + itemMaster.getOID() + "\" value=\"" + pt.getGol9_margin() + "\" class=\"formElemen\" onChange=javascript:checkMargin9('" + itemMaster.getOID() + "')>" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"7\" name=\"gol9_" + itemMaster.getOID() + "\" value=\"" + JSPFormater.formatNumber(pt.getGol9(), "###,###.##") + "\" class=\"formElemen\" onChange=javascript:checkGol9('" + itemMaster.getOID() + "')>" + "</div>");
            }
            
            if (totGol >= 10) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"5\" name=\"m10_" + itemMaster.getOID() + "\" value=\"" + pt.getGol10_margin() + "\" class=\"formElemen\" onChange=javascript:checkMargin10('" + itemMaster.getOID() + "')>" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"7\" name=\"gol10_" + itemMaster.getOID() + "\" value=\"" + JSPFormater.formatNumber(pt.getGol10(), "###,###.##") + "\" class=\"formElemen\" onChange=javascript:checkGol10('" + itemMaster.getOID() + "')>" + "</div>");
            }
            

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(itemMaster.getOID()));
        }

        return jsplist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");

//--------------- search ------------------------------------------------------
            long srcGroupId = JSPRequestValue.requestLong(request, "src_group");
            long srcCategoryId = JSPRequestValue.requestLong(request, "src_category");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcBarCode = JSPRequestValue.requestString(request, "src_barcode");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            int orderBy = JSPRequestValue.requestInt(request, "order_by");
            long srcMerkId = JSPRequestValue.requestLong(request, "src_merk");
            long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
//-----------------------------------------------------------------------------
            int totGol = Integer.parseInt(DbSystemProperty.getValueByName("jum_gol"));
            /*variable declaration*/
            int recordToGet = 20;

            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "type<>" + I_Ccs.TYPE_CATEGORY_FINISH_GOODS + " and type<>" + I_Ccs.TYPE_CATEGORY_CIVIL_WORK;
            String orderClause = "";
            
            if (orderBy == 0) {
                orderClause = "item_group_id";
            } else if (orderBy == 1) {
                orderClause = "item_category_id";
            } else if (orderBy == 2) {
                orderClause = "code";
            } else if (orderBy == 3) {
                orderClause = "name";
            } else if (orderBy == 4) {
                orderClause = "merk_id";
            }


            if (srcGroupId != 0) {
                whereClause = DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + "=" + srcGroupId;
            }
            if (srcCategoryId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + "=" + srcCategoryId;
            }
            if (srcCode != null && srcCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode + "%'";
            }
            if (srcName != null && srcName.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + srcName + "%'";
            }
            if (srcBarCode != null && srcBarCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "(" + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " like '%" + srcBarCode + "%' or " + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2] + " like '%" + srcBarCode + "%' or " + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3] + " like '%" + srcBarCode + "%')";
            }
            if (srcVendorId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " pos_vendor_item.vendor_id=" + srcVendorId;
            }

            if (whereClause != null && whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " is_active=1 ";

            int vectSize = 0;
            if (srcVendorId != 0) {
                vectSize = DbItemMaster.getCountBySupplier(whereClause);
            } else {
                vectSize = DbItemMaster.getCount(whereClause);
            }


            CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
            JSPLine jspLine = new JSPLine();
            Vector listItemMaster = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlItemMaster.action(iJSPCommand, oidItemMaster);
            /* end switch*/
            JspItemMaster jspItemMaster = ctrlItemMaster.getForm();


            ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
            msgString = ctrlItemMaster.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
            }


            if (oidItemMaster == 0) {
                oidItemMaster = itemMaster.getOID();
            }

            if (srcVendorId != 0) {
                listItemMaster = DbItemMaster.listByVendor(start, recordToGet, whereClause, orderClause);
            } else {
                listItemMaster = DbItemMaster.list(start, recordToGet, whereClause, orderClause);
            }


            if (iJSPCommand == JSPCommand.SAVE) {
                if (listItemMaster.size() > 0) {
                    for (int i = 0; i < listItemMaster.size(); i++) {
                        ItemMaster im = new ItemMaster();
                        im = (ItemMaster) listItemMaster.get(i);
                        double basePrice = JSPRequestValue.requestDouble(request, "hpp_" + im.getOID());
                        double unitCost = JSPRequestValue.requestDouble(request, "cost_" + im.getOID());
                        PriceType pt = new PriceType();
                        pt = DbPriceType.getPriceType(im.getOID());

                        if (totGol >= 1) {
                            pt.setGol1_margin(JSPRequestValue.requestDouble(request, "m1_" + im.getOID()));
                            pt.setGol1(JSPRequestValue.requestDouble(request, "gol1_" + im.getOID()));
                        }
                        if (totGol >= 2) {
                            pt.setGol2_margin(JSPRequestValue.requestDouble(request, "m2_" + im.getOID()));
                            pt.setGol2(JSPRequestValue.requestDouble(request, "gol2_" + im.getOID()));
                        }
                        if (totGol >= 3) {
                            pt.setGol3(JSPRequestValue.requestDouble(request, "gol3_" + im.getOID()));
                            pt.setGol3_margin(JSPRequestValue.requestDouble(request, "m3_" + im.getOID()));
                        }
                        if (totGol >= 4) {
                            pt.setGol4_margin(JSPRequestValue.requestDouble(request, "m4_" + im.getOID()));
                            pt.setGol4(JSPRequestValue.requestDouble(request, "gol4_" + im.getOID()));
                        }
                        if (totGol >= 5) {
                            pt.setGol5_margin(JSPRequestValue.requestDouble(request, "m5_" + im.getOID()));
                            pt.setGol5(JSPRequestValue.requestDouble(request, "gol5_" + im.getOID()));
                        }
                        if (totGol >= 6) {
                            pt.setGol6_margin(JSPRequestValue.requestDouble(request, "m6_" + im.getOID()));
                            pt.setGol6(JSPRequestValue.requestDouble(request, "gol6_" + im.getOID()));
                        }

                        if (totGol >= 7) {
                            pt.setGol7_margin(JSPRequestValue.requestDouble(request, "m7_" + im.getOID()));
                            pt.setGol7(JSPRequestValue.requestDouble(request, "gol7_" + im.getOID()));
                        }

                        if (totGol >= 8) {
                            pt.setGol8_margin(JSPRequestValue.requestDouble(request, "m8_" + im.getOID()));
                            pt.setGol8(JSPRequestValue.requestDouble(request, "gol8_" + im.getOID()));
                        }

                        if (totGol >= 9) {
                            pt.setGol9_margin(JSPRequestValue.requestDouble(request, "m9_" + im.getOID()));
                            pt.setGol9(JSPRequestValue.requestDouble(request, "gol9_" + im.getOID()));
                        }
                        
                        if (totGol >= 10) {
                            pt.setGol10_margin(JSPRequestValue.requestDouble(request, "m10_" + im.getOID()));
                            pt.setGol10(JSPRequestValue.requestDouble(request, "gol10_" + im.getOID()));
                        }


                        if (pt.getOID() == 0) {
                            pt.setQtyFrom(1);
                            pt.setQtyTo(10000);
                            pt.setItemMasterId(im.getOID());
                            pt.setChangeDate(new Date());
                            DbPriceType.insertExc(pt);
                        } else {
                            DbPriceType.updateExc(pt);
                        }

                        Vector vvi = new Vector();
                        if (srcVendorId == 0) {
                            vvi = DbVendorItem.list(0, 0, "item_master_id=" + im.getOID() + " and  vendor_id=" + im.getDefaultVendorId(), "");
                        } else {
                            vvi = DbVendorItem.list(0, 0, "item_master_id=" + im.getOID() + " and vendor_id=" + srcVendorId, "");
                        }
                        VendorItem vi = new VendorItem();
                        if (vvi.size() > 0) {
                            try {
                                vi = (VendorItem) vvi.get(0);
                            } catch (Exception ex) {

                            }
                        }

                        if (vi.getOID() == 0) {//insert vendor item
                            vi.setItemMasterId(im.getOID());
                            vi.setLastPrice(unitCost);
                            vi.setVendorId(srcVendorId);
                            vi.setRegDisValue(0);
                            vi.setRealPrice(0);
                            vi.setMarginPrice(0);
                            vi.setRegDisPercent(0);
                            vi.setUpdateDate(new Date());
                            try {
                                DbVendorItem.insertExc(vi);
                            } catch (Exception ex) {

                            }
                        } else {//update vendor item
                            vi.setLastPrice(unitCost);
                            DbVendorItem.updateExc(vi);

                        }

                        try {
                            if (im.getNew_cogs() != basePrice) {
                                im.setNew_cogs(basePrice);
                                DbItemMaster.updateExc(im);
                            }
                        } catch (Exception ex) {

                        }
                    }
                }

                iJSPCommand = JSPCommand.SEARCH;

            }



            //Vector categories = DbItemCategory.list(0, 0, "", DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID] + "," + DbItemCategory.colNames[DbItemCategory.COL_NAME]);
            //Vector units = DbUom.list(0, 0, "", "");

            if (iJSPCommand == JSPCommand.ADD) {
                itemMaster.setForSale(1);
                itemMaster.setForBuy(1);
                itemMaster.setIsActive(1);
                itemMaster.setRecipeItem(1);
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        
        <script language="JavaScript">
            
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.RptItemMasterXLS?idx=<%=System.currentTimeMillis()%>");
                }    
                
                function cmdSearch(){
                    //document.frmitemmaster.hidden_item_master_id.value="0";
                    document.frmitemmaster.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmitemmaster.start.value="0";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="updateHarga.jsp";
                    document.frmitemmaster.submit();
                }
                
                
                function cmdSave(){
                    document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="updateHarga.jsp";
                    document.frmitemmaster.submit();
                }
                
                function cmdListFirst(){
                    document.frmitemmaster.command.value="<%=JSPCommand.FIRST%>";
                    document.frmitemmaster.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmitemmaster.action="updateHarga.jsp";
                    document.frmitemmaster.submit();
                }
                
                function cmdListPrev(){
                    document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
                    document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmitemmaster.action="updateHarga.jsp";
                    document.frmitemmaster.submit();
                }
                
                function cmdListNext(){
                    document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
                    document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmitemmaster.action="updateHarga.jsp";
                    document.frmitemmaster.submit();
                }
                
                function cmdListLast(){
                    document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
                    document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmitemmaster.action="updateHarga.jsp";
                    document.frmitemmaster.submit();
                }
                
                
                
                function cmdEdit(oidItemMaster){
                    document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                    document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="updateHarga.jsp";
                    document.frmitemmaster.submit();
                }
                function checkCost(oid){
                    
                    <%if (listItemMaster.size() > 0) {%>
                    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
                    if(oid==<%=im.getOID()%>){
                        
                        var st = document.frmitemmaster.gol1_<%=im.getOID()%>.value;	
                        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                        var mar = document.frmitemmaster.m1_<%=im.getOID()%>.value;
                        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                        
                        if(parseFloat(cost) > parseFloat(cog)){
                            cog = cost;
                            
                            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                        }
                        <%if (totGol >= 1) {%>
                        
                        <%}%>
                        <%if (totGol >= 2) {%>
                        checkGol2(oid);
                        <%}%>
                        <%if (totGol >= 3) {%>
                        checkGol3(oid);
                        <%}%>
                        <%if (totGol >= 4) {%>
                        checkGol4(oid);
                        <%}%>
                        <%if (totGol >= 5) {%>
                        checkGol5(oid);
                        <%}%>
                        <%if (totGol >= 1) {%>
                        checkMargin1(oid);
                        <%}%>    
                        <%if (totGol >= 2) {%>
                        checkMargin2(oid);
                        <%}%>    
                        <%if (totGol >= 3) {%>
                        checkMargin3(oid);
                        <%}%>    
                        <%if (totGol >= 4) {%>
                        checkMargin4(oid);
                        <%}%>    
                        <%if (totGol >= 5) {%>                               
                        checkMargin5(oid);
                        <%}%>    
                        
                        
                    }    
                    <%}%>
                    
                    <%}%>
                    
                }
                
                
                function checkGol1(oid){
                    <%if (listItemMaster.size() > 0) {%>
                    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
                    if(oid==<%=im.getOID()%>){
                        
                        var st = document.frmitemmaster.gol1_<%=im.getOID()%>.value;	
                        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                        var mar = document.frmitemmaster.m1_<%=im.getOID()%>.value;
                        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                        
                        
                        if(parseFloat(cost) > parseFloat(cog)){
                            cog = cost;
                            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                        }                       
                        mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;                        
                        
                        document.frmitemmaster.m1_<%=im.getOID()%>.value =mar; 
                    }    
                    <%}%>
                    
                    <%}%>
                    
                }
                function checkMargin1(oid){
                    
                    <%if (listItemMaster.size() > 0) {%>
                    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
                    if(oid==<%=im.getOID()%>){
                        var st = document.frmitemmaster.gol1_<%=im.getOID()%>.value;	
                        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                        var mar = document.frmitemmaster.m1_<%=im.getOID()%>.value;
                        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                        if(parseFloat(cost) > parseFloat(cog)){
                            cog = cost;
                            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                        }
                        //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                        //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                        
                        
                        document.frmitemmaster.gol1_<%=im.getOID()%>.value =st; 
                    }    
                    <%}%>
                    
                    <%}%>
                    
                }
                
                
                function checkGol2(oid){
                    <%if (listItemMaster.size() > 0) {%>
                    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
                    if(oid==<%=im.getOID()%>){
                        var st = document.frmitemmaster.gol2_<%=im.getOID()%>.value;	
                        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                        var mar = document.frmitemmaster.m2_<%=im.getOID()%>.value;
                        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                        if(parseFloat(cost) > parseFloat(cog)){
                            cog = cost;
                            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                        }
                        //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                        //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                        mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                        if(mar > 0){
                            
                        }else{
                        var mar =0;
                    }
                    
                    document.frmitemmaster.m2_<%=im.getOID()%>.value =mar; 
                }    
                <%}%>
                
                <%}%>
                
            }
            function checkMargin2(oid){
                
                <%if (listItemMaster.size() > 0) {%>
                <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
                if(oid==<%=im.getOID()%>){
                    var st = document.frmitemmaster.gol2_<%=im.getOID()%>.value;	
                    var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                    var mar = document.frmitemmaster.m2_<%=im.getOID()%>.value;
                    var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                    var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                    if(parseFloat(cost) > parseFloat(cog)){
                        cog = cost;
                        document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                    }
                    //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                    //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                    st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                    
                    
                    document.frmitemmaster.gol2_<%=im.getOID()%>.value =st; 
                }    
                <%}%>
                
                <%}%>
                
            }
            
            function checkGol3(oid){
                <%if (listItemMaster.size() > 0) {%>
                <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
                if(oid==<%=im.getOID()%>){
                    var st = document.frmitemmaster.gol3_<%=im.getOID()%>.value;	
                    var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                    var mar = document.frmitemmaster.m3_<%=im.getOID()%>.value;
                    var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                    var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                    if(parseFloat(cost) > parseFloat(cog)){
                        cog = cost;
                        document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                    }
                    //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                    //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                    mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                    if(mar > 0){
                        
                    }else{
                    var mar =0;
                }
                
                document.frmitemmaster.m3_<%=im.getOID()%>.value =mar; 
            }    
            <%}%>
            
            <%}%>
            
        }
        function checkMargin3(oid){
            
            <%if (listItemMaster.size() > 0) {%>
            <%for (int i = 0; i < listItemMaster.size(); i++) {%>
            <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
            if(oid==<%=im.getOID()%>){
                var st = document.frmitemmaster.gol3_<%=im.getOID()%>.value;	
                var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                var mar = document.frmitemmaster.m3_<%=im.getOID()%>.value;
                var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                if(parseFloat(cost) > parseFloat(cog)){
                    cog = cost;
                    document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                }
                //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                
                
                document.frmitemmaster.gol3_<%=im.getOID()%>.value =st; 
            }    
            <%}%>
            
            <%}%>
            
        }
        
        function checkGol4(oid){
            <%if (listItemMaster.size() > 0) {%>
            <%for (int i = 0; i < listItemMaster.size(); i++) {%>
            <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
            if(oid==<%=im.getOID()%>){
                var st = document.frmitemmaster.gol4_<%=im.getOID()%>.value;	
                var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                var mar = document.frmitemmaster.m4_<%=im.getOID()%>.value;
                var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                if(parseFloat(cost) > parseFloat(cog)){
                    cog = cost;
                    document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                }
                //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                if(mar > 0){
                    
                }else{
                var mar =0;
            }
            
            document.frmitemmaster.m4_<%=im.getOID()%>.value =mar; 
        }    
        <%}%>
        
        <%}%>
        
    }
    function checkMargin4(oid){
        
        <%if (listItemMaster.size() > 0) {%>
        <%for (int i = 0; i < listItemMaster.size(); i++) {%>
        <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
            var st = document.frmitemmaster.gol4_<%=im.getOID()%>.value;	
            var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
            var mar = document.frmitemmaster.m4_<%=im.getOID()%>.value;
            var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
            var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
            if(parseFloat(cost) > parseFloat(cog)){
                cog = cost;
                document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
            }
            //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
            st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
            
            
            document.frmitemmaster.gol4_<%=im.getOID()%>.value =st; 
        }    
        <%}%>
        
        <%}%>
        
    }
    
    function checkGol5(oid){
        <%if (listItemMaster.size() > 0) {%>
        <%for (int i = 0; i < listItemMaster.size(); i++) {%>
        <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
            var st = document.frmitemmaster.gol5_<%=im.getOID()%>.value;	
            var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
            var mar = document.frmitemmaster.m5_<%=im.getOID()%>.value;
            var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
            var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
            if(parseFloat(cost) > parseFloat(cog)){
                cog = cost;
                document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
            }
            //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
            //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
            mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
            if(mar > 0){
                
            }else{
            var mar =0;
        }
        
        document.frmitemmaster.m5_<%=im.getOID()%>.value =mar; 
    }    
    <%}%>
    
    <%}%>
    
}
function checkMargin5(oid){
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol5_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m5_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }
        //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
        //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
        
        
        document.frmitemmaster.gol5_<%=im.getOID()%>.value =st; 
    }    
    <%}%>
    
    <%}%>
    
}


function checkGol6(oid){
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol6_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m6_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
        if(mar > 0){
            
        }else{
        var mar =0;
    }
    
    document.frmitemmaster.m6_<%=im.getOID()%>.value =mar; 
}    
<%}%>

<%}%>

}
function checkMargin6(oid){
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol6_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m6_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
        document.frmitemmaster.gol6_<%=im.getOID()%>.value =st; 
    }    
    <%}%>
    
    <%}%>
    
}



function checkGol7(oid){
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol7_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m7_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
        if(mar > 0){
            
        }else{
        var mar =0;
    }
    
    document.frmitemmaster.m7_<%=im.getOID()%>.value =mar; 
}    
<%}%>

<%}%>

}
function checkMargin7(oid){
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol7_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m7_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
        document.frmitemmaster.gol7_<%=im.getOID()%>.value =st; 
    }    
    <%}%>
    
    <%}%>
    
}

function checkGol8(oid){
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol8_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m8_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
        if(mar > 0){
            
        }else{
        var mar =0;
    }
    
    document.frmitemmaster.m8_<%=im.getOID()%>.value =mar; 
}    
<%}%>

<%}%>

}
function checkMargin8(oid){
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol8_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m8_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
        document.frmitemmaster.gol8_<%=im.getOID()%>.value =st; 
    }    
    <%}%>
    
    <%}%>
    
}


function checkGol8(oid){
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol8_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m8_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
        if(mar > 0){
            
        }else{
        var mar =0;
    }
    
    document.frmitemmaster.m8_<%=im.getOID()%>.value =mar; 
}    
<%}%>

<%}%>

}
function checkMargin8(oid){
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol8_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m8_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
        document.frmitemmaster.gol8_<%=im.getOID()%>.value =st; 
    }    
    <%}%>
    
    <%}%>
    
}

function checkGol9(oid){
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol9_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m9_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
        if(mar > 0){
            
        }else{
        var mar =0;
    }
    
    document.frmitemmaster.m9_<%=im.getOID()%>.value =mar; 
}    
<%}%>

<%}%>

}
function checkMargin9(oid){
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol9_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m9_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
        document.frmitemmaster.gol9_<%=im.getOID()%>.value =st; 
    }    
    <%}%>
    
    <%}%>
    
}


function checkGol10(oid){
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol10_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m10_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
        if(mar > 0){
            
        }else{
        var mar =0;
    }
    
    document.frmitemmaster.m10_<%=im.getOID()%>.value =mar; 
}    
<%}%>

<%}%>

}
function checkMargin10(oid){
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol10_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m10_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }        
        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
        document.frmitemmaster.gol10_<%=im.getOID()%>.value =st; 
    }    
    <%}%>
    
    <%}%>
    
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> 
                                <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
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
                                                        <form name="frmitemmaster" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container" valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                        <tr valign="bottom"> 
                                                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                                    Maintenance </font><font class="tit1">&raquo; 
                                                                                                    </font><font class="tit1"><span class="lvl2">POS 
                                                                                                        </span>&raquo; <span class="lvl2">Item 
                                                                                            List </span></font></b></td>
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
                                                                                <td height="5"></td>
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                                <td class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8"  colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="8" valign="middle" colspan="3"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td width="5%">&nbsp;</td>
                                                                                                                    <td width="11%">&nbsp;</td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="14%">&nbsp;</td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="15%">&nbsp;</td>
                                                                                                                    <td width="42%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="7" nowrap><b><u>Search 
                                                                                                                    Option</u></b></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5%">&nbsp;</td>
                                                                                                                    <td width="11%">&nbsp;</td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="14%">&nbsp;</td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="15%">&nbsp;</td>
                                                                                                                    <td width="42%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5%">Group</td>
                                                                                                                    <td width="11%"> 
                                                                                                                        <%
            Vector groupsx = DbItemGroup.list(0, 0, "", "name");
                                                                                                                        %>
                                                                                                                        <select name="src_group">
                                                                                                                            <option value="0" <%if (srcGroupId == 0) {%>selected<%}%>>All 
                                                                                                                                    ..</option>
                                                                                                                            <%if (groupsx != null && groupsx.size() > 0) {
                for (int i = 0; i < groupsx.size(); i++) {
                    ItemGroup ig = (ItemGroup) groupsx.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=ig.getOID()%>" <%if (srcGroupId == ig.getOID()) {%>selected<%}%>><%=ig.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="6%">SKU</td>
                                                                                                                    <td width="14%"> 
                                                                                                                        <input type="text" name="src_code" size="15" value="<%=srcCode%>" onchange="javascript:cmdSearch()">
                                                                                                                    </td>
                                                                                                                    <td width="6%">Barcode</td>
                                                                                                                    <td width="15%">
                                                                                                                        <input type="text" name="src_barcode" size="15" value="<%=srcBarCode%>" onchange="javascript:cmdSearch()">
                                                                                                                    </td>
                                                                                                                    <td width="42%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5%">Category</td>
                                                                                                                    <td width="11%"> 
                                                                                                                        <%
            Vector categoryx = DbItemCategory.list(0, 0, "", "name");
                                                                                                                        %>
                                                                                                                        <select name="src_category">
                                                                                                                            <option value="0" <%if (srcCategoryId == 0) {%>selected<%}%>>All 
                                                                                                                                    ..</option>
                                                                                                                            <%if (categoryx != null && categoryx.size() > 0) {
                for (int i = 0; i < categoryx.size(); i++) {
                    ItemCategory ic = (ItemCategory) categoryx.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=ic.getOID()%>" <%if (srcCategoryId == ic.getOID()) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="6%">Name</td>
                                                                                                                    <td width="14%"> 
                                                                                                                        <input type="text" name="src_name" value="<%=srcName%>" onchange="javascript:cmdSearch()">
                                                                                                                    </td>
                                                                                                                    <td width="6%">Order By</td>
                                                                                                                    <td width="15%"> 
                                                                                                                        <select name="order_by">
                                                                                                                            <option value="0" <%if (orderBy == 0) {%>selected<%}%>>GROUP</option>
                                                                                                                            <option value="1" <%if (orderBy == 1) {%>selected<%}%>>CATEGORY</option>
                                                                                                                            <option value="2" <%if (orderBy == 2) {%>selected<%}%>>CODE</option>
                                                                                                                            <option value="3" <%if (orderBy == 3) {%>selected<%}%>>NAME</option>
                                                                                                                            <option value="4" <%if (orderBy == 4) {%>selected<%}%>>MERK</option>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="42%"> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5%">Vendor</td>
                                                                                                                    <td width="11%">
                                                                                                                        <select name="src_vendor_id">
                                                                                                                            <option value="0" <%if (srcVendorId == 0) {%>selected<%}%>>- 
                                                                                                                                    All -</option>
                                                                                                                            <%

            Vector vendors = DbVendor.list(0, 0, "", "name");

            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor d = (Vendor) vendors.get(i);
                    String str = "";
                                                                                                                            %>
                                                                                                                            <option value="<%=d.getOID()%>" <%if (srcVendorId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="14%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="15%">&nbsp;</td>
                                                                                                                    <td width="42%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="7" background="../images/line1.gif"><img src="../images/line1.gif" width="47" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="7">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
            try {
                if (listItemMaster.size() > 0) {
                                                                                                    %>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                                        <%= drawList(listItemMaster, oidItemMaster, start, iJSPCommand, srcVendorId)%> </td>
                                                                                                    </tr>
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
                                                                                                                jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                                                jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                                                jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                                                jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                                                jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                                                jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                                                jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                                                jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                                %>
                                                                                                        <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td>
                                                                                                            <table width="20%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>                                                                                                                    
                                                                                                                    <td><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save21','','../images/save2.gif',1)"><img src="../images/save.gif" name="save21" height="22" border="0"></a></td>                                                                                                                    
                                                                                                                    
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>    
                                                                                                        
                                                                                                    </tr>
                                                                                                    
                                                                                                    
                                                                                                    <%  }
            } catch (Exception exc) {
            }%>
                                                                                              
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
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
            <%@ include file="../main/footer.jsp"%>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
