puts "Nettoyage..."
Swap.destroy_all
UserSkill.destroy_all
User.destroy_all
Skill.destroy_all

# ── Compétences ──────────────────────────────────────────────────────────────
puts "Création des compétences..."
skills_data = {
  "JavaScript"        => "tech",    "Ruby on Rails"     => "tech",
  "React"             => "tech",    "Python"            => "tech",
  "Node.js"           => "tech",    "PostgreSQL"        => "tech",
  "Guitare"           => "music",   "Piano"             => "music",
  "Composition"       => "music",   "Chant"             => "music",
  "Cuisine italienne" => "cooking", "Pâtisserie"        => "cooking",
  "Cuisine japonaise" => "cooking", "Photographie"      => "design",
  "UI Design"         => "design",  "Montage vidéo"     => "design",
  "Illustrator"       => "design",  "Anglais"           => "language",
  "Espagnol"          => "language","Japonais"          => "language"
}
skills_data.each { |name, cat| Skill.create!(name: name, category: cat) }

def s(name) = Skill.find_by!(name: name)

# ── Admin ─────────────────────────────────────────────────────────────────────
puts "Création de l'admin..."
User.create!(
  name: "Admin SkillSwap", email: "admin@skillswap.fr",
  password: "password123", location: "Lyon, France",
  bio: "Administrateur de la plateforme.", is_admin: true, credits_minutes: 999
)

# ── Utilisateurs ─────────────────────────────────────────────────────────────
puts "Création des utilisateurs..."
users_data = [
  { name: "Sophie Martin",    email: "sophie@example.com", location: "Lyon, 3ème arr.",
    bio: "Développeuse frontend passionnée par React et Vue.js",
    credits: 240, swaps: 12, rating: 4.9,
    teach: [["JavaScript","expert"],["React","expert"],["UI Design","intermediate"]],
    learn: ["Guitare","Photographie","Cuisine italienne"] },
  { name: "Thomas Dubois",    email: "thomas@example.com", location: "Lyon, 6ème arr.",
    bio: "Musicien professionnel et professeur de guitare",
    credits: 180, swaps: 8, rating: 4.8,
    teach: [["Guitare","expert"],["Composition","expert"],["Piano","intermediate"]],
    learn: ["Ruby on Rails","Python","Anglais"] },
  { name: "Marie Lefebvre",   email: "marie@example.com",  location: "Lyon, 2ème arr.",
    bio: "Chef à domicile spécialisée en cuisine méditerranéenne",
    credits: 320, swaps: 15, rating: 5.0,
    teach: [["Cuisine italienne","expert"],["Pâtisserie","expert"],["Photographie","intermediate"]],
    learn: ["Espagnol","UI Design","Piano"] },
  { name: "Lucas Bernard",    email: "lucas@example.com",  location: "Lyon, 1er arr.",
    bio: "Photographe freelance et vidéaste",
    credits: 150, swaps: 6, rating: 4.7,
    teach: [["Photographie","expert"],["Montage vidéo","expert"],["Illustrator","expert"]],
    learn: ["Cuisine japonaise","Ruby on Rails","Guitare"] },
  { name: "Emma Petit",       email: "emma@example.com",   location: "Lyon, 7ème arr.",
    bio: "Professeure d'anglais et traductrice",
    credits: 200, swaps: 20, rating: 4.9,
    teach: [["Anglais","expert"],["Espagnol","intermediate"],["Japonais","beginner"]],
    learn: ["Ruby on Rails","UI Design","Cuisine italienne"] },
  { name: "Alexandre Moreau", email: "alex@example.com",   location: "Lyon, 4ème arr.",
    bio: "Développeur backend spécialisé en Node.js et Python",
    credits: 300, swaps: 10, rating: 4.8,
    teach: [["Node.js","expert"],["Python","expert"],["PostgreSQL","expert"]],
    learn: ["Guitare","Photographie","UI Design"] }
]

users = users_data.map do |d|
  u = User.create!(name: d[:name], email: d[:email], password: "password123",
                   location: d[:location], bio: d[:bio],
                   credits_minutes: d[:credits], swaps_count: d[:swaps], rating: d[:rating])
  d[:teach].each { |name, level| UserSkill.create!(user: u, skill: s(name), level: level, skill_type: "teach") }
  d[:learn].each { |name| UserSkill.create!(user: u, skill: s(name), level: "beginner", skill_type: "learn") }
  u
end

# ── Swaps d'exemple ───────────────────────────────────────────────────────────
puts "Création des swaps..."
sophie, thomas, marie = users[0], users[1], users[2]
Swap.create!(proposer: thomas, receiver: sophie, skill: s("JavaScript"),
             duration: 60, status: "accepted", message: "Bonjour, je voudrais apprendre JS !")
Swap.create!(proposer: sophie, receiver: thomas, skill: s("Guitare"),
             duration: 60, status: "accepted", message: "Je veux apprendre la guitare !")
Swap.create!(proposer: marie,  receiver: sophie, skill: s("React"),
             duration: 90, status: "pending",  message: "Intéressée par React pour mon site.")

puts ""
puts "✓ Seeds terminés !"
puts "─────────────────────────────────────"
puts "Admin  : admin@skillswap.fr  / password123"
puts "User   : sophie@example.com  / password123"
puts "─────────────────────────────────────"
