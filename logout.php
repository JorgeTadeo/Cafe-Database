<?php
//start the session
session_start();
//clear session variables
$_SESSION = array();
// end the session
session_destroy();
header("Location: /index.php"); 
?>
