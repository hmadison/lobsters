SELECT
        id as streamable_id,
        'Story' as streamable_type,
        NULL as user_id,
        created_at as created_at
FROM
        stories
UNION SELECT
      comment_id as streamable_id,
      'Comment' as streamable_type,
      user_id as user_id,
      comment_created_at as created_at
FROM
        replying_comments
UNION SELECT
      id as streamable_id,
      'Message' as streamable_type,
      recipient_user_id as user_id,
      created_at as created_at
FROM
        messages
;
