<?php

header("Access-Control-Allow-Headers: X-Requested-With");
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include "connect.php";




if (isset($_POST["id"]) && isset($_POST["dataUscita"])) {
  $id = $_POST["id"];
  $dataU = $_POST["dataUscita"];
  $sql = "UPDATE targhe SET dataUscita='" . $dataU . "' WHERE id=" . (int)$id;

  if (mysqli_query($conn, $sql)) {
    http_response_code(200);
  } else {
    echo "Error updating record: " . mysqli_error($conn);
    http_response_code(503);
  }
} else {
  http_response_code(400);
}





mysqli_close($conn);



?>