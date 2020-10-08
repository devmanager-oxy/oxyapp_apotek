<tr> 
                                                                                            <td class="tablehdr" height="20" width="300"><%=langFR[6]%></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablehdr" width="150" height="20"><%=per.getName()%></td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b>Activa</b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td width="150" class="tablecell"> 
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%

                                                                                //----- liquid asset -------
                                                                                //add Top Header
                                                                                sesReport = new SesReportBs();
                                                                                sesReport.setType("Top Level");
                                                                                sesReport.setDescription("Activa");
                                                                                sesReport.setFont(1);
                                                                                vSesDep = new Vector();
                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                    vSesDep.add("0");
                                                                                }
                                                                                sesReport.setDepartment(vSesDep);
                                                                                listReport.add(sesReport);

                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LIQUID_ASSET, "DC", temp) != 0 || valShowList != 1) {	//add Group Header
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_LIQUID_ASSET);
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
                                                                                            <td class="tablecell"><b><%=strTotal + I_Project.ACC_GROUP_LIQUID_ASSET%></b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td width="150" class="tablecell"> 
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%

                                                                                Vector liqAssetx = DbCoa.list(0, 0, "account_group='" + I_Project.ACC_GROUP_LIQUID_ASSET + "'", "code");

                                                                                if (liqAssetx != null && liqAssetx.size() > 0) {
                                                                                    String str = "";
                                                                                    String str1 = "";
                                                                                    for (int i = 0; i < liqAssetx.size(); i++) {
                                                                                        coa = (Coa) liqAssetx.get(i);

                                                                                        //if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET))
                                                                                        //{
                                                                                        str = SessReport.switchLevel(coa.getLevel());
                                                                                        str1 = SessReport.switchLevel1(coa.getLevel());
                                                                                        double amount = DbCoa.getCoaBalance(coa.getOID(), temp);
                                                                                        coaSummary1 = coaSummary1 + amount;
                                                                                        //displayStr = strDisplay(amount, coa.getStatus());								
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
                                                                                            <td class="tablecell1"> 
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
                                                                                                                                double liqAsset = DbCoa.getCoaBalance(coa.getOID(), per);
                                                                                                                                displayStr = SessReport.strDisplay(liqAsset, coa.getStatus());
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"><%=displayStr%>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%
                                                                                                                    }
                                                                                                                } else {
                                                                                                                    if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {
                                                                                                                        //add detail
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
                                                                                                double liqAsset = DbCoa.getCoaBalance(coa.getOID(), per);
                                                                                                displayStr = SessReport.strDisplay(liqAsset, coa.getStatus());
                                                                                            %>
                                                                                            <td width="150" class="tablecell1"> 
                                                                                                <div align="right"><%=displayStr%><%//=(liqAsset==0) ? "" : JSPFormater.formatNumber(liqAsset, "#,###.##")%>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
