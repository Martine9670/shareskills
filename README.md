# ShareSkills — Plateforme d'échange de compétences

ShareSkills est une application web permettant à des utilisateurs d'échanger leurs compétences sans argent, en utilisant un système de crédits en minutes. Tu enseignes ce que tu sais, tu apprends ce que tu veux.

---

## Fonctionnalités

### Côté utilisateur
- **Landing page** publique avec présentation de la plateforme et statistiques en temps réel
- **Inscription / Connexion** avec authentification sécurisée (bcrypt)
- **Tableau de bord** personnel : crédits disponibles, swaps réalisés, demandes en attente, activité récente
- **Recherche** d'utilisateurs par compétence (texte libre) ou par catégorie (Tech, Musique, Cuisine, Design, Langues)
- **Profil utilisateur** : bio, localisation, photo de profil, compétences enseignées et à apprendre
- **Gestion des compétences** : ajout et suppression de compétences (enseigner / apprendre) avec niveau (débutant, intermédiaire, expert)
- **Photo de profil** uploadable via Active Storage (fallback sur avatar généré automatiquement)
- **Swaps** : proposition d'un échange avec durée et message, acceptation ou refus, transfert automatique de crédits
- **Historique** complet des swaps sur le profil

### Côté administration (`/admin`)
- Accessible uniquement aux utilisateurs avec `is_admin: true`
- **Gestion des utilisateurs** : liste, modification (crédits, rôle admin), suppression
- **Gestion des compétences** : création, modification, suppression
- **Messagerie admin** :
  - Contacter directement un utilisateur par email
  - Mettre deux utilisateurs en relation (email envoyé aux deux avec leurs profils respectifs)

### Emails (ActionMailer)
- Email de bienvenue à l'inscription
- Notification lors d'une proposition de swap
- Notification lors de l'acceptation d'un swap
- Email de contact depuis l'admin
- Email de mise en relation entre deux utilisateurs

---

## Stack technique

| Couche | Technologie |
|---|---|
| Langage | Ruby 3.x |
| Framework | Ruby on Rails 8.1 |
| Base de données | SQLite3 (dev/test), SQLite3 multi-fichiers (production) |
| Asset pipeline | Propshaft (pas Sprockets) |
| JavaScript | Importmap + Hotwire (Turbo + Stimulus) |
| Authentification | `has_secure_password` (bcrypt) — sans Devise |
| Upload fichiers | Active Storage |
| Traitement images | image_processing (~> 1.2) |
| Emails | ActionMailer |
| Serveur web | Puma |
| Cache / Queue / Cable | Solid Cache, Solid Queue, Solid Cable |
| Déploiement | Kamal (Docker) |
| CSS | Vanilla CSS par feature (pas de framework) |

---

## Structure de la base de données

```
users
  ├── id, name, email, password_digest
  ├── bio, location, rating
  ├── credits_minutes (défaut: 120)
  ├── swaps_count
  └── is_admin (défaut: false)

skills
  ├── id, name
  └── category  (tech | music | cooking | design | language)

user_skills  (table de jointure)
  ├── user_id, skill_id
  ├── skill_type  (teach | learn)
  └── level       (beginner | intermediate | expert)

swaps
  ├── proposer_id → users
  ├── receiver_id → users
  ├── skill_id    → skills
  ├── duration    (en minutes)
  ├── message
  └── status      (pending | accepted | rejected)

active_storage_attachments / active_storage_blobs
  └── photos de profil (avatar_image)
```

---

## Installation

### Prérequis

- Ruby 3.x — `ruby -v`
- Bundler — `gem install bundler`
- SQLite3 — `sqlite3 --version`

### Étapes

**1. Cloner le dépôt**
```bash
git clone https://github.com/<ton-pseudo>/share_skills.git
cd share_skills
```

**2. Installer les dépendances Ruby**
```bash
bundle install
```

**3. Préparer la base de données**
```bash
bin/rails db:create
bin/rails db:migrate
```

**4. Peupler avec des données de test**
```bash
bin/rails db:seed
```

Cela crée 7 utilisateurs, 20 compétences et 3 swaps d'exemple.

**5. Lancer le serveur**
```bash
bin/rails server
```

L'application est disponible sur [http://localhost:3000](http://localhost:3000).

---

## Architecture CSS

Le CSS est organisé par feature, sans framework externe et sans style inline. Chaque fichier est importé dans `application.css` (manifest Propshaft) :

```
app/assets/stylesheets/
  ├── application.css   ← manifest (@import de tous les fichiers)
  ├── base.css          ← variables CSS, reset, typographie, grille
  ├── utils.css         ← classes utilitaires (btn, card, badge...)
  ├── navbar.css        ← navigation desktop + mobile
  ├── landing.css       ← page d'accueil publique
  ├── auth.css          ← formulaires login / signup
  ├── dashboard.css     ← tableau de bord utilisateur
  ├── search.css        ← vue recherche et cartes utilisateurs
  ├── profile.css       ← profil utilisateur et compétences
  ├── modal.css         ← modale de proposition de swap
  ├── notification.css  ← messages flash
  ├── admin.css         ← panel d'administration
  └── footer.css        ← pied de page
```

---

## Architecture JavaScript

Le JS utilise l'importmap de Rails (pas de webpack/esbuild). Les fonctions interactives sont exposées sur `window` pour être accessibles depuis les attributs `onclick` HTML :

```
app/javascript/
  ├── application.js    ← point d'entrée (importe Turbo, Stimulus, shareskills)
  └── shareskills.js      ← logique UI : showView(), openModal(), toggleSkillForm()...
```

Fonctions principales :
- `showView(name)` — bascule entre les sections Dashboard / Recherche / Profil
- `openModal(userId, userName)` — ouvre la modale de proposition de swap
- `closeModal()` — ferme la modale
- `toggleSkillForm(type)` — affiche/masque le formulaire d'ajout de compétence

---

## Emails en développement

Par défaut en développement, les emails s'affichent dans les logs du serveur (`log/development.log`).

Pour les visualiser dans le navigateur, ajoute la gem `letter_opener` :

```ruby
# Gemfile (group :development)
gem "letter_opener"
```

```ruby
# config/environments/development.rb
config.action_mailer.delivery_method = :letter_opener
config.action_mailer.perform_deliveries = true
```

---

## Système de crédits

Chaque utilisateur commence avec **120 minutes** de crédits.

Lors de l'acceptation d'un swap :
- Le **proposeur** reçoit les minutes (il allait apprendre)
- Le **receveur** dépense les minutes (il va enseigner)
- Les deux compteurs `swaps_count` sont incrémentés
- La transaction est atomique (rollback automatique en cas d'erreur)

---

## Déploiement

L'application est configurée pour un déploiement via **Kamal** (Docker). Voir `config/deploy.yml` pour la configuration serveur.

```bash
kamal setup   # premier déploiement
kamal deploy  # mises à jour
```

Author : Martine PINNA
