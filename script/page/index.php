<html>

<head>
  <title>3EM Engineering</title>
</head>

<body>
  <script>
    document.onkeydown = function (evt) {
      var keyCode = evt ? (evt.which ? evt.which : evt.keyCode) : event.keyCode;
      if (keyCode == 13) {
        //your function call here
        document.frm.submit();
      }
    }
  </script>



  <div class="container">
    <h1>ATTENZIONE A METTERE LA TARGA! </h1>
    <form name="frm" method="POST" action="insTar.php">
      <p>
        <label for="targa">Targa</label>
        <input type="text" value="" placeholder="Inserisci la targa" id="targa" name="targa">
        <input type="submit" />
      </p>
      <p>
    </form>
  </div>
  <style>
    body {
      background-color: #f6f6f6;
      font-family: "Open Sans", Arial, Helvetica;
      font-size: 40px;
    }

    div {
      width: 400px;
      margin: 0 auto;
      text-align: center;
    }

    h1 {
      margin-bottom: 1.5em;
      font-size: 35px;
      color: red;
      font-weight: bold;
      font-weight: 100;
    }

    form p {
      position: relative;
    }

    label {
      position: absolute;
      left: -9999px;
      text-indent: -9999px;
    }

    input {
      width: 250px;
      padding: 15px 12px;
      margin-bottom: 5px;
      border: 1px solid #e5e5e5;
      border-bottom: 2px solid #ddd;
      background: #f2f2f2;
      color: #555;

    }

    .container {
      position: absolute;
      top: 50%;
      left: 50%;
      -moz-transform: translateX(-50%) translateY(-50%);
      -webkit-transform: translateX(-50%) translateY(-50%);
      transform: translateX(-50%) translateY(-50%);
    }
  </style>


</body>

<style>

</style>

</html>