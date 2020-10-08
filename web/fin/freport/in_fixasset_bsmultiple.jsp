<%
                                                                                if (fixAssetx != null && fixAssetx.size() > 0) {
                                                                                    String str = "";
                                                                                    String str1 = "";
                                                                                    for (int i = 0; i < fixAssetx.size(); i++) {
                                                                                        coa = (Coa) fixAssetx.get(i);

                                                                                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET)) {
                                                                                            str = SessReport.switchLevel(coa.getLevel());
                                                                                            str1 = SessReport.switchLevel1(coa.getLevel());
                                                                                            double amount = DbCoa.getCoaBalance(coa.getOID(), temp);

                                                                                            if (valShowList == 1) {
                                                                                                if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC", temp) != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                    vSesDep = new Vector();
                                                                                                    for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                                        vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per));
                                                                                                    }
                                                                                                    sesReport.setDepartment(vSesDep);
                                                                                                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" nowrap> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                                double fixAsset = DbCoa.getCoaBalance(coa.getOID(), per);
                                                                                                                                displayStr = SessReport.strDisplay(fixAsset, coa.getStatus());
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"> 
                                                                                                    <div align="right"><%=displayStr%><%//=(fixAsset==0) ? "" : JSPFormater.formatNumber(fixAsset, "#,###.##")%>&nbsp;&nbsp;</div>
                                                                                                </div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%		}
                                                                                                                } else {
                                                                                                                    if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                                        sesReport = new SesReportBs();
                                                                                                                        sesReport.setType(coa.getStatus());
                                                                                                                        sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                                        vSesDep = new Vector();
                                                                                                                        for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                                                            vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per));
                                                                                                                        }
                                                                                                                        sesReport.setDepartment(vSesDep);
                                                                                                                        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" nowrap> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                                        double fixAsset = DbCoa.getCoaBalance(coa.getOID(), per);
                                                                                                        displayStr = SessReport.strDisplay(fixAsset, coa.getStatus());
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"> 
                                                                                                    <div align="right"><%=displayStr%><%//=(fixAsset==0) ? "" : JSPFormater.formatNumber(fixAsset, "#,###.##")%>&nbsp;&nbsp;</div>
                                                                                                </div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }				//add footer level

                                                                                            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_FIXED_ASSET, "DC", temp) != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_FIXED_ASSET);
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                                    vSesDep.add("" + SessReport.getTotalFixAssetByPeriod(fixAssetx, per));
                                                                                                }
                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%=strTotal + "Sub Total " + I_Project.ACC_GROUP_FIXED_ASSET%></b></span></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                        Periode per = (Periode) temp.get(ix);
                                                                        double totalFixAsset = SessReport.getTotalFixAssetByPeriod(fixAssetx, per);
                                                                        displayStr = SessReport.strDisplay(totalFixAsset);
                                                                                            %>
                                                                                            <td width="150"> 
                                                                                                <div align="right"><b><%=displayStr%><%//=(totalFixAsset==0) ? "" : JSPFormater.formatNumber(totalFixAsset, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%
                                                                                    }
                                                                                }

                                                                                //------------- end of fixed asset ------------
%>


<%
//--------------- start other asset ------------

                                                                                Vector othAssetx = DbCoa.list(0, 0, "account_group='" + I_Project.ACC_GROUP_OTHER_ASSET + "'", "code");

                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_ASSET, "DC", temp) != 0 || valShowList != 1) {	//add Group Header
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_OTHER_ASSET);
                                                                                    sesReport.setFont(1);
                                                                                    vSesDep = new Vector();
                                                                                    for (int ix = 0; ix < temp.size(); ix++) {
                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                        vSesDep.add("0");
                                                                                    }
                                                                                    sesReport.setDepartment(vSesDep);
                                                                                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=strTotal + I_Project.ACC_GROUP_OTHER_ASSET%></b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td width="150" class="tablecell"> 
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <% 	}%>
                                                                                        <%
                                                                                if (othAssetx != null && othAssetx.size() > 0) {
                                                                                    String str = "";
                                                                                    String str1 = "";
                                                                                    for (int i = 0; i < othAssetx.size(); i++) {
                                                                                        coa = (Coa) othAssetx.get(i);

                                                                                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET)) {
                                                                                            str = SessReport.switchLevel(coa.getLevel());
                                                                                            str1 = SessReport.switchLevel1(coa.getLevel());
                                                                                            double amount = DbCoa.getCoaBalance(coa.getOID());
                                                                                            if (valShowList == 1) {
                                                                                                if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC", temp) != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                    vSesDep = new Vector();
                                                                                                    for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                                        vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per));
                                                                                                    }
                                                                                                    sesReport.setDepartment(vSesDep);
                                                                                                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td nowrap class="tablecell1"> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                                double othAsset = DbCoa.getCoaBalance(coa.getOID(), per);
                                                                                                                                displayStr = SessReport.strDisplay(othAsset, coa.getStatus());
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"><%=displayStr%><%//=(othAsset==0) ? "" : JSPFormater.formatNumber(othAsset, "#,###.##")%>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%				}
                                                                                                                } else {
                                                                                                                    if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                                        sesReport = new SesReportBs();
                                                                                                                        sesReport.setType(coa.getStatus());
                                                                                                                        sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                                        vSesDep = new Vector();
                                                                                                                        for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                                                            vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per));
                                                                                                                        }
                                                                                                                        sesReport.setDepartment(vSesDep);
                                                                                                                        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td  nowrap class="tablecell1"> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                                        double othAsset = DbCoa.getCoaBalance(coa.getOID(), per);
                                                                                                        displayStr = SessReport.strDisplay(othAsset, coa.getStatus());
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"><%=displayStr%><%//=(othAsset==0) ? "" : JSPFormater.formatNumber(othAsset, "#,###.##")%>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%
                                                                                                        }
                                                                                                    }
                                                                                                }

                                                                                            }

                                                                                            //add footer level
                                                                                            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_ASSET, "DC", temp) != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_OTHER_ASSET);
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                                    vSesDep.add("" + SessReport.getTotalOthAssetByPeriod(othAssetx, per));
                                                                                                }
                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td ><span class="level2"><b><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_OTHER_ASSET%></b></span></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                Periode per = (Periode) temp.get(ix);
                                                                                double totalOthAsset = SessReport.getTotalOthAssetByPeriod(othAssetx, per);
                                                                                displayStr = SessReport.strDisplay(totalOthAsset);
                                                                                            %>
                                                                                            <td width="150"> 
                                                                                                <div align="right"><b><%=displayStr%><%//=(totalOthAsset==0) ? "" : JSPFormater.formatNumber(totalOthAsset, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%
                                                                                    }
                                                                                }
%><%
                                                                                
                                                                                //--------- line kosong--------- 
%>
                                                                                        <%
                                                                                //--------- total activa -------

                                                                                if (coaSummary1 + coaSummary2 + coaSummary3 != 0 || valShowList != 1) {	//add Group Footer
%>
                                                                                        <tr> 
                                                                                            <td ><span class="level2"><b>Total Activa</b></span></td>
                                                                                            <%
                                                                                            vSesDep = new Vector();
                                                                                            for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                double totalLiqAsset = SessReport.getTotalLiqAssetByPeriod(liqAssetx, per);
                                                                                                double totalFixAsset = SessReport.getTotalFixAssetByPeriod(fixAssetx, per);
                                                                                                double totalOthAsset = SessReport.getTotalOthAssetByPeriod(othAssetx, per);
                                                                                                totalLiqAsset = totalLiqAsset + totalFixAsset + totalOthAsset;
                                                                                                displayStr = SessReport.strDisplay(totalLiqAsset);
                                                                                                vSesDep.add("" + totalLiqAsset);
                                                                                            %>
                                                                                            <td width="150"> 
                                                                                                <div align="right"><b><%=displayStr%><%//=(totalLiqAsset==0) ? "" : JSPFormater.formatNumber(totalLiqAsset, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Footer Top Level");
                                                                                    sesReport.setDescription("Total Activa");
                                                                                    sesReport.setFont(1);
                                                                                    sesReport.setDepartment(vSesDep);
                                                                                    listReport.add(sesReport);
                                                                                }
                                                                                sesReport = new SesReportBs();
                                                                                sesReport.setType("Space");
                                                                                sesReport.setDescription("");
                                                                                vSesDep = new Vector();
                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                    vSesDep.add("0");
                                                                                }
                                                                                sesReport.setDepartment(vSesDep);
                                                                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td height="15">&nbsp;</td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td width="150"> 
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="15" class="tablecell1">&nbsp;</td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="15" class="tablecell"><b>Liabilities</b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td width="150" class="tablecell"> 
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        
                                                                                         <%
                                                                                //-------------- start current liabilities -----------

                                                                                //add Top Header
                                                                                sesReport = new SesReportBs();
                                                                                sesReport.setType("Top Level");
                                                                                sesReport.setDescription("Liabilities");
                                                                                sesReport.setFont(1);
                                                                                vSesDep = new Vector();
                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                    vSesDep.add("0");
                                                                                }
                                                                                sesReport.setDepartment(vSesDep);
                                                                                listReport.add(sesReport);

                                                                                Vector currLiabilx = DbCoa.list(0, 0, "account_group='" + I_Project.ACC_GROUP_CURRENT_LIABILITIES + "'", "code");

                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_CURRENT_LIABILITIES, "CD", temp) != 0 || valShowList != 1) {	//add Group Header
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_CURRENT_LIABILITIES);
                                                                                    sesReport.setFont(1);
                                                                                    vSesDep = new Vector();
                                                                                    for (int ix = 0; ix < temp.size(); ix++) {
                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                        vSesDep.add("0");
                                                                                    }
                                                                                    sesReport.setDepartment(vSesDep);
                                                                                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" ><b><%=strTotal + I_Project.ACC_GROUP_CURRENT_LIABILITIES%></b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td width="150" class="tablecell"> 
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%	}%>
                                                                                        <%
                                                                                if (currLiabilx != null && currLiabilx.size() > 0) {
                                                                                    coaSummary4 = 0;
                                                                                    String str = "";
                                                                                    String str1 = "";
                                                                                    for (int i = 0; i < currLiabilx.size(); i++) {
                                                                                        coa = (Coa) currLiabilx.get(i);

                                                                                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES)) {
                                                                                            str = SessReport.switchLevel(coa.getLevel());
                                                                                            str1 = SessReport.switchLevel1(coa.getLevel());
                                                                                            double amount = DbCoa.getCoaBalanceCD(coa.getOID());
                                                                                            coaSummary4 = coaSummary4 + amount;
                                                                                            displayStr = SessReport.strDisplay(amount, coa.getStatus());
                                                                                            if (valShowList == 1) {
                                                                                                if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD", temp) != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0) || SessReport.LoadValue(coa.getOID(), temp, "CD")) {	//add detail
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                    vSesDep = new Vector();
                                                                                                    for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                                        vSesDep.add("" + DbCoa.getCoaBalanceCD(coa.getOID(), per));
                                                                                                    }
                                                                                                    sesReport.setDepartment(vSesDep);
                                                                                                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td nowrap class="tablecell1"> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                                double currLib = DbCoa.getCoaBalanceCD(coa.getOID(), per);
                                                                                                                                displayStr = SessReport.strDisplay(currLib, coa.getStatus());
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"><%=displayStr%><%//=(currLib==0) ? "" : JSPFormater.formatNumber(currLib, "#,###.##")%>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%				}
                                                                                                                } else {
                                                                                                                    if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0) || SessReport.LoadValue(coa.getOID(), temp, "CD")) {	//add detail
                                                                                                                        sesReport = new SesReportBs();
                                                                                                                        sesReport.setType(coa.getStatus());
                                                                                                                        sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                                        vSesDep = new Vector();
                                                                                                                        for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                                                            vSesDep.add("" + DbCoa.getCoaBalanceCD(coa.getOID(), per));
                                                                                                                        }
                                                                                                                        sesReport.setDepartment(vSesDep);
                                                                                                                        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td  nowrap class="tablecell1"> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                                        double currLib = DbCoa.getCoaBalanceCD(coa.getOID(), per);
                                                                                                        displayStr = SessReport.strDisplay(currLib, coa.getStatus());
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"><%=displayStr%><%//=(currLib==0) ? "" : JSPFormater.formatNumber(currLib, "#,###.##")%>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%					}
                                                                                                    }
                                                                                                }
                                                                                                if (coaSummary4 < 0) {
                                                                                                    displayStr = "(" + JSPFormater.formatNumber(coaSummary4 * -1, "#,###.##") + ")";
                                                                                                } else if (coaSummary4 < 0) {
                                                                                                    displayStr = JSPFormater.formatNumber(coaSummary4, "#,###.##");
                                                                                                } else if (coaSummary4 == 0) {
                                                                                                    displayStr = "";
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_CURRENT_LIABILITIES, "CD", temp) != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_CURRENT_LIABILITIES);
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                                    vSesDep.add("" + SessReport.getTotalCurrLibByPeriod(currLiabilx, per));
                                                                                                }
                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td ><span class="level2"><b><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_CURRENT_LIABILITIES%></b></span></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                Periode per = (Periode) temp.get(ix);
                                                                                double totalCurrLib = SessReport.getTotalCurrLibByPeriod(currLiabilx, per);
                                                                                displayStr = SessReport.strDisplay(totalCurrLib);
                                                                                            %>
                                                                                            <td width="150"> 
                                                                                                <div align="right"><b><%=displayStr%><%//=(totalCurrLib==0) ? "" : JSPFormater.formatNumber(totalCurrLib, "#,###.##") %>&nbsp;&nbsp;</b></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%
                                                                                    }
                                                                                }
                                                                                        %>
                                                                                        
                                                                                          <%
                                                                                // -------------------- long term liabilities ---------

                                                                                Vector ltermLiabilx = DbCoa.list(0, 0, "account_group='" + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES + "'", "code");
                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES, "CD", temp) != 0 || valShowList != 1){	//add Group Header
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES);
                                                                                    sesReport.setFont(1);
                                                                                    vSesDep = new Vector();
                                                                                    for (int ix = 0; ix < temp.size(); ix++) {
                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                        vSesDep.add("0");
                                                                                    }
                                                                                    sesReport.setDepartment(vSesDep);
                                                                                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" ><b><%=strTotal + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES%></b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td width="150" class="tablecell"> 
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%	}%>
                                                                                        <%
                                                                                if (ltermLiabilx != null && ltermLiabilx.size() > 0) {
                                                                                    coaSummary5 = 0;
                                                                                    String str = "";
                                                                                    String str1 = "";
                                                                                    for (int i = 0; i < ltermLiabilx.size(); i++) {
                                                                                        coa = (Coa) ltermLiabilx.get(i);

                                                                                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES)) {
                                                                                            str = SessReport.switchLevel(coa.getLevel());
                                                                                            str1 = SessReport.switchLevel1(coa.getLevel());
                                                                                            double amount = DbCoa.getCoaBalanceCD(coa.getOID());
                                                                                            coaSummary5 = coaSummary5 + amount;
                                                                                            displayStr = SessReport.strDisplay(amount, coa.getStatus());
                                                                                            if (valShowList == 1) {
                                                                                                if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD", temp) != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                    vSesDep = new Vector();
                                                                                                    for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                                        vSesDep.add("" + DbCoa.getCoaBalanceCD(coa.getOID(), per));
                                                                                                    }
                                                                                                    sesReport.setDepartment(vSesDep);
                                                                                                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td  nowrap class="tablecell1"> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                                double ltermLib = DbCoa.getCoaBalanceCD(coa.getOID(), per);
                                                                                                                                displayStr = SessReport.strDisplay(ltermLib, coa.getStatus());
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"><%=displayStr%><%//=(ltermLib==0) ? "" : JSPFormater.formatNumber(ltermLib, "#,###.##")%>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%
                                                                                                                    }
                                                                                                                } else {
                                                                                                                    if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                                        sesReport = new SesReportBs();
                                                                                                                        sesReport.setType(coa.getStatus());
                                                                                                                        sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                                        vSesDep = new Vector();
                                                                                                                        for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                                                            vSesDep.add("" + DbCoa.getCoaBalanceCD(coa.getOID(), per));
                                                                                                                        }
                                                                                                                        sesReport.setDepartment(vSesDep);
                                                                                                                        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td nowrap class="tablecell1"> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                double ltermLib = DbCoa.getCoaBalanceCD(coa.getOID(), per);
                                                                                                displayStr = SessReport.strDisplay(ltermLib, coa.getStatus());
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"><%=displayStr%><%//=(ltermLib==0) ? "" : JSPFormater.formatNumber(ltermLib, "#,###.##")%>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                if (coaSummary5 < 0) {
                                                                                                    displayStr = "(" + JSPFormater.formatNumber(coaSummary5 * -1, "#,###.##") + ")";
                                                                                                } else if (coaSummary5 > 0) {
                                                                                                    displayStr = JSPFormater.formatNumber(coaSummary5, "#,###.##");
                                                                                                } else if (coaSummary5 == 0) {
                                                                                                    displayStr = "";
                                                                                                }
                                                                                            }				//add footer level

                                                                                            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES, "CD", temp) != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES);
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                                    vSesDep.add("" + SessReport.getTotalLongLibByPeriod(ltermLiabilx, per));
                                                                                                }
                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td ><span class="level2"><b><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES%></b></span></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                Periode per = (Periode) temp.get(ix);
                                                                                double totalCurrLib = SessReport.getTotalLongLibByPeriod(ltermLiabilx, per);
                                                                                displayStr = SessReport.strDisplay(totalCurrLib);
                                                                                            %>
                                                                                            <td width="150"> 
                                                                                                <div align="right"><b><%=displayStr%><%=(totalCurrLib == 0) ? "" : JSPFormater.formatNumber(totalCurrLib, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%
                                                                                    }
                                                                                }%>
                                                                                        
