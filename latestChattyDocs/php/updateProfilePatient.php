<?php
error_reporting(0);
include_once("dbconnect.php");

$username = $_POST['username'];
$name = $_POST['name'];
$password = $_POST['password'];
$phone = $_POST['phone'];


$usersql = "SELECT * FROM PATIENT WHERE PATIENTID = '$username'";

if (isset($name) && (!empty($name))){
    $sql = "UPDATE PATIENT SET FULLNAME = '$name' WHERE PATIENTID = '$username'";
}
if (isset($password) && (!empty($password))){
    $sql = "UPDATE PATIENT SET PASSWORD = sha1($password) WHERE PATIENTID = '$username'";
}
if (isset($phone) && (!empty($phone))){
    $sql = "UPDATE PATIENT SET PHONE = '$phone' WHERE PATIENTID = '$username'";
}

if ($conn->query($sql) === TRUE) {
    $result = $conn->query($usersql);
if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["ROLE"].",".$row["PATIENTID"].",".$row["PASSWORD"].",".$row["FULLNAME"].",".$row["EMAIL"].",".$row["PHONE"].",".$row["ADDRESS"];
    }
}else{
    echo "failed,null,null,null,null,null,null,null";
    }
} else {
    echo "error";
}

$conn->close();
?>
