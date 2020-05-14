<?php
//error_reporting(0);
include_once ("dbconnect.php");
$username = $_POST['username'];
$role = $_POST['role'];
$lastLogin = $_POST['lastLogin'];
$token = $_POST['token'];
$system = $_POST['system'];
$version = $_POST['version'];
$manufacture = $_POST['manufacture'];
$model = $_POST['model'];
$sqlinsert = "INSERT INTO CHECKAPP(ROLE,USERNAME,LASTLOGIN,TOKEN,SYSTEM,VERSION,MANUFACTURE,MODEL) VALUES ('$role',$username','$lastLogin','$token','$system','$version','$manufacture','$model')";

$sql = "SELECT * FROM PSYCHIATRIST WHERE PSYCHIATRISTID = '$username'";
$result = $conn->query($sql);

if ($conn->query($sqlinsert) === TRUE){
    echo "success";
    if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["ROLE"].",".$row["PSYCHIATRISTID"].",".$row["PASSWORD"].",".$row["FULLNAME"].",".$row["EMAIL"].",".$row["PHONE"].",".$row["QUALIFICATION"];
    }
}else{
    echo "failed,null,null,null,null,null,null,null";
}
}else {
    echo "failed";
}

?>