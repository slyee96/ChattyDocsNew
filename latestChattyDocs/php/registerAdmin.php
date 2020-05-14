<?php
//error_reporting(0);
include_once ("dbconnect.php");
$roles = $_POST['role'];
$adminid = $_POST['username'];
$password = sha1($_POST['password']);
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sqlinsert = "INSERT INTO ADMIN(ROLE,ADMINID,PASSWORD,NAME,EMAIL,PHONE) VALUES ('$roles','$adminid','$password','$name','$email','$phone')";

if ($conn->query($sqlinsert) === TRUE) {
    $path = '../profile/'.$email.'.jpg';
    file_put_contents($path, $decoded_string);
    echo "success";
} else {
    echo "failed";
}


?>