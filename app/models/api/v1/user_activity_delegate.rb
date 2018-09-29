class Api::V1::UserActivityDelegate < ActivityDelegate
  handle(:create, with: :document) do |user, document|
    story = Story.new(user: user, title: document[:name], url: document[:url])
    story.tags = document[:tag].map { |t| Tag.find_by(tag: t[:id]) }.compact

    story
  end

  handle(:create, with: :note) do |user, note|
    comment = Comment.new(user: user, comment: note[:content])
    parent = object_for(note[:inReplyTo])

    if parent.is_a? Story
      comment.story_id = parent.id
    else
      comment.story_id = parent.story_id
      comment.parent_comment_id = parent.id
    end

    comment
  end

  handle(:update, with: :document) do |user, document|
    story = object_for(document[:id])
    return false unless story.is_editable_by_user?(user)

    story.tags = document[:tag].map { |t| Tag.find_by(tag: t[:id]) }.compact if document[:tags]
    story.title = document[:name] if document[:name]

    story
  end

  handle(:update, with: :note) do |user, note|
    comment = object_for(note[:id])
    return false unless comment.is_editable_by_user?(user)

    comment.comment = note[:content] if note[:content]
    comment
  end

  handle(:delete) do |user, object_id|
    object = object_for(object_id)
    return false unless object.is_editable_by_user?(user)

    case object
    when Story
      object.is_expired = true
    when Comment
      object.delete_for_user(user)
    end

    object
  end

  handle(:like) do |user, object_id|
    object = object_for(object_id)

    case object
    when Story
      Vote.vote_thusly_on_story_or_comment_for_user_because(1, object.id, nil, user.id, nil, true)
    when Comment
      Vote.vote_thusly_on_story_or_comment_for_user_because(1, object.story.id, object.id, user.id, nil, true)
    end

    true
  end

  handle(:undo) do |user, object_id|
    object = object_for(object_id)

    case object
    when Story
      Vote.vote_thusly_on_story_or_comment_for_user_because(0, object.id, nil, user.id, nil, true)
    when Comment
      Vote.vote_thusly_on_story_or_comment_for_user_because(0, object.story.id, object.id, user.id, nil, true)
    end

    true
  end
end
