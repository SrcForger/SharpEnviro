<?php if ( !bb_is_topic() ) : ?>

<div id="post-form-title-container" class="">
    <?php _e('Title'); ?>
    <br />
    <label for="topic">
        <input name="topic" type="text" id="topic" size="50" maxlength="80" tabindex="1" />
    </label>
</div>
<?php endif; do_action( 'post_form_pre_post' ); ?>
<div id="post-form-post-container"> <br />
    <?php _e('Post'); ?>
    <label for="post_content">
        <textarea name="post_content" cols="50" rows="8" id="post_content" tabindex="3"></textarea>
    </label>
</div>
<div id="post-form-tags-container"> <br />
    <?php printf(__('Tags (comma seperated)'), bb_get_tag_page_link()) ?> <br />
    <label for="tags-input">
        <input id="tags-input" name="tags" type="text" size="50" maxlength="100" value="<?php bb_tag_name(); ?>" tabindex="4" />
    </label>
    
    <div id="post-form-submit-container" class="submit" style="float:right">
        <input type="submit" id="postformsub" name="Submit" value="<?php echo esc_attr__( 'Send Post &raquo;' ); ?>" tabindex="4" />
    </div>
</div>
<div style="display:inline">
    <?php if ( bb_is_tag() || bb_is_front() ) : ?>
    <div id="post-form-forum-container" style="float:left">
        <label for="forum-id">
            <?php _e('Forum'); ?>
            <?php bb_new_topic_forum_dropdown(); ?>
        </label>
    </div>
    <?php endif; ?>
    
</div>
<div id="post-form-allowed-container" class="allowed"> <br />
    <?php _e('Allowed markup:'); ?>
    <code>
    <?php allowed_markup(); ?>
    </code>. <br />
    <?php _e('You can also put code in between backtick ( <code>`</code> ) characters.'); ?>
</div>
