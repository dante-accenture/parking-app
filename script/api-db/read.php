<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include "connect.php";

$sql = "SELECT * FROM targhe";

$result = mysqli_query($conn, $sql);
if (mysqli_num_rows($result) > 0) {
  $arrayTarg = array();

  while ($row = mysqli_fetch_assoc($result)) {
    $targa = array("id" => $row["id"], "targa" => $row["targa"], "dataEntrata" => $row["dataEntrata"], "dataUscita" => $row["dataUscita"]);

    array_push($arrayTarg, $targa);
  }
  http_response_code(200);
  echo json_encode($arrayTarg);
} else {
  echo "Nessuna targa trovata";
  http_response_code(404);
}

mysqli_close($conn);

?>