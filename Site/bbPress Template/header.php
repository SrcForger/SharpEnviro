<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"<?php bb_language_attributes( '1.1' ); ?>>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>
<?php bb_title() ?>
</title>
<?php bb_feed_head(); ?>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<?php bb_stylesheet_uri(); ?>" type="text/css" />
<link href="<?php bb_active_theme_uri(); ?>css/bbstyle.css" rel="stylesheet" type="text/css" />
<link href="<?php bb_active_theme_uri(); ?>css/reset.css" rel="stylesheet" type="text/css" />
<link href="<?php bb_active_theme_uri(); ?>css/grid.css" rel="stylesheet" type="text/css" />
<link href="<?php bb_active_theme_uri(); ?>css/typography.css" rel="stylesheet" type="text/css" />
<link href="<?php bb_active_theme_uri(); ?>css/page_forum.css" rel="stylesheet" type="text/css" />
<link href="<?php bb_active_theme_uri(); ?>css/screen.css" rel="stylesheet" type="text/css" />
<link href="<?php bb_active_theme_uri(); ?>css/form.css" rel="stylesheet" type="text/css" />
<?php bb_head(); ?>
<script src="<?php bb_active_theme_uri(); ?>js/jquery-1.2.6.min.js" type="text/javascript"></script>
<script src="<?php bb_active_theme_uri(); ?>js/compactform.js" type="text/javascript"></script>
<script src="<?php bb_active_theme_uri(); ?>js/jquery.curvycorners.packed.js" type="text/javascript"></script>
<script type="text/javascript">
	jQuery.noConflict();
        jQuery(function(){
                jQuery('#activetab').corner({
                  tl: { radius: 5 },
                  tr: { radius: 5 },
                  bl: false,
                  br: false,
                  antiAlias: true,
                  autoPad: false
                });
        });
    </script>
    
    
</head>
<body id="<?php bb_location(); ?>">
<div id="header" class="container">
  <div id="navbar">
    <?php 
			$navlinks = get_bookmarks
			(							 
				array(
					'orderby' => 'name', 
					'order' => 'ASC',
					'category_name' => 'Navigation'
				)
			);
			$currentURL = curPageURL();
			?>
    <?php foreach ( $navlinks as $navlink ): ?>
    
    <!--Blog check-->
    <?php if ( $navlink->link_name == "Blog" & $post->post_type == "post"): ?>
    <a class="tab" id="activetab" href="<?php echo $navlink->link_url; ?>" name="<?php echo $navlink->link_description; ?>"><?php echo $navlink->link_name; ?></a>
    
    <!--Forum check-->
    <?php elseif (( $navlink->link_name == "Forums") & (strpos($currentURL, "forum") !== false)): ?>
    <a class="tab" id="activetab" href="<?php echo $navlink->link_url; ?>" name="forum"> <?php echo $navlink->link_name; ?></a>
    
    <?php elseif ($currentURL == $navlink->link_url): ?>
    <a class="tab" id="activetab" href="<?php echo $navlink->link_url; ?>" name="<?php echo $navlink->link_description; ?>"><?php echo $navlink->link_name; ?></a>
    
    <?php else: ?>
    <a href="<?php echo $navlink->link_url; ?>" name="<?php echo $navlink->link_description; ?>"><?php echo $navlink->link_name; ?></a>
    
	<?php endif; ?>
    
	<?php endforeach; ?>
  </div>
</div>
<div id="stripe" class="orange"> </div>
<div id="content" class="container">
<div class="topcontent span-18">
  <!-- <?php login_form(); ?> <?php if ( is_bb_profile() ) profile_menu(); ?> -->
</div>
