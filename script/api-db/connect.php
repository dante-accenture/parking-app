<?php
$servername = "sql8.freesqldatabase.com";
$username = "sql8601691";
$password = "jFU9cp86E8";
$db = "sql8601691";

$conn = mysqli_connect($servername, $username, $password, $db);

if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

?>