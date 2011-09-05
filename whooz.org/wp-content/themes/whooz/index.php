<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">

<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>WHOOZ - Manhattan National Wildlife Habitat</title>
	<link rel="stylesheet" href="<?php bloginfo('stylesheet_directory') ?>/style.css" type="text/css" media="screen" title="no title" charset="utf-8">
	<link rel="stylesheet" href="style.css" type="text/css" media="print" title="no title" charset="utf-8">
</head>
<body>
	
	<?php get_header(); ?>
	
	<div id="content">
		<!-- <img style="float:left;padding-right:20px;padding-left:20px;" src="/map-large.png" alt="Map"> -->
			<?php if (have_posts()) : ?>

				<?php while (have_posts()) : the_post(); ?>

					<div class="post" id="post-<?php the_ID(); ?>">
						<h2><a href="<?php the_permalink() ?>" rel="bookmark" title="Permanent Link to <?php the_title_attribute(); ?>"><?php the_title(); ?></a></h2>
						<small><?php the_time('F jS, Y') ?> <!-- by <?php the_author() ?> --></small>

						<div class="entry">
							<?php the_content('Read the rest of this entry &raquo;'); ?>
						</div>
					</div>

				<?php endwhile; ?>

				<div class="navigation">
					<div class="alignleft"><?php next_posts_link('&laquo; Older Entries') ?></div>
					<div class="alignright"><?php previous_posts_link('Newer Entries &raquo;') ?></div>
				</div>

			<?php else : ?>

				<h2 class="center">Not Found</h2>
				<p class="center">Sorry, but you are looking for something that isn't here.</p>

			<?php endif; ?>
		<br style="clear:both;" />
	</div>
	<div id="footer">
		By <a href="">Jeffrey Warren</a> and <a href="">Natalie Jeremijenko</a>
	</div>
</body>
</html>
