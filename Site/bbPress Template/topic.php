<?php bb_get_header(); ?>
<div id="content" class="container"><!-- [ #content ] -->
    <div class="topcontent span-18">
        <h1 class="span-18 last">Welcome on our forums :-)</h1>
        <div class="span-13">login <!-- <?php if ( !in_array( bb_get_location(), array( 'login-page', 'register-page' ) ) ) login_form(); ?><?php if ( bb_is_profile() ) profile_menu(); ?> --></div>
         <div class="span-5 last" id="rcolhead"><h1>Forums</h1></div>
    </div>

<div class="span-18">
	<div class="span-13">
        <div class="bbcrumb"><a href="<?php bb_uri(); ?>"><?php bb_option('name'); ?></a><?php bb_forum_bread_crumb(); ?></div>
        <div class="infobox" role="main">
        
        <div id="topic-info">
        <span id="topic_labels"><?php bb_topic_labels(); ?></span>
        <h2<?php topic_class( 'topictitle' ); ?>><?php topic_title(); ?></h2>
        <span id="topic_posts">(<?php topic_posts_link(); ?>)</span>
        <span id="topic_voices">(<?php printf( _n( '%s voice', '%s voices', bb_get_topic_voices() ), bb_get_topic_voices() ); ?>)</span>
        
        <ul class="topicmeta">
            <li><?php printf(__('Started %1$s ago by %2$s'), get_topic_start_time(), get_topic_author()) ?></li>
        <?php if ( 1 < get_topic_posts() ) : ?>
            <li><?php printf(__('<a href="%1$s">Latest reply</a> from %2$s'), esc_attr( get_topic_last_post_link() ), get_topic_last_poster()) ?></li>
        <?php endif; ?>
        <?php if ( bb_is_user_logged_in() ) : ?>
            <li<?php echo $class;?> id="favorite-toggle"><?php user_favorites_link(); ?></li>
        <?php endif; do_action('topicmeta'); ?>
        </ul>
        </div>
        
        <?php topic_tags(); ?>
        
        <div style="clear:both;"></div>
        </div>
        <?php do_action('under_title'); ?>
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
        <div class="clearit"><br style=" clear: both;" /></div>
        <p class="rss-link"><a href="<?php topic_rss_link(); ?>" class="rss-link"><?php _e('<abbr title="Really Simple Syndication">RSS</abbr> feed for this topic') ?></a></p>
        <?php topic_pages( array( 'before' => '<div class="nav">', 'after' => '</div>' ) ); ?>
        <?php endif; ?>
        <?php if ( topic_is_open( $bb_post->topic_id ) ) : ?>
        <?php post_form(); ?>
        <?php else : ?>
        <h2><?php _e('Topic Closed') ?></h2>
        <p><?php _e('This topic has been closed to new replies.') ?></p>
        <?php endif; ?>
        <?php if ( bb_current_user_can( 'delete_topic', get_topic_id() ) || bb_current_user_can( 'close_topic', get_topic_id() ) || bb_current_user_can( 'stick_topic', get_topic_id() ) || bb_current_user_can( 'move_topic', get_topic_id() ) ) : ?>
        
        <div class="admin">
        <?php bb_topic_admin(); ?>
        </div>
        
        <?php endif; ?>
        
</div><!-- [/ .span 13 ] -->

	<div class="span-5 last" id="rcolbody">
    	<?php if ( bb_forums() ) : ?>
        <div id="forums" class="backg-grey">
            <p>
                <table id="mini_forumlist">
                
                <?php while ( bb_forum() ) : ?>
                <?php if (bb_get_forum_is_category()) : ?>
                <tr<?php bb_forum_class('bb-category'); ?>>
                    <td><?php bb_forum_pad( '<div class="nest">' ); ?><a href="<?php forum_link(); ?>"><?php forum_name(); ?></a><?php forum_description( array( 'before' => '<small> &#8211; ', 'after' => '</small>' ) ); ?><?php bb_forum_pad( '</div>' ); ?></td>
                </tr>
                <?php continue; endif; ?>
                <tr<?php bb_forum_class(); ?>>
                    <td><?php bb_forum_pad( '<div class="nest">' ); ?><a href="<?php forum_link(); ?>"><?php forum_name(); ?></a><?php forum_description( array( 'before' => '<small> &#8211; ', 'after' => '</small>' ) ); ?><?php bb_forum_pad( '</div>' ); ?></td>
                </tr>
                <?php endwhile; ?>
                </table>
        	</p>
        </div><!-- [/ #forums ) -->
        <?php endif; // bb_forums() ?>
		
		<div id="discussions" class="backg-grey">
			<h1>Discussions</h1>
			<?php if ( $topics || $super_stickies ) : ?>
            <p>
                <table id="mini_latest">
                <tr>
                    <th class="col_topic"><?php _e('Topic'); ?> &#8212; <?php bb_new_topic_link(); ?></th>
                    <th class="col_posts"><?php _e('Posts'); ?></th>
                </tr>
                
                <?php if ( $super_stickies ) : foreach ( $super_stickies as $topic ) : ?>
                <tr<?php topic_class(); ?>>
                    <td><?php bb_topic_labels(); ?> <big><a href="<?php topic_link(); ?>"><?php topic_title(); ?></a></big><?php topic_page_links(); ?></td>
                    <td class="num"><?php topic_posts(); ?></td>
                </tr>
                <?php endforeach; endif; // $super_stickies ?>
                
                <?php if ( $topics ) : foreach ( $topics as $topic ) : ?>
                <tr<?php topic_class(); ?>>
                    <td><?php bb_topic_labels(); ?> <a href="<?php topic_link(); ?>"><?php topic_title(); ?></a><?php topic_page_links(); ?></td>
                    <td class="num"><?php topic_posts(); ?></td>
                </tr>
                <?php endforeach; endif; // $topics ?>
                </table>
                <?php bb_latest_topics_pages( array( 'before' => '<div class="nav">', 'after' => '</div>' ) ); ?>
            </p>
            <?php endif; // $topics or $super_stickies ?>
        </div><!-- [/ #discussions ) -->
        
    </div><!-- [/ .span 5] -->

</div><!-- [/ .span 18 ] -->
</div><!-- [/ #content ] -->
<?php bb_get_footer(); ?>
