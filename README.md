# parking_app


## export db to csv
```php
<?php
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
$csv_filename = 'targhe-'.date('Y-m-d').'.csv';

// database variables
$hostname = "sql7.freesqldatabase.com";
$user = "sql7599760";
$password = "2ShBY1PEuA";
$database = "sql7599760";

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
//echo($csv_export);
$myfile = fopen($csv_filename, "w") or die("Unable to open file!");
fwrite($myfile, $csv_export);
fclose($myfile);
?>
```


## Send email PHP
```php
<?php
//Import PHPMailer classes into the global namespace
//These must be at the top of your script, not inside a function
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

//Load Composer's autoloader
require 'vendor/autoload.php';

//Create an instance; passing `true` enables exceptions
$mail = new PHPMailer(true);

try {
    //Server settings
    $mail->SMTPDebug = SMTP::DEBUG_SERVER;                      //Enable verbose debug output
    $mail->isSMTP();                                            //Send using SMTP
    $mail->Host       = 'smtp.gmail.com';                     //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   ="d4nte.dav@gmail.com";                     //SMTP username
    $mail->Password   = 'tsredmzdwstsixcn';                               //SMTP password
    $mail->SMTPSecure = "ssl";            //Enable implicit TLS encryption
    $mail->Port = 465;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`

    //Recipients
    $mail->setFrom('d4nte.dav@gmail.com', 'Dante Dav');
    $mail->addAddress('d.dante03@gmail.com');               
    $mail->addReplyTo('info@example.com', 'Information');


    //Attachments
    //$mail->addAttachment('/var/tmp/file.tar.gz');         //Add attachments
    
    //Content
    $mail->isHTML(true);                                  //Set email format to HTML
    $mail->Subject = 'Here is the subject';
    $mail->Body    = 'This is the HTML message body <b>in bold!</b>';
    $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

    $mail->send();
    echo 'Message has been sent';
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}

?>
```
https://www.ilblogdiunprogrammatore.it/38633-configurare-xampp-per-inviare-email-con-gmail.html
