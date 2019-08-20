class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost  = current_user.microposts.build
    @feed_items = current_user.microposts.feed(current_user.id).order_by
                              .paginate page: params[:page],
                                        per_page: Settings.layout.per_page
  end

  def help; end

  def contact; end

  def about; end
end
