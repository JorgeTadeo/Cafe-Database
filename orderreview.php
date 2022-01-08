<?php
    session_start();
	$servername = "localhost";
    $dbusername = "Main";
    $dbpassword = "Gearsofwar2";
    $database = "cafedb";

    $conn = new mysqli($servername, $dbusername, $dbpassword, $database);
    // Check connection
	if ($conn->connect_errno) {
		echo "Failed to connect to MySQL: (" . $conn->connect_errno . ") " . $conn->connect_error;
	}
?>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>title</title>
	
  </head>
  <style>
  body {
	margin-left: 0px;
    margin-right: 0px;
    margin-top: 0px;
    margin-bottom: 0px;
  }
  #order-review {
	background-color: #3d3935 !important;
	color: white;
	padding-left: 8px;
	padding-top: 8px;
	padding-bottom: 8px;
	box-shadow: 0 1px 1px rgba(0,0,0,.24),0 4px 4px rgba(0,0,0,.12);
  }
  a {
	color: white;
	text-decoration: none;
  }
  #order-contents > p {
	border-bottom: 1px solid black;
	margin-top: 0px;
    margin-bottom: 0px;
  }
  #order-review > p {
	font-size: 1.4rem;
	line-height: 1.5;
	letter-spacing: -.01em;
  }
  
 ul.dotleaders {
      list-style: none;
      padding: 0;
      /* This width can be whatever you like */
      width: 320px;
      /* Keeps extra dots from appearaing past last character */
      overflow-x: hidden;
    }

      ul.dotleaders li:before {
        float: left;
        /* Keeps dots on same line as text */
        width: 0;
        /* Prevents word wrap */
        white-space: nowrap;
        /* Just a lot of dots with a space in between, no specific number */
        content: ". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ";
      }

      ul.dotleaders li span:first-child {
        padding-right: 0.33em;
        /* Helps to cover dots under the words */
        background-color: white;
      }

      ul.dotleaders li span + span {
        float: right;
        padding-left: 0.33em;
        /* Helps to cover dots under the price */
        background-color: white;
      }
  
  </style>
  <body> 
  <div id="order-review">
  <a href="url">< Back to Menu</a>
  <?php 
  echo   <p>Review order</p>;
  ?>
  </div>
  <div id="order-contents">
  <p> order item 1</p>
  <p> order item 2</p>
  <p> order item 3</p>
  </div>
  <div id="order-total">
  <ul class="dotleaders">
    <li><span>Subtotal</span><span>$8.95</span></li>
    <li><span>Total</span><span>$8.95</span></li>
  </ul>
  </div>
  </body>
</html>
