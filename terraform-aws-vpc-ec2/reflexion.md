# Reflexion: AWS VPC und EC2 mit Terraform

## Erstellte AWS-Ressourcen

In diesem Projekt wurden folgende AWS-Ressourcen-Typen mit Terraform erstellt:

1. **Virtual Private Cloud (VPC)**
   - Ein eigenes, isoliertes Netzwerk in AWS
   - Erstellt durch das `terraform-aws-modules/vpc/aws` Modul
   - Inklusive CIDR-Block `10.0.0.0/16`

2. **Subnets**
   - 3 Private Subnets: `10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24`
   - 3 Public Subnets: `10.0.101.0/24`, `10.0.102.0/24`, `10.0.103.0/24`
   - Verteilt über verschiedene Availability Zones

3. **Security Group**
   - AWS-Firewall-Regeln für die EC2-Instanz
   - Typ: `aws_security_group`

4. **EC2 Instance**
   - Virtuelle Maschine in AWS
   - Erstellt durch das `terraform-aws-modules/ec2-instance/aws` Modul
   - Typ: t2.micro mit Ubuntu 24.04 LTS

## Abhängigkeiten in der Konfiguration

In diesem Projekt wurden hauptsächlich **implizite Abhängigkeiten** verwendet:

1. **Subnet → VPC**
   - Implizite Abhängigkeit durch die Verwendung des VPC-Moduls
   - Terraform erkennt automatisch, dass Subnets erst nach der VPC erstellt werden können

2. **Security Group → VPC**
   - Implizite Abhängigkeit durch `vpc_id = module.vpc.vpc_id`
   - Terraform weiß, dass es zuerst die VPC-ID benötigt

3. **EC2 → Subnet & Security Group**
   - Implizite Abhängigkeit durch:
     ```hcl
     subnet_id = element(module.vpc.public_subnets, 0)
     vpc_security_group_ids = [aws_security_group.ssh_access_sg.id]
     ```

## Rolle der Security Group

Die Security Group fungiert als virtuelle Firewall für die EC2-Instanz und ist aus folgenden Gründen wichtig:

1. **Zugriffskontrolle**
   - Regelt präzise, welcher Netzwerkverkehr erlaubt ist
   - SSH-Zugriff (Port 22) wird explizit erlaubt

2. **SSH-Konfiguration**
   - Ermöglicht Remote-Verwaltung der EC2-Instanz
   - Ohne SSH-Regel wäre kein Remote-Zugriff möglich
   - In der Produktion sollte der Zugriff auf spezifische IP-Bereiche beschränkt werden

## Vergleich terraform plan/apply mit S3-Bucket-Aufgabe

Hauptunterschiede:

1. **Komplexität**
   - VPC/EC2: Mehr Ressourcen und Abhängigkeiten
   - S3: Einzelne, isolierte Ressource

2. **Erstellungszeit**
   - VPC/EC2: Längerer Prozess wegen Netzwerk- und VM-Provisioning
   - S3: Schnelle Erstellung, da nur Storage-Ressource

3. **Abhängigkeiten**
   - VPC/EC2: Viele verschachtelte Abhängigkeiten
   - S3: Kaum Abhängigkeiten zu anderen Ressourcen

## Terraform State-Datei

Die `terraform.tfstate` Datei:

1. **Nach terraform apply**
   - Speichert den aktuellen Zustand aller erstellten Ressourcen
   - Enthält Details wie IDs, IPs und Konfigurationen

2. **Nach terraform destroy**
   - Bleibt bestehen, aber zeigt einen leeren Ressourcenzustand
   - Dokumentiert, dass keine Ressourcen mehr existieren
