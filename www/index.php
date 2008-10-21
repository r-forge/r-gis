
<!-- This is the project specific website template -->
<!-- It can be changed as liked or replaced by other content -->

<?php

$domain=ereg_replace('[^\.]*\.(.*)$','\1',$_SERVER['HTTP_HOST']);
$group_name=ereg_replace('([^\.]*)\..*$','\1',$_SERVER['HTTP_HOST']);
$themeroot='http://r-forge.r-project.org/themes/rforge/';

echo '<?xml version="1.0" encoding="UTF-8"?>';
?>
<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en   ">

  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title><?php echo $group_name; ?></title>
	<link href="<?php echo $themeroot; ?>styles/estilo1.css" rel="stylesheet" type="text/css" />
  </head>

<body>

<! --- R-Forge Logo --- >
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr><td>
<a href="/"><img src="<?php echo $themeroot; ?>/images/logo.png" border="0" alt="R-Forge Logo" /> </a> </td> </tr>
</table>


<!-- get project title  -->
<!-- own website starts here, the following may be changed as you like -->

<?php if ($handle=fopen('http://'.$domain.'/export/projtitl.php?group_name='.$group_name,'r')){
$contents = '';
while (!feof($handle)) {
	$contents .= fread($handle, 8192);
}
fclose($handle);
echo $contents; } ?>

<!-- end of project description -->

<br>
This R-forge repository contains a number of related packages, that might eventually grow-up and move out to their own repository. 
<br>
The 'raster' package deals with low level raster (grid) data manipulation. It is used by the other packages, so you need to install it first if you want to use the others. raster depends on a number of packages, notably sp and rgdal. We hope this package to CRAN before the end of this year (2008). 
<br>
The 'Rgis' package is to become partly meta-package, gluing some other spatial packages together, partly GUI GIS package, and partly an easy access to on-line spatial data (this is the only bit that has been implemented, to a small extent, so far).
<br>
The 'RemoteSensing' package contains remote sensing functions (right now mainly a set of vegetation indices). 
<br>
'diversity' contains functions for the analysis of biodiversity data (not much there right now, and have a look at adehabitat instead if this is what you are looking for.)


<p> The <strong>project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>. </p>

</body>
</html>
