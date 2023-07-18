<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>유저페이지</title>
<link rel="stylesheet" href="/hotplace//resources/css/memberreview/userpage.css?after" >
<link rel="stylesheet" href="/hotplace//resources/css/memberreview/userpage_json.css?after" >
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script type="text/javascript">

let page =1;
let mrePage = 1;
let par_count; // 게시글 개수
let mer_count; // 게시글 개수

$(function(){
	console.log('onload...');
	
	$.ajax({
		url: "party/json/selectAll.do",
		data:{
			writerNum : ${param.num},
			page: page, //${param.page}
		},
		method: 'GET',
		dataType: 'json',
		success: function(arr){
			console.log('ajax...',arr);
			let tag_vos = '';
			
			
			$.each(arr, function(index, vo){
				let deadLine = vo.deadLine.substring(0,16);
				let timeLimit = vo.timeLimit.substring(0,16);
					
				if (vo.writerNum === ${vo2.num}) { // user_id
					tag_vos +=`
						<div class="par-post">
							<div class="par-status">\${vo.applicants}/\${vo.max}</div>
							<div class="par-title">[\${vo.place}] \${vo.title}</div>
							<div class="par-container">
								<div class="par-list">
									<div>마감일</div>
									<div>약속일</div>
									<div>주최자</div>
								</div>
								<div class="par-data">
									<div>\${deadLine}</div>
									<div>\${timeLimit}</div>
									<div>\${vo.writerName}</div>
								</div>
							</div>
							<button class="par-bt" onclick="location.href='party/selectOne.do?partyNum=\${vo.partyNum}'">MORE VIEW</button>
						</div>
					`;
				}
				
			}); // end for-each

			$(".par-selectAll").css('color', '#F47420');
			$(".par_paging").css("display", "block");
			$(".mre_paging").css("display", "none");
			$('#par_vos').html(tag_vos);
		}, // end success
		
		error:function(xhr,status,error){
			console.log('xhr.status:', xhr.status);
		} // end error
	}); // end ajax;
	  
	function par_totalCount(){ // 게시글 개수 계산
		console.log('par_totalCount...');
		$.ajax({
			url: "party/json/par_totalCount.do",
			data:{
				writerNum : ${param.num}
			},
			method: 'GET',
			dataType: 'json',
			success: function(cnt){
				console.log('cnt...',cnt);
	            par_count = cnt;
	            $('#par_count').text(par_count);
			}, // end success
			
			error:function(xhr,status,error){
				console.log('xhr.status:', xhr.status);
				
			} // end error
		}) // end ajax;	
	};
	par_totalCount();
	
	$(document).on('click', '#par_back_page', function(e) { // 이전 버튼 클릭 시 동작
	    e.preventDefault(); // 기본 링크 동작(페이지 다시로드)을 막음.
		if(page==1){ // 첫번째 페이지에서 팝업 경고창
			alert('첫 페이지입니다.');
			return false;
		}
	    // 이전 페이지 번호 계산
	    let previousPage = parseInt(page) - 1;
	    page = previousPage;
		console.log('par_count',par_count);
	    
	 	// parameter 수정 후 페이지 다시 로드
	    par_selectAll(previousPage);
	});
 
	$(document).on('click', '#par_next_page', function(e) {
// 		console.log('page...',page);
		console.log('par_count',par_count);
		e.preventDefault(); // 기본 링크 동작(페이지 다시로드)을 막음.
		if((page*6) >= par_count){ // 마지막 페이지에서 팝업 경고창
			alert('마지막 페이지입니다.');
			return false;
		}
		// 다음 페이지 번호 계산
	    let nextPage = parseInt(page) + 1;
		page = nextPage;
		console.log('page...',page);
		
		// parameter 수정 후 페이지 다시 로드
	    par_selectAll(nextPage);
	});	

}); // end onload	


function mre_selectAll(memberreviewNum=0, mrePage){ // ${param.memberreviewNum} 
// 	console.log('mer_selectAll()....userNum:',userNum);
// 	console.log('mer_selectAll()....memverreviewNum:',memberreviewNum);
	
// 	$('#par_vos').hide(); // 모임리스트 요소를 숨기도록 설정
// 	$('#memberreview_list').show();
// 	$('#insertButton').show();
	$.ajax({
		url : "memberreview/json/selectAll.do",
		data:{
			userNum:${vo2.num}, // ${param.userNum}
			page: mrePage, //${param.page}
		},
		method:'GET',
		dataType:'json',
		success : function(vos) {
			console.log('ajax...success:', vos);

			let tag_txt = '';
			
			$.each(vos,function(index,vo){
				let wdate = vo.wdate.substring(0,16);
				
// 				console.log('ajax...success:', vo);
				
				let ratedValue = parseInt(vo.rated);
// 				console.log('vo.rated:', vo.rated);
// 				console.log('vo.partynum:', vo.partyNum);

				let tag_td = `\${vo.content}`;
				let tag_rated = `
			        <div id="starRating">
		            <ul class="star-rating"  data-rating="\${ratedValue}">
		                <li class="star fa fa-star"></li>
		                <li class="star fa fa-star"></li>
		                <li class="star fa fa-star"></li>
		                <li class="star fa fa-star"></li>
		                <li class="star fa fa-star"></li>
		            </ul>
		        </div>`;
		       
				// userNum==vo.userNum
				if(memberreviewNum==vo.memberreviewNum) {
					tag_td = `<input type="text" value="\${vo.content}" id="input_content" required><button onclick="updateOK(\${vo.memberreviewNum})">수정완료</button>`;
					tag_rated = `
				            <ul class="star-rating"  data-rating="\${ratedValue}" required>
				                <li class="star fa fa-star" data-rating="1"></li>
				                <li class="star fa fa-star" data-rating="2"></li>
				                <li class="star fa fa-star" data-rating="3"></li>
				                <li class="star fa fa-star" data-rating="4"></li>
				                <li class="star fa fa-star" data-rating="5"></li>
				            </ul>
			        	`;
					$(document).ready(function() {
			            $('.star-rating .star').click(function() {
			              var rating = $(this).attr('data-rating');
			              $('.star-rating .star').removeClass('active');
			              $(this).prevAll().addBack().addClass('active');
			              console.log('별점: ' + rating);
			              $('#mre_rated').val(rating); // input2 폼에 선택한 별점 값 설
			            });
			          });
			        isFormInserted = true;
				}
				
				let tag_div = ``;
				if(vo.writerNum==${num}){ //'${user_id}'===vo.writerNum
					tag_div = `
						<button class="mre-update" onclick="mre_selectAll(\${vo.userNum},\${vo.memberreviewNum}, mrePage)">수정</button>
						<button class="mre-delete" onclick="deleteOK(\${vo.memberreviewNum})">삭제</button>
					`;
				}

				tag_txt += `
					<div class="mre-post">
						<div class="mre-userImpo">
							<img id="preview" width="50px" src="${pageContext.request.contextPath}/resources/ProfileImage/\${vo.writerNum}.png"
							onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/ProfileImage/default.png';">
							<div class="mre-writerName">\${vo.writerName}</div>
							<div class="mre-rated" id="starRating">\${tag_rated}</div>
							<div class="mre-date">\${wdate}</div>
						</div>
						<div class="mre-input">
							<div class="mre-content">\${tag_td}</div>
							<div class="mre-bt">\${tag_div}</div>
						</div>
					</div>
				`;
			});//end ajax
			
			$(".mre-post").css("display", "block");
			$(".par-post").css("display", "none");
			
			$(".mre_paging").css("display", "block");
			$(".par_paging").css("display", "none");
			
// 			$(".formContainer").css("display", "block");
			$('#memberreview_list').html(tag_txt);
			
			// 별점 채우기
			$('.star-rating').each(function() {
			  var ratedValue = parseInt($(this).data('rating'));
			  var stars = $(this).find('.star');
			  for (var i = 0; i < ratedValue; i++) {
			    $(stars[i]).addClass('active');
			  }
			});
			
// 			mre_totalCount();
		},
		error:function(xhr,status,error){
			console.log('xhr.status:', xhr.status);
		}
	});
}// end mre_selectAll

function mre_totalCount(){ // 게시글 개수 계산
	console.log('mre_totalCount...');
	$.ajax({
		url: "memberreview/json/mre_totalCount.do",
		data:{
			userNum:${vo2.num}
		},
		method: 'GET',
		dataType: 'json',
		success: function(cnt){
			console.log('cnt...',cnt);
            mre_count = cnt;
            $('#mre_count').text(mre_count);
		}, // end success
		
		error:function(xhr,status,error){
			console.log('xhr.status:', xhr.status);
			
		} // end error
	}) // end ajax;	
};
mre_totalCount();

$(document).on('click', '#mre_back_page', function(e) { // 이전 버튼 클릭 시 동작
    e.preventDefault(); // 기본 링크 동작(페이지 다시로드)을 막음.
	if(mrePage==1){ // 첫번째 페이지에서 팝업 경고창
		alert('첫 페이지입니다.');
		return false;
	}
    // 이전 페이지 번호 계산
    let previousPage = parseInt(mrePage) - 1;
    mrePage = previousPage;
	console.log('mre_count',mre_count);
    
 	// parameter 수정 후 페이지 다시 로드
	mre_selectAll(memberreviewNum=0, mrePage)
});

$(document).on('click', '#mre_next_page', function(e) {
//		console.log('page...',page);
	console.log('mre_count',mre_count);
	e.preventDefault(); // 기본 링크 동작(페이지 다시로드)을 막음.
	if((mrePage*5) >= mre_count){ // 마지막 페이지에서 팝업 경고창
		alert('마지막 페이지입니다.');
		return false;
	}
	// 다음 페이지 번호 계산
    let nextPage = parseInt(mrePage) + 1;
    mrePage = nextPage;
	console.log('mrePage...',mrePage);
	
	// parameter 수정 후 페이지 다시 로드
    mre_selectAll(memberreviewNum=0, mrePage)
});
	

let isFormInserted = false;

function insert() {
	console.log('insert()...');
	
    if (!isFormInserted) {
		console.log('insert()...if');
    	
    	$(".mre-post").css("display", "none");
		$(".par-post").css("display", "none");
		$(".mre_paging").css("display", "none");
		$(".par_paging").css("display", "none");
		
// 		$('#par_vos').hide();
// 		$('#memberreview_list').hide();
    	
        // 폼을 감싸는 부모 요소 생성
        var formContainer = $('<div id="formContainer" class="formContainer"></div>');
// 		<div class="mre-writerName">\${vo.writerName}</div>
        var form = $(`
        		  <form class="insert-form">
		        	<div class="mre-userImpo">
						<img id="preview" width="50px" src="${pageContext.request.contextPath}/resources/ProfileImage/${num}.png"
						onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/ProfileImage/default.png';">
						<div class="insert-rated">
		        		    <input type="hidden" name="rated" id="mre_rated" required>
							<ul class="star-rating">
		        		      <li class="star fa fa-star" data-rating="1"></li>
		        		      <li class="star fa fa-star" data-rating="2"></li>
		        		      <li class="star fa fa-star" data-rating="3"></li>
		        		      <li class="star fa fa-star" data-rating="4"></li>
		        		      <li class="star fa fa-star" data-rating="5"></li>
		        		    </ul>
		        		</div>
					</div>
        		    <input class="insert-content" type="text" name="content" id="mre_content">
        		    <button class="insert-bt" onclick="insertOK()">작성완료</button>
        		  </form>
        		`);

        formContainer.append(form);
        formContainer.addClass('show-star-rating');

        $(document).ready(function() {
            $('.star-rating .star').click(function() {
              var rating = $(this).attr('data-rating');
              $('.star-rating .star').removeClass('active');
              $(this).prevAll().addBack().addClass('active');
              console.log('별점: ' + rating);
              $('#mre_rated').val(rating); // input2 폼에 선택한 별점 값 설
            });
          });

        isFormInserted = true;
    	// 기존 폼을 제거하고 새로운 폼으로 교체
        $('#formContainer').replaceWith(formContainer);
    }else {
    	// 초기화 작업 수행
    	$('#formContainer').replaceWith(formContainer);
        $('.insert-form').remove();
        $(".mre-post").css("display", "block");
//         $('#par_vos').show();
//         $('#memberreview_list').show();
        isFormInserted = false;
    }
}//end insert

function insertOK() {
    var rated = $('#mre_rated').val();
    var content = $('#mre_content').val();

    if (!rated) {
        alert('별점을 입력하세요.');
        isFormInserted = false;
        return insert();
    }
    
    if (content==null) {
    	content = '';
    }
	
    if (isFormInserted) {
        $('form').on('submit', function(event) {
            event.preventDefault();
        });
        console.log('insertOK()....');
        console.log($('#mre_content').val());
        $.ajax({
            url: "memberreview/json/insertOK.do",
            data: {
                partyNum: 9,//9 ${vo.partyNum}
                userNum: ${vo2.num}, //
                writerNum: ${num},
                rated: $('#mre_rated').val(),
                content: content || ''
            },
            method: 'POST',
            dataType: 'json',
            success: function(obj) {
                console.log('ajax...success:', obj);
                if (obj.result == 1) {
                    isFormInserted = false; // 폼이 초기화되면 false로 설정하여 다시 작성 버튼이 나타날 수 있도록 함
                    $('#formContainer').replaceWith('<div id="formContainer"></div>');
                    // 기존 폼으로 돌아감
                    mre_selectAll(userNum='\${vo.userNum}');
                }
            },
            error: function(xhr, status, error) {
                console.log('xhr.status:', xhr.status);
            }
        });
	    $('#mre_content').val(''); // input 폼 초기화
	    $('#mre_rated').val(''); // input 폼 초기화
    }
}//end insertOK
	
function updateOK(memberreviewNum=0){
	console.log('updateOK()....',memberreviewNum);
	console.log($('#starRating').val());
	
	let rated = $('.star-rating .star.active').last().data('rating');
	
	$.ajax({
		url : "memberreview/json/updateOK.do",
		data:{
			memberreviewNum:memberreviewNum,
			content: $('#input_content').val(),
			rated: rated
		},
		method:'POST',
		dataType:'json',
		success : function(obj) {
			console.log('ajax...success:', obj);
			if(obj.result==1) mre_selectAll(userNum='\${vo.userNum}');
		},
		error:function(xhr,status,error){
			console.log('xhr.status:', xhr.status);
		}
	});
	
}//end updateOK
	
function deleteOK(memberreviewNum=0){
	console.log('deleteOK()....',memberreviewNum);
	
  if (confirm("글을 삭제하시겠습니까?")) {
	  $.ajax({
			url : "memberreview/json/deleteOK.do",
			data:{
				memberreviewNum:memberreviewNum
			},
			method:'GET',
			dataType:'json',
			success : function(obj) {
				console.log('ajax...success:', obj);
				if(obj.result==1) mre_selectAll(userNum='\${vo.userNum}');
			},
			error:function(xhr,status,error){
				console.log('xhr.status:', xhr.status);
			}
		});
	    return;
	  }
}//end deleteOK
	
function par_selectAll(page){
	$('#par_vos').show(); // 모임리스트 요소를 보이도록 설정
	$('#memberreview_list').hide();
// 	console.log('par_selectAll...');
	
	$.ajax({
		url: "party/json/selectAll.do",
		data:{
			writerNum : ${param.num},
			page: page, //${param.page}
		},
		method: 'GET',
		dataType: 'json',
		success: function(arr){
			console.log('ajax...',arr);
			let tag_vos = '';
			
			$.each(arr, function(index, vo){
				let deadLine = vo.deadLine.substring(0,16);
				let timeLimit = vo.timeLimit.substring(0,16);
				if (vo.writerNum === ${vo2.num}) { // user_id
					tag_vos +=`
						<div class="par-post">
							<div class="par-status">\${vo.applicants}/\${vo.max}</div>
							<div class="par-title">[\${vo.place}] \${vo.title}</div>
							<div class="par-container">
								<div class="par-list">
									<div>마감일</div>
									<div>약속일</div>
									<div>주최자</div>
								</div>
								<div class="par-data">
									<div>\${deadLine}</div>
									<div>\${timeLimit}</div>
									<div>\${vo.writerName}</div>
								</div>
							</div>
							<button class="par-bt" onclick="location.href='party/selectOne.do?partyNum=\${vo.partyNum}'">MORE VIEW</button>
						</div>
					`;
				}
				
			}); // end for-each
			
			$(".par-post").css("display", "block");
			$(".mre-post").css("display", "none");
			
			$(".mre_paging").css("display", "block");
			$(".par_paging").css("display", "none");
			
			$('#par_vos').html(tag_vos);
		}, // end success
		
		error:function(xhr,status,error){
			console.log('xhr.status:', xhr.status);
		} // end error
	}); // end ajax;
}
	
	
</script>
</head>
<body>

	<div class="userPage-body">
		<div class="userImpo">
			<img id="preview" width="80px" src="${pageContext.request.contextPath}/resources/ProfileImage/${vo2.num}.png"
						onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/ProfileImage/default.png';">
			<div class="userName">
				<a href="http://localhost:8088/hotplace/userpage.do?num=${vo2.num}">${vo2.nick_name}</a>
			</div>
			<button class="myPartyBt" onclick="location.href='party/myParty.do?userNum=${num}'">내 신청확인</button>
		</div>
		
		<div class="selectAll">
			<div class="par-selectAll" onclick="par_selectAll()">모임리스트 (<span id="par_count"></span>)</div>
			<div class="mre-selectAll" onclick="mre_selectAll()" id="reviewLink">후기목록 (<span id="mre_count"></span>)</div>
		</div>
		
		<div class="userPage-data">
			<div id="par_vos"></div>
			<div id="memberreview_list"></div>
			<div id="formContainer"></div>
		</div>
		
		
		<div class="par_paging" id="par_paging">
			<button class="par_back_page" id="par_back_page">이전</button>
			<button class="par_next_page" id="par_next_page">다음</button>
		</div>
	
		<div class="mre_paging" id="mre_paging">
			<button class="mre_back_page" id="mre_back_page">이전</button>
			<button class="mre_next_page" id="mre_next_page">다음</button>
			<button class="mre-insert" onclick="insert()">작성</button>
		</div>
	</div>
	
<script type="text/javascript">
$('.par-selectAll').on('click', function() {
	  $(this).css('color', '#F47420');
	  $(".mre-selectAll").css("color", "gray");
	});

$('.mre-selectAll').on('click', function() {
	  $(this).css('color', '#F47420');
	  $(".par-selectAll").css("color", "gray");
	});

</script>
	
</body>
</html>



