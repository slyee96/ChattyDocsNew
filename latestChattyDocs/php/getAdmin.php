<?php
error_reporting(0);
include_once("dbconnect.php");
$username = $_POST['username'];

$sql = "SELECT * FROM ADMIN WHERE ADMINID = $username";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["ROLE"].",".$row["ADMINID"].",".$row["PASSWORD"].",".$row["NAME"].",".$row["EMAIL"].",".$row["PHONE"];
    }
}else{
    echo "failed,null,null,null,null,null,null";
}