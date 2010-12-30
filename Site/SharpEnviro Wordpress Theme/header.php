<?php global $titan; ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
	"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
	<?php if ( is_front_page() ) : ?>
		<title><?php bloginfo( 'name'); ?></title>
	<?php elseif ( is_404() ) : ?>
		<title><?php _e( 'Page Not Found |', 'titan' ); ?> | <?php bloginfo( 'name'); ?></title>
	<?php elseif ( is_search() ) : ?>
		<title><?php printf(__ ("Search results for '%s'", "titan"), attribute_escape(get_search_query())); ?> | <?php bloginfo( 'name'); ?></title>
	<?php else : ?>
		<title><?php wp_title($sep = ''); ?> | <?php bloginfo( 'name');?></title>
	<?php endif; ?>

	<!-- Basic Meta Data -->
	<meta name="Copyright" content="Design is copyright 2008 - <?php echo date('Y'); ?> The Theme Foundry" />
	<meta http-equiv="imagetoolbar" content="no" />
	<meta http-equiv="Content-Type" content="<?php bloginfo( 'html_type'); ?>; charset=<?php bloginfo( 'charset'); ?>" />
	<?php if ((is_single() || is_category() || is_page() || is_home()) && (!is_paged())){} else { ?>
		<meta name="robots" content="noindex,follow" />
	<?php } ?>

	<!-- Favicon -->
	<link rel="shortcut icon" href="<?php bloginfo( 'stylesheet_directory'); ?>/images/favicon.ico" />

	<!--Stylesheets-->
	<link href="<?php bloginfo( 'stylesheet_url'); ?>" type="text/css" media="screen" rel="stylesheet" />
	<!--[if lt IE 8]>
	<link rel="stylesheet" type="text/css" media="screen" href="<?php bloginfo( 'template_url'); ?>/stylesheets/ie.css" />
	<![endif]-->

	<!--Scripts-->
	<!--[if lte IE 7]>
	<script type="text/javascript">
	sfHover=function(){var sfEls=document.getElementById("nav").getElementsByTagName("LI");for(var i=0;i<sfEls.length;i++){sfEls[i].onmouseover=function(){this.className+=" sfhover";}
	sfEls[i].onmouseout=function(){this.className=this.className.replace(new RegExp(" sfhover\\b"),"");}}}
	if (window.attachEvent)window.attachEvent("onload",sfHover);
	</script>
	<![endif]-->

	<!--WordPress-->
	<link rel="alternate" type="application/rss+xml" title="<?php bloginfo( 'name'); ?> RSS Feed" href="<?php bloginfo( 'rss2_url'); ?>" />
	<link rel="pingback" href="<?php bloginfo( 'pingback_url'); ?>" />

	<!--WP Hook-->
	<?php if ( is_singular() ) wp_enqueue_script( 'comment-reply' ); ?>
	<?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
	<div class="skip-content"><a href="#content">Skip to content</a></div>
	<div id="header" class="clear">
		<div id="follow">
			<div class="wrapper clear">
				<dl>
					<dd></dd>
				</dl>
			</div><!--end wrapper-->
		</div><!--end follow-->
		<div class="wrapper">
			<?php /*if (is_home()) echo( '<h1 id="title">'); else echo( '<div id="title">');?><a href="<?php bloginfo( 'url'); ?>"><?php bloginfo( 'name'); ?></a><?php if (is_home()) echo( '</h1>'); else echo( '</div>'); */?>
			<?php if (is_home()) echo( '<h1 id="title">'); else echo( '<div id="title">');?><a href="<?php bloginfo( 'url'); ?>"><img src="wp-content/themes/titan/images/SharpEnviroBanner.png"></img></a><?php if (is_home()) echo( '</h1>'); else echo( '</div>');?>
			<div id="navigation">
				<ul id="nav">
                                        <?php $title = trim(wp_title('',False,'')); ?>
					<li class="page_item <?php if (is_front_page()) echo( 'current_page_item');?>"><a href="<?php bloginfo( 'url'); ?>"><?php _e( 'About', 'titan' ); ?></a></li>
					<li class="page_item <?php if (($title == 'News')) echo('current_page_item');?>"><a href="http://www.sharpenviro.com/wp/?page_id=189">News</a></li>
					<li class="page_item <?php if (($title == 'Download')) echo('current_page_item');?>"><a href="http://www.sharpenviro.com/wp/?page_id=70">Download</a></li>
					<li class="page_item <?php if (($title == 'FAQ')) echo('current_page_item');?>"><a href="http://www.sharpenviro.com/wp/?page_id=17">FAQ</a></li>
					<li class="page_item <?php if (($title == 'Forum')) echo('current_page_item');?>"><a href="http://www.sharpenviro.com/phpbb/index.php">Forum</a></li>
					<li class="page_item <?php if (($title == 'Development')) echo('current_page_item');?>"><a href="http://www.sharpenviro.com/wp/?page_id=90">Development</a></li>
					<li class="page_item <?php if (($title == 'Contact')) echo('current_page_item');?>"><a href="http://www.sharpenviro.com/wp/?page_id=23">Contact</a></li>
					<?php if ($titan->hidePages() !== 'true' ): ?>
						<?php wp_list_pages( 'title_li=' ); ?>
					<?php endif; ?>
					<?php if ($titan->hideCategories() != 'true' ): ?>
						<?php wp_list_categories( 'title_li=' ); ?>
					<?php endif; ?>
                                 </ul>
			</div><!--end navigation-->
		</div><!--end wrapper-->
	</div><!--end header-->
<div class="wrapperbg">
<div class="content-background">
	<div class="wrapper">
		<div class="notice"></div>
		<div id="content">