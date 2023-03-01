<?php

if (isset($_POST["targa"]) && !empty($_POST["targa"])) {

  echo $_POST["targa"];

  $servername = "192.168.1.254";
  $username = "root";
  $password = "root";
  $db = "dbsample";

  $conn = mysqli_connect($servername, $username, $password, $db);

  if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
  }

  $sql = "SELECT * FROM targhe WHERE targa='" . $_POST["targa"] . "'";
  $result = mysqli_query($conn, $sql);

  if (mysqli_num_rows($result) > 0) {
    $lastIsFilled = false;

    while ($row = mysqli_fetch_assoc($result)) {
      if ($row["dataUscita"] == "NULL" || $row["dataUscita"] == "null") {
        $sql = "UPDATE targhe SET dataUscita='" . date("d-m-Y H:i:s") . "' WHERE id=" . $row["id"];
        $lastIsFilled = false;
        if (mysqli_query($conn, $sql)) {
          echo "<script type='text/javascript'>alert('Targa inserita');</script>";
        }

      } else {
        $lastIsFilled = true;
      }
    }
    if ($lastIsFilled == true) {
      $sql = "INSERT INTO targhe (targa, dataEntrata, dataUscita)
VALUES ('" . $_POST["targa"] . "', '" . date("d-m-Y H:i:s") . "', 'NULL')";
      if (mysqli_query($conn, $sql)) {
        "<script type='text/javascript'>alert('Targa inserita');</script>";
      }
    }
  } else {
    $sql = "INSERT INTO targhe (targa, dataEntrata, dataUscita)
VALUES ('" . $_POST["targa"] . "', '" . date("d-m-Y H:i:s") . "', 'NULL')";
    if (mysqli_query($conn, $sql)) {
      "<script type='text/javascript'>alert('Targa inserita');</script>";
    }

  }


  mysqli_close($conn);
}
?>