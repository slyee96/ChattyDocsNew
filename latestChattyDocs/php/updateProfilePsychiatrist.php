<?php
error_reporting(0);
include_once("dbconnect.php");

$username = $_POST['username'];
$name = $_POST['name'];
$password = $_POST['password'];
$phone = $_POST['phone'];


$usersql = "SELECT * FROM PSYCHIATRIST WHERE PSYCHIATRISTID = '$username'";

if (isset($name) && (!empty($name))){
    $sql = "UPDATE PSYCHIATRIST SET FULLNAME = '$name' WHERE PSYCHIATRISTID = '$username'";
}
if (isset($password) && (!empty($password))){
    $sql = "UPDATE PSYCHIATRIST SET PASSWORD = sha1($password) WHERE PSYCHIATRISTID = '$username'";
}
if (isset($phone) && (!empty($phone))){
    $sql = "UPDATE PSYCHIATRIST SET PHONE = '$phone' WHERE PSYCHIATRISTID = '$username'";
}

if ($conn->query($sql) === TRUE) {
    $result = $conn->query($usersql);
if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["ROLE"].",".$row["PSYCHIATRISTID"].",".$row["PASSWORD"].",".$row["FULLNAME"].",".$row["EMAIL"].",
        ".$row["PHONE"].",".$row["QUALIFICATION"].",".$row["LANGUAGE"].",".$row["AVAILABLETIME"].",".$row["LOCATION"];
    }
}else{
    echo "failed,null,null,null,null,null,null,null,null,null,null";
}
} else {
    echo "error";
}

$conn->close();
?>
