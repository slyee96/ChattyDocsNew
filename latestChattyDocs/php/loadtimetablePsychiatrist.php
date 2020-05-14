<?php
error_reporting(0);
include_once("dbconnect.php");
$username = $_POST['username'];

$sql = "SELECT * FROM PSYCHIATRIST ORDER BY PSYCHIATRISTID DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["psychiatrist"] = array();
    while ($row = $result ->fetch_assoc()){
        $psychiatristlist = array();
        $psychiatristlist[psychiatristrole] = $row["ROLE"];
        $psychiatristlist[psychiatristid] = $row["PSYCHIATRISTID"];
        $psychiatristlist[psychiatristfullname] = $row["FULLNAME"];
        $psychiatristlist[psychiatristemail] = $row["EMAIL"];
        $psychiatristlist[psychiatristphone] = $row["PHONE"];
        $psychiatristlist[psychiatristqualification] = $row["QUALIFICATION"];
        $psychiatristlist[psychiatristlanguage] = $row["LANGUAGE"];
        $psychiatristlist[psychiatristimage] = $row["IMAGE"];
        $psychiatristlist[psychiatristavailable] = $row["AVAILABLETIME"];
        $psychiatristlist[psychiatristlocation] = $row["LOCATION"];
        array_push($response["psychiatrist"], $psychiatristlist);  
        
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>