<?php bb_get_header(); ?>

<div id="content">
    <!-- [ #content ] -->
    <div class="topcontent span-18">
        <div class="span-18 last stripetext"> <span><a href="<?php bb_uri(); ?>">
            <?php bb_option('name'); ?>
            </a> &raquo;
            <?php _e('Search')?>
            </span>
            <?php if ( !empty ( $q ) ) : ?>
            <?php _e(' for')?>
            &#8220;<?php echo esc_html($q); ?>&#8221;
            <?php endif; ?>
        </div>
    </div>
    <div class="clear span-18">
        <?php login_form(); ?>
        <?php if ( is_bb_profile() ) profile_menu(); ?>
    </div>
    <div class="span-18">
        <div id="results" class="span-12">
            <h1>Search results</h1>
				
                <?php if ( $recent ) : ?>
            <div id="results-recent" class="search-results">
                <h2>
                    <?php _e('Recent Posts')?>
                </h2>
                <ol>
                    <?php foreach ( $recent as $bb_post ) : ?>
                    
                    <div<?php alt_class( 'recent' ); ?>>
                    
                    <li> <a href="<?php post_link(); ?>">
                        <p>
						<span class="thetitle"><?php topic_title($bb_post->topic_id); ?>
                        </a> </span>
                        
                        <div>
						<?php post_text(); ?>
                        </div>
                        
                        <div class="freshness thedate"> <span class="ss_sprite ss_date">&nbsp </span> <?php printf( __('Posted %s'), bb_datetime_format_i18n( bb_get_post_time( array( 'format' => 'timestamp' ) ) ) ); ?></div>
						</p>
                    </li>
                    </div>  
                    
                    <?php endforeach; ?>
                </ol>
            </div>
            <?php endif; ?>
            <?php if ( $relevant ) : ?>
            <div id="results-relevant" class="search-results">
                <h2>
                    <?php _e('Relevant posts')?>
                </h2>
                <ol>
                    <?php foreach ( $relevant as $bb_post ) : ?>
                    
                    <div<?php alt_class( 'relevant' ); ?>>
                    
                    <li> <a href="<?php post_link(); ?>">
                        <p>
						<span class="thetitle"><?php topic_title($bb_post->topic_id); ?>
                        </a> </span>
                        
                        <div>
						<?php post_text(); ?>
                        </div>
                        
                        <div class="freshness thedate"> <span class="ss_sprite ss_date">&nbsp </span> <?php printf( __('Posted %s'), bb_datetime_format_i18n( bb_get_post_time( array( 'format' => 'timestamp' ) ) ) ); ?></div>
						</p>
                    </li>
                    </div>                    
					<?php endforeach; ?>
                </ol>
                
                <br />
                <p><?php printf(__('You may also try your <a href="http://google.com/search?q=site:%1$s %2$s">search at Google</a>'), bb_get_uri(null, null, BB_URI_CONTEXT_TEXT), urlencode($q)) ?></p>
   
            </div>
            <?php endif; ?>
            <?php if ( $q && !$recent && !$relevant ) : ?>
            <p>
                <?php _e('No results found.') ?>
            </p>
            <?php endif; ?>
            <br />
                 </div>
        <div id="rcolbody" class="span-6 last rcolspacing">
            <h1>Search Criteria</h1>
            <p>
                <?php bb_topic_search_form(); ?>
        </div>
    </div>
</div>
<?php bb_get_footer(); ?>
