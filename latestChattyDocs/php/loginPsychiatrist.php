<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = $_POST['password'];
$passwordsha = sha1($password);

$sql = "SELECT * FROM PSYCHIATRIST WHERE EMAIL = '$email' AND PASSWORD = '$passwordsha' AND VERIFY ='1'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["ROLE"].",".$row["PSYCHIATRISTID"].",".$row["PASSWORD"].",".$row["FULLNAME"].",".$row["EMAIL"].",
        ".$row["PHONE"].",".$row["QUALIFICATION"].",".$row["LANGUAGE"];
    }
}else{
    echo "failed,null,null,null,null,null,null,null,null";
}