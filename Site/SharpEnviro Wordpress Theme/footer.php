<?php global $titan; ?>
</div><!--end wrapper-->
</div><!--end content-background-->
</div><!--end wrapperbg-->
<div id="footer">
	<div class="wrapper clear">
		<div id="footer-about" class="footer-column">
			<h2>SharpEnviro</h2>
                        <div style="padding-left:12px; padding-top:5px"> <!-- IE Fix -->                   
                            <a class="rss" href="<?php bloginfo( 'rss2_url'); ?>"><img src="wp-content/themes/titan/images/feed-icon.png"> RSS Feed</a><div></div>
			    <a class="email" href="?page_id=23"><img src="wp-content/themes/titan/images/email-icon.png"> Contact</a>
                        </div>
                </div>
		<div id="footer-flickr" class="footer-column">
			<h2>Sourceforge.net</h2>
                        <div style="float:left; margin-right:5px; margin-top:3px; margin-bottom:-5px"><a href="http://sourceforge.net/projects/sharpe"><img src="http://sflogo.sourceforge.net/sflogo.php?group_id=62227&amp;type=13" width="120" height="30" alt="Get SharpEnviro at SourceForge.net. Fast, secure and Free Open Source software downloads" /></a></div><div style="line-height:150%">SharpEnviro is an open source project. The complete source code is freely available on the SourceForge.net project page.</div>
                </div>
		<div id="footer-search" class="footer-column">
			<h2><?php _e('Search', 'titan'); ?></h2>
			<?php if (is_file(STYLESHEETPATH . '/searchform.php')) include (STYLESHEETPATH . '/searchform.php'); else include(TEMPLATEPATH . '/searchform.php'); ?>
		</div>
		<div id="copyright">
			<p class="copyright-notice"><?php _e('Copyright', 'titan'); ?> &copy; <?php echo date('Y'); ?> <?php echo $titan->copyrightName(); ?>. Theme based on the <a href="http://thethemefoundry.com/titan/">Titan Theme</a> by <a href="http://thethemefoundry.com">The Theme Foundry</a>.</p>
		</div><!--end copyright-->
	</div><!--end wrapper-->
</div><!--end footer-->
<?php wp_footer(); ?>
<?php
	if ($titan->statsCode() != '') {
		echo $titan->statsCode();
	}
?>
</body>
</html>