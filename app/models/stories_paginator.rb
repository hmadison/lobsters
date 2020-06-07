class StoriesPaginator
  attr_accessor :per_page

  STORIES_PER_PAGE = 25

  def initialize(scope, after = nil, user = nil)
    @scope = scope
    @after = after
    @user = user
    @per_page = STORIES_PER_PAGE
  end

  def get
    after_id = if @after
                 Story.find_by(short_id: @after)
               else
                 Story.first
               end

    with_pagination_info @scope
      .limit(STORIES_PER_PAGE)
      .where('id > ?', after_id)
      .order(id: :desc)
      .includes(:user, :suggested_titles, :suggested_taggings, :taggings => :tag)
  end

private

  def with_pagination_info(scope)
    scope = scope.to_a
    show_more = scope.count > per_page
    scope.pop if show_more

    [cache_votes(scope), show_more]
  end

  def cache_votes(scope)
    if @user
      votes = Vote.votes_by_user_for_stories_hash(@user.id, scope.map(&:id))

      hs = HiddenStory.where(:user_id => @user.id, :story_id =>
        scope.map(&:id)).map(&:story_id)
      ss = SavedStory.where(:user_id => @user.id, :story_id =>
        scope.map(&:id)).map(&:story_id)

      scope.each do |s|
        if votes[s.id]
          s.vote = votes[s.id]
        end
        if hs.include?(s.id)
          s.is_hidden_by_cur_user = true
        end
        if ss.include?(s.id)
          s.is_saved_by_cur_user = true
        end
      end
    end
    scope
  end
end
