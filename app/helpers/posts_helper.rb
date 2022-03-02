module PostsHelper
  def post_image_present_style(post)
    post.image.present? ? "background-image:url(#{post.image});" : ""
  end
end
