LET $authors: array = (<array>1..=5).map(|$i| "testuser" + <string>$i).map(|$name| {username: $name, id: type::thing("user", $name)});

FOR $author IN $authors {
    CREATE $author.id SET
        username = $author.username,
        email = $author.username + "@xkonti.tech"
    ;
}

LET $posts: array = (<array>1..=2000).map(|$i| "post" + <string>$i).map(|$name| {title: $name, id: type::thing("post", $name)});

FOR $post IN $posts {
    CREATE $post.id SET
        title = $post.title,
        description = "...",
        slug = $post.title.slug(),
        obsolete = false,
        draft = rand::bool(),
        learnable = rand::bool(),
        og_image = "wololo.png",
        published_at = time::now()
    ;
    RELATE rand::enum($authors).id->authored->$post.id;
}

CREATE comment SET
    content = "Give up already!",
    author = $auth,
    post = post:post2
;

RELATE user:user_2kg38yfLgcs5xwqbzLfcmRzAHp8->approved->comment:xngvv5un5ofefxmrtuq3;

# Calculate likes_count and comments_count for each post
UPDATE post SET
    likes_count = (SELECT count() AS count FROM liked WHERE out.id == $parent.id GROUP ALL)[0].count OR 0,
    comments_count = (SELECT count() AS count FROM comment WHERE post.id == $parent.id AND approved == true GROUP ALL)[0].count OR 0
;