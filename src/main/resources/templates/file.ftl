
<script src="static/js/jquery.1.9.1.min.js"></script>

<script src="static/js/vendor/jquery.ui.widget.js"></script>
<script src="static/js/jquery.iframe-transport.js"></script>
<script src="static/js/jquery.fileupload.js"></script>

<!-- we code these -->
<link href="static/css/dropzone.css" type="text/css" rel="stylesheet" />
<script src="static/js/myuploadfunction.js"></script>
<div style="width:500px;padding:20px">

    <input id="fileupload" type="file" name="files[]" data-url="upload" multiple/>

    <div id="dropzone" class="fade well">Drop files here</div>

    <div id="progress" class="progress">
        <div class="bar" style="width: 0%;">
            <span></span>
        </div>
    </div>

    <table id="uploaded-files" class="table">
        <tr>
            <th>File Name</th>
            <th>File Size</th>
            <th>File Type</th>
            <th>Download</th>
        </tr>
    </table>

</div>

