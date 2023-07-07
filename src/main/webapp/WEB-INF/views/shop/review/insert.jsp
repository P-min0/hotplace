<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <script>
function handleSubmit(event) {
    event.preventDefault(); // 기본 제출 동작 막기

    // form 요소 찾기
    var form = document.getElementById("reviewForm");

    // form 데이터를 가져오기 위한 FormData 객체 생성
    var formData = new FormData(form);

    // AJAX 요청 보내기
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "insertOK.do");
    xhr.onload = function() {
        // 요청이 완료되었을 때 처리할 로직 작성
        if (xhr.status === 200) {
            // 작업 완료 후 창 닫기
            window.opener.location.reload(); // 부모 창 새로고침
            window.close(); // 현재 창 닫기
        }
    };
    xhr.send(formData);

    // 작업 완료 후 창 닫기
}
function showImagePreview(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var imagePreview = document.getElementById("imagePreview");
            imagePreview.src = e.target.result;
        };
        reader.readAsDataURL(input.files[0]);
    }
}
</script>
    <meta charset="UTF-8">
    <title>Insert title here</title>
</head>
<body>
    <form id="reviewForm" enctype="multipart/form-data">
   		<div>
            <label for="image">Image:</label>
            <input type="file" name="multipartFile" accept="image/*" onchange="showImagePreview(this)">
        </div>
        <div>
            <img id="imagePreview" src="#" alt="Image Preview" style="max-width: 200px; max-height: 200px;">
        </div>
        <div>
            <label for="content">Content:</label>
            <textarea id="content" name="content" rows="4" cols="50"></textarea>
        </div>
        <div>
            <label for="rate">Rate:</label>
            <select id="rated" name="rated">
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
            </select>
        </div>
         <div>
            <input type="hidden" name="writerName" value="${param.nickName}">
            <input type="hidden" name="shopNum" value="${param.num}">
        </div>
        <div>
            <input type="submit" value="확인" onclick="handleSubmit(event)">
        </div>
    </form>
</body>
</html>