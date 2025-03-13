<img src="./mmxyojmn.png"
style="width:4.41667in;height:6.625in" />

> <u>NPE Opdracht Cybersecurity & Virtualisatie</u>

**Laurent** **Dedeyne**

**Lucca** **Strobbe**

**Simon** **Dierickx**

> <u>Stappenplan opzetten omgeving</u>
>
> 1\. We starten de omgeving op door het script “CVE.bat” uit te voeren,
> dit script doet het volgende:
>
> \- De router (Debian VM) starten.
>
> \- Ubuntu VM aanmaken en configureren
>
> \- Na het opstarten van de VM toont het script de uit te voeren
> commando’s aan de gebruiker:
>
> *Press* *CTRL-ALT-T* *to* *open* *a* *terminal...* *Enter* *"sudo*
> *su"* *and* *enter* *"osboxes.org"...*
>
> *Enter* *"sudo* *echo* *'osboxes* *ALL=(ALL)* *NOPASSWD:* *ALL'*
> *\>\>* */etc/sudoers"...* *Enter* *"sudo* *bash*
> */osboxes/VBox_GAs_7.0.10/autorun.sh"...*
>
> Na het uitvoeren van de commando’s gaat het script automatisch verder:
>
> \- VM start opnieuw op
>
> \- Shared folder wordt gelinkt
>
> \- Roept het volgende script aan (CVE2.bat)
>
> 2\. Dit tweede script doet volgende configuratie volledig automatisch:
>
> \- Installatie van verouderde versie van SSH door het “script.sh”
> bestand - De status van SSH testen
>
> \- “KALI.bat” wordt aangeroepen
>
> <u>Stappenplan voor de aanval (KALI.bat)</u>
>
> \- Kali VM aanmaken en configureren
>
> \- Na het opstarten van de VM toont het script de uit te voeren
> commando’s aan de gebruiker:
>
> Press CTRL-ALT-T to open a terminal... Enter "sudo su" and enter
> "osboxes.org"...
>
> Enter "sudo echo 'osboxes ALL=(ALL) NOPASSWD: ALL' \>\>
> /etc/sudoers"... Enter "sudo systemctl start ssh"...
>
> Na het uitvoeren van de commando’s gaat het script automatisch
> verder: - SSH verbinding met de Kali wordt opgezet
>
> \- Het “scriptKali.sh” script wordt uitgevoerd (wordt via pastebin
> gedownload). - Dit script runt de msfconsole via een resourcescript om
> de brute force op de
>
> gebruikersnaam te starten.
>
> \- Eens de gebruikersnaam gevonden is wordt via Hydra het wachtwoord
> achterhaalt
>
> \- Met deze gebruikersnaam en wachtwoord wordt dan een SSH verbinden
> met de Ubuntu VM opgezet.
