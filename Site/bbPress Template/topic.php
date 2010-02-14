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
    <div class="span-18">
        <div id="topic" class="span-13">
            <h1>
                <?php topic_title(); ?>
            </h1>
            <p>
            
            <!--Infobox-->
            <div class="infobox" role="main">
                <div id="topic-info"> <span id="topic_labels">
                    <?php bb_topic_labels(); ?>
                    </span>
                    <span id="topic_posts">(
                    <?php topic_posts_link(); ?>
                    )</span> <span id="topic_voices">(<?php printf( _n( '%s voice', '%s voices', bb_get_topic_voices() ), bb_get_topic_voices() ); ?>)</span>
                    <ul class="topicmeta">
                        <li><?php printf(__('Started %1$s ago by %2$s'), get_topic_start_time(), get_topic_author()) ?></li>
                        <?php if ( 1 < get_topic_posts() ) : ?>
                        <li><?php printf(__('<a href="%1$s">Latest reply</a> from %2$s'), esc_attr( get_topic_last_post_link() ), get_topic_last_poster()) ?></li>
                        <?php endif; ?>
                        <?php if ( bb_is_user_logged_in() ) : ?>
                        <li<?php echo $class;?> id="favorite-toggle">
                            <?php user_favorites_link(); ?>
                        </li>
                        <?php endif; do_action('topicmeta'); ?>
                    </ul>
                </div>
                <?php topic_tags(); ?>
                <div style="clear:both;"></div>
            </div>
            <!--/Infobox-->
            
            </p>
        </div>
        <!-- [/ .span 13 ] -->
        <div class="span-5 last" id="rcolbody">
            <?php if ( bb_forums() ) : ?>
            <div id="forums" class="backg-grey rcolborder rcolspacing">
                <h1>Options</h1>
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
                            <div class="forumTitle" >
                                <div class="forumIcon"><img src="<?php bb_active_theme_uri(); ?>images/forum/forum.png" width="16" height="16" /> </div>
                                <a href="<?php forum_link(); ?>">
                                <?php forum_name(); ?>
                                </a> </div>
                            <div class="forumDescription" >
                                <?php forum_description( array( 'before' => '', 'after' => '' ) ); ?>
                            </div>
                            <?php bb_forum_pad( '</div>' ); ?></td>
                        <td class="num"><?php forum_posts(); ?></td>
                    </tr>
                    <?php endwhile; ?>
                </table>
            </div>
            <!-- [/ #forums ) -->
            <?php endif; // bb_forums() ?>
            <div id="rssfeed" class="backg-grey rcolborder rcolspacing">
                <h1>Subscribe</h1>
                <p class="rss-link"><a href="<?php bb_forum_posts_rss_link(); ?>" class="rss-link">
                    <?php _e('<abbr title="Really Simple Syndication">RSS</abbr> feed for this forum'); ?>
                    </a></p>
            </div>
        </div>
        <!-- [/ .span 5] -->
    </div>
    <!-- [/ .span 18 ] -->
</div>
</div>
<!-- [/ #content ] -->
<?php bb_get_footer(); ?>
