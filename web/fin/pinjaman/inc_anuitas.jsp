<table width="100%" border="0" cellspacing="1" cellpadding="1">
                                          <tr> 
                                            <td class="tablehdr" width="3%">&nbsp;</td>
                                            <td class="tablehdr" colspan="5">Koperasi</td>
                                            <td class="tablehdr" colspan="5">Bank</td>
                                            <td class="tablehdr" width="6%">&nbsp;</td>
                                            <td class="tablehdr" width="5%">&nbsp;</td>
                                            <td class="tablehdr" width="6%">&nbsp;</td>
                                            <td width="5%" class="tablehdr">&nbsp;</td>
                                            <td width="7%" class="tablehdr">&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td class="tablehdr" width="3%">Ang.</td>
                                            <td class="tablehdr" width="9%">%/bln</td>
                                            <td class="tablehdr" width="9%">Pokok 
                                            </td>
                                            <td class="tablehdr" width="9%">Bunga 
                                            </td>
                                            <td class="tablehdr" width="9%"> 
                                              <div align="center">Saldo</div>
                                            </td>
                                            <td class="tablehdr" width="8%">Angsuran 
                                            </td>
                                            <td class="tablehdr" width="9%">%/bln</td>
                                            <td class="tablehdr" width="9%">Pokok 
                                            </td>
                                            <td class="tablehdr" width="8%">Bunga 
                                            </td>
                                            <td class="tablehdr" width="9%">Saldo 
                                            </td>
                                            <td class="tablehdr" width="7%">Angsuran 
                                            </td>
                                            <td class="tablehdr" width="6%">Jatuh 
                                              Tempo</td>
                                            <td class="tablehdr" width="5%">Status</td>
                                            <td class="tablehdr" width="6%">Tanggal 
                                              Angsuran</td>
                                            <td width="5%" class="tablehdr">Angsuran</td>
                                            <td width="7%" class="tablehdr">Pelunasan</td>
                                          </tr>
                                          <tr> 
                                            <td class="tablecell" width="3%"> 
                                              <div align="center"></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap>&nbsp;</td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right"></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right"></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pinjaman.getTotalPinjaman(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell" width="8%" nowrap> 
                                              <div align="right"></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap>&nbsp;</td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right"></div>
                                            </td>
                                            <td class="tablecell" width="8%" nowrap> 
                                              <div align="right"></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pinjaman.getTotalPinjaman(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell" width="7%" nowrap> 
                                              <div align="right"></div>
                                            </td>
                                            <td class="tablecell" width="6%" nowrap> 
                                              <div align="right"></div>
                                            </td>
                                            <td class="tablecell" width="5%" nowrap> 
                                              <div align="center"></div>
                                            </td>
                                            <td class="tablecell" width="6%" nowrap> 
                                              <div align="center"></div>
                                            </td>
                                            <td class="tablecell" width="5%">&nbsp; 
                                            </td>
                                            <td class="tablecell" width="7%"> 
                                              <div align="center"></div>
                                            </td>
                                          </tr>
                                          <%
										  boolean nextPayment = false;
										  long prevPaidDetail = 0;
										  
										  for(int i=0; i<pds.size(); i++){
										  		PinjamanDetail pd = (PinjamanDetail)pds.get(i);
												
												Vector bayars = DbBayarPinjaman.list(0,0, "pinjaman_detail_id="+pd.getOID(), "");
												BayarPinjaman bp = new BayarPinjaman();
												if(bayars!=null && bayars.size()>0){
													bp = (BayarPinjaman)bayars.get(0);
												}
												
												//pertama
												if(i==0 && bp.getOID()==0){
													nextPayment = true;
												}
												//kedua dst
												else{
													if(prevPaidDetail!=0 && bp.getOID()==0){
														nextPayment = true;
													}
												}
												
												prevPaidDetail = bp.getOID();
										  %>
                                          <%		
												Date xdt = new Date();
											    Date jtt = pd.getJatuhTempo();
												
												boolean editable = true;
												if(pd.getStatus()==0){													
													if(jtt.getYear()<xdt.getYear()){
														editable = false;
													}
													else{
														if(jtt.getYear()==xdt.getYear()){
															if(jtt.getMonth()<=xdt.getMonth()){
																editable = false;
															}
														}
													}													
												}
												else{
													editable = false;
												}
												
											  
												if(i%2==0){
										  %>
                                          <tr> 
                                            <td class="tablecell" width="3%"> 
                                              <div align="center"><%=pd.getCicilanKe()%></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right"> 
                                                <%
											  if(editable && (pinjaman.getStatus()==DbPinjaman.STATUS_DRAFT || pinjaman.getStatus()==DbPinjaman.STATUS_APPROVE)){%>
                                                <a href="javascript:cmdEditBunga('<%=pd.getOID()%>')"><%=JSPFormater.formatNumber(pd.getBungaKoperasiPercent(), "#,###.##")%></a> 
                                                <%}else{%>
                                                <%=JSPFormater.formatNumber(pd.getBungaKoperasiPercent(), "#,###.##")%> 
                                                <%}%>
                                              </div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getAmount(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getBunga(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getSaldoKoperasi(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell" width="8%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getTotalKoperasi(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getBungaBankPercent(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getAmountBank(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell" width="8%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getBungaBank(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getSaldoBank(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell" width="7%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getTotalBank(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell" width="6%" nowrap> 
                                              <div align="right">&nbsp;&nbsp; 
                                                <%if(i==0 && bp.getOID()==0){%>
                                                <a href="javascript:cmdUpdateTanggal('<%=pd.getOID()%>')"><%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd/MM/yy")%></a> 
                                                <%}else{%>
                                                <%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd/MM/yy")%> 
                                                <%}%>
                                                &nbsp;&nbsp;</div>
                                            </td>

                                            <td class="tablecell" width="5%" nowrap> 
                                              <div align="center"><%=DbPinjaman.strPaymentStatus[pd.getStatus()]%></div>
                                            </td>
                                            <td class="tablecell" width="6%" nowrap> 
                                              <div align="center"><%=(bp.getOID()!=0) ? JSPFormater.formatDate(bp.getTanggal(), "dd/MM/yy") : "-"%></div>
                                            </td>
                                            <td class="tablecell" width="5%"> 
                                              <div align="center"> 
                                                <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                                <a href="javascript:cmdBayar('<%=pd.getOID()%>')">Angsuran</a> 
                                                <%	}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_ANGSURAN){														
													%>
                                                <a href="javascript:cmdBayarDetail('<%=pd.getOID()%>')">Detail</a> 
                                                <%	
														}
													}
												}%>
                                              </div>
                                            </td>
                                            <td class="tablecell" width="7%"> 
                                              <div align="center"> 
                                                <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                                <a href="javascript:cmdPelunasan('<%=pd.getOID()%>')">Pelunasan</a> 
                                                <%
														}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_PELUNASAN){
														%>
                                                <a href="javascript:cmdPelunasanDetail('<%=pd.getOID()%>')">Detail</a> 
                                                <%
														}
													}
												}%>
                                              </div>
                                            </td>
                                          </tr>
                                          <%}else{%>
                                          <tr> 
                                            <td class="tablecell1" width="3%"> 
                                              <div align="center"><%=pd.getCicilanKe()%></div>
                                            </td>
                                            <td class="tablecell1" width="9%" nowrap> 
                                              <div align="right"> 
                                                <%
											  if(editable && (pinjaman.getStatus()==DbPinjaman.STATUS_DRAFT || pinjaman.getStatus()==DbPinjaman.STATUS_APPROVE)){%>
                                                <a href="javascript:cmdEditBunga('<%=pd.getOID()%>')"><%=JSPFormater.formatNumber(pd.getBungaKoperasiPercent(), "#,###.##")%></a> 
                                                <%}else{%>
                                                <%=JSPFormater.formatNumber(pd.getBungaKoperasiPercent(), "#,###.##")%> 
                                                <%}%>
                                              </div>
                                            </td>
                                            <td class="tablecell1" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getAmount(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell1" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getBunga(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell1" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getSaldoKoperasi(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell1" width="8%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getTotalKoperasi(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell1" width="9%" nowrap> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getBungaBankPercent(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getAmountBank(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell1" width="8%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getBungaBank(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell1" width="9%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getSaldoBank(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell1" width="7%" nowrap> 
                                              <div align="right">&nbsp;&nbsp;<%=JSPFormater.formatNumber(pd.getTotalBank(), "#,###")%></div>
                                            </td>
                                            <td class="tablecell1" width="6%" nowrap> 
                                              <div align="right">&nbsp;&nbsp; 
                                                <%if(i==0 && bp.getOID()==0){%>
                                                <a href="javascript:cmdUpdateTanggal('<%=pd.getOID()%>')"><%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd/MM/yy")%></a> 
                                                <%}else{%>
                                                <%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd/MM/yy")%> 
                                                <%}%>
                                                &nbsp;&nbsp;</div>
                                            </td>
                                            <td class="tablecell1" width="5%" nowrap> 
                                              <div align="center"><%=DbPinjaman.strPaymentStatus[pd.getStatus()]%></div>
                                            </td>
                                            <td class="tablecell1" width="6%" nowrap> 
                                              <div align="center"><%=(bp.getOID()!=0) ? JSPFormater.formatDate(bp.getTanggal(), "dd/MM/yy") : "-"%></div>
                                            </td>
                                            <td class="tablecell1" width="5%"> 
                                              <div align="center"> 
                                                <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                                <a href="javascript:cmdBayar('<%=pd.getOID()%>')">Angsuran</a> 
                                                <%	}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_ANGSURAN){														
													%>
                                                <a href="javascript:cmdBayarDetail('<%=pd.getOID()%>')">Detail</a> 
                                                <%	
														}
													}
												}%>
                                              </div>
                                            </td>
                                            <td class="tablecell1" width="7%"> 
                                              <div align="center"> 
                                                <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                                <a href="javascript:cmdPelunasan('<%=pd.getOID()%>')">Pelunasan</a> 
                                                <%
														}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_PELUNASAN){
														%>
                                                <a href="javascript:cmdPelunasanDetail('<%=pd.getOID()%>')">Detail</a> 
                                                <%
														}
													}
												}%>
                                              </div>
                                            </td>
                                          </tr>
                                          
                                          <%
										  	
											
										  
										  }%>
										  <%if(iJSPCommand==JSPCommand.PRINT && pd.getOID()==oidPinjamanDetail){%>
										  <tr>
                                            <td width="3%">&nbsp;</td>
                                            <td width="9%"><a name="go"></a></td>
                                            <td width="9%"></td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="7%">Jatuh tempo Angsuran 
                                              I</td>
                                            <td width="6%"> 
                                              <input name="jatuh_tempo" value="<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>" size="11" readonly>
                                              <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpinjaman.jatuh_tempo);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                            <td width="5%"><a href="javascript:cmdUpdateJT()">Update</a></td>
                                            <td width="6%"><a href="javascript:cmdCancel()">Batalkan</a></td>
                                            <td width="5%">&nbsp;</td>
                                            <td width="7%">&nbsp;</td>
                                          </tr>
										  <%}%>
                                          <%if(iJSPCommand==JSPCommand.SUBMIT && pd.getOID()==oidPinjamanDetail){%>
                                          <tr> 
                                            <td width="3%">&nbsp;</td>
                                            <td width="9%"><a name="go"></a></td>
                                            <td width="9%"></td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td width="7%">&nbsp;</td>
                                            <td width="6%">&nbsp;</td>
                                            <td width="5%">&nbsp;</td>
                                            <td width="6%">&nbsp;</td>
                                            <td width="5%">&nbsp;</td>
                                            <td width="7%">&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td width="3%">&nbsp;</td>
                                            <td width="9%"><b>Bunga Kop.</b></td>
                                            <td width="9%"> 
                                              <div align="center"> 
                                                <input type="text" name="bunga_koperasi" size="10">
                                              </div>
                                            </td>
                                            <td width="9%"><b>Bunga Bank</b></td>
                                            <td width="9%"> 
                                              <div align="center"> 
                                                <input type="text" name="bunga_bank" size="10">
                                              </div>
                                            </td>
                                            <td width="8%"> 
                                              <div align="center"><a href="javascript:cmdUpdateBunga()">Update</a></div>
                                            </td>
                                            <td width="9%"> 
                                              <div align="center"><a href="javascript:cmdCancel()">Batalkan</a></div>
                                            </td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td width="7%">&nbsp;</td>
                                            <td width="6%">&nbsp;</td>
                                            <td width="5%">&nbsp;</td>
                                            <td width="6%">&nbsp;</td>
                                            <td width="5%">&nbsp;</td>
                                            <td width="7%">&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td width="3%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="center">%/tahun</div>
                                            </td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="center">%/tahun</div>
                                            </td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td width="7%">&nbsp;</td>
                                            <td width="6%">&nbsp;</td>
                                            <td width="5%">&nbsp;</td>
                                            <td width="6%">&nbsp;</td>
                                            <td width="5%">&nbsp;</td>
                                            <td width="7%">&nbsp;</td>
                                          </tr>
                                          <%}
										  nextPayment = false;
										  %>
                                          <%}%>
                                          <tr> 
                                            <td width="3%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td width="7%">&nbsp;</td>
                                            <td width="6%">&nbsp;</td>
                                            <td width="5%">&nbsp;</td>
                                            <td width="6%">&nbsp;</td>
                                            <td width="5%">&nbsp;</td>
                                            <td width="7%">&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td width="3%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td colspan="2"><b>Total Pinjaman</b> 
                                              <div align="right"></div>
                                            </td>
                                            <td colspan="4" class="tablecell1"> 
                                              <div align="right"><b><%= JSPFormater.formatNumber(pinjaman.getTotalPinjaman(),"#,###.##") %></b></div>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <td width="3%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td colspan="2"><b>Total Pembayaran</b> 
                                              <div align="right"></div>
                                            </td>
                                            <td colspan="4" class="tablecell1"> 
                                              <div align="right"> <b> 
                                                <%
											double totalBayar = DbBayarPinjaman.getTotalPayment(pinjaman.getOID());
											%>
                                                <%= JSPFormater.formatNumber(totalBayar,"#,###.##") %></b></div>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <td width="3%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%"> 
                                              <div align="right"></div>
                                            </td>
                                            <td colspan="2"><b>Sisa</b> 
                                              <div align="right"></div>
                                            </td>
                                            <td colspan="4" class="tablecell1"> 
                                              <div align="right"><b><%= JSPFormater.formatNumber(pinjaman.getTotalPinjaman()-totalBayar,"#,###.##") %></b></div>
                                            </td>
                                          </tr>
                                        </table>
                                      