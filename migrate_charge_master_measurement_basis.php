<?php
/**
 * Migración de datos: asigna Measurement Basis a Charge Master según JSON.
 *
 * Lee SQL/Data SearatesERP_Json_Administración_chargemaster.json,
 * busca el id de tbl_erp_measurement_basis por des,
 * busca el id de tbl_erp_charge_master por nombre_charge,
 * y actualiza id_product_unida_medida con el id del measurement basis.
 */

$jsonPath = __DIR__ . '/Data SearatesERP_Json_Administración_chargemaster.json';

if (!file_exists($jsonPath)) {
    echo "ERROR: No se encuentra el archivo JSON: $jsonPath\n";
    exit(1);
}

$json = file_get_contents($jsonPath);
$data = json_decode($json, true);
if (json_last_error() !== JSON_ERROR_NONE || !is_array($data)) {
    echo "ERROR: JSON inválido: " . json_last_error_msg() . "\n";
    exit(1);
}

// Credenciales PostgreSQL por argumentos (con valores locales por defecto)
$host = $argv[1] ?? 'localhost';
$db   = $argv[2] ?? 'scl_cargo';
$user = $argv[3] ?? 'postgres';
$pass = $argv[4] ?? '241302';
$port = $argv[5] ?? '5432';

$dsn = "pgsql:host=$host;port=$port;dbname=$db";

try {
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    echo "ERROR de conexión: " . $e->getMessage() . "\n";
    exit(1);
}

// Cargar catálogo de Measurement Basis (solo activos / estado = '1')
$mbStmt = $pdo->query("SELECT id, des, funcionamiento FROM public.tbl_erp_measurement_basis WHERE COALESCE(estado, '1') = '1'");
$measurementBasisMap = [];
foreach ($mbStmt as $row) {
    $key = mb_strtolower(trim((string)$row['des']));
    $measurementBasisMap[$key] = (string)$row['id'];
}

// Preparar statements
$findCharge = $pdo->prepare("SELECT id FROM public.tbl_erp_charge_master WHERE nombre_charge ILIKE :nombre AND COALESCE(estado, '1') = '1' LIMIT 1");
$updateCharge = $pdo->prepare("UPDATE public.tbl_erp_charge_master SET id_product_unida_medida = :mb_id WHERE id = :id");

$updated = 0;
$notFoundCharge = [];
$notFoundMb = [];
$skippedEmpty = 0;

foreach ($data as $item) {
    $productName = isset($item['Product Name']) ? trim((string)$item['Product Name']) : '';
    $mbDes = isset($item['Measurement Basis']) ? trim((string)$item['Measurement Basis']) : '';

    if ($productName === '') {
        continue;
    }

    if ($mbDes === '') {
        $skippedEmpty++;
        continue;
    }

    // Buscar measurement basis
    $mbKey = mb_strtolower($mbDes);
    if (!isset($measurementBasisMap[$mbKey])) {
        $notFoundMb[$mbDes] = ($notFoundMb[$mbDes] ?? 0) + 1;
        continue;
    }
    $mbId = $measurementBasisMap[$mbKey];

    // Buscar charge master
    $findCharge->execute([':nombre' => $productName]);
    $charge = $findCharge->fetch();

    if (!$charge) {
        $notFoundCharge[] = $productName;
        continue;
    }

    // Actualizar
    $updateCharge->execute([':mb_id' => $mbId, ':id' => $charge['id']]);
    $updated++;
}

echo "=== Resumen ===\n";
echo "Registros actualizados: $updated\n";
echo "Charge Master no encontrados: " . count($notFoundCharge) . "\n";
echo "Measurement Basis no encontrados: " . count($notFoundMb) . "\n";
echo "Sin Measurement Basis en JSON: $skippedEmpty\n";

if (!empty($notFoundCharge)) {
    echo "\nCharge Master no encontrados:\n";
    foreach (array_unique($notFoundCharge) as $name) {
        echo "  - $name\n";
    }
}

if (!empty($notFoundMb)) {
    echo "\nMeasurement Basis no encontrados (valores del JSON):\n";
    foreach (array_keys($notFoundMb) as $mb) {
        echo "  - $mb\n";
    }
}

echo "\nValores de Measurement Basis disponibles en BD:\n";
foreach ($measurementBasisMap as $des => $id) {
    echo "  [$id] $des\n";
}
