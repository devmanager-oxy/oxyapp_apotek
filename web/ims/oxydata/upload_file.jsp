<%
	
%>
<script language="JavaScript">
function gogo(){
	document.form1.submit();
}
</script>

<html>
 <head><title>Upload page</title></head></p> <p><body>
 <form action="upload_file_multipale.jsp" method="post" enctype="multipart/form-data" name="form1" id="form1">
   <center>
   <table border="2">
       <tr>
	       <td align="center"><b>Multipale file Uploade</td>
	   </tr>
       <tr>
	       <td>
		       Specify file: <input name="file" type="file" value="c:/customer.txt" id="file">
		   <td>
	   </tr>
	   <tr>
	      <td>
		     Specify file:<input name="file" type="file" id="file">
		  </td>
        <tr>
		   <td>
		      Specify file:<input name="file" type="file" id="file">
		   </td>
		 </tr>
		 <tr>
		    <td align="center">
               <input type="submit" name="Submit" value="Submit files"/>
			</td>
		 </tr>
    </table>
	<center>
 </form>
 </body>
 </html>
<script language="JavaScript">
	//gogo();
</script>