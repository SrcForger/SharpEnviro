<?php bb_get_header(); ?>

<div id="content">
    <!-- [ #content ] -->
    <div class="topcontent span-18">
        <div class="span-18 last stripetext"> <a href="<?php bb_uri(); ?>">
            <?php bb_option('name'); ?>
            </a> &raquo; <a href="<?php bb_tag_page_link(); ?>">
            <?php _e('Tags'); ?>
            </a> &raquo;
            <?php bb_tag_name(); ?>
        </div>
    </div>
    <div class="clear span-18">
        <?php login_form(); ?>
        <?php if ( is_bb_profile() ) profile_menu(); ?>
    </div>
    <div class="span-18">
        <div id="discussions" class="span-18">
            <h1>Tagged Posts</h1>
            <p>
                <?php do_action('tag_above_table'); ?>
                <?php if ( $topics ) : ?>
            <table id="latest" role="main">
                <tr>
                    <th><?php _e('Topic'); ?>
                        &#8212;
                        <?php bb_new_topic_link(); ?></th>
                    <th><?php _e('Posts'); ?></th>
                    <!-- <th><?php _e('Voices'); ?></th> -->
                    <th><?php _e('Last Poster'); ?></th>
                    <th><?php _e('Freshness'); ?></th>
                </tr>
                <?php foreach ( $topics as $topic ) : ?>
                <tr<?php topic_class(); ?>>
                    <td><?php bb_topic_labels(); ?>
                        <a href="<?php topic_link(); ?>">
                        <?php topic_title(); ?>
                        </a>
                        <?php topic_page_links(); ?></td>
                    <td class="num"><?php topic_posts(); ?></td>
                    <!-- <td class="num"><?php bb_topic_voices(); ?></td> -->
                    <td class="num"><?php topic_last_poster(); ?></td>
                    <td class="num"><a href="<?php topic_last_post_link(); ?>">
                        <?php topic_time(); ?>
                        </a></td>
                </tr>
                <?php endforeach; ?>
            </table>
            <p class="rss-link"><a href="<?php bb_tag_posts_rss_link(); ?>" class="rss-link">
                <?php _e('<abbr title="Really Simple Syndication">RSS</abbr> link for this tag') ?>
                </a></p>
            <?php tag_pages( array( 'before' => '<div class="nav">', 'after' => '</div>' ) ); ?>
            <br />
            <?php endif; ?>
            <?php post_form(); ?>
            <?php do_action('tag_below_table'); ?>
            <?php manage_tags_forms(); ?>
            </p>
        </div>
    </div>
</div>
<?php bb_get_footer(); ?>
