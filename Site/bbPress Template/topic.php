<?php bb_get_header(); ?>

<div id="content">
    <!--Header title-->
    <div class="topcontent span-18">
        <div class="span-18 last stripetext"><a href="<?php bb_uri(); ?>">
            <?php bb_option('name'); ?>
            </a>
            <?php bb_forum_bread_crumb(); ?>
            &raquo; Viewing Topic </div>
    </div>
    <div class="clear span-18">
        <?php login_form(); ?>
        <?php if ( is_bb_profile() ) profile_menu(); ?>
    </div>
    <div class="span-18">
        <div id="topic" class="span-12"> <span id="topic_labels">
            <?php bb_topic_labels(); ?>
            </span>
            <h1>
                <?php topic_title(); ?>
            </h1>
            <p>
                <?php do_action('under_title'); ?>
            <div class="infobox" role="main">
                <div id="topic-info">
                    <ul class="topicmeta">
                        <li> <span class="ss_sprite ss_information">&nbsp;</span> <span id="topic_posts">
                            <?php topic_posts_link(); ?>
                            </span> <span id="topic_voices"><?php printf( _n( '%s voice', '%s voices', bb_get_topic_voices() ), bb_get_topic_voices() ); ?></span> </li>
                        <li> <span class="ss_sprite ss_date">&nbsp;</span> <?php printf(__('Started %1$s ago by %2$s'), get_topic_start_time(), get_topic_author()) ?></li>
                        <?php if ( 1 < get_topic_posts() ) : ?>
                        <li> <span class="ss_sprite ss_user">&nbsp;</span> <?php printf(__('<a href="%1$s">Latest reply</a> from %2$s'), esc_attr( get_topic_last_post_link() ), get_topic_last_poster()) ?></li>
                        <?php endif; ?>
                        <?php if ( bb_is_user_logged_in() ) : ?>
                        <li <?php echo $class;?> id="favorite-toggle"> <span class="ss_sprite ss_heart">&nbsp;</span>
                            <?php user_favorites_link(); ?>
                        </li>
                        <?php endif; do_action('topicmeta'); ?>
                    </ul>
                </div>
                <?php topic_tags(); ?>
                <div style="clear:both;"></div>
            </div>
            <?php if ($posts) : ?>
            <?php topic_pages( array( 'before' => '<div class="nav">', 'after' => '</div>' ) ); ?>
            <div id="ajax-response"></div>
            <ol id="thread" class="list:post">
                <?php foreach ($posts as $bb_post) : $del_class = post_del_class(); ?>
                <li id="post-<?php post_id(); ?>"<?php alt_class('post', $del_class); ?>>
                    <?php bb_post_template(); ?>
                </li>
                <?php endforeach; ?>
            </ol>
            <div class="clearit"><br style=" clear: both;" />
            </div>
            <?php topic_pages( array( 'before' => '<div class="nav">', 'after' => '</div>' ) ); ?>
            <?php endif; ?>
            
            <div id="postform">
        <?php if ( topic_is_open( $bb_post->topic_id ) ) : ?>
        <?php post_form(); ?>
        <?php else : ?>
        <h2>
            <?php _e('Topic Closed') ?>
        </h2>
        <p>
            <?php _e('This topic has been closed to new replies.') ?>
            </br>
        </p>
        <?php endif; ?>
    </div>
    
    <div>
    <?php if ( bb_current_user_can( 'delete_topic', get_topic_id() ) || bb_current_user_can( 'close_topic', get_topic_id() ) || bb_current_user_can( 'stick_topic', get_topic_id() ) || bb_current_user_can( 'move_topic', get_topic_id() ) ) : ?>
    <div class="admin">
        <?php bb_topic_admin( array( 'before' => '[', 'after' => ']' ) ); ?>
    </div>
    <?php endif; ?>
    </div>
            </p>
        </div>
        <!-- [/ .span 13 ] -->
        <div class="span-6 last" id="rcolbody">
            <?php if ( bb_forums() ) : ?>
            <div id="forums" class="backg-grey rcolborder rcolspacing">
                <h1>Forums</h1>
                <p>
                <table id="miniforumlist">
                    <tr>
                        <th class="col_theme"><?php _e('Forum'); ?></th>
                        <th class="col_posts"><?php _e('Posts'); ?></th>
                    </tr>
                    <?php while ( bb_forum() ) : ?>
                    <?php if (bb_get_forum_is_category()) : ?>
                    <tr<?php bb_forum_class('bb-category'); ?>>
                        <td colspan="3"><?php bb_forum_pad( '<div class="nest">' ); ?>
                            <a href="<?php forum_link(); ?>">
                            <?php forum_name(); ?>
                            </a>
                            <?php forum_description( array( 'before' => '<small> &#8211; ', 'after' => '</small>' ) ); ?>
                            <?php bb_forum_pad( '</div>' ); ?></td>
                    </tr>
                    <?php continue; endif; ?>
                    <tr<?php bb_forum_class(); ?>>
                        <td><?php bb_forum_pad( '<div class="nest">' ); ?>
                            <div class="forumTitle" > <span class="ss_sprite ss_folder">&nbsp;</span> <a href="<?php forum_link(); ?>">
                                <?php forum_name(); ?>
                                </a> </div>
                            <?php bb_forum_pad( '</div>' ); ?></td>
                        <td class="num"><?php forum_posts(); ?></td>
                    </tr>
                    <?php endwhile; ?>
                </table>
            </div>
            <!-- [/ #forums ) -->
            <?php endif; // bb_forums() ?>
            <div id="topic" class="backg-grey rcolborder rcolspacing">
                <h1>Subscribe</h1>
                <p>
                <ul class="topicmeta">
                    <li><a href="<?php topic_rss_link(); ?>" class="rss-link">
                        <?php _e('<abbr title="Really Simple Syndication">RSS</abbr> feed for this topic') ?>
                        </a></li>
                </ul>
                <span class="rss-link"></span>
                </p>
            </div>
            <!-- [/ #forums ) -->
        </div>
        <!-- [/ .span 5] -->
    </div>
    <!-- [/ .span 18 ] -->
    
    
</div>
</div>
<!-- [/ #content ] -->
<?php bb_get_footer(); ?>
