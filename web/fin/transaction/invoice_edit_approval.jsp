<table width="32%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="33%" class="tablecell1"><b><u>Document 
                                                        History</u></b></td>
                                                      <td width="34%" class="tablecell1"> 
                                                        <div align="center"><b><u>User</u></b></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"><b><u>Date</u></b></div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="33%" class="tablecell1"><i>Prepared 
                                                        by</i></td>
                                                      <td width="34%" class="tablecell1"> 
                                                        <div align="center"> <i> 
                                                          <%
												User u = new User();
												try{
													u = DbUser.fetch(receive.getUserId());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"><i><%=JSPFormater.formatDate(receive.getDate(), "dd MMMM yy")%></i></div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="33%" class="tablecell1"><i>Approved 
                                                        by</i></td>
                                                      <td width="34%" class="tablecell1"> 
                                                        <div align="center"> <i> 
                                                          <%
												 u = new User();
												try{
													u = DbUser.fetch(receive.getApproval1());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"> <i> 
                                                          <%if(receive.getApproval1()!=0){%>
                                                          <%=JSPFormater.formatDate(receive.getApproval1Date(), "dd MMMM yy")%> 
                                                          <%}%>
                                                          </i></div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="33%" class="tablecell1"><i>Checked 
                                                        by </i></td>
                                                      <td width="34%" class="tablecell1"> 
                                                        <div align="center"><i> 
                                                          <%
												 u = new User();
												try{
													u = DbUser.fetch(receive.getApproval2());
												}
												catch(Exception e){
												}
												%>
                                                          <%=u.getLoginId()%></i></div>
                                                      </td>
                                                      <td width="33%" class="tablecell1"> 
                                                        <div align="center"><i> 
                                                          <%if(receive.getApproval2()!=0){%>
                                                          <%=JSPFormater.formatDate(receive.getApproval2Date(), "dd MMMM yy")%> 
                                                          <%}%>
                                                          </i></div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                