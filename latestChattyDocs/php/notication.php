<?php
error_reporting(0);
include_once("dbconnect.php");

$role = $_POST['role'];
$username = $_POST['username'];

$sql = "SELECT * FROM NOTIFICATION WHERE ROLE = '$role' AND USERNAME '$username'";

$result = $conn->query($sql);

if ($conn->query($sql) === TRUE) {
    echo "success";
}else {
    echo "failed";
}