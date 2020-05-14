<?php
error_reporting(0);
include_once("dbconnect.php");
$role = $_POST['role'];
$username = $_POST['username'];
$status = "unread";

$sql = "SELECT * FROM NOTIFICATION WHERE ROLE = '$role' AND USERNAME = '$username' AND STATUS = '$status'";
$result = $conn->query($sql);
$get = mysqli_num_rows($result);
echo $get;
?>