<?php
error_reporting(0);
include_once("dbconnect.php");
$username = $_POST['username'];

$sql = "SELECT * FROM PATIENT ORDER BY PATIENTID DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["patient"] = array();
    while ($row = $result ->fetch_assoc()){
        $patientlist = array();
        $patientlist[patientrole] = $row["ROLE"];
        $patientlist[patientid] = $row["PATIENTID"];
        $patientlist[patientfullname] = $row["FULLNAME"];
        $patientlist[patientemail] = $row["EMAIL"];
        $patientlist[patientphone] = $row["PHONE"];
        $patientlist[patienthealthy] = $row["HEALTHYBACKGROUND"];
        $patientlist[patientproblem] = $row["PROBLEM"];
        array_push($response["patient"], $patientlist);  
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>