class Tumblr
  KEY = "qRXke3SZUjmrSvgwPIROVeMgkXzEM2rdu6MUr0fxxXBFyw7RVN"
  SECRET = "NtwPb7Usx382bEUn8oiMH5FIKQykoclizCnhEeMTYrDYyhJvzZ"

  def drafts(blog_name)
    draft_url = "http://api.tumblr.com/v2/blog/#{blog_name}.tumblr.com/posts/draft"
    response = request.get(draft_url)
    JSON.parse(response.body)["response"]["posts"]
  end

  def draft_post(id, blog_name)
    drafts(blog_name).keep_if{|post| post["id"] == id.to_i }.first
  end

  def post_new(blog_name)
    new_post_url = "http://api.tumblr.com/v2/blog/#{blog_name}.tumblr.com/post"
    response = request.post(new_post_url, {state: "draft", type: "text", body: "EditorX #{Time.now.to_i}"})
    JSON.parse(response.body)["response"]
  end

  def request=(access_token)
    @request ||= access_token
  end

  def request
    @request
  end
end


class EditorX < Sinatra::Base
  def initialize(arguments)
    super(arguments)
    @tumblr = Tumblr.new
  end

  configure do
    enable :sessions
  end

  helpers do
    def current_user
      session[:auth]
    end

    def blog_name
      session[:auth][:info].blogs[0].name
    end
  end

  use OmniAuth::Builder do
    provider :tumblr, ENV['TUMBLR_KEY'] || Tumblr::KEY , ENV['TUMBLR_SECRET'] || Tumblr::SECRET
  end

  get "/" do
    @current_user = current_user
    erb :index
  end

  get "/auth/tumblr/callback" do
    auth_data = request.env['omniauth.auth']
    session[:access_token] = auth_data["extra"].first[1]
    session[:auth] = {info: auth_data.info, credentials: auth_data.credentials}
    redirect "/"
  end

  get "/posts/draft" do
    content_type :json
    @tumblr.request=session[:access_token]
    @tumblr.drafts(blog_name).to_json
  end

  get "/posts/draft/:id" do
    content_type :json
    @tumblr.request=session[:access_token]
    @tumblr.draft_post(params[:id], blog_name).to_json
  end

  get "/posts/new" do
    content_type :json
    @tumblr.request=session[:access_token]
    @tumblr.post_new(blog_name).to_json
  end
end
