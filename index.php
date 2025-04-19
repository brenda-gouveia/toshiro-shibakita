<?php
// Habilitar a exibição de erros
ini_set("display_errors", 1);
error_reporting(E_ALL);

// Definir cabeçalho antes de qualquer saída
header('Content-Type: text/html; charset=iso-8859-1');

// Exibir a versão atual do PHP
echo 'Versão Atual do PHP: ' . phpversion() . '<br>';
?>
<html>

<head>
<title>Exemplo PHP</title>
</head>
<body>

<?php

$servername = "192.168.0.106";
$username = "root";
$password = "root";
$database = "testdb";

// Criar conexão


$link = new mysqli($servername, $username, $password, $database);

/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

$valor_rand1 =  rand(1, 999);
$valor_rand2 = strtoupper(substr(bin2hex(random_bytes(4)), 1));
$host_name = gethostname();


$query = "INSERT INTO dados (AlunoID, Nome, Sobrenome, Endereco, Cidade, Host) VALUES ('$valor_rand1' , '$valor_rand2', '$valor_rand2', '$valor_rand2', '$valor_rand2','$host_name')";

if ($link->query($query) === TRUE) {
  echo "New record created successfully";
} else {
  echo "Error: " . $link->error;
}

?>
</body>
</html>


