#Testskript1

#Variablen definieren
$name = "Samuelé"
$alter = 32
$datum = get-Date -format "dddd, dd.MM.yyyy"
#Variable Verwenden
$begrüßung = "Hallo, mein Name ist $name."
$vorstellung = "Ich bin $name und ich bin $alter Jahre alt."
$hobby = "Kurzgeschichten schreiben, Leute nerven und vieles mehr."
#Ausgabe
Write-Host $begrüßung
Write-Host $vorstellung
Write-host "Meine Hobbys sind: $hobby"
write-host "Heute ist der $datum"