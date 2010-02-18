		<div id="position-<?php post_position(); ?>">

			<div class="threadauthor">
				<?php post_author_avatar_link(); ?>

					<br/>
			</div>
			<div class="threadpost">
            	<span class="username"><?php post_author_link(); ?> </span>
                <span class="slash">/ </span> 
				<span class="thedate"><?php printf( __('Posted %s ago'), bb_get_post_time() ); ?> </span>
                
				<div class="post"><?php post_text(); ?></div>
				<div class="poststuff"><?php bb_post_admin(); ?></div>
			</div>
		</div> 