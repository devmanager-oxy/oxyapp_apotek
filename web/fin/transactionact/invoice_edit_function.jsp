<%!
    public Vector drawList(int iJSPCommand, JspReceiveItem frmObject,
            ReceiveItem objEntity, Vector objectClass,
            long receiveItemId, String approot, long oidVendor,
            int iErrCode2, String status, Vector errorx, String[] langCT) {

        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablearialhdr");
        jsplist.setCellStyle("tablearialcell");
        jsplist.setCellStyle1("tablearialcell1");
        jsplist.setHeaderStyle("tablearialhdr");

        jsplist.addHeader("<table><tr><td class=\"tablearialhdr\">" + "No" + "</td></tr></table>", "20");
        jsplist.addHeader("" + langCT[14], "");
        jsplist.addHeader("" + langCT[26], "5%");
        jsplist.addHeader("" + langCT[15], "10%");
        jsplist.addHeader("" + langCT[16], "5%");
        jsplist.addHeader("" + langCT[17], "10%");
        jsplist.addHeader("" + langCT[18], "10%");
        jsplist.addHeader("" + langCT[19], "5%");
        jsplist.addHeader("" + langCT[20], "12%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;

        Vector temp = new Vector();

        for (int i = 0; i < objectClass.size(); i++) {

            ReceiveItem receiveItem = (ReceiveItem) objectClass.get(i);

            try {
                receiveItem = DbReceiveItem.fetchExc(receiveItem.getOID());
            } catch (Exception e) {
            }

            SessIncomingGoodsL igL = new SessIncomingGoodsL();
            rowx = new Vector();
            if (receiveItemId == receiveItem.getOID()) {
                index = i;
            }

            ItemMaster itemMaster = new ItemMaster();
            ItemGroup ig = new ItemGroup();
            ItemCategory ic = new ItemCategory();
            try {
                itemMaster = DbItemMaster.fetchExc(receiveItem.getItemMasterId());
                ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
            } catch (Exception e) {
            }

            Uom uom = new Uom();
            try {
                uom = DbUom.fetchExc(receiveItem.getUomId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
            rowx.add(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
            igL.setGroup(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());

            if (receiveItem.getIsBonus() == DbReceiveItem.BONUS) {
                rowx.add("<div align=\"center\">Yes</div>");
            } else {
                rowx.add("<div align=\"center\">-</div>");
            }

            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getAmount(), "#,###.##") + "</div>");
            igL.setPrice(receiveItem.getAmount());
            rowx.add("<div align=\"center\">" + receiveItem.getQty() + "</div>");
            igL.setQty(receiveItem.getQty());
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getTotalDiscount(), "#,###.##") + "</div>");
            igL.setDiscount(receiveItem.getTotalDiscount());
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(((receiveItem.getAmount() * receiveItem.getQty())- receiveItem.getTotalDiscount()), "#,###.##") + "</div>");
            igL.setTotal(((receiveItem.getAmount() * receiveItem.getQty())- receiveItem.getTotalDiscount()));
            rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
            igL.setUnit(uom.getUnit());

            String errStr = "";
            try {
                errStr = ((String) errorx.get(i));
            } catch (Exception e) {
                errStr = "";
            }
            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(receiveItem.getApCoaId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"left\">" + coa.getCode() + " - " + coa.getName() + "<br>" + errStr + "</div>");

            lstData.add(rowx);
            temp.add(igL);
        }

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(temp);
        return v;

    }
%>