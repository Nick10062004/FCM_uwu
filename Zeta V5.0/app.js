// DOM Elements
const modal = document.getElementById('modal');

// --- Repair Data Management ---
let repairRequests = [
    {
        id: 101, title: 'ท่อน้ำระเบียงอุดตัน', date: '11 ก.พ. 2569', preferredDate: '2026-02-15', house: '123/45', requester: 'คุณสมชาย', category: 'ระบบประปา',
        status: 'pending', statusText: 'รออนุมัติ', reviewed: false, icon: 'water-outline', iconColor: '#3b82f6', bg: '#eff6ff'
    },
    {
        id: 102, title: 'ปลั๊กไฟห้องนอนไหม้', date: '11 ก.พ. 2569', preferredDate: '2026-02-14', house: '105/9', requester: 'คุณวิภา', category: 'ระบบไฟฟ้า',
        status: 'pending', statusText: 'รออนุมัติ', reviewed: false, icon: 'flash-outline', iconColor: '#f59e0b', bg: '#fff7ed'
    },
    {
        id: 103, title: 'หลอดไฟทางเดินขาด', date: '10 ก.พ. 2569', preferredDate: '2026-02-12', house: '102/12', requester: 'คุณวิจิตร', category: 'ระบบไฟฟ้า',
        status: 'working', statusText: 'กำลังซ่อม', techName: 'ช่างเกรียงไกร', icon: 'bulb-outline', iconColor: '#f59e0b', bg: '#fff7ed'
    },
    {
        id: 104, title: 'ก๊อกน้ำห้องน้ำรั่ว', date: '10 ก.พ. 2569', preferredDate: '2026-02-10', house: '105/9', requester: 'คุณวิภา', category: 'ระบบประปา',
        status: 'done', statusText: 'เสร็จสิ้น', techName: 'ช่างวิชัย', reviewed: true, rating: 5, icon: 'water-outline', iconColor: '#3b82f6', bg: '#eff6ff'
    },
    {
        id: 105, title: 'เครื่องทำน้ำอุ่นไม่ร้อน', date: '09 ก.พ. 2569', preferredDate: '2026-02-12', house: '110/3', requester: 'คุณบุญมา', category: 'ระบบไฟฟ้า',
        status: 'working', statusText: 'กำลังซ่อม', techName: 'ช่างวิชัย', icon: 'thermometer-outline', iconColor: '#f59e0b', bg: '#fff7ed'
    },
    {
        id: 106, title: 'ท่อน้ำทิ้งรั่วใต้ซิงค์', date: '11 ก.พ. 2569', preferredDate: '2026-02-11', house: '108/2', requester: 'คุณมานพ', category: 'ระบบประปา',
        status: 'working', statusText: 'กำลังซ่อม', techName: 'ช่างวิชัย', icon: 'water-outline', iconColor: '#3b82f6', bg: '#eff6ff'
    }
];

let technicians = [
    {
        id: 1, name: 'ช่างวิชัย', skill: 'ระบบประปา', status: 'available', rating: 4.9, jobs: 127,
        avatar: 'https://i.pravatar.cc/150?u=1', color: '#3b82f6',
        assignedJobs: [
            { date: '2026-02-12', title: 'ซ่อมท่อประปารั่ว ห้อง 201' },
            { date: '2026-02-13', title: 'ล้างถังพักน้ำส่วนกลาง' },
            { date: '2026-02-18', title: 'เปลี่ยนก๊อกน้ำสนาม' }
        ]
    },
    {
        id: 2, name: 'ช่างเกรียงไกร', skill: 'ระบบไฟฟ้า', status: 'busy', rating: 4.7, jobs: 89,
        avatar: 'https://i.pravatar.cc/150?u=2', color: '#f59e0b',
        assignedJobs: [
            { date: '2026-02-11', title: 'เช็คแผงวงจร ตึก A' },
            { date: '2026-02-12', title: 'ติดตั้งไฟกิ่ง' },
            { date: '2026-02-12', title: 'ซ่อมปลั๊กไฟ ห้อง 505' },
            { date: '2026-02-14', title: 'ตรวจเช็คลิฟต์' },
            { date: '2026-02-15', title: 'ซ่อมแอร์ห้องรับรอง' }
        ]
    },
    {
        id: 3, name: 'ช่างสมหมาย', skill: 'งานโครงสร้าง', status: 'available', rating: 4.8, jobs: 56,
        avatar: 'https://i.pravatar.cc/150?u=3', color: '#10b981',
        assignedJobs: [
            { date: '2026-02-20', title: 'สำรวจรอยร้าวรั้วโครงการ' }
        ]
    },
    {
        id: 4, name: 'ช่างสถาพร', skill: 'ระบบแอร์', status: 'available', rating: 4.6, jobs: 42,
        avatar: 'https://i.pravatar.cc/150?u=4', color: '#06b6d4',
        assignedJobs: []
    },
    {
        id: 5, name: 'ช่างอำนาจ', skill: 'งานสี / ตกแต่ง', status: 'available', rating: 4.5, jobs: 38,
        avatar: 'https://i.pravatar.cc/150?u=5', color: '#8b5cf6',
        assignedJobs: []
    }
];

// --- Initialization Logic ---
document.addEventListener('DOMContentLoaded', () => {
    initTheme();

    if (isSettingsPage()) {
        initSettingsPage();
    }

    if (document.getElementById('furniture-grid')) {
        renderFurniture('all');
    }

    // Auto-load lists if elements exist
    if (document.getElementById('requestList')) {
        renderRequests('all');
    }
    if (document.getElementById('historyTableBody')) {
        renderRequests('all');
    }

    // Path highlighting
    const currentPath = window.location.pathname.split('/').pop() || 'index.html';
    document.querySelectorAll('.nav-item').forEach(item => {
        if (item.getAttribute('href') === currentPath) item.classList.add('active');
        else item.classList.remove('active');
    });
});

function renderRequests(filter = 'all') {
    const list = document.getElementById('requestList');
    const historyList = document.getElementById('historyTableBody');
    if (!list && !historyList) return;

    const filtered = filter === 'all' ? repairRequests : repairRequests.filter(r => r.status === filter);

    // Target 1: Repair Status Tracking (repair.html)
    if (list) {
        list.innerHTML = '';
        if (filtered.length === 0) {
            list.innerHTML = '<tr><td colspan="2" style="text-align:center; padding: 2rem; color: var(--text-muted);">ไม่พบรายการ</td></tr>';
        } else {
            filtered.forEach(req => {
                const tr = document.createElement('tr');
                tr.className = 'animate-fade-in';
                tr.innerHTML = `
                    <td>
                        <div style="font-weight: 600;">${req.title}</div>
                        <div style="font-size: 0.8rem; color: var(--text-muted);">แจ้งเมื่อ ${req.date}</div>
                    </td>
                    <td>${req.status === 'done' ? (req.reviewed ? renderStars(req.rating) : `<button class="btn btn-primary" style="padding: 0.3rem 0.6rem; font-size: 0.8rem;" onclick="openReviewModal(${req.id})">ประเมินผล</button>`) : `<span class="status-badge status-${req.status}">${req.statusText}</span>`}</td>
                `;
                list.appendChild(tr);
            });
        }
    }

    // Target 2: History List (history.html)
    if (historyList) {
        historyList.innerHTML = '';
        if (filtered.length === 0) {
            historyList.innerHTML = '<tr><td colspan="5" style="text-align:center; padding: 3rem; color: var(--text-muted);">ไม่มีประวัติการแจ้งซ่อมในหมวดหมู่นี้</td></tr>';
        } else {
            filtered.forEach(req => {
                const tr = document.createElement('tr');
                tr.className = 'animate-fade-in';
                tr.innerHTML = `
                    <td>${req.date}</td>
                    <td>${req.category || 'ทั่วไป'}</td>
                    <td>${req.title}</td>
                    <td><span class="status-badge status-${req.status}">${req.statusText}</span></td>
                    <td style="color: #fbbf24;">${req.status === 'done' ? (req.reviewed ? renderStars(req.rating) : `<button class="btn btn-primary" style="padding: 0.2rem 0.5rem; font-size: 0.75rem;" onclick="openReviewModal(${req.id})">ประเมิน</button>`) : '-'}</td>
                `;
                historyList.appendChild(tr);
            });
        }
    }
}

function filterRequests(status, btn) {
    // Update tabs
    document.querySelectorAll('.status-filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    renderRequests(status);
}

function initSettingsPage() {
    const saved = JSON.parse(localStorage.getItem('zeta_settings') || '{}');
    const theme = localStorage.getItem('zeta_theme') || 'auto';

    const keys = ['notif-news', 'notif-repair', 'gfx-overall', 'gfx-texture', 'gfx-shadows'];
    stashedSettings = { theme: theme };

    keys.forEach(key => {
        const el = document.getElementById(key);
        if (el) {
            if (el.type === 'checkbox') stashedSettings[key] = el.checked;
            else if (el.nodeName === 'SELECT') stashedSettings[key] = el.value;
        }
    });

    Object.assign(stashedSettings, saved);
    currentTempSettings = JSON.parse(JSON.stringify(stashedSettings));

    applySettingsToUI(currentTempSettings);
    setTheme(currentTempSettings.theme);
    checkForChanges();
}

// --- Repair Form Logic ---
const repairForm = document.getElementById('repairForm');
const requestList = document.getElementById('requestList');

if (repairForm) {
    repairForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const titleInput = repairForm.querySelector('input[type="text"]');
        const prefDateInput = document.getElementById('preferredDate');
        const title = titleInput.value;
        const prefDate = prefDateInput ? prefDateInput.value : '';
        const date = new Date().toLocaleDateString('th-TH', { day: 'numeric', month: 'short', year: 'numeric' });

        const newReq = {
            id: Date.now(),
            title: title,
            date: date,
            preferredDate: prefDate,
            status: 'pending',
            statusText: 'รอดำเนินการ',
            icon: 'hammer-outline',
            iconColor: '#64748b',
            bg: '#f1f5f9'
        };

        repairRequests.unshift(newReq);
        renderRequests('all'); // Show all after adding

        // Reset filter tabs to 'All'
        document.querySelectorAll('.status-filter-btn').forEach(b => {
            b.classList.remove('active');
            if (b.innerText === 'ทั้งหมด') b.classList.add('active');
        });

        showModal();
        repairForm.reset();
    });
}

// Redundant modal removed

function showModal() {
    const m = document.getElementById('modal');
    if (m) {
        m.style.display = 'flex';
        m.style.animation = 'fadeIn 0.3s ease-out';
    }
}

function closeModal() {
    const m = document.getElementById('modal');
    if (m) m.style.display = 'none';
}

// --- Profile Edit Modal Logic (v1.4) ---
function openEditModal(type, label, currentValue) {
    const modal = document.getElementById('editProfileModal');
    const title = document.getElementById('editModalTitle');
    const inputLabel = document.getElementById('editInputLabel');
    const input = document.getElementById('editInputValue');
    const typeHidden = document.getElementById('editTypeHidden');

    if (!modal) return;

    title.innerText = `แก้ไข${label}`;
    inputLabel.innerText = label;
    input.value = (type === 'password' || type === 'pin') ? '' : currentValue;
    input.type = (type === 'password' || type === 'pin') ? 'password' : 'text';
    typeHidden.value = type;

    modal.style.display = 'flex';
    modal.style.animation = 'fadeIn 0.3s ease-out';
}

function closeEditModal() {
    const modal = document.getElementById('editProfileModal');
    if (modal) modal.style.display = 'none';
}

function saveProfileChange() {
    const type = document.getElementById('editTypeHidden').value;
    const value = document.getElementById('editInputValue').value;

    if (!value) {
        alert('กรุณากรอกข้อมูล');
        return;
    }

    // Logic for validation (example)
    if (type === 'pin' && value.length !== 6) {
        alert('PIN ต้องพกพา 6 หลัก');
        return;
    }

    alert('บันทึกข้อมูลเรียบร้อยแล้ว (จำลอง)');
    closeEditModal();
}

let stashedSettings = {};
let currentTempSettings = {};

function initTheme() {
    const savedTheme = localStorage.getItem('zeta_theme') || 'auto';
    setTheme(savedTheme);
}

function setTheme(theme, isTemp = false) {
    const html = document.documentElement;

    // UI Update (if on settings page)
    document.querySelectorAll('.theme-option').forEach(opt => {
        opt.classList.remove('active');
        if (opt.dataset.theme === theme) opt.classList.add('active');
    });

    // Apply visual change immediately
    if (theme === 'auto') {
        const isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        html.setAttribute('data-theme', isDark ? 'dark' : 'light');
    } else {
        html.setAttribute('data-theme', theme);
    }

    if (isTemp) {
        currentTempSettings['theme'] = theme;
        checkForChanges();
    } else {
        localStorage.setItem('zeta_theme', theme);
    }
}

// Watch for system theme change if in auto mode
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
    const activeTheme = isSettingsPage() ? currentTempSettings['theme'] : localStorage.getItem('zeta_theme');
    if (activeTheme === 'auto') {
        document.documentElement.setAttribute('data-theme', e.matches ? 'dark' : 'light');
    }
});

// --- Version 2.0 Auth Logic ---
const REGEX = {
    name: /^[ก-๙a-zA-Z\s]{2,}$/,
    house: /^\d+\/\d+$/,
    citizen: /^\d{13}$/,
    phone: /^\d{10}$/,
    email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    password: /^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.{8,})/
};

function validateAuthField(type, el) {
    const value = el.value;
    const isValid = REGEX[type].test(value);

    if (isValid) {
        el.classList.add('valid');
        el.classList.remove('invalid');
    } else {
        el.classList.add('invalid');
        el.classList.remove('valid');
    }
}

function handleLogin() {
    const emailEl = document.getElementById('login-email');
    const passwordEl = document.getElementById('login-password');
    const email = emailEl ? emailEl.value : '';

    // Mockup Login Logic - Role Detection
    const lowerEmail = email.toLowerCase();
    let role = 'resident';
    if (lowerEmail === 'admin@gmail.com') role = 'juristic';
    if (lowerEmail === 'technician@gmail.com') role = 'technician';

    localStorage.setItem('zeta_logged_in', 'true');
    localStorage.setItem('zeta_role', role);
    localStorage.setItem('zeta_pin_verified', 'false'); // Reset PIN verification session

    const hasPin = !!localStorage.getItem('zeta_pin');

    if (!hasPin) {
        window.location.href = 'pin-setup.html';
    } else {
        window.location.href = 'pin-verify.html';
    }
}

function handleRegister() {
    const fields = ['name', 'house', 'citizen', 'phone', 'email', 'password'];
    let allValid = true;

    fields.forEach(f => {
        const input = document.getElementById(`reg-${f}`);
        if (!REGEX[f].test(input.value)) {
            input.classList.add('invalid');
            allValid = false;
        }
    });

    if (allValid) {
        localStorage.setItem('zeta_logged_in', 'true');
        localStorage.setItem('zeta_role', 'resident');
        alert('ลงทะเบียนสำเร็จ! กำลังเข้าสู่ระบบและพาคุณไปตั้งค่า PIN');
        window.location.href = 'pin-setup.html';
    } else {
        alert('กรุณากรอกข้อมูลให้ถูกต้องตามที่กำหนด');
    }
}

let pinValue = "";
let firstPin = "";
let isConfirming = false;

function handlePinInput(val) {
    if (val === 'back') {
        pinValue = pinValue.slice(0, -1);
    } else if (pinValue.length < 6) {
        pinValue += val;
    }

    updatePinDisplay();

    const saveBtn = document.getElementById('btn-save-pin');
    const verifyBtn = document.getElementById('btn-verify-pin');
    if (saveBtn) saveBtn.disabled = pinValue.length !== 6;
    if (verifyBtn) verifyBtn.disabled = pinValue.length !== 6;
}

function updatePinDisplay() {
    const dots = document.querySelectorAll('.pin-dot');
    dots.forEach((dot, i) => {
        if (i < pinValue.length) dot.classList.add('filled');
        else dot.classList.remove('filled');
    });
}

function savePin() {
    if (pinValue.length === 6) {
        if (!isConfirming) {
            // Step 1: Set PIN
            firstPin = pinValue;
            pinValue = "";
            isConfirming = true;
            updatePinDisplay();

            // Update UI
            document.querySelector('.auth-header h1').innerText = "ยืนยันรหัส PIN";
            document.querySelector('.auth-header p').innerText = "กรุณากรอกรหัส PIN อีกครั้งเพื่อยืนยัน";
            document.getElementById('btn-save-pin').innerText = "ยืนยันรหัส PIN";
            document.getElementById('btn-save-pin').disabled = true;
        } else {
            // Step 2: Confirm PIN
            if (pinValue === firstPin) {
                localStorage.setItem('zeta_pin', pinValue);
                localStorage.setItem('zeta_pin_verified', 'true');
                alert('ตั้งค่ารหัส PIN เรียบร้อยแล้ว!');
                const role = localStorage.getItem('zeta_role') || 'resident';
                if (role === 'juristic') window.location.href = '../juristic/index.html';
                else if (role === 'technician') window.location.href = '../technician/index.html';
                else window.location.href = '../resident/index.html';
            } else {
                alert('รหัส PIN ไม่ตรงกัน กรุณาตั้งรหัสใหม่อีกครั้ง');
                // Reset to start
                pinValue = "";
                firstPin = "";
                isConfirming = false;
                updatePinDisplay();
                document.querySelector('.auth-header h1').innerText = "ตั้งรหัส PIN";
                document.querySelector('.auth-header p').innerText = "กำหนดรหัสผ่าน 6 หลักเพื่อความรวดเร็วในการเข้าใช้งานครั้งต่อไป";
                document.getElementById('btn-save-pin').innerText = "บันทึกรหัส PIN";
                document.getElementById('btn-save-pin').disabled = true;
            }
        }
    }
}

function verifyPin() {
    const savedPin = localStorage.getItem('zeta_pin');
    if (pinValue === savedPin) {
        localStorage.setItem('zeta_pin_verified', 'true');
        const role = localStorage.getItem('zeta_role') || 'resident';
        if (role === 'juristic') window.location.href = '../juristic/index.html';
        else if (role === 'technician') window.location.href = '../technician/index.html';
        else window.location.href = '../resident/index.html';
    } else {
        alert('รหัส PIN ไม่ถูกต้อง');
        pinValue = "";
        updatePinDisplay();
        document.getElementById('btn-verify-pin').disabled = true;
    }
}

function isSettingsPage() {
    return !!document.getElementById('btn-save-settings');
}

function checkForChanges() {
    if (!isSettingsPage()) return;

    const keys = Object.keys(currentTempSettings);

    for (const key of keys) {
        const stashVal = stashedSettings[key];
        const tempVal = currentTempSettings[key];

        // Visual feedback: highlight changed setting row
        const row = document.getElementById(key)?.closest('.setting-row');
        if (row) {
            if (stashVal !== tempVal) {
                row.style.borderColor = 'var(--primary)';
                row.style.background = 'var(--primary-light)';
            } else {
                row.style.borderColor = 'var(--border)';
                row.style.background = 'var(--bg-main)';
            }
        }
    }

    const saveBtn = document.getElementById('btn-save-settings');
    const undoBtn = document.getElementById('btn-undo');

    // Always enabled per user request (v1.8)
    if (saveBtn) {
        saveBtn.disabled = false;
        saveBtn.style.opacity = '1';
    }
    if (undoBtn) {
        undoBtn.disabled = false;
        undoBtn.style.opacity = '1';
    }
}

function updateSetting(id, value) {
    // Force boolean for notifications, string for others
    if (id.startsWith('notif-')) {
        currentTempSettings[id] = !!value;
    } else {
        currentTempSettings[id] = String(value);
    }
    checkForChanges();
}

function updateOverallQuality(value) {
    const textureEl = document.getElementById('gfx-texture');
    const shadowEl = document.getElementById('gfx-shadows');

    const valString = String(value);
    if (textureEl) textureEl.value = valString;
    if (shadowEl) shadowEl.value = valString;

    currentTempSettings['gfx-overall'] = valString;
    currentTempSettings['gfx-texture'] = valString;
    currentTempSettings['gfx-shadows'] = valString;

    checkForChanges();
}

function saveAllSettings() {
    // Commit temp to local storage
    localStorage.setItem('zeta_settings', JSON.stringify(currentTempSettings));

    // Extract theme and save separately for initTheme
    if (currentTempSettings.theme) {
        localStorage.setItem('zeta_theme', currentTempSettings.theme);
    }

    // Update stash to match current temp
    stashedSettings = JSON.parse(JSON.stringify(currentTempSettings));
    checkForChanges();
    alert('บันทึกการตั้งค่าเรียบร้อยแล้ว');
}

function revertSettings() {
    if (confirm('คุณต้องการยกเลิกการเปลี่ยนแปลงทั้งหมดใช่หรือไม่?')) {
        currentTempSettings = JSON.parse(JSON.stringify(stashedSettings));
        applySettingsToUI(currentTempSettings);
        setTheme(currentTempSettings.theme || 'auto');
        checkForChanges();
    }
}

function applySettingsToUI(settings) {
    Object.keys(settings).forEach(key => {
        const el = document.getElementById(key);
        if (el) {
            if (el.type === 'checkbox') el.checked = settings[key];
            else if (el.nodeName === 'SELECT' || el.type === 'text') el.value = settings[key];
        }
    });

    // Theme options need manual class update
    document.querySelectorAll('.theme-option').forEach(opt => {
        opt.classList.remove('active');
        if (opt.dataset.theme === settings.theme) opt.classList.add('active');
    });
}

// Navigation Guard
window.addEventListener('click', (e) => {
    const navLink = e.target.closest('.nav-item');
    if (navLink && isSettingsPage()) {
        const hasChanges = JSON.stringify(stashedSettings) !== JSON.stringify(currentTempSettings);
        if (hasChanges) {
            e.preventDefault();
            const choice = confirm('คุณมีการเปลี่ยนแปลงที่ยังไม่ได้บันทึก ต้องการบันทึกก่อนไปต่อหรือไม่?\n\nกด OK เพื่อบันทึก | กด Cancel เพื่อไม่บันทึก');
            if (choice) {
                saveAllSettings();
                window.location.href = navLink.href;
            } else {
                // If they specifically clicked "Cancel" they might want to stay or discard.
                // In standard browser confirm, cancel means "don't proceed with OK action"
                // The user asked: "alert ถาม มีตัวเลือกว่าบันทึก หรือ ไม่บันทึก"
                const discard = confirm('ต้องการละทิ้งการเปลี่ยนแปลงใช่หรือไม่?');
                if (discard) window.location.href = navLink.href;
            }
        }
    }
});

// --- History Filtering Logic ---

// --- History Filtering Logic ---
const btnFilterHistory = document.getElementById('btn-filter-history');
if (btnFilterHistory) {
    btnFilterHistory.addEventListener('click', () => {
        const start = document.getElementById('history-start').value;
        const end = document.getElementById('history-end').value;
        const historyList = document.getElementById('historyList');

        if (!start || !end) {
            alert('กรุณาเลือกช่วงเวลาให้ครบถ้วน');
            return;
        }

        if (historyList) {
            historyList.style.opacity = '0.5';
            setTimeout(() => {
                historyList.style.opacity = '1';
                alert(`กำลังค้นหาประวัติในช่วงวันที่ ${start} ถึง ${end}`);
            }, 500);
        }
    });
}

// --- Navigation Logic ---
const navItems = document.querySelectorAll('.nav-item');
// Redundant path logic removed


// --- Version 1.1: Furniture & Warranty Logic ---
const furnitureData = [
    { id: 1, category: "bathroom", name: "อ่างอาบน้ำ", start: "2025-01-01", end: "2027-01-01" },
    { id: 2, category: "bathroom", name: "โถชำระ", start: "2025-01-01", end: "2027-01-01" },
    { id: 3, category: "bathroom", name: "อ่างล้างมือ", start: "2025-01-01", end: "2026-06-01" },
    { id: 4, category: "bathroom", name: "เครื่องทำน้ำอุ่น", start: "2025-01-01", end: "2026-01-01" },

    { id: 5, category: "kitchen", name: "เคาน์เตอร์ห้องครัว", start: "2025-01-01", end: "2028-01-01" },
    { id: 6, category: "kitchen", name: "ซิงค์ล้างจาน", start: "2025-01-01", end: "2027-01-01" },
    { id: 7, category: "kitchen", name: "เครื่องล้างจาน", start: "2025-01-01", end: "2026-01-01" },
    { id: 8, category: "kitchen", name: "เตาอบ", start: "2025-01-01", end: "2026-01-15" },
    { id: 9, category: "kitchen", name: "ที่ดูดควัน", start: "2025-01-01", end: "2026-01-01" },
    { id: 10, category: "kitchen", name: "ตู้เย็น", start: "2025-01-01", end: "2027-01-01" },

    { id: 11, category: "living", name: "โทรทัศน์", start: "2024-12-01", end: "2025-12-01" },
    { id: 12, category: "living", name: "เครื่องเสียง", start: "2025-01-01", end: "2026-01-01" },
    { id: 13, category: "living", name: "เครื่องปรับอากาศ", start: "2025-02-01", end: "2027-02-01" },
    { id: 14, category: "living", name: "ชุดโซฟา", start: "2025-01-01", end: "2028-01-01" },

    { id: 15, category: "bedroom", name: "ตู้เสื้อผ้า", start: "2025-01-01", end: "2030-01-01" },
    { id: 16, category: "bedroom", name: "เตียง", start: "2025-01-01", end: "2030-01-01" },
    { id: 17, category: "bedroom", name: "โทรทัศน์ (Smart TV)", start: "2025-01-01", end: "2026-01-01" },
    { id: 18, category: "bedroom", name: "ชั้นวางหนังสือ", start: "2025-01-01", end: "2028-01-01" },

    { id: 19, category: "other", name: "แท็บเล็ตติดบ้าน", start: "2025-01-01", end: "2026-01-01" },
    { id: 20, category: "other", name: "ประตูอัจฉริยะ (Smart Door)", start: "2025-01-01", end: "2027-01-01" },
    { id: 21, category: "other", name: "หลอดไฟ LED", start: "2025-01-01", end: "2025-07-01" },
    { id: 22, category: "other", name: "หน้าต่าง", start: "2025-01-01", end: "2028-01-01" },
    { id: 23, category: "other", name: "ผนังและวอลเปเปอร์", start: "2025-01-01", end: "2027-01-01" },
    { id: 24, category: "other", name: "พื้นกระเบื้อง", start: "2025-01-01", end: "2030-01-01" },
    { id: 25, category: "other", name: "หลังคา", start: "2025-01-01", end: "2035-01-01" },
];

function calculateRemainingDays(endDateStr) {
    const end = new Date(endDateStr);
    const now = new Date();
    const diffTime = end - now;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
}

function renderFurniture(category = 'all') {
    const grid = document.getElementById('furniture-grid');
    if (!grid) return;

    grid.innerHTML = '';
    const filtered = category === 'all' ? furnitureData : furnitureData.filter(item => item.category === category);

    filtered.forEach(item => {
        const remaining = calculateRemainingDays(item.end);
        let badgeClass = 'badge-ok';
        let statusText = `เหลืออีก ${remaining} วัน`;

        if (remaining <= 0) {
            badgeClass = 'badge-expired';
            statusText = 'หมดประกัน';
        } else if (remaining < 30) {
            badgeClass = 'badge-warning';
        }

        const card = document.createElement('div');
        card.className = 'furniture-card animate-fade-in';
        card.innerHTML = `
            <div style="font-weight: 700; color: var(--text-main); font-size: 1.1rem;">${item.name}</div>
            <span class="remaining-badge ${badgeClass}">${statusText}</span>
            <div class="warranty-info">
                <div><ion-icon name="calendar-outline" style="vertical-align: middle;"></ion-icon> เริ่ม: ${new Date(item.start).toLocaleDateString('th-TH')}</div>
                <div><ion-icon name="shield-checkmark-outline" style="vertical-align: middle;"></ion-icon> สิ้นสุด: ${new Date(item.end).toLocaleDateString('th-TH')}</div>
            </div>
            <button class="btn" style="padding: 0.5rem; font-size: 0.8rem; border: 1px solid var(--border); background: var(--bg-card);" onclick="alert('แจ้งซ่อม ${item.name}...')">แจ้งซ่อมรายการนี้</button>
        `;
        grid.appendChild(card);
    });
}

// Tab interaction
const tabBtns = document.querySelectorAll('.tab-btn');
tabBtns.forEach(btn => {
    btn.addEventListener('click', () => {
        tabBtns.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        renderFurniture(btn.dataset.category);
    });
});

// End of file

function renderStars(rating) {
    let stars = '<div style="color: #fbbf24; display: flex; gap: 2px;">';
    for (let i = 1; i <= 5; i++) {
        stars += `<ion-icon name="${i <= rating ? 'star' : 'star-outline'}"></ion-icon>`;
    }
    stars += '</div>';
    return stars;
}

let selectedRating = 0;
let currentReviewId = null;

function openReviewModal(reqId) {
    const req = repairRequests.find(r => r.id === reqId);
    if (!req) return;

    currentReviewId = reqId;
    selectedRating = 0;

    document.getElementById('reviewTechName').innerText = req.techName || 'ช่างผู้ชำนาญการ';
    document.getElementById('reviewTechReport').innerText = req.techReport || 'ปิดงานซ่อมเรียบร้อยแล้ว ทุกระบบทำงานปกติ';
    document.getElementById('reviewFeedback').value = '';

    updateStarUI(0);

    const modal = document.getElementById('reviewModal');
    if (modal) {
        modal.style.display = 'flex';
        modal.style.animation = 'fadeIn 0.3s ease-out';
    }
}

function updateStarUI(rating) {
    selectedRating = rating;
    const stars = document.querySelectorAll('.star-input ion-icon');
    stars.forEach((star, i) => {
        if (i < rating) {
            star.setAttribute('name', 'star');
            star.style.color = '#fbbf24';
        } else {
            star.setAttribute('name', 'star-outline');
            star.style.color = 'var(--text-muted)';
        }
    });

    const submitBtn = document.getElementById('btn-submit-review');
    if (submitBtn) submitBtn.disabled = rating === 0;
}

function submitReview() {
    if (selectedRating === 0 || !currentReviewId) return;

    const reqIndex = repairRequests.findIndex(r => r.id === currentReviewId);
    if (reqIndex !== -1) {
        repairRequests[reqIndex].reviewed = true;
        repairRequests[reqIndex].rating = selectedRating;
        repairRequests[reqIndex].feedback = document.getElementById('reviewFeedback').value;

        closeReviewModal();
        renderRequests('all');
        alert('ขอบคุณสำหรับคำประเมินครับ!');
    }
}

// --- Juristic Logic (v3.0) ---
function openAssignModal(reqId) {
    const modal = document.getElementById('assignModal');
    const req = repairRequests.find(r => r.id === reqId);

    if (modal && req) {
        modal.style.display = 'flex';
        modal.dataset.reqId = reqId;
        modal.dataset.prefDate = req.preferredDate || '';

        // Render tech grid for assignment
        renderTechGrid('assignTechChecklist', 'updateMultiCalendar');

        // Reset calendars
        const calendarGrid = document.getElementById('techCalendarsGrid');
        if (calendarGrid) calendarGrid.innerHTML = '';
        const multiContainer = document.getElementById('multiCalendarContainer');
        if (multiContainer) multiContainer.style.display = 'none';

        const titleInput = document.getElementById('assignTitle');
        if (titleInput) titleInput.value = req.title;

        const dateDisplay = document.getElementById('preferredDateDisplay');
        if (dateDisplay) {
            dateDisplay.innerText = req.preferredDate ? new Date(req.preferredDate).toLocaleDateString('th-TH', { day: 'numeric', month: 'long', year: 'numeric' }) : 'ไม่ระบุ';
        }
    }
}

function closeAssignModal() {
    const modal = document.getElementById('assignModal');
    if (modal) modal.style.display = 'none';
}

function confirmAssignment() {
    const modal = document.getElementById('assignModal');
    const reqId = parseInt(modal.dataset.reqId);
    const req = repairRequests.find(r => r.id === reqId);

    // Get checked tech IDs
    const checked = Array.from(document.querySelectorAll('#assignTechChecklist input:checked')).map(i => parseInt(i.value));

    if (checked.length === 0) {
        alert('โปรดเลือกช่างอย่างน้อย 1 คน');
        return;
    }

    if (req) {
        const assignedTechs = technicians.filter(t => checked.includes(t.id));
        req.status = 'working';
        req.statusText = 'กำลังดำเนินการ';
        req.techName = assignedTechs.map(t => t.name).join(', '); // Support multi-tech name display

        assignedTechs.forEach(tech => {
            if (!tech.assignedJobs) tech.assignedJobs = [];
            tech.assignedJobs.push({
                date: new Date().toISOString().split('T')[0],
                title: req.title
            });
        });
    }

    alert(`อนุมัติและมอบหมายงานเรียบร้อยแล้ว`);
    closeAssignModal();
    renderJuristicRequests('all');
}

// --- Multi-Tech Helpers (v4.4) ---
function renderTechGrid(containerId, changeHandler) {
    const container = document.getElementById(containerId);
    if (!container) return;

    // Mini 3:4 profile cards with silhouette icons
    container.innerHTML = technicians.map(t => `
        <div class="tech-profile-card" data-id="${t.id}" data-container="${containerId}" 
             onclick="toggleTechSelection(this, '${changeHandler}')"
             style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 0.8rem; background: var(--bg-card); border: 1px solid var(--border); border-radius: 1rem; cursor: pointer; transition: all 0.2s ease; text-align: center; aspect-ratio: 3/4;">
            <div style="position: relative; margin-bottom: 0.6rem;">
                <div style="width: 50px; height: 50px; background: #e0f2fe; color: #3b82f6; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; box-shadow: inset 0 2px 4px 0 rgb(0 0 0 / 0.05);">
                    <ion-icon name="person"></ion-icon>
                </div>
                <div style="position: absolute; bottom: 0; right: 0; width: 12px; height: 12px; background: ${t.status === 'available' ? '#10b981' : '#f59e0b'}; border: 2px solid white; border-radius: 50%;"></div>
            </div>
            <p style="font-size: 0.75rem; font-weight: 700; margin-bottom: 0.1rem; color: var(--text-main); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; width: 100%;">${t.name}</p>
            <p style="font-size: 0.65rem; color: var(--text-muted);">${t.skill}</p>
            <input type="checkbox" value="${t.id}" style="display: none;">
        </div>
    `).join('');
}

function toggleTechSelection(card, changeHandler) {
    const checkbox = card.querySelector('input[type="checkbox"]');
    checkbox.checked = !checkbox.checked;

    if (checkbox.checked) {
        card.style.background = '#f0fdf4';
        card.style.borderColor = '#10b981';
        card.style.transform = 'translateY(-4px)';
        card.style.boxShadow = '0 10px 15px -3px rgb(0 0 0 / 0.1)';
    } else {
        card.style.background = 'white';
        card.style.borderColor = 'var(--border)';
        card.style.transform = 'none';
        card.style.boxShadow = 'none';
    }

    // Trigger calendar update
    if (window[changeHandler]) window[changeHandler]();
}

function updateMultiCalendar() {
    const internalModal = document.getElementById('internalTaskModal');
    const isInternal = internalModal && internalModal.style.display === 'flex';
    const checklistId = isInternal ? 'internalTechChecklist' : 'assignTechChecklist';
    const gridId = isInternal ? 'internalTechCalendarsGrid' : 'techCalendarsGrid';
    const containerId = isInternal ? 'internalMultiCalendar' : 'multiCalendarContainer';

    const checkedIds = Array.from(document.querySelectorAll(`#${checklistId} input:checked`)).map(i => parseInt(i.value));
    const grid = document.getElementById(gridId);
    const container = document.getElementById(containerId);
    const modal = isInternal ? internalModal : document.getElementById('assignModal');

    if (checkedIds.length === 0) {
        if (container) container.style.display = 'none';
        return;
    }

    if (container) container.style.display = 'block';
    if (grid) {
        grid.innerHTML = '';
        checkedIds.forEach(id => {
            const tech = technicians.find(t => t.id === id);
            if (tech) {
                const techWrapper = document.createElement('div');
                techWrapper.style.padding = '1rem';
                techWrapper.style.background = '#f8fafc';
                techWrapper.style.borderRadius = '1rem';
                techWrapper.style.border = '1px solid var(--border)';

                techWrapper.innerHTML = `
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.8rem;">
                        <p style="font-size: 0.85rem; font-weight: 700; color: #1e293b; display: flex; align-items: center; gap: 0.5rem;">
                            <span style="width: 8px; height: 8px; background: #6366f1; border-radius: 50%;"></span>
                            ตารางงาน: ${tech.name} (${tech.skill})
                        </p>
                        <button onclick="removeTechFromSelection(${tech.id}, '${checklistId}')" 
                                style="background: #fee2e2; color: #ef4444; border: none; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s ease;">
                            <ion-icon name="trash-outline" style="font-size: 1.1rem;"></ion-icon>
                        </button>
                    </div>
                `;
                const calDiv = document.createElement('div');
                techWrapper.appendChild(calDiv);
                grid.appendChild(techWrapper);
                const highlightDate = modal ? modal.dataset.prefDate : null;
                renderCalendar(tech, calDiv, highlightDate);
            }
        });
    }
}

function removeTechFromSelection(techId, checklistId) {
    const card = document.querySelector(`#${checklistId} .tech-profile-card[data-id="${techId}"]`);
    if (card) {
        const changeHandler = checklistId === 'internalTechChecklist' ? 'updateMultiCalendar' : 'updateMultiCalendar';
        toggleTechSelection(card, changeHandler);
    }
}

// --- Denial Logic (v4.0) ---
let currentDenyId = null;

function openDenyModal(reqId) {
    currentDenyId = reqId;
    const modal = document.getElementById('denyModal');
    if (modal) {
        modal.style.display = 'flex';
        document.getElementById('denyReason').value = '';
    }
}

function closeDenyModal() {
    const modal = document.getElementById('denyModal');
    if (modal) modal.style.display = 'none';
}

function setDenyTemplate(text) {
    document.getElementById('denyReason').value = text;
}

function confirmDeny() {
    const reason = document.getElementById('denyReason').value.trim();
    if (!reason) {
        alert('โปรดระบุเหตุผลในการปฏิเสธ');
        return;
    }

    const req = repairRequests.find(r => r.id === currentDenyId);
    if (req) {
        req.status = 'denied';
        req.statusText = 'ถูกปฏิเสธ';
        req.denyReason = reason;

        alert('ปฏิเสธรายการแจ้งซ่อมเรียบร้อยแล้ว');
        closeDenyModal();
        renderJuristicRequests('all');
    }
}

// --- Internal Task Logic (v4.0) ---
function openInternalTaskModal() {
    const modal = document.getElementById('internalTaskModal');
    if (modal) {
        modal.style.display = 'flex';
        document.getElementById('internalTitle').value = '';
        document.getElementById('internalDetails').value = '';

        // Render tech grid for internal task
        renderTechGrid('internalTechChecklist', 'updateMultiCalendar');

        const grid = document.getElementById('internalTechCalendarsGrid');
        if (grid) grid.innerHTML = '';
        const container = document.getElementById('internalMultiCalendar');
        if (container) container.style.display = 'none';
    }
}

function closeInternalTaskModal() {
    const modal = document.getElementById('internalTaskModal');
    if (modal) modal.style.display = 'none';
}

function submitInternalTask() {
    const title = document.getElementById('internalTitle').value.trim();
    const location = document.getElementById('internalLocation').value;
    const details = document.getElementById('internalDetails').value.trim();

    // Get checked tech IDs
    const checked = Array.from(document.querySelectorAll('#internalTechChecklist input:checked')).map(i => parseInt(i.value));

    if (!title) {
        alert('โปรดระบุชื่อรายการ');
        return;
    }

    const assignedTechs = technicians.filter(t => checked.includes(t.id));
    const hasTechs = assignedTechs.length > 0;

    const newId = 900 + repairRequests.length;
    const newReq = {
        id: newId,
        title: title,
        date: new Date().toLocaleDateString('th-TH', { day: 'numeric', month: 'short', year: 'numeric' }),
        house: 'ส่วนกลาง',
        location: location,
        requester: 'นิติบุคคล',
        category: 'งานส่วนกลาง',
        details: details,
        status: hasTechs ? 'working' : 'pending',
        statusText: hasTechs ? 'กำลังดำเนินการ' : 'รออนุมัติ',
        techName: hasTechs ? assignedTechs.map(t => t.name).join(', ') : null,
        icon: 'construct-outline',
        iconColor: '#6366f1',
        bg: '#eef2ff'
    };

    if (hasTechs) {
        assignedTechs.forEach(tech => {
            if (!tech.assignedJobs) tech.assignedJobs = [];
            tech.assignedJobs.push({
                date: new Date().toISOString().split('T')[0],
                title: title
            });
        });
    }

    repairRequests.push(newReq);
    alert(hasTechs ? 'สร้างและมอบหมายงานส่วนกลางเรียบร้อยแล้ว' : 'สร้างรายการงานส่วนกลางเรียบร้อยแล้ว');
    closeInternalTaskModal();
    renderJuristicRequests('all');
}

function renderJuristicRequests(filter = 'all') {
    const list = document.getElementById('juristicRequestList');
    const internalList = document.getElementById('internalRequestList');
    const internalSection = document.getElementById('internalTaskSection');
    if (!list) return;

    list.innerHTML = '';
    if (internalList) internalList.innerHTML = '';

    // Filter rules
    const allFiltered = filter === 'all' ? repairRequests : repairRequests.filter(r => r.status === filter);

    // Separate: Resident Requests vs Internal (Community) Tasks
    const residentRequests = allFiltered.filter(r => r.house !== 'ส่วนกลาง');
    const internalTasks = repairRequests.filter(r => r.house === 'ส่วนกลาง' && (filter === 'all' || r.status === filter));

    // Render Internal (Community) Tasks
    if (internalSection) {
        if (internalTasks.length > 0) {
            internalSection.style.display = 'block';
            internalTasks.forEach(req => {
                const card = createRequestCard(req, true); // true for internal style
                internalList.appendChild(card);
            });
        } else {
            internalSection.style.display = 'none';
        }
    }

    // Render Resident Requests
    if (residentRequests.length === 0) {
        list.innerHTML = '<div style="padding: 3rem; text-align: center; color: var(--text-muted);">ไม่พบรายการในหมวดหมู่นี้</div>';
    } else {
        residentRequests.forEach(req => {
            const card = createRequestCard(req, false);
            list.appendChild(card);
        });
    }

    updateTabCounts();
}

function createRequestCard(req, isInternal = false) {
    const card = document.createElement('div');
    card.className = 'request-card animate-fade-in';
    if (isInternal) {
        card.style.borderLeft = '4px solid #6366f1';
        card.style.background = '#f8fafc';
    }

    let actionsUI = '';
    if (req.status === 'pending') {
        actionsUI = `
            <div style="display: flex; gap: 0.5rem; justify-content: flex-end;">
                <button class="btn" style="color: #ef4444; border: 1px solid #fee2e2; background: #fef2f2; font-size: 0.85rem; padding: 0.5rem 1rem;" 
                    onclick="openDenyModal(${req.id})">ปฏิเสธ</button>
                <button class="btn btn-primary" style="font-size: 0.85rem; padding: 0.5rem 1rem;" onclick="openAssignModal(${req.id})">อนุมัติ & มอบหมาย</button>
            </div>
        `;
    } else if (req.status === 'working') {
        actionsUI = `
            <div style="text-align: right;">
                <p style="font-size: 0.85rem; font-weight: 600; color: var(--juristic-accent);">มอบหมายให้: ${req.techName}</p>
                <button class="btn btn-secondary" style="padding: 0.3rem 0.8rem; margin-top: 0.4rem; font-size: 0.8rem;" onclick="alert('ดูความคืบหน้า...')">ดูความคืบหน้า</button>
            </div>
        `;
    } else if (req.status === 'done') {
        actionsUI = `
            <div style="text-align: right;">
                <span class="status-badge status-done" style="margin-bottom: 0.5rem; display: inline-block;">เสร็จสิ้น</span>
                ${req.reviewed ? renderStars(req.rating) : '<p style="font-size: 0.8rem; color: var(--text-muted);">รอการประเมิน</p>'}
            </div>
        `;
    } else if (req.status === 'denied') {
        actionsUI = `
            <div style="text-align: right;">
                <span class="status-badge" style="background: #fee2e2; color: #ef4444; border: 1px solid #fecaca; margin-bottom: 0.5rem; display: inline-block;">ปฏิเสธแล้ว</span>
                <p style="font-size: 0.75rem; color: var(--text-muted); max-width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; cursor: help;" title="${req.denyReason || ''}">เหตุผล: ${req.denyReason || 'ไม่ได้ระบุ'}</p>
            </div>
        `;
    }

    const locationLabel = isInternal ? `<span style="color: #6366f1; font-weight: 600;">[ส่วนกลาง: ${req.location || ''}]</span>` : `บ้านเลขที่ ${req.house || 'ไม่ระบุ'}`;

    card.innerHTML = `
        <div style="display: flex; gap: 1.5rem; align-items: center;">
            <div style="width: 50px; height: 50px; background: ${req.bg || '#f1f5f9'}; color: ${req.iconColor || '#64748b'}; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                <ion-icon name="${req.icon || 'alert-circle-outline'}"></ion-icon>
            </div>
            <div>
                <h3 style="font-size: 1rem; margin-bottom: 0.2rem;">${req.title}</h3>
                <p style="font-size: 0.85rem; color: var(--text-muted);">${locationLabel} | แจ้งโดย ${req.requester || 'ลูกบ้าน'} | ${req.date}</p>
            </div>
        </div>
        ${actionsUI}
    `;
    return card;
}

function updateTabCounts() {
    const filters = ['all', 'pending', 'working', 'done'];
    filters.forEach(filter => {
        const count = filter === 'all' ? repairRequests.length : repairRequests.filter(r => r.status === filter).length;
        const tab = document.querySelector(`.tab-item[data-filter="${filter}"] .count-badge`);
        if (tab) tab.innerText = count;
    });
}

// --- Technician Schedule Logic (v3.5) ---
function openScheduleModal(techId = null) {
    if (!techId) {
        techId = document.getElementById('techSelect').value;
    }

    if (!techId) {
        alert('โปรดเลือกช่างก่อนดูตารางงาน');
        return;
    }

    const tech = technicians.find(t => t.id == techId);
    if (!tech) return;

    const modal = document.getElementById('scheduleModal');
    if (!modal) {
        createScheduleModal();
    }

    renderCalendar(tech);
    document.getElementById('scheduleModal').style.display = 'flex';
}

function updateInlineCalendar() {
    const techId = document.getElementById('techSelect').value;
    const container = document.getElementById('inlineCalendarContainer');
    const modal = document.getElementById('assignModal');

    if (!techId || !container) {
        if (container) container.style.display = 'none';
        return;
    }

    const tech = technicians.find(t => t.id == techId);
    if (!tech) return;

    container.style.display = 'block';
    const highlightDate = modal ? modal.dataset.prefDate : null;
    renderCalendar(tech, container, highlightDate);
}

function createScheduleModal() {
    const modal = document.createElement('div');
    modal.id = 'scheduleModal';
    modal.style = "display:none; position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.5); z-index: 2000; align-items: center; justify-content: center;";
    modal.innerHTML = `
        <div class="card" style="max-width: 500px; width: 90%;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <div>
                    <h2 id="schedTechName">ตารางงาน</h2>
                    <p style="font-size: 0.8rem; color: var(--text-muted);" id="schedTechSkill"></p>
                </div>
                <ion-icon name="close-outline" style="font-size: 1.5rem; cursor: pointer;" onclick="document.getElementById('scheduleModal').style.display='none'"></ion-icon>
            </div>
            
            <div id="calendarContainer" style="margin-bottom: 1.5rem;">
                <!-- Calendar will be rendered here -->
            </div>
            
            <div style="display: flex; gap: 1rem; align-items: center; font-size: 0.85rem; padding-top: 1rem; border-top: 1px solid var(--border);">
                <div style="display: flex; align-items: center; gap: 0.5rem;">
                    <div style="width: 12px; height: 12px; background: #ef4444; border-radius: 3px;"></div>
                    <span>มีงานมอบหมาย</span>
                </div>
                <div style="display: flex; align-items: center; gap: 0.5rem;">
                    <div style="width: 12px; height: 12px; background: #10b981; border-radius: 3px;"></div>
                    <span>ว่าง / พร้อมรับงาน</span>
                </div>
                <div style="display: flex; align-items: center; gap: 0.5rem;">
                    <div style="width: 12px; height: 12px; background: #facc15; border-radius: 50%; border: 2px solid #a16207;"></div>
                    <span>วันที่ลูกบ้านสะดวก</span>
                </div>
            </div>
        </div>
    `;
    document.body.appendChild(modal);
}

function renderCalendar(tech, targetContainer = null, highlightDate = null, selectedDate = null) {
    const isInline = !!targetContainer;
    const isTechPortal = localStorage.getItem('zeta_role') === 'technician';

    // Set titles if in modal
    if (!isInline) {
        const nameEl = document.getElementById('schedTechName');
        const skillEl = document.getElementById('schedTechSkill');
        if (nameEl) nameEl.innerText = `ตารางงาน: ${tech.name}`;
        if (skillEl) skillEl.innerText = tech.skill;
    }

    const container = targetContainer || document.getElementById('calendarContainer');
    if (!container) return;

    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth();
    const todayStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;

    const monthName = new Date(year, month).toLocaleDateString('th-TH', { month: 'long', year: 'numeric' });

    let html = `
        <div style="text-align: center; font-weight: 600; margin-bottom: 1rem; font-size: ${isInline ? '0.9rem' : '1rem'};">${monthName}</div>
        <div style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 5px; text-align: center;">
            <div style="font-size: 0.7rem; color: var(--text-muted);">อา</div>
            <div style="font-size: 0.7rem; color: var(--text-muted);">จ</div>
            <div style="font-size: 0.7rem; color: var(--text-muted);">อ</div>
            <div style="font-size: 0.7rem; color: var(--text-muted);">พ</div>
            <div style="font-size: 0.7rem; color: var(--text-muted);">พฤ</div>
            <div style="font-size: 0.7rem; color: var(--text-muted);">ศ</div>
            <div style="font-size: 0.7rem; color: var(--text-muted);">ส</div>
    `;

    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();

    // Empty slots before 1st
    for (let i = 0; i < firstDay; i++) {
        html += `<div></div>`;
    }

    // Aggregate jobs by date
    const jobsByDate = {};
    if (tech.assignedJobs) {
        tech.assignedJobs.forEach(job => {
            if (!jobsByDate[job.date]) jobsByDate[job.date] = [];
            jobsByDate[job.date].push(job.title);
        });
    }

    // Days
    for (let day = 1; day <= daysInMonth; day++) {
        const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
        const dayJobs = jobsByDate[dateStr] || [];
        const isBusy = dayJobs.length > 0;
        const isPreferred = highlightDate === dateStr;
        const isSelected = selectedDate === dateStr;
        const isToday = todayStr === dateStr;

        let bgColor = isBusy ? '#fee2e2' : '#ecfdf5';
        let textColor = isBusy ? '#ef4444' : '#10b981';
        let border = isBusy ? '1px solid #fecaca' : '1px solid #d1fae5';
        let extraStyle = '';
        let tooltip = isBusy ? `งานในวันนี้:\n- ${dayJobs.join('\n- ')}` : 'ว่าง สำหรับการนัดหมาย';

        if (isPreferred) {
            bgColor = isBusy ? '#fef08a' : '#fef9c3';
            border = '2px solid #a16207';
            extraStyle = 'box-shadow: 0 0 10px rgba(234, 179, 8, 0.4); z-index: 1;';
        }

        if (isSelected) {
            border = '2px solid var(--gold)';
            bgColor = 'rgba(212, 175, 55, 0.2)';
            extraStyle += 'transform: scale(1.05); z-index: 2;';
        }

        if (isToday && !isSelected && !isPreferred) {
            border = '1px solid #3b82f6';
            extraStyle += 'text-decoration: underline;';
        }

        // Dot indicators for multiple jobs
        let dotsHTML = '';
        if (isBusy) {
            dotsHTML = `<div style="display: flex; justify-content: center; gap: 2px; margin-top: 2px;">`;
            dayJobs.forEach(() => {
                dotsHTML += `<div style="width: 4px; height: 4px; background: #ef4444; border-radius: 50%;"></div>`;
            });
            dotsHTML += `</div>`;
        }

        const clickHandler = isTechPortal ? `onclick="selectTechDate(${tech.id}, '${dateStr}')"` : '';

        html += `
            <div title="${tooltip}" ${clickHandler} style="padding: ${isInline ? '0.3rem 0' : '0.5rem 0'}; background: ${bgColor}; color: ${textColor}; border: ${border}; border-radius: 5px; font-size: 0.85rem; font-weight: 700; cursor: ${isTechPortal ? 'pointer' : 'help'}; position: relative; transition: all 0.2s ease; ${extraStyle}">
                ${day}
                ${dotsHTML}
            </div>
        `;
    }

    html += `</div>`;

    // Legend
    html += `
        <div style="display: flex; gap: 0.8rem; flex-wrap: wrap; align-items: center; font-size: 0.75rem; margin-top: 1rem; justify-content: center;">
            <div style="display: flex; align-items: center; gap: 0.3rem;"><div style="width: 8px; height: 8px; background: #ef4444; border-radius: 2px;"></div> มีงาน</div>
            <div style="display: flex; align-items: center; gap: 0.3rem;"><div style="width: 8px; height: 8px; background: #10b981; border-radius: 2px;"></div> ว่าง</div>
            <div style="display: flex; align-items: center; gap: 0.3rem;"><div style="width: 8px; height: 8px; background: #fef08a; border-radius: 50%; border: 1px solid #a16207;"></div> วันนัด/เลือก</div>
        </div>
    `;

    container.innerHTML = html;
}

function selectTechDate(techId, dateStr) {
    const tech = technicians.find(t => t.id === techId);
    if (!tech) return;

    // Re-render calendar to show selection
    renderCalendar(tech, document.getElementById('techCalendarContainer'), null, dateStr);

    // Render Daily Agenda
    renderDailyAgenda(tech, dateStr);
}

function renderDailyAgenda(tech, dateStr) {
    const container = document.getElementById('dailyAgendaContainer');
    if (!container) return;

    const displayDate = new Date(dateStr).toLocaleDateString('th-TH', { day: 'numeric', month: 'long', year: 'numeric' });
    const dayJobs = (tech.assignedJobs || []).filter(j => j.date === dateStr);

    let html = `
        <div style="margin-bottom: 1rem;">
            <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 0.2rem;">ตารางงานวันที่</p>
            <h3 style="color: var(--gold);">${displayDate}</h3>
        </div>
    `;

    if (dayJobs.length === 0) {
        html += `
            <div style="padding: 2rem; text-align: center; border: 2px dashed var(--border); border-radius: 1rem; color: var(--text-muted);">
                <ion-icon name="calendar-clear-outline" style="font-size: 2rem; margin-bottom: 0.5rem;"></ion-icon>
                <p>ไม่มีงานที่มอบหมายในวันนี้</p>
            </div>
        `;
    } else {
        html += `<div style="display: flex; flex-direction: column; gap: 0.8rem;">`;
        dayJobs.forEach(job => {
            // Find full request details if possible
            const req = repairRequests.find(r => r.title === job.title);
            html += `
                <div class="agenda-item animate-fade-in" style="padding: 1rem; background: var(--bg-card); border: 1px solid var(--border); border-radius: 1rem; border-left: 4px solid var(--gold);">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5rem;">
                        <span class="status-badge status-${req ? req.status : 'working'}" style="font-size: 0.7rem;">${req ? req.statusText : 'กำลังซ่อม'}</span>
                        <span style="font-size: 0.75rem; color: var(--text-muted); font-weight: 600;">#${req ? req.id : '---'}</span>
                    </div>
                    <h4 style="font-size: 1rem; margin-bottom: 0.3rem;">${job.title}</h4>
                    <p style="font-size: 0.8rem; color: var(--text-muted);"><ion-icon name="home-outline"></ion-icon> บ้านเลขที่ ${req ? req.house : '---'}</p>
                    ${req ? `<a href="task-details.html?id=${req.id}" class="btn" style="margin-top: 0.8rem; width: 100%; border-color: var(--gold); color: var(--gold); font-size: 0.8rem; padding: 0.4rem;">ดูรายละเอียด</a>` : ''}
                </div>
            `;
        });
        html += `</div>`;
    }

    container.innerHTML = html;
}


// --- Technician Portal Logic (v5.0) ---
function renderTechTasks(filter = 'all') {
    const list = document.getElementById('techTaskList');
    if (!list) return;

    // Mock: current tech is 'ช่างวิชัย'
    const currentTechName = 'ช่างวิชัย';

    // Filter tasks assigned to this tech
    const techTasks = repairRequests.filter(req => req.techName && req.techName.includes(currentTechName));
    const filtered = filter === 'all' ? techTasks : techTasks.filter(t => t.status === filter);

    list.innerHTML = '';
    if (filtered.length === 0) {
        list.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 3rem; color: var(--text-muted);">ไม่มีรายการงานในหมวดหมู่นี้</div>';
        return;
    }

    filtered.forEach(req => {
        const card = document.createElement('div');
        card.className = 'task-card animate-fade-in';
        card.innerHTML = `
            <div class="task-header">
                <span class="category-tag">${req.category || 'ทั่วไป'}</span>
                <span class="status-badge status-${req.status}">${req.statusText}</span>
            </div>
            <h3 style="font-size: 1.1rem; margin: 0.5rem 0;">${req.title}</h3>
            <div style="font-size: 0.85rem; color: var(--text-muted); display: flex; flex-direction: column; gap: 0.4rem;">
                <p><ion-icon name="home-outline" style="vertical-align: middle;"></ion-icon> บ้านเลขที่ ${req.house}</p>
                <p><ion-icon name="calendar-outline" style="vertical-align: middle;"></ion-icon> นัดหมาย: ${req.preferredDate || req.date}</p>
            </div>
            <div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--border);">
                <a href="task-details.html?id=${req.id}" class="btn btn-secondary" style="width: 100%; border-color: var(--gold); color: var(--gold); border-radius: 8px; text-decoration: none; display: block; text-align: center;">ดูรายละเอียดและเริ่มงาน</a>
            </div>
        `;
        list.appendChild(card);
    });
}

function loadTechTaskDetails(taskId) {
    const req = repairRequests.find(r => r.id === taskId);
    if (!req) return;

    const titleEl = document.getElementById('taskTitle');
    const detailsEl = document.getElementById('taskDetails');
    const houseEl = document.getElementById('houseNumber');
    const nameEl = document.getElementById('requesterName');
    const phoneEl = document.getElementById('requesterPhone');
    const dateEl = document.getElementById('preferredDateDisplay');
    const targetEl = document.getElementById('targetObject');
    const assignedEl = document.getElementById('assignedTime');
    const badgeEl = document.getElementById('taskStatusBadge');

    if (titleEl) titleEl.innerText = req.title;
    if (detailsEl) detailsEl.innerText = req.details || 'ไม่มีรายละเอียดเพิ่มเติม';
    if (houseEl) houseEl.innerText = `บ้านเลขที่ ${req.house}`;
    if (nameEl) nameEl.innerText = req.requester;
    if (phoneEl) phoneEl.innerText = '08x-xxx-xxxx'; // Mock
    if (dateEl) dateEl.innerText = req.preferredDate || req.date;
    if (targetEl) targetEl.innerText = req.title.split(' ')[0]; // Simple guess
    if (assignedEl) assignedEl.innerText = `ได้รับมอบหมายเมื่อ ${req.date}`;

    // Status Badge
    if (badgeEl) {
        badgeEl.className = `status-badge status-${req.status}`;
        badgeEl.innerText = req.statusText;
    }

    // Stepper & Action Button
    updateStepperUI(req.status);
}

function updateStepperUI(status) {
    const steps = ['pending', 'working', 'done'];
    const currentIdx = steps.indexOf(status);

    steps.forEach((s, idx) => {
        const el = document.getElementById(`step-${s}`);
        if (!el) return;
        el.classList.remove('active', 'done');
        if (idx < currentIdx) el.classList.add('done');
        else if (idx === currentIdx) el.classList.add('active');
    });

    const btn = document.getElementById('btnAction');
    if (!btn) return;

    if (status === 'pending' || status === 'waiting') {
        btn.innerText = 'เริ่มดำเนินการ';
        btn.className = 'btn btn-primary';
        btn.disabled = false;
        btn.style.background = 'var(--gold)';
        btn.style.color = '#1e293b';
    } else if (status === 'working') {
        btn.innerText = 'บันทึกงานเสร็จสมบูรณ์';
        btn.style.background = '#10b981';
        btn.style.color = 'white';
        btn.disabled = false;
    } else {
        btn.innerText = 'งานเสร็จสิ้นแล้ว';
        btn.disabled = true;
        btn.style.opacity = '0.5';
    }
}

function toggleTaskStatus() {
    const urlParams = new URLSearchParams(window.location.search);
    const taskId = parseInt(urlParams.get('id'));
    const reqIndex = repairRequests.findIndex(r => r.id === taskId);

    if (reqIndex !== -1) {
        const currentStatus = repairRequests[reqIndex].status;
        if (currentStatus === 'pending' || currentStatus === 'waiting') {
            repairRequests[reqIndex].status = 'working';
            repairRequests[reqIndex].statusText = 'กำลังซ่อม';
            alert('เริ่มดำเนินการซ่อมแซม');
        } else if (currentStatus === 'working') {
            repairRequests[reqIndex].status = 'done';
            repairRequests[reqIndex].statusText = 'เสร็จสิ้น';
            const report = document.getElementById('techReport');
            if (report) repairRequests[reqIndex].techReport = report.value;
            alert('บันทึกปิดงานเรียบร้อย');
        }
        loadTechTaskDetails(taskId);
    }
}

// Tech Filter Interaction (click delegator for technician pages)
document.addEventListener('click', (e) => {
    const tabBtn = e.target.closest('.tab-btn');
    if (tabBtn && document.getElementById('techTaskList')) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        tabBtn.classList.add('active');
        renderTechTasks(tabBtn.dataset.filter);
    }
});

function confirmLogout() {
    if (confirm('คุณแน่ใจว่าต้องการออกจากระบบ?')) {
        localStorage.removeItem('zeta_logged_in');
        localStorage.removeItem('zeta_role');
        localStorage.removeItem('zeta_pin_verified');

        // Dynamic path based on current location
        const path = window.location.pathname;
        if (path.includes('/technician/') || path.includes('/resident/') || path.includes('/juristic/') || path.includes('/auth/')) {
            window.location.href = '../auth/login.html';
        } else {
            window.location.href = 'auth/login.html';
        }
    }
}
