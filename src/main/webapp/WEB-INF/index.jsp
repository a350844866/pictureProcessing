<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>图像风格转换</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
  <link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.indigo-pink.min.css">
  <link rel="stylesheet" href="http://creativeit.github.io/getmdl-select/getmdl-select.min.css">
  <style>
    .body-container {
      position: relative;
      top: 110px;
      width: 80%;
      margin: 0 auto;
    }

    .body-container .mdl-card {
      width: 80%;
      min-height: 500px;
      margin: 0 auto;
    }

    div[data-name="isLoading"] {
      z-index: 999;
      position: absolute;
      top: calc(50% - 14px);
      left: calc(50% - 14px);
    }

    .body-container .upload-btn {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
    }

    #upload-btn {
      display: none;
    }

    .uploaded-img {
      min-width: 80%;
      min-height: 450px;
      margin: 25px 0;
      padding: 0 3%;
    }

    .operate-btns {
      min-height: 64px;
      margin-top: 30px;
      text-align: center;
    }

    .hover {
      position: absolute;
      width: 100%;
      height: 100vh;
      background-color: rgba(255, 255, 255, .5);
    }
  </style>
</head>

<body>
  <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header">
    <header class="mdl-layout__header">
      <div class="mdl-layout__header-row">
        <span class="mdl-layout-title">图像风格转换Demo</span>
        <div class="mdl-layout-spacer"></div>
      </div>
    </header>
  </div>
  <div class="body-container">
    <form action="${pageContext.request.contextPath}/uploadPicture" target="frameFile" id="upload-data" method="post" enctype="multipart/form-data">
      <div class="mdl-card mdl-shadow--2dp">
        <div data-name="isLoading" class="mdl-spinner mdl-js-spinner is-active" style="display: none;"></div>
        <img src="" alt="" class="uploaded-img" id="preview-img">
        <input type="file" name="upload-img" id="upload-btn" />
        <button data-name="fake-upload" class="upload-btn mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect">
          点击按钮选择要上传的图片
        </button>
        <div data-name="hover" class="hover" style="display: none;"></div>
      </div>
      <div class="operate-btns">
        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select getmdl-select__fix-height">
          <input type="text" value="" class="mdl-textfield__input" id="styles" readonly>
          <input type="hidden" value="" name="styleName">
          <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
          <label for="styles" class="mdl-textfield__label">选择一种风格</label>
          <ul for="styles" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
            <li class="mdl-menu__item" data-val="BY">Belarus</li>
            <li class="mdl-menu__item" data-val="BR">Brazil</li>
            <li class="mdl-menu__item" data-val="ES">Estonia</li>
            <li class="mdl-menu__item" data-val="FI">Finland</li>
          </ul>
        </div>
        </br>
        <button data-name="change-btn" class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored">
          开始转换
        </button>
        <button data-name="reselect-btn" style="margin-left: 10px;" class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent">
          重新选择图片
        </button>
      </div>
    </form>
    <div aria-live="assertive" aria-atomic="true" aria-relevant="text" class="mdl-snackbar mdl-js-snackbar">
      <div class="mdl-snackbar__text"></div>
      <button type="button" class="mdl-snackbar__action"></button>
    </div>
    <iframe name='frameFile' style='display: none;'></iframe>
  </div>
  <script defer src="https://code.getmdl.io/1.3.0/material.min.js"></script>
  <script defer src="http://creativeit.github.io/getmdl-select/getmdl-select.min.js"></script>
  <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
  <script>
    var presets = {
      upload: $('#upload-btn'),
      previewArea: $('#preview-img'),
      loading: $('div[data-name="isLoading"]'),
      hover: $('div[data-name="hover"]'),
      fake: $('button[data-name="fake-upload"]'),
      notification: $('.mdl-js-snackbar')
    }

    $('button[data-name="fake-upload"]').on('click', function (e) {
      e.preventDefault();
      presets.upload.click();
    });

    presets.upload.on('change', function () {
      var imgs = this.files;
      var img = imgs[0];

      if (!/\/(?:jpeg|jpg|png)/i.test(img.type)) {
        presets.notification[0].MaterialSnackbar.showSnackbar(
          {
            message: '请选择正确的图片格式'
          }
        );
        return;
      } else if (img.size > 2048*1000) {
        presets.notification[0].MaterialSnackbar.showSnackbar(
          {
            message: '图片大小不能超过2M'
          }
        );
        return;
      };

      var reader = new FileReader();

      presets.fake.hide();
      presets.loading.show();
      presets.hover.show();

      reader.onload = function () {
        var result = this.result;

        var image = new Image();
        image.src = result;
        image.onload = function () {
          var width = image.width;
          var height = image.height;
          var trueHeight = presets.previewArea[0].clientWidth * (height / width);
          presets.previewArea.eq(0).attr('height', trueHeight);
          presets.hover.eq(0).css('height', trueHeight + 50);
        };
        presets.previewArea.prop('src', result);
        presets.loading.hide();
        presets.hover.hide();
      };

      reader.readAsDataURL(img);
    });

    $('button[data-name="change-btn"]').on('click', function (e) {
      e.preventDefault();

      if (!presets.upload.val()) {
        presets.notification[0].MaterialSnackbar.showSnackbar(
          {
            message: '请先选择一张图片'
          }
        );
        return;
      }
      presets.loading.show();
      presets.hover.show();
      $('#upload-data').submit();
    });

    $('button[data-name="reselect-btn"]').on('click', function (e) {
      e.preventDefault();
      presets.previewArea.prop('src', '');
      presets.previewArea.removeAttr('height');
      presets.fake.show();
      presets.loading.hide();
      presets.hover.hide();
    });

  </script>
</body>

</html>