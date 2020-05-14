<?php
error_reporting(0);
include_once("dbconnect.php");

$role = $_POST['role'];
$username = $_POST['username'];
$id = $_POST['notiid'];
$status = $_POST['actionType'];

$sql = "UPDATE NOTIFICATION SET STATUS = '$status' WHERE ROLE = '$role' AND USERNAME '$username'";

$result = $conn->query($sql);

if ($conn->query($sql) === TRUE) {
    echo "success";
}else {
    echo "failed";
}