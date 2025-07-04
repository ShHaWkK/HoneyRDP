# HoneyRDP

HoneyRDP est un honeypot RDP \*haute interaction\* simulant un poste Windows Server 2019/2022 complet. Il permet d'enregistrer en continu les actions effectuées via le bureau distant et d'analyser le trafic associé. Suricata est déployé via Docker Compose et la configuration est automatisée par Ansible. Les journaux peuvent ensuite être envoyés vers votre stack ELK existante.

## Fonctionnalités principales

- **Captation des sessions** : scripts PowerShell enregistrant vidéo, mouvements de souris, nouvelles fenêtres et frappes clavier (`session_recorder.ps1`, `ps_session_logger.ps1` et `keystroke_logger.ps1`).
- **Leurres** : des documents fictifs sont placés dans `C:\ImportantData` et des raccourcis sont ajoutés sur le bureau avec un fond d'ecran personnalisé.
- **Surveillance du trafic** : Suricata inspecte le flux RDP. Les journaux générés peuvent être envoyés vers votre ELK distant pour visualisation et alerte.
- **Alertes** : Filebeat transmet les événements à Logstash où vous pouvez configurer notifications e‑mail et Slack.
- **Déploiement automatisé** : Ansible installe Docker, copie la configuration et lance les conteneurs nécessaires.

## Déploiement rapide

1. Modifier `ansible/inventory` avec l'adresse IP et l'utilisateur du serveur.
2. Lancer le playbook :

```bash
ansible-playbook -i ansible/inventory ansible/site.yml
```

3. Fournir une machine virtuelle Windows Server 2019/2022 accessible en RDP. Le playbook déploie automatiquement les scripts PowerShell et crée les tâches planifiées correspondantes.

Le conteneur Suricata est alors disponible sur la machine hôte. Seul le port **3389** doit être exposé vers l'extérieur.
Un agent Filebeat relaie en continu les journaux Suricata vers votre Logstash distant.

## Notes

- Les règles Suricata peuvent être mises à jour avec `suricata-update` dans le conteneur.
- Les fichiers leurres peuvent être remplacés régulièrement en adaptant `scripts/rotate_lures.ps1`.
 - Le script `setup_desktop.ps1` installe le fond d'écran (décodé depuis `wallpaper.b64`) et crée des dossiers factices pour un environnement réaliste.
- Pensez à configurer vos propres actions d'alerte dans la pipeline Logstash distante.
