<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include "connect.php";

if(isset($_POST["targa"])){
  $sql = "SELECT * FROM targhe WHERE targa='".$_POST["targa"]."'";

  $result = mysqli_query($conn, $sql);
  if (mysqli_num_rows($result) > 0) {
    $arrayTarg = array();
  
    while ($row = mysqli_fetch_assoc($result)) {
      $targa = array("id" => (int)$row["id"], "targa" => $row["targa"], "dataEntrata" => $row["dataEntrata"], "dataUscita" => $row["dataUscita"]);
  
      array_push($arrayTarg, $targa);
    }
    http_response_code(200);
    echo json_encode($arrayTarg);
  } else {
    echo "[]";
    http_response_code(200);
  }
}else{
    http_response_code(400);
}

mysqli_close($conn);

?>