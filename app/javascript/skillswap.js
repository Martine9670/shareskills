// ===========================
// DATA
// ===========================

const users = [
    {
        id: 1,
        name: "Sophie Martin",
        avatar: "https://i.pravatar.cc/150?u=sophie",
        bio: "Développeuse frontend passionnée par React et Vue.js",
        location: "Lyon, 3ème arr.",
        credits: 240,
        skills: [
            { name: "JavaScript", level: "expert",       category: "tech" },
            { name: "React",      level: "expert",       category: "tech" },
            { name: "UI Design",  level: "intermediate", category: "design" }
        ],
        wants: ["Guitare", "Photographie", "Cuisine italienne"],
        rating: 4.9,
        swaps: 12
    },
    {
        id: 2,
        name: "Thomas Dubois",
        avatar: "https://i.pravatar.cc/150?u=thomas",
        bio: "Musicien professionnel et professeur de guitare",
        location: "Lyon, 6ème arr.",
        credits: 180,
        skills: [
            { name: "Guitare",      level: "expert",       category: "music" },
            { name: "Composition",  level: "expert",       category: "music" },
            { name: "Piano",        level: "intermediate", category: "music" }
        ],
        wants: ["Programmation", "Marketing digital", "Anglais"],
        rating: 4.8,
        swaps: 8
    },
    {
        id: 3,
        name: "Marie Lefebvre",
        avatar: "https://i.pravatar.cc/150?u=marie",
        bio: "Chef à domicile spécialisée en cuisine méditerranéenne",
        location: "Lyon, 2ème arr.",
        credits: 320,
        skills: [
            { name: "Cuisine italienne",       level: "expert",       category: "cooking" },
            { name: "Pâtisserie",              level: "expert",       category: "cooking" },
            { name: "Photographie culinaire",  level: "intermediate", category: "design" }
        ],
        wants: ["Jardinage", "Yoga", "Espagnol"],
        rating: 5.0,
        swaps: 15
    },
    {
        id: 4,
        name: "Lucas Bernard",
        avatar: "https://i.pravatar.cc/150?u=lucas",
        bio: "Photographe freelance et vidéaste",
        location: "Lyon, 1er arr.",
        credits: 150,
        skills: [
            { name: "Photographie",   level: "expert", category: "design" },
            { name: "Montage vidéo", level: "expert", category: "design" },
            { name: "Lightroom",      level: "expert", category: "design" }
        ],
        wants: ["Cuisine", "Développement web", "Tennis"],
        rating: 4.7,
        swaps: 6
    },
    {
        id: 5,
        name: "Emma Petit",
        avatar: "https://i.pravatar.cc/150?u=emma",
        bio: "Professeure d'anglais et traductrice",
        location: "Lyon, 7ème arr.",
        credits: 200,
        skills: [
            { name: "Anglais",     level: "expert",       category: "language" },
            { name: "Espagnol",    level: "intermediate", category: "language" },
            { name: "Traduction",  level: "expert",       category: "language" }
        ],
        wants: ["Programmation", "Design", "Cuisine"],
        rating: 4.9,
        swaps: 20
    },
    {
        id: 6,
        name: "Alexandre Moreau",
        avatar: "https://i.pravatar.cc/150?u=alex",
        bio: "Développeur backend spécialisé en Node.js et Python",
        location: "Lyon, 4ème arr.",
        credits: 300,
        skills: [
            { name: "Node.js",     level: "expert", category: "tech" },
            { name: "Python",      level: "expert", category: "tech" },
            { name: "PostgreSQL",  level: "expert", category: "tech" }
        ],
        wants: ["Guitare", "Photographie", "Design"],
        rating: 4.8,
        swaps: 10
    }
];

const transactions = [
    { id: 1, from: "Sophie Martin",  to: "Vous",          skill: "JavaScript",      duration: 60, date: "15 Mars 2024", type: "received" },
    { id: 2, from: "Vous",           to: "Thomas Dubois", skill: "Guitare",          duration: 60, date: "10 Mars 2024", type: "given" },
    { id: 3, from: "Marie Lefebvre", to: "Vous",          skill: "Cuisine italienne",duration: 90, date: "5 Mars 2024",  type: "received" },
    { id: 4, from: "Vous",           to: "Lucas Bernard", skill: "React",            duration: 45, date: "28 Fév 2024",  type: "given" }
];

// ===========================
// STATE
// ===========================

let currentCategory = null;
let selectedUser    = null;
let selectedDuration = 60;

// ===========================
// INIT
// ===========================

document.addEventListener('DOMContentLoaded', () => {
    renderUsers(users);
    renderDashboardActivity();
    renderProfileHistory();

    document.getElementById('search-input').addEventListener('input', (e) => {
        filterUsers(e.target.value, currentCategory);
    });

    document.getElementById('swap-modal').addEventListener('click', (e) => {
        if (e.target === e.currentTarget) closeModal();
    });
});

// ===========================
// NAVIGATION
// ===========================

function showView(viewName) {
    document.querySelectorAll('.view-section').forEach(el => el.classList.remove('active'));
    document.getElementById(`view-${viewName}`).classList.add('active');

    document.querySelectorAll('.nav-btn').forEach(btn => btn.classList.remove('active'));
    const navBtn = document.getElementById(`nav-${viewName}`);
    if (navBtn) navBtn.classList.add('active');

    document.querySelectorAll('.mobile-btn').forEach(btn => btn.classList.remove('active'));
    const mobileBtn = document.querySelector(`.mobile-btn[data-view="${viewName}"]`);
    if (mobileBtn) mobileBtn.classList.add('active');
}

// ===========================
// RENDER
// ===========================

function renderUsers(userList) {
    const grid      = document.getElementById('users-grid');
    const noResults = document.getElementById('no-results');

    if (userList.length === 0) {
        grid.innerHTML = '';
        noResults.classList.remove('hide');
        return;
    }

    noResults.classList.add('hide');
    grid.innerHTML = userList.map(user => {
        const extraSkills = user.skills.length > 2
            ? `<span class="skills-more">+${user.skills.length - 2}</span>`
            : '';

        return `
            <div class="user-card" onclick="openSwapModal(${user.id})">
                <div class="user-header">
                    <img src="${user.avatar}" alt="${user.name}" class="user-avatar">
                    <div class="user-meta">
                        <div class="user-name">${user.name}</div>
                        <div class="user-location">📍 ${user.location}</div>
                        <div class="user-rating">★ ${user.rating}</div>
                    </div>
                </div>
                <p class="user-bio">${user.bio}</p>
                <div class="skills-row">
                    ${user.skills.slice(0, 2).map(skill =>
                        `<span class="skill-tag ${skill.level}">${skill.name}</span>`
                    ).join('')}
                    ${extraSkills}
                </div>
                <div class="user-footer">
                    <div class="user-credits">
                        <span>⏱</span>
                        <span>${user.credits} min</span>
                    </div>
                    <span class="swaps-count">${user.swaps} swaps</span>
                </div>
            </div>
        `;
    }).join('');
}

function renderDashboardActivity() {
    const container = document.getElementById('dashboard-activity');
    container.innerHTML = transactions.slice(0, 3).map(t => `
        <div class="activity-item">
            <div class="activity-icon ${t.type}">${t.type === 'received' ? '←' : '→'}</div>
            <div class="activity-content">
                <div class="activity-title">${t.type === 'received' ? `Reçu de ${t.from}` : `Donné à ${t.to}`}</div>
                <div class="activity-meta">${t.skill} • ${t.duration} min</div>
            </div>
            <div class="activity-value ${t.type}">${t.type === 'received' ? '+' : '-'}${t.duration} min</div>
        </div>
    `).join('');
}

function renderProfileHistory() {
    const container = document.getElementById('profile-history');
    container.innerHTML = transactions.map(t => `
        <div class="activity-item">
            <div class="activity-icon ${t.type}">${t.type === 'received' ? '←' : '→'}</div>
            <div class="activity-content">
                <div class="activity-title">${t.skill}</div>
                <div class="activity-meta">${t.type === 'received' ? `De ${t.from}` : `À ${t.to}`} • ${t.date}</div>
            </div>
            <div class="activity-value ${t.type}">${t.type === 'received' ? '+' : '-'}${t.duration} min</div>
        </div>
    `).join('');
}

// ===========================
// FILTRES
// ===========================

function filterByCategory(category) {
    currentCategory = category;

    document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
    const activeBtn = document.querySelector(`.filter-btn[data-cat="${category || 'all'}"]`);
    if (activeBtn) activeBtn.classList.add('active');

    filterUsers(document.getElementById('search-input').value, category);
}

function filterUsers(search, category) {
    const filtered = users.filter(user => {
        const matchesSearch   = !search || user.name.toLowerCase().includes(search.toLowerCase()) ||
                                user.skills.some(s => s.name.toLowerCase().includes(search.toLowerCase()));
        const matchesCategory = !category || user.skills.some(s => s.category === category);
        return matchesSearch && matchesCategory;
    });
    renderUsers(filtered);
}

// ===========================
// MODAL
// ===========================

function openSwapModal(userId) {
    selectedUser = users.find(u => u.id === userId);
    if (!selectedUser) return;

    document.getElementById('modal-user-info').innerHTML = `
        <img src="${selectedUser.avatar}" alt="${selectedUser.name}">
        <div>
            <div class="modal-user-name">${selectedUser.name}</div>
            <div class="modal-user-subtitle">Vous allez échanger avec ${selectedUser.name}</div>
        </div>
    `;

    const skillSelect = document.getElementById('modal-skill');
    skillSelect.innerHTML = selectedUser.skills.map(s =>
        `<option value="${s.name}">${s.name} (${s.level})</option>`
    ).join('');

    document.getElementById('swap-modal').classList.add('active');
}

function closeModal() {
    document.getElementById('swap-modal').classList.remove('active');
    selectedUser = null;
}

function selectDuration(minutes) {
    selectedDuration = minutes;
    document.querySelectorAll('.duration-btn').forEach(btn => btn.classList.remove('active'));
    document.querySelector(`.duration-btn[data-duration="${minutes}"]`).classList.add('active');
}

function confirmSwap() {
    const skill    = document.getElementById('modal-skill').value;
    const userName = selectedUser ? selectedUser.name : '';
    closeModal();
    showNotification(`Swap proposé à ${userName} ! ${selectedDuration} min de ${skill}`);
}

// ===========================
// NOTIFICATION
// ===========================

function showNotification(message) {
    const notif = document.getElementById('notification');
    document.getElementById('notification-message').textContent = message;
    notif.classList.add('show');
    setTimeout(() => notif.classList.remove('show'), 4000);
}

// Exposition globale pour les attributs onclick dans le HTML
window.showView        = showView;
window.filterByCategory = filterByCategory;
window.openSwapModal   = openSwapModal;
window.closeModal      = closeModal;
window.selectDuration  = selectDuration;
window.confirmSwap     = confirmSwap;
