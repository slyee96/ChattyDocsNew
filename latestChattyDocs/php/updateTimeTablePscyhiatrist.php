<?php
error_reporting(0);
include_once("dbconnect.php");
$username = $_POST['username'];
$availabletime = $_POST['availabletime'];
$location = $_POST['location'];

$sql = "UPDATE PSYCHIATRIST SET AVAILABLETIME = '$availabletime', LOCATION = '$location' WHERE PSYCHIATRISTID = '$username'";

if($conn->query($sql) === TRUE) { 
    echo "success";
}else{
    echo "failed";
}

?>