SELECT
        stories.id AS streamable_id,
        'Story' AS streamable_type,
        stories.user_id AS user_id,
        tags.id AS tag_id,
        stories.created_at AS created_at
FROM
        stories
LEFT JOIN
        taggings ON taggings.story_id = stories.id
LEFT JOIN
        tags ON taggings.tag_id = tags.id
UNION SELECT
        comments.id AS streamable_id,
        'Comment' AS streamable_type,
        comments.user_id AS user_id,
        NULL AS tag_id,
        comments.created_at AS created_at
FROM
        comments
;
