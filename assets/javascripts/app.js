//= require vendor/jquery
//= require_tree ./vendor
//= require tumblr

var fixEditorSize = function(e){
  var target = $(e.currentTarget)
  target.css("height", (document.height-70)+"px")
  var size = (parseInt(target.css("height").replace("px", ""))+2)+"px"

  wrapperIframe = $(editor.getElement('wrapperIframe'))
  wrapperIframe.css("height", size)

  editorIframe = $(editor.getElement('editorIframe'))
  editorIframe.css("height", size)
};

$(document).ready(function(){
  var opts = {
    focusOnLoad: true,
    container: "editorx",
    theme: {
      editor: "/../assets/editorx-theme.css"
    }
  }

  var editor = new EpicEditor(opts).load(),
      editor_body = $(editor.getElement('editor').body);

  Tumblr.editor = editor
  Tumblr.start()

  editor_body.focus(function(e){
    body = $(e.currentTarget)
    $("header").addClass("off")
    body.removeClass("off")
  });

  editor_body.blur(function(e){
    body = $(e.currentTarget)
    $("header").removeClass("off")
    body.addClass("off")
  });

  editor_body.bind("keyup change cut paste focus", fixEditorSize);

  window.editor = editor
  $("#editorx").css("height", document.height);
  $("select#posts").change(Tumblr.load_post);
  $("#new_post").click(Tumblr.new_post);
});
