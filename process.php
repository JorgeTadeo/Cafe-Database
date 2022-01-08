<?php
		session_start();	
		$servername = "localhost";
        $dbusername = "Main";
        $dbpassword = "Gearsofwar2";
        $database = "cafedb";

		$mysqli = new mysqli($servername, $dbusername, $dbpassword, $database);
		if ($mysqli->connect_errno) {
			echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
		}
		
		if($_REQUEST['btn_submit']=="Login"){
			
			$username = $_POST['user'];
			$password = $_POST['pass'];

			//mysql injection prevention
			$username = stripcslashes($username);
			$password = stripcslashes($password);
				
			$username = $mysqli->real_escape_string($username);

			$password = $mysqli->real_escape_string($password);
	  
			$result = $mysqli->query("select * from CUSTOMER where Username = '$username' and Password = '$password';")
						or die("Failed to query database ");
			$row = $result->fetch_assoc();
			if($row['Username'] == $username && $row['Password'] == $password ){
				$_SESSION['CustomerID'] = $row['CustomerID']; 
                $_SESSION['FirstName'] = $row['FirstName'];
                $_SESSION["loggedin"] = true;
				header("Location: order.php"); 				
			}
			else{
				header("Location: login.php"); 
			}
		}
		elseif ($_REQUEST['btn_submit']=="Register") {
        # Register-button was clicked
			header("Location: register.php"); 
		}
?>