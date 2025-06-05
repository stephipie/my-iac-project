## 1. Anwendungsfall: Eine skalierbare Webanwendung mit Nginx und einer einfachen Node.js-API
### Problemstellung
Stell dir vor, du möchtest eine kleine Webanwendung bereitstellen, die aus einem Nginx-Webserver (als Reverse Proxy) und einer simplen Node.js-Anwendung (als Backend-API) besteht. Diese Anwendung soll lokal auf deinem Entwicklungsrechner laufen, aber so konfiguriert sein, dass sie leicht portierbar und skalierbar ist. Die manuelle Erstellung und Konfiguration der Docker-Container, Netzwerke und Volumes ist zeitaufwendig, fehleranfällig und schwierig zu reproduzieren, besonders wenn man die Anwendung auf verschiedenen Umgebungen (z.B. Test- oder Produktivsystemen) bereitstellen möchte. Jede Änderung erfordert manuelle Schritte, die das Risiko von Inkonsistenzen erhöhen.

## 2. Warum Terraform (IaC) dafür geeignet ist
Terraform ist hierfür ideal, weil es ein Infrastructure as Code (IaC)-Tool ist. Anstatt Infrastruktur manuell zu konfigurieren, beschreiben wir sie deklarativ in Code. Das bringt folgende Vorteile:

* Automatisierung: Die gesamte Infrastruktur (Container, Netzwerke, Volumes) wird automatisch erstellt, wenn der Terraform-Code ausgeführt wird. Das spart Zeit und reduziert manuelle Fehler.
Reproduzierbarkeit: Derselbe Terraform-Code erzeugt immer die gleiche Infrastruktur. Das ist entscheidend für konsistente Entwicklungs-, Test- und Produktionsumgebungen.
* Versionierung: Da die Infrastruktur in Code definiert ist, kann sie in einem Versionskontrollsystem (wie Git) gespeichert werden. Dies ermöglicht es, Änderungen nachzuverfolgen, zu prüfen und bei Bedarf zu früheren Versionen zurückzukehren.
* Zusammenarbeit: Teams können effizienter zusammenarbeiten, da die Infrastrukturdefinition geteilt und gemeinsam entwickelt werden kann.
* Parametrisierung: Durch die Verwendung von Variablen können wir unsere Konfiguration flexibel gestalten. So lassen sich beispielsweise Portnummern, Containernamen oder Image-Versionen einfach anpassen, ohne den Kern-Code zu ändern.

## 3. Begründung der Nutzung von Terraform-Bausteinen
Dieser Anwendungsfall erfordert die Nutzung aller geforderten Bausteine, um eine flexible, wartbare und gut strukturierte Lösung zu gewährleisten.

### Variablen:
* Notwendigkeit: Um die Anwendung flexibel zu halten, müssen wir Konfigurationsparameter wie die Images der Docker-Container (Nginx und Node.js), die Container-Namen, die exponierten Ports und den Netzwerknamen anpassen können. Diese Werte ändern sich möglicherweise zwischen Entwicklung und Produktion oder auch innerhalb der Entwicklungsumgebung (z.B. verschiedene Image-Versionen).
* Beispiel-Nutzung: Wir werden Variablen für $nginx_image, $node_app_image, $nginx_port, $node_app_port, $network_name und $project_prefix verwenden. So können wir beispielsweise schnell ein anderes Nginx-Image testen oder den Host-Port für Nginx ändern, ohne direkt in den Ressourcendefinitionen zu editieren.

### Outputs:
* Notwendigkeit: Nach der Bereitstellung der Infrastruktur benötigen wir Informationen wie die ID des erstellten Docker-Netzwerks und die Zugangs-URL für die Nginx-Anwendung. Diese Informationen sind wichtig für die Validierung und weitere Nutzung der Anwendung (z.B. in CI/CD-Pipelines oder für manuelle Tests).
* Beispiel-Nutzung: Wir werden Outputs definieren, die die $network_id und die $nginx_access_url (bestehend aus localhost und dem zugewiesenen Port) anzeigen, sobald terraform apply abgeschlossen ist.

### Locals:
* Notwendigkeit: Manchmal müssen wir Werte berechnen oder wiederholt verwenden, die nicht direkt als Input kommen, aber für die Ressourcendefinitionen nützlich sind. Dies verbessert die Lesbarkeit und vermeidet Redundanz. Im Kontext von Docker kann das zum Beispiel das Zusammenfügen von Präfixen mit Ressourcennamen sein.
* Beispiel-Nutzung: Wir könnten Locals verwenden, um eindeutige, präfixierte Namen für unsere Container und das Netzwerk zu generieren (z.B. $local.nginx_container_name und $local.node_app_container_name basierend auf dem $project_prefix). Dies stellt sicher, dass unsere Ressourcen auch in Umgebungen mit mehreren ähnlichen Deployments eindeutig benannt sind.

### Module:
* Notwendigkeit: Obwohl unsere Anwendung relativ klein ist, besteht sie aus wiederkehrenden Mustern: Ein Container muss gestartet und mit einem Netzwerk verbunden werden. Wenn wir später weitere Microservices hinzufügen oder ein ähnliches Setup für eine andere Anwendung benötigen, möchten wir nicht jedes Mal den gesamten Code neu schreiben. Ein Modul für einen "Containerized Service" kapselt diese Logik und fördert die Wiederverwendung und Modularität.
* Beispiel-Nutzung: Wir werden ein Modul namens "docker-service" erstellen. Dieses Modul nimmt Parameter wie image, name, ports und network_id entgegen und definiert die docker_container- und die docker_network_attachment-Ressource. In unserer main.tf werden wir dieses Modul dann zweimal instanziieren – einmal für Nginx und einmal für die Node.js-App. Dies macht unsere main.tf übersichtlicher und das Hinzufügen weiterer Services trivial.

## Verzeichnis - Struktur nach Best Practices für Terraform:

terraform-docker-app/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
└── modules/
    └── docker-service/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

## Herausforderungen:

* Terraform benötigt die Provider-Information nicht nur im Root - Verzeichnis, sondern auch innerhalb der Modules. Getestet innerhalb des modules/docker-service/main.tf und dann seperiert in eine eigenständige provider.tf für die Übersichtlichkeit und Struktur nach Best-Practise