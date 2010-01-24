<?php bb_get_header(); ?>

<div id="content" class="">
  <!-- [ #content ] -->
  <div class="topcontent span-18">
    <div class="span-18 last stripetext">Our community provides the best support...</div>
  </div>
  <div class="span-9">
    <?php if ( $forums ) : ?>
    <div class="span-9" >
      <h1>Welcome</h1>
      <p>Welcome to the support forums of SharpEnviro. We hope you use this resource for many things including support, dicussion and general banter of all kinds. Please create an account if you have not done already and post whatever you desire. Please respect the community by not flaming each other, bumping up ancient posts or trolling :) </p>
      <p>The hottest tags found in our forum</p>
      <div class="frontpageheatmap">
        <?php bb_tag_heat_map(); ?>
      </div>
      <h1>Search the forums</h1>
      <p>Enter a few words that describe the problem you are having</p>
      <p>
        <?php search_form(); ?>
      </p>
    </div>
  </div>
  <!-- [/ span9 ] -->
  <div class="span-9 last" id="rcolbody">
    <!-- [/ #forums ) -->
    <?php if ( bb_forums() ) : ?>
    
   
    
    <div id="forums" class="backg-grey rcolborder rcolspacing">
      <h1>Forums</h1>
      <p>
      <table id="forumlist">
        <tr>
          <th class="col_theme"><?php _e('Forum'); ?></th>
          <th class="col_topics"><?php _e('Topics'); ?></th>
          <th class="col_posts"><?php _e('Posts'); ?></th>
        </tr>
        <?php while ( bb_forum() ) : ?>
        <?php if (bb_get_forum_is_category()) : ?>
        <tr<?php bb_forum_class('bb-category'); ?>>
          <td colspan="3"><?php bb_forum_pad( '<div class="nest">' ); ?>
            <a href="<?php forum_link(); ?>">
            <?php forum_name(); ?>
            </a>
            <?php forum_description( array( 'before' => '<small> &#8211; ', 'after' => '</small>' ) ); ?>
            <?php bb_forum_pad( '</div>' ); ?></td>
        </tr>
        <?php continue; endif; ?>
        <tr<?php bb_forum_class(); ?>>
          <td><?php bb_forum_pad( '<div class="nest">' ); ?>
            <div class="forumTitle" > <div class="forumIcon"><img src="<?php bb_active_theme_uri(); ?>images/forum/forum.png" width="16" height="16" /> </div> <a href="<?php forum_link(); ?>">
              <?php forum_name(); ?>
              </a> </div>
            <div class="forumDescription" >
              <?php forum_description( array( 'before' => '', 'after' => '' ) ); ?>
            </div>
            <?php bb_forum_pad( '</div>' ); ?></td>
          <td class="num"><?php forum_topics(); ?></td>
          <td class="num"><?php forum_posts(); ?></td>
        </tr>
        <?php endwhile; ?>
      </table>
    </div>
    
     <div id="discussions" class="backg-grey rcolspacing rcolborder">
        
        <h1>Announcements</h1>
      <p>
        <table id="latest">
        <tr>
          <th class="col_topic"><?php _e('Topic'); ?> </th> 
          <th class="col_posts"><?php _e('Posts'); ?></th>
          <th class="col_poster"><?php _e('Poster'); ?></th>
          <th class="col_freshness"><?php _e('Freshness'); ?></th>
        </tr>
        
              <?php if ( $super_stickies ) : foreach ( $super_stickies as $topic ) : ?>
        <tr<?php topic_class(); ?>>
          <td><?php bb_topic_labels(); ?>
             <big><a href="<?php topic_link(); ?>">
            <?php topic_title(); ?>
            </a></big>
            <?php topic_page_links(); ?></td>
          <td class="num"><?php topic_posts(); ?></td>
          <!-- <td class="num"><?php bb_topic_voices(); ?></td> -->
          <td class="num"><?php topic_last_poster(); ?></td>
          <td class="num"><a href="<?php topic_last_post_link(); ?>">
            <?php topic_time(); ?>
            </a></td>
        </tr>
        <?php endforeach; endif; // $super_stickies ?>
        </table>
        </p>
      </div>
    
    <div id="discussions" class="backg-grey rcolspacing rcolborder">
      <h1>Latest discussions</h1>
      <?php $super_stickies = get_sticky_topics(); ?>
      <?php if ( $topics || $super_stickies ) : ?>
      <p>
      <table id="latest">
        <tr>
          <th class="col_topic"><?php _e('Topic'); ?>
            &#8212;
            <?php bb_new_topic_link(); ?> </th> 
          <th class="col_posts"><?php _e('Posts'); ?></th>
          <th class="col_poster"><?php _e('Poster'); ?></th>
          <th class="col_freshness"><?php _e('Freshness'); ?></th>
        </tr>

        <?php if ( $topics ) : foreach ( $topics as $topic ) : ?>
        <tr<?php topic_class(); ?>>
          <td><?php bb_topic_labels(); ?>
            <div class="forumTitle" > <div class="commentIcon"><img src="<?php bb_active_theme_uri(); ?>images/forum/comment.png" width="16" height="16" /> </div>  <a href="<?php topic_link(); ?>">
              <?php topic_title(); ?>
              </a> </div>
            <?php topic_page_links(); ?></td>
          <td class="num"><?php topic_posts(); ?></td>
          <!-- <td class="num"><?php bb_topic_voices(); ?></td> -->
          <td class="num"><?php topic_last_poster(); ?></td>
          <td class="num"><div class="forumTitle"> <a href="<?php topic_last_post_link(); ?>">
              <?php topic_time(); ?>
              </a></div></td>
        </tr>
        <?php endforeach; endif; // $topics ?>
      </table>
      <?php bb_latest_topics_pages( array( 'before' => '<div class="nav">', 'after' => '</div>' ) ); ?>
      </p>
      <?php endif; // $topics or $super_stickies ?>
    </div>
    </p>
  </div>
  <?php endif; // bb_forums() ?>
  <?php if ( bb_is_user_logged_in() ) : ?>
  <?php endif; // bb_is_user_logged_in() ?>
  <?php else : // $forums ?>
  <div class="bbcrumb"><a href="<?php bb_uri(); ?>">
    <?php bb_option('name'); ?>
    </a> &raquo;
    <?php _e('Add New Topic'); ?>
  </div>
  <?php post_form(); endif; // $forums ?>
</div>
<!-- [/ span9 last ] -->
</div>
<!-- [/ .span-18 ] -->
</div>
<!-- [/ #content ] -->
<?php bb_get_footer(); ?>
