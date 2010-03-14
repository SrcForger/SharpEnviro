<?php bb_get_header(); ?>

<div id="content">
    <!-- [ #content ] -->
    <div class="topcontent span-18">
        <div class="span-18 last stripetext"> 
        <a href="<?php bb_uri(); ?>"><?php bb_option('name'); ?></a> &raquo; <a href="<?php user_profile_link( $user_id ); ?>"><?php echo get_user_display_name( $user_id ); ?></a> &raquo; <?php echo $profile_page_title; ?>
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
            </p>
        </div>
    </div>
</div>

<div class="bbcrumb"><a href="<?php bb_uri(); ?>"><?php bb_option('name'); ?></a> &raquo; <a href="<?php user_profile_link( $user_id ); ?>"><?php echo get_user_display_name( $user_id ); ?></a> &raquo; <?php echo $profile_page_title; ?></div>
<h2 role="main"><?php echo get_user_name( $user->ID ); ?></h2>

<?php bb_profile_base_content(); ?>

<?php bb_get_footer(); ?>
