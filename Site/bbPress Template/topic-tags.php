<div id="topic-tags">
        <?php if ( bb_get_topic_tags() ) : ?>
        <?php bb_list_tags(); ?>
        <?php else : ?>
        <?php printf(__('No <a href="%s">tags</a> yet.'), bb_get_tag_page_link() ); ?>
        <?php endif; ?>
        <?php tag_form(); ?>
</div>
