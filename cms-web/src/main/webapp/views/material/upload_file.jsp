<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/tag.jsp"%>
<!DOCTYPE html >
<html>
<head>
<%@ include file="/common/meta.jsp" %>
<title>资源</title>
<meta name="keywords" content="">
<meta name="description" content="">
<%@ include file="/common/style.jsp" %>
<link href="${ctx}/resources/assets/lib/icheck/icheck.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/resources/assets/lib/webuploader/0.1.5/webuploader.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/resources/assets/lib/zTree/v3/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/resources/assets/lib/treeselect/jquery.treeselect.css" rel="stylesheet" type="text/css">
<style type="text/css">
.mfs-container {
	/* min-width: 150px;max-height: 100px;  */
	/* position: relative; */
	
}

.mfs-selected-option {
	border: 1px #ccc solid;
	display: inline-block;
	width: 100%;
	font-size: 14px;
	height: 31px;
	line-height: 2.42857;
	padding-left: 4px;
}

.mfs-options {
position: absolute;
	border: 1px #ccc solid;
	/* border-top:0px; */
	width: 100%;
	margin: 0;
	padding: 0px;
	color: #333;
	overflow: auto;
	min-height: 100px;
	max-height: 300px;
	background: #ffffff;
	z-index: 9;
	 margin-top: -6px; 
}
</style>
</head>
<body>
<div class="pd-20">
	
	<form action="${ctx}//${model.userId==null?'save':'update'}" method="post" class="form form-horizontal" id="form_add">
		
		
		
		<div class="row cl">
			<label class="form-label col-3">上传文件：</label>
			<div class="formControls col-5">
				<div class="uploader-thum-container">
					<div id="filePicker">选择文件</div>
					<button id="btn-star" type="button" class="btn btn-default btn-uploadstar radius ml-10">开始上传</button>
					<div id="fileList" class="uploader-list">
						<c:if test="${model.userId != null}">
						<div id="WU_FILE_0" class="item upload-state-success">
						<div class="pic-box">
						<img width="30" src="${model.headPortrait}">
						</div>
						
						<input type="hidden" name="headPortrait" value="${model.headPortrait}"></div>
						</c:if>
					</div>
				</div>
			</div>
		</div>
		
		
		<!-- <div class="row cl">
			<div class="col-9 col-offset-3">
				<input class="btn btn-primary radius" type="submit" value="&nbsp;&nbsp;提交&nbsp;&nbsp;">
			</div>
		</div> -->
		  
	</form>
	
	<div id="resourceContent" class="resourceContent">
		<ul id="resourceTree" class="ztree selectZtree" style="margin-top: 0; width: 160px;"></ul>  
	</div>
</div>
<%@ include file="/common/script.jsp" %>
<script type="text/javascript" src="${ctx}/resources/assets/lib/icheck/jquery.icheck.min.js"></script> 
<script type="text/javascript" src="${ctx}/resources/assets/lib/Validform/5.3.2/Validform.js"></script>
<script type="text/javascript" src="${ctx}/resources/assets/lib/webuploader/0.1.5/webuploader.js"></script> 
<script type="text/javascript">
	var uploader;
	
	$(function(){
		$list = $("#fileList"),
		$btn = $("#btn-star"),
		state = "pending";
		//uploader;
		

		uploader = WebUploader.create({
			auto: false,
			swf: 'lib/webuploader/0.1.5/Uploader.swf',
		
			// 文件接收服务端。
			server: global.basePath+'/upload/file?dir=material',
		
			// 选择文件的按钮。可选。
			// 内部根据当前运行是创建，可能是input元素，也可能是flash.
			pick: '#filePicker',
		
			// 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
			resize: false,
			// 只允许选择图片文件。
			accept: {
				title: 'Images',
				extensions: 'txt,rar,zip,doc,docx,xls,xlsx,jpg,jpeg,gif,png,swf,wmv,avi,wma,mp3,mid',
				mimeTypes: '.txt,.rar,.zip,.doc,.docx,.xls,.xlsx,.jpg,.jpeg,.gif,.png,.swf,.wmv,.avi,.wma,.mp3,.mid'
			}
		});
		uploader.on( 'fileQueued', function( file ) {
			debugger
			var $li = $(
				'<div id="' + file.id + '" class="item">' +
					'<span onclick="removefile(\''+file.id+'\')" class="btn-remove-file Hui-iconfont Hui-iconfont-close"></span><div class="pic-box"><img width="30"></div>'+
					'<div class="info">' + file.name + '</div>' +
					'<p class="state">等待上传...</p>'+
				'</div>'
			),
			//debugger
			$img = $li.find('img');
			//$list.html('');
			$list.find(file.id).remove();
			$list.append( $li );
		
			// 创建缩略图
			// 如果为非图片文件，可以不用调用此方法。
			// thumbnailWidth x thumbnailHeight 为 100 x 100
			thumbnailWidth=100;
			thumbnailHeight=100;
			uploader.makeThumb( file, function( error, src ) {
				if ( error ) {
					$img.replaceWith('<span>不能预览</span>');
					return;
				}
		
				$img.attr( 'src', src );
			}, thumbnailWidth, thumbnailHeight );
		});
		// 文件上传过程中创建进度条实时显示。
		uploader.on( 'uploadProgress', function( file, percentage ) {
			var $li = $( '#'+file.id ),
				$percent = $li.find('.progress-box .sr-only');
		
			// 避免重复创建
			if ( !$percent.length ) {
				$percent = $('<div class="progress-box"><span class="progress-bar radius"><span class="sr-only" style="width:0%"></span></span></div>').appendTo( $li ).find('.sr-only');
			}
			$li.find(".state").text("上传中");
			$percent.css( 'width', percentage * 100 + '%' );
		});
		
		// 文件上传成功，给item添加成功class, 用样式标记上传成功。
		uploader.on( 'uploadSuccess', function( file,response) {
			if(response.success){
				var data=response.data;
				//var $img=$( '#'+file.id ).find('img');
				$( '#'+file.id ).addClass('upload-state-success').find(".state").text("已上传");
				//$( '#'+file.id ).append('<input type="hidden" name="headPortrait" value="'+data.webUrl+'">');
				//$img.attr( 'src', data.webUrl );
			}else{
				$( '#'+file.id ).addClass('upload-state-error').find(".state").text(response.message);
			}
			
		});
		
		// 文件上传失败，显示上传出错。
		uploader.on( 'uploadError', function( file ) {
			
			$( '#'+file.id ).addClass('upload-state-error').find(".state").text("上传出错");
		});
		
		// 完成上传完了，成功或者失败，先删除进度条。
		uploader.on( 'uploadComplete', function( file ) {
			$( '#'+file.id ).find('.progress-box').fadeOut();
		});
		uploader.on('all', function (type) {
	        if (type === 'startUpload') {
	            state = 'uploading';
	        } else if (type === 'stopUpload') {
	            state = 'paused';
	        } else if (type === 'uploadFinished') {
	            state = 'done';
	        }

	        if (state === 'uploading') {
	            $btn.text('暂停上传');
	        } else {
	            $btn.text('开始上传');
	        }
	    });

	    $btn.on('click', function () {
	    	debugger
	        if (state === 'uploading') {
	            uploader.stop();
	        } else {
	            uploader.upload();
	        }
	    });
	});
	
	function removefile(id){
		debugger
		uploader.removeFile( id );
		$('#'+id).remove();
	}

</script>
</body>
</html>