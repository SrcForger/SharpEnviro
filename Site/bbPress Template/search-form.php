<form class="search-form" role="search" action="<?php bb_uri('search.php', null, BB_URI_CONTEXT_FORM_ACTION); ?>" method="get">

		<input class="text" type="text" size="40" maxlength="100" name="q" id="q" />
		<input class="submit" type="submit" value="<?php echo esc_attr__( 'Search' ); ?>" />
	
</form>