class Tumblr

  start: ->
    if $("#posts").length > 0
      @render_posts()

  key: ->
    $("meta[api-key]").attr("value")


  render_posts: ->
    blog_name = $("#posts").data("blog-name")
    $.get "/posts/draft", (posts)->
      for post in posts
        title = if post.title? then  post.title else post.slug
        option_post = $("<option></option>").attr("value", post.id).html(title)
        $("select#posts").append(option_post)

  load_post: (e)=>
    if e.preventDefault
      target = $(e.currentTarget)
      id = target.find(":selected").val()
     else
      id = e

    $.get "/posts/draft/#{id}", (post)=>
      @editor.importFile post.slug, post.body

  new_post: (e)=>
    e.preventDefault
    $.get "/posts/new", (post)=>
      @load_post(post.id)





window.Tumblr = new Tumblr
