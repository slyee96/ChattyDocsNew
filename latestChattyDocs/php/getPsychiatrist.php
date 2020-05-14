<?php
error_reporting(0);
include_once("dbconnect.php");
$username = $_POST['username'];

$sql = "SELECT * FROM PSYCHIATRIST WHERE PSYCHIATRISTID = '$username'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["ROLE"].",".$row["PSYCHIATRISTID"].",".$row["PASSWORD"].",".$row["FULLNAME"].",".$row["EMAIL"].",
        ".$row["PHONE"].",".$row["QUALIFICATION"].",".$row["LANGUAGE"].",".$row["AVAILABLETIME"].",".$row["LOCATION"];
    }
}else{
    echo "failed,null,null,null,null,null,null,null,null,null,null";
}