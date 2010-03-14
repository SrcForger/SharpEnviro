<?php bb_get_header(); ?>

<div id="content">
    <!-- [ #content ] -->
    <div class="topcontent span-18">
        <div class="span-18 last stripetext"><a href="<?php bb_uri(); ?>">
            <?php bb_option('name'); ?>
            </a>
            <?php bb_forum_bread_crumb(); ?>
        </div>
    </div>
    
    <div class="clear span-18">  	
         <?php login_form(); ?> <?php if ( is_bb_profile() ) profile_menu(); ?> 
    </div>
    
    <div class="span-18">
        <div id="discussions" class="span-12">

            <h1>Discussions</h1>
            <p>
            
            <?php if ( $topics || $stickies ) : ?>
            <table id="latest">
                <tr>
                    <th><?php _e('Topic'); ?>
                        &#8212;
                        <?php new_topic(); ?></th>
                    <th><?php _e('Posts'); ?></th>
                    <th><?php _e('Last Poster'); ?></th>
                    <th><?php _e('Freshness'); ?></th>
                </tr>
                
                <?php if ( $stickies ) : foreach ( $stickies as $topic ) : ?>
                <tr<?php topic_class(); ?>>
                    <td <span class="num"> <?php bb_topic_labels(); ?> </span>
                        <big><a href="<?php topic_link(); ?>">
                        <?php topic_title(); ?>
                        </a></big></td>
                    <td class="num"><?php topic_posts(); ?></td>
                    <td class="num"><?php topic_last_poster(); ?></td>
                    <td class="num"><small>
                        <?php topic_time(); ?>
                        </small></td>
                </tr>
                <?php endforeach; endif; ?>
                
                <?php if ( $topics ) : foreach ( $topics as $topic ) : ?>
                <tr<?php topic_class(); ?>>
                    <td <span class="num"> <?php bb_topic_labels(); ?> </span>
                        <big><a href="<?php topic_link(); ?>">
                        <?php topic_title(); ?>
                        </a></big></td>
                    <td class="num"><?php topic_posts(); ?></td>
                    <td class="num"><?php topic_last_poster(); ?></td>
                    <td class="num"><small>
                        <?php topic_time(); ?>
                        </small></td>
                </tr>
                <?php endforeach; endif; ?>
                
            </table>
            <?php endif; ?>
            
            <?php forum_pages( array( 'before' => '<div class="nav">', 'after' => '</div>' ) ); ?>
            <?php post_form(); ?>
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
                            <div class="forumTitle" >
                                <span class="ss_sprite ss_folder">&nbsp;</span>
                                <a href="<?php forum_link(); ?>">
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
