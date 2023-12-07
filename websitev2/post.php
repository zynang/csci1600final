<?php
$time = time();
$brain = $_POST['brain'];
$file = 'brain.html';
$data = $time. " - ".$brain;
file_put_contents($file, $data);
?>