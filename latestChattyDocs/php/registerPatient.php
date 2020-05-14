<?php
//error_reporting(0);
include_once ("dbconnect.php");
$roles = $_POST['role'];
$patientid = $_POST['username'];
$password = sha1($_POST['password']);
$name = $_POST['name'];
$email = $_POST['email'];
$address = $_POST['address'];
$phone = $_POST['phone'];
$healthy = $_POST['healthybackground'];
$problem = $_POST['problem'];
$token = $_POST['token'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sqlinsert = "INSERT INTO PATIENT(ROLE,PATIENTID,PASSWORD,FULLNAME,EMAIL,PHONE,ADDRESS,HEALTHYBACKGROUND,PROBLEM,VERIFY,TOKEN,IMAGE) VALUES ('$roles','$patientid','$password','$name','$email','$phone','$address','$healthy','$problem','1','$token','$put')";

if ($conn->query($sqlinsert) === TRUE) {
    $path = '../profile/'.$email.'.jpg';
    $put = file_put_contents($path, $decoded_string);
    sendEmail($email);
    echo "success";
} else {
    echo "failed";
}

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for ChattyDocs'; 
    $message = 'http://myondb.com/latestChattyDocs/php/verifyPatient.php?email='.$useremail; 
    $headers = 'From: noreply@myondb.com.my' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>