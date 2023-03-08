<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");
function mysqli_field_name($result, $field_offset)
{
    $properties = mysqli_fetch_field_direct($result, $field_offset);
    return is_object($properties) ? $properties->name : null;
}


/* vars for export */
// database record to be exported
$db_record = 'targhe';
// optional where query
$where = '';
// filename for export
$csv_filename = 'file/targhe-'.date('Y-m-d').'.csv';

// database variables
$hostname = "sql109.iceiy.com";
$user = "icei_33699746";
$password ="lollo1234";
$database = "icei_33699746_targhe";

// Database connecten voor alle services
$conn = mysqli_connect($hostname, $user, $password, $database);
  
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}
					


// create var to be filled with export data
$csv_export = '';

// query to get data from database
$query = mysqli_query($conn, "SELECT * FROM ".$db_record." ".$where);
$field = mysqli_num_fields($query);

// create line with field names
for($i = 0; $i < $field; $i++) {
  $csv_export.= mysqli_field_name($query,$i).',';
}
// newline (seems to work both on Linux & Windows servers)
$csv_export.= '
';

while($row = mysqli_fetch_array($query)) {
  // create line with field values
  for($i = 0; $i < $field; $i++) {
    $csv_export.= '"'.$row[mysqli_field_name($query,$i)].'",';
  }	
  $csv_export.= '
';	
}

mysqli_close($conn);
// Export the data and prompt a csv file for download
//header("Content-type: text/x-csv");
//header("Content-Disposition: attachment; //filename=".$csv_filename."");
echo("{'data':'". $csv_export."'}");
//$myfile = fopen($csv_filename, "w") or die("Unable to open file!");
//fwrite($myfile, $csv_export);
//fclose($myfile);
?>