
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
<p>
The R-forge project contains a number of related packages. It is an incubator for package ideas, that might eventually grow-up and move out to their own repository. This has happend for <a href="http://r-forge.r-project.org/projects/raster/">raster</a>, <a href="http://r-forge.r-project.org/projects/gdistance/">gdistance</a>, and the packages in <a href="http://r-forge.r-project.org/projects/gdistance/">cropsim</a>.</p>
<br>
<p>Most of these packages depend on the <a href="http://r-forge.r-project.org/projects/raster/">raster</a> package that provides basic classes and methods for raster (grid) data manipulation. So you will need to install that package first if you want to use the others. The raster package itsels depends on sp and rgdal. </p>
<br>
<p>'geodata' is for easy access to on-line spatial data. We are currently working on links to GADM boundaries, SRTM, worlclim, and DCW data. </p>
<br>
<p>'RemoteSensing' contains remote sensing functions (right now mainly a set of vegetation indices). </p>
<br>
<p>'diversity' contains functions for the analysis of biodiversity data (not much there right now, and have a look at adehabitat instead if this is what you are looking for.), and will focus macroecology and niche modeling
<br>
</p>

<p> The <strong>project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>. </p>

</body>
</html>
