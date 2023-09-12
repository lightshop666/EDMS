<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
table {
  width: 100%;
  border-collapse: collapse;
}
th, td {
  border: 1px solid black;
  padding: 10px;
}
</style>

</head>
<body>

<script type="text/javascript">
/* Javascript 샘플 코드 */

var xhr = new XMLHttpRequest();
var url = 'http://openapi.1365.go.kr/openapi/service/rest/VolunteerPartcptnService/getVltrAreaList'; /*URL*/
var queryParams = '?' + encodeURIComponent('serviceKey') + '='+'${serviceKey}'; /*Service Key*/
queryParams += '&' + encodeURIComponent('schSido') + '=' + encodeURIComponent('6110000'); /**/
queryParams += '&' + encodeURIComponent('schSign1') + '=' + encodeURIComponent('3170000'); /**/
/* queryParams += '&' + encodeURIComponent('upperClCode') + '=' + encodeURIComponent('0100'); 
queryParams += '&' + encodeURIComponent('nanmClCode') + '=' + encodeURIComponent('0199'); */
queryParams += '&' + encodeURIComponent('schCateGu') + '=' + encodeURIComponent('all');
/* queryParams += '&' + encodeURIComponent('keyword') + '=' + encodeURIComponent('의정부'); */

xhr.open('GET', url + queryParams);
xhr.onreadystatechange = function () {
    if (this.readyState == 4) {
    	 var parser = new DOMParser(); // DOMParser 객체를 생성합니다.
         var xmlDoc = parser.parseFromString(this.responseText, "text/xml"); // 응답 텍스트를 파싱하여 XML 문서 객체를 생성합니다.

         var table = document.getElementById("apiResponseTable"); // 테이블 요소를 가져옵니다.
         
         // TODO: xmlDoc에서 필요한 데이터 추출 및 테이블 생성 로직 구현
         // XML의 구조와 어떤 데이터를 표시하려는지에 따라 이 부분의 코드가 달라질 것입니다.
    	
        alert('Status: '+this.status+'nHeaders: '+JSON.stringify(this.getAllResponseHeaders())+'nBody: '+this.responseText);
    }
};

xhr.send('');

</script>

<table id="apiResponseTable">
<!-- 테이블 헤더 및 본문은 자바스크립트에서 동적으로 생성됩니다 -->
</table>

</body>
</html>