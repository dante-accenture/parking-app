<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include "connect.php";




if (isset($_POST["targa"]) && isset($_POST["dataEntrata"])) {
  $targa = $_POST["targa"];
  $dataE = $_POST["dataEntrata"];
  
  $sql = "INSERT INTO targhe (targa, dataEntrata, dataUscita)
VALUES ('" . $targa . "', '" . $dataE . "', '";

  if (isset($_POST["dataUscita"])) {
    $dataU = $_POST["dataUscita"];
    $sql .= $dataU . "')";
  } else {
    $sql .= "NULL')";
  }

  if (mysqli_query($conn, $sql)) {
    http_response_code(200);
  } else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
    http_response_code(503);
  }
} else {
  http_response_code(400);
}




mysqli_close($conn);



?>