<?php
//error_reporting(0);
$username = $_POST['username'];
$email = $_POST['email'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$path = '../profile/'.$email.'.jpg';

if (file_put_contents($path, $decoded_string)){
    echo 'success';
}else{
    echo 'failed';
}

?>