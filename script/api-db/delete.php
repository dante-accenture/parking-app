<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include "connect.php";

if (isset($_POST["id"])) {
  $sql = "DELETE FROM targhe WHERE id=" . $_POST["id"];

  if (mysqli_query($conn, $sql)) {
    http_response_code(200);
  } else {
    echo "Error deleting record: " . mysqli_error($conn);
    http_response_code(503);
  }
} else {
  http_response_code(400);
}





mysqli_close($conn);

?>