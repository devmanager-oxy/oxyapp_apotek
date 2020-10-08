
<%-- 
    Document   : in_bsmultiple
    Created on : Jul 18, 2011, 1:45:20 PM
    Author     : Roy Andika
--%>

<tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td width="6%"><%=langFR[0]%></td>
                                    <td width="94%" colspan="2"> 
                                      <select name="showlist" onChange="javascript:cmdChangeList()">
                                        <option value="1" <%if(valShowList==1){%>selected<%}%>><%=langFR[1]%></option>
                                        <option value="2" <%if(valShowList==2){%>selected<%}%>><%=langFR[2]%></option>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="20" valign="middle" align="center" colspan="3"> 
                                      
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="26%"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="23%"><%=langFR[3]%></td>
                                                <td width="44%"> 
                                                  <select name="year" onChange="javascript:cmdChangeYear()">
                                                    <option value="<%=year%>" <%if(year==yearselect){%>selected<%}%>><%=(year+1900)%></option>
                                                    <option value="<%=year-1%>" <%if((year-1)==yearselect){%>selected<%}%>><%=year-1+1900%></option>
                                                    <option value="<%=year-2%>" <%if((year-2)==yearselect){%>selected<%}%>><%=year-2+1900%></option>
                                                  </select>
                                                </td>
                                                <td width="33%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="48%"> 
                                            <div align="center"><span class="level1"><font size="+1"><b><%=langFR[4]%></b></font></span></div>
                                          </td>
                                          <td width="26%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  
                                  
                                  
                                  <%
								  	Periode periode = DbPeriode.getOpenPeriod();
									String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");        
								  %>
                                  <tr align="left" valign="top"> 
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><b><%=langFR[5]%></b></span></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3"></td>
                                  </tr>
