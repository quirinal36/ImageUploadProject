<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="java.awt.Image"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%
String path = getServletContext().getRealPath("/upload");// 이미지가 저장될 주소
String filename = "";
Logger logger = Logger.getLogger("file_upload.jsp");

if(request.getContentLength() > 20*1024*1024 ){
	%>
	<script>alert("업로드 용량(총 20Mytes)을 초과하였습니다.");history.back();</script>
	<%
	return;

} else {

	try {
		MultipartRequest multi=new MultipartRequest(request, path, 15*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
	
		java.text.SimpleDateFormat formatter2 = new java.text.SimpleDateFormat ("yyyy_MM_dd_HHmmssSSS", java.util.Locale.KOREA);
		int cnt = 1;
		String upfile = (multi.getFilesystemName("Filedata"));
		
		if (!upfile.equals("")) {
			String dateString = formatter2.format(new java.util.Date());
			String moveFileName = dateString + upfile.substring(upfile.lastIndexOf(".") );
			String fileExt = upfile.substring(upfile.lastIndexOf(".") + 1);
			File sourceFile = new File(path + File.separator + upfile);
			File targetFile = new File(path + File.separator + moveFileName);
			
			logger.info(sourceFile.getAbsolutePath());
			
			BufferedImage img = ImageIO.read(sourceFile);
			
			ImageIO.write(img, "JPEG", targetFile);
			
			filename = moveFileName;
			
			sourceFile.delete();
			%>
			<form id="fileform" name="fileform" method="post">
				<input type="hidden" name="filename" id="filename"	value="<%=filename%>">
				<input type="hidden" name="path" 		value="<%=path%>">
				<input type="hidden" name="fcode" 		value="<%=path%>">
			</form>
			<%
		}
	} catch (Exception e) {
		System.out.println("e : " + e.getMessage());
	}
}
%>

<script type="text/javascript">
	function fileAttach(){
		f = document.fileform;
	    fname 	= f.filename.value; 
	    var fullUrl = "http://upload.uffda.kr/upload/"+fname;
	    try{
	    	window.opener.$("#targetUpload").val(fullUrl);
	    }catch(e){ 
            alert(e); 
	    }
	    try{
	    	window.opener.$("#targetImgPreview").attr('src', fullUrl);
	    }catch(e){
	    	console.log(e);
	    }
	}
	fileAttach();
	this.window.close();
</script>
