
<?php
echo "Hello!! This is site (with SSL/TLS) from todo_list.php."
$user = "root";
$password = "123L45p68";
$database = "nginx_test";
$table = "todo_list";

try {
	$db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
	echo "<h2>TODO</h2><ol>";
	foreach($db->query("SELECT content FROM $table") as $row) {
		echo "<li>" . $row['content'] . "</li>";
	}
	echo "</ol>";
} catch (PDOException $e) {
	print "Error!: " . $e->getMessage();
	die();
}
?>
