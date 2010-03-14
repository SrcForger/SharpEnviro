<?php bb_get_header(); ?>

<div id="content">
    <!-- [ #content ] -->
    <div class="topcontent span-18">
        <div class="span-18 last stripetext"> <a href="<?php bb_uri(); ?>">
            <?php bb_option('name'); ?>
            </a> &raquo;
            <?php _e('Tags'); ?>
        </div>
    </div>
    <div class="clear span-18">
        <?php login_form(); ?>
        <?php if ( is_bb_profile() ) profile_menu(); ?>
    </div>
    <div class="span-18">
        <div id="discussions" class="span-18">
            <h1>All Tags</h1>
            <p>
            <div id="hottags">
                <?php bb_tag_heat_map( 9, 38, 'pt', 80 ); ?>
            </div>
            </p>
        </div>
    </div>
</div>
<?php bb_get_footer(); ?>
