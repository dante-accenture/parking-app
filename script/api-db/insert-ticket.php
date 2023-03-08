<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include "connect.php";




if (isset($_POST["targa"]) && isset($_POST["dataEntrata"]) && isset($_POST["ticket"])) {
  $targa = $_POST["targa"];
  $dataE = $_POST["dataEntrata"];
  $ticket = $_POST["ticket"];

  $sql = "INSERT INTO targhe (targa, dataEntrata, ticket, dataUscita)
VALUES ('" . $targa . "', '" . $dataE . "', " . $ticket. "', ";

  if (isset($_POST["dataUscita"])) {
    $dataU = $_POST["dataUscita"];
    $sql .= "'" . $dataU . "')";
  } else {
    $sql .= "null)";
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