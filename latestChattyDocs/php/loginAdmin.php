<?php
include_once("dbconnect.php");
$username = $_POST['username'];
$password = $_POST['password'];
$passwordsha = sha1($password);

$sql = "SELECT * FROM ADMIN WHERE ADMINID = '$username' AND PASSWORD = '$passwordsha'";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["ROLE"].",".$row["ADMINID"].",".$row["PASSWORD"].",".$row["NAME"].",".$row["EMAIL"].",".$row["PHONE"];
    }
}else{
    echo "failed,null,null,null,null,null,null";
}