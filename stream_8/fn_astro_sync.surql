DEFINE FUNCTION OVERWRITE fn::update_content(
    $topics: array<object>,
    $posts: array<object>,
    $series: array<object>
    ) -> bool {
        -- Validate topics
        FOR $topic IN $topics {
            IF !$topic.id.is_uuid() {
                THROW "Invalid topic ID: " + <string>$topic.id;
            };
        };

        -- Validate posts
        FOR $post IN $posts {
            IF !$post.id.is_uuid() {
                THROW "Invalid post ID: " + <string>$post.id;
            };
        };

        -- Validate series
        FOR $s IN $series {
            IF !$s.id.is_uuid() {
                THROW "Invalid series ID: " + <string>$s.id;
            };
        };

        -- TODO: Update stuff
        LET $update_id = rand::uuid();

        -- UPDATE topics - mark them as not deleted to un-delete previously deleted topics that
        -- match the ID
        FOR $topic IN $topics {
            LET $topic_id = type::thing("topic", $topic.id);
            UPSERT $topic_id CONTENT {
                name: $topic.name,
                description: $topic.description,
                slug: $topic.slug,
                deleted_at: NONE,
                last_update_id: $update_id
            };
        };

        -- Detect deleted topics
        LET $topics_to_delete = (SELECT VALUE id FROM topic WHERE last_update_id != $update_id AND !deleted_at);
        UPDATE $topics_to_delete SET deleted_at = time::now();

        -- UPDATE posts - mark them as not deleted to un-delete previously deleted posts that
        -- match the ID
        FOR $post IN $posts {
            LET $post_id = type::thing("post", $post.id);
            UPSERT $post_id SET
                title = $post.title,
                description = $post.description,
                slug = $post.slug,
                featured = $post.featured,
                obsolete = $post.obsolete,
                draft = $post.draft,
                learnable = $post.learnable,
                og_image = $post.og_image,
                published_on = $post.published_on,
                published_at = $post.published_at,
                updates = $post.updates,
                deleted_at = NONE,
                last_update_id = $update_id
            ;
        };

        -- Detect deleted posts
        LET $posts_to_delete = (SELECT VALUE id FROM post WHERE last_update_id != $update_id AND !deleted_at);
        UPDATE $posts_to_delete SET deleted_at = time::now();

        -- UPDATE series - mark them as not deleted to un-delete previously deleted series that
        -- match the ID
        FOR $s IN $series {
            LET $series_id = type::thing("series", $s.id);
            UPSERT $series_id CONTENT {
                name: $s.name,
                description: $s.description,
                slug: $s.slug,
                deleted_at: NONE,
                last_update_id: $update_id
            };
        };

        -- Detect deleted series
        LET $series_to_delete = (SELECT VALUE id FROM series WHERE last_update_id != $update_id AND !deleted_at);
        UPDATE $series_to_delete SET deleted_at = time::now();

        return true;
    }
;