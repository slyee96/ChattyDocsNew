<?php
error_reporting(0);
include_once("dbconnect.php");
$username = $_POST['username'];

$sql = "SELECT * FROM PATIENT WHERE PATIENTID = $username";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["ROLE"].",".$row["PATIENTID"].",".$row["PASSWORD"].",".$row["FULLNAME"].",".$row["EMAIL"].",".$row["PHONE"].",".$row["ADDRESS"];
    }
}else{
    echo "failed,null,null,null,null,null,null,null";
}